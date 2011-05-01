Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1EAVfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 17:35:53 -0400
Subject: Re: [PATCH v3] mac80211_hwsim driver support userspace frame tx/rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, j@w1.fi,
	javier@cozybit.com
In-Reply-To: <1304278186-8509-1-git-send-email-jlopex@gmail.com> (sfid-20110501_213001_674263_B303BEBE)
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
	 <1304278186-8509-1-git-send-email-jlopex@gmail.com>
	 (sfid-20110501_213001_674263_B303BEBE)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 May 2011 23:35:20 +0200
Message-ID: <1304285720.3669.23.camel@jlt3.sipsolutions.net> (sfid-20110501_233608_171379_3F984D46)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I never got around to looking at this patch before, sorry. Some
comments.

> +static int hwsim_frame_send_nl(struct mac_address *src,
> +			       struct sk_buff *my_skb, int _pid)
> +{
> +
> +	struct ieee80211_tx_info *txi;
> +	struct sk_buff *skb;
> +	void *msg_head;
> +	int rc;
> +
> +	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);

This would be better with a proper size, if Felix actually adds a-MSDU
support then SKBs might become larger than GOODSIZE. Problem is I'm not
exactly sure how to calculate the right size, my_skb->size + some small
constant (20 or so?) should do though.

> +	if (skb == NULL) {
> +		printk(KERN_DEBUG "mac80211_hwsim: problem allocating skb\n");
> +		goto out;
> +	}

That might be the least of your worries when the system is under memory
pressure, I think you should remove this message.

> +	/* We get a copy of the control buffer for this tx*/
> +	rc = nla_put(skb, HWSIM_ATTR_CB_SKB, sizeof(my_skb->cb),
> +		     my_skb->cb);

Do we really want to expose the raw information here? It contains
pointers like the station pointer, which is kinda useless, no?

> +	/* We get the flags for this transmission, wmediumd maybe
> +	   changes its behaviour depending on the flags */
> +	rc = nla_put_u32(skb, HWSIM_ATTR_FLAGS, txi->flags);
> +	/* We get the tx control (rate and retries) info*/
> +	rc = nla_put(skb, HWSIM_ATTR_TX_INFO,

You're losing the first "rc". Why not use NLA_PUT_U32 which contains the
goto nla_put_failure?

> +		     sizeof(struct ieee80211_tx_rate)*IEEE80211_TX_MAX_RATES,
> +		     txi->control.rates);

Why do you also expose this separately when it's already part of the CB?
Still I'm not sure we should expose such APIs, Felix is working on
changing this, do you really want to update wmediumd all the time? How
would you version that to detect which version to use?

> +	genlmsg_end(skb, msg_head);
> +	rc = genlmsg_unicast(&init_net, skb, _pid);
> +	if (rc != 0) {
> +		printk(KERN_DEBUG "mac80211_hwsim: wmediumd not responding "
> +		       "at PID:%d, switching to no wmediumd mode.\n", _pid);
> +		atomic_set(&wmediumd_pid, 0);
> +		return -1;

That actually works? (but see below)

>  static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
>  				    struct sk_buff *skb)
>  {
>  	struct mac80211_hwsim_data *data = hw->priv, *data2;
> -	bool ack = false;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>  	struct ieee80211_rx_status rx_status;
>  
> +	bool ack = false;
> +
>  	if (data->idle) {
>  		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
>  		return false;
>  	}
>  
> +	if (data->ps != PS_DISABLED)
> +		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> +
> +	/* wmediumd mode */
> +	if (atomic_read(&wmediumd_pid)) {
> +		/* If frame is correctly send through netlink return true*/
> +		if (hwsim_frame_send_nl((struct mac_address *)
> +		    &data->addresses[1].addr, skb,
> +		    atomic_read(&wmediumd_pid)) == 0)
> +			return true;

This doesn't make sense. Why would you assume an ACK if you handed it
off to userspace? Wouldn't wmediumd get to decide whether an ACK was
given? Or did you change the return semantics of this function?

> @@ -555,6 +634,11 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	}
>  
>  	ack = mac80211_hwsim_tx_frame(hw, skb);
> +	/* wmediumd mode*/
> +	if (atomic_read(&wmediumd_pid))
> +		return;

I guess you did. Would it make sense to just move the idle stuff into
this function, and handle the wmediumd mode separately completely?

> @@ -1244,6 +1328,283 @@ static int hwsim_fops_group_write(void *dat, u64 val)
>  	return 0;
>  }
>  
> +
> +struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
> +			     struct mac_address *addr)
> +{

> +	if (!_found) {
> +		printk(KERN_DEBUG "mac80211_hwsim: invalid radio ID\n");

I'd prefer not having messages that userspace can trigger, even if it
needs to be privileged.

> +	int frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
> +	char *frame_data = (char *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
> +	int flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
> +
> +	/* Allocate new skb here */
> +	struct sk_buff *skb = alloc_skb(IEEE80211_MAX_DATA_LEN, GFP_KERNEL);

Why not allocate the right size?

> +	if (skb == NULL)
> +		goto out;
> +
> +	if (frame_data_len <= IEEE80211_MAX_DATA_LEN) {

Then you don't even need the check. Oh crap, I just realised that in
some corner cases in mac80211 I'm now making the assumption that the
same SKB is used. I guess that's wrong, something we should discuss,
should we make that assumption (and change this stuff here)? But I guess
we'd better remove that assumption, I'll take a look.

> +	if (data2 == NULL)
> +		goto out;
> +
> +	/*Tx info received because the frame was broadcasted on user space,
> +	 so we get all the necessary info: tx attempts and skb control buffer*/

Comment style?

> +	tx_attempts = (struct ieee80211_tx_rate *)nla_data(
> +		       info->attrs[HWSIM_ATTR_TX_INFO]);
> +
> +	if (tx_attempts == NULL)
> +		goto out;
> +
> +	/* ieee80211_tx_status() does not dereference anything from the
> +	 ieee80211_tx_info structure included in this cb, so it is safe
> +	 to get whatever we get from userspace and copy it here. */

Ditto. This seems a bit odd though, while we do that right now I
wouldn't necessarily trust that for a userspace API.

In fact, why don't we just hang on to the SKB? Then we just need to pass
a cookie to userspace, and then free release the skb. If userspace
doesn't respond with the cookie, we'd be able to "leak" memory, but we
can require userspace returns some status before too many frames build
up maybe?

> +	/* ieee80211_tx_status() does not dereference anything from the
> +	 ieee80211_tx_info structure included in this cb, so it is safe
> +	 to get whatever we get from userspace and copy it here. */
> +
> +	cb = (char *)nla_data(info->attrs[HWSIM_ATTR_CB_SKB]);
> +	memcpy(skb->cb, cb, sizeof(skb->cb));
> +
> +	/* now send back TX status */
> +	txi = IEEE80211_SKB_CB(skb);
> +
> +	if (txi->control.vif)
> +		hwsim_check_magic(txi->control.vif);
> +	if (txi->control.sta)
> +		hwsim_check_sta_magic(txi->control.sta);

Err, this dereferences them after you just said it wouldn't be safe.
That's really not a good idea now that you've copied it from userspace.

> +static int hwsim_register_received_nl(struct sk_buff *skb_2,
> +				      struct genl_info *info)
> +{
> +	if (info == NULL)
> +		goto out;
> +
> +	atomic_set(&wmediumd_pid, info->snd_pid);
> +
> +	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
> +	       "switching to wmediumd mode with pid %d\n", info->snd_pid);
> +
> +	return 0;
> +
> +out:
> +	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +	return -1;
> +}
> +
> +/* Generic Netlink operations array */
> +static struct genl_ops hwsim_ops[] = {
> +	{
> +		.cmd = HWSIM_CMD_REGISTER,
> +		.flags = 0,
> +		.policy = hwsim_genl_policy,
> +		.doit = hwsim_register_received_nl,
> +		.dumpit = NULL,
> +	},
> +	{
> +		.cmd = HWSIM_CMD_FRAME,
> +		.flags = 0,
> +		.policy = hwsim_genl_policy,
> +		.doit = hwsim_cloned_frame_received_nl,
> +		.dumpit = NULL,
> +	},
> +	{
> +		.cmd = HWSIM_CMD_TX_INFO_FRAME,
> +		.flags = 0,
> +		.policy = hwsim_genl_policy,
> +		.doit = hwsim_tx_info_frame_received_nl,
> +		.dumpit = NULL,
> +	},

Oh, and in fact, you aren't even requiring it to be privileged. That's a
problem waiting to happen if you keep the userspace API as it is.

> +static int hwsim_init_netlink(void)
> +{
> +	int rc;
> +	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
> +
> +	atomic_set(&wmediumd_pid, 0);
> +
> +	rc = genl_register_family(&hwsim_genl_family);
> +	if (rc != 0)
> +		goto failure;
> +	rc = genl_register_ops(&hwsim_genl_family, &hwsim_ops[0]);

This would be easier with genl_register_family_with_ops().

> +	ret = genl_unregister_ops(&hwsim_genl_family, &hwsim_ops[2]);
> +	if (ret != 0) {
> +		printk(KERN_DEBUG "mac80211_hwsim: unregister ops: %i\n", ret);
> +		return;
> +	}
> +	ret = genl_unregister_family(&hwsim_genl_family);

Unregistering the ops isn't necessary, they go with the family.

> + * Registration is done by sending a register message to the driver and
> + * will be automatically unregistered if the user application doesn't
> + * responds to sent frames.

I think that logic should be replaced by using a netlink notifier that
tells you when the application closed the socket. We implement this for
some things in nl80211, see nl80211_netlink_notify().

> +static struct genl_family hwsim_genl_family = {
> +	.id = GENL_ID_GENERATE,
> +	.hdrsize = 0,
> +	.name = "MAC80211_HWSIM",
> +	.version = VERSION_NR,
> +	.maxattr = HWSIM_ATTR_MAX,
> +};

This shouldn't be in a header file.



I think the API could use with some more thought. I'd much rather
translate the skb CB info into something userspace can parse, and
implement an skb status queue of outstanding SKBs that userspace needs
to give a status for. Use the pointer as a cookie, but don't dereference
it blindly (walk the SKB list when userspace gives a cookie and check
it's correct). When the skb queue gets too full, drop some, or so. Only
need up to four outstanding SKBs for each device anyway, I think? Maybe
not even that, not sure if/how QoS is relevant.

johannes

