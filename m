Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab1EZDvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 23:51:38 -0400
Subject: Re: [PATCH v6] mac80211_hwsim driver support userspace frame tx/rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, j@w1.fi,
	javier@cozybit.com
In-Reply-To: <1306350193-3003-1-git-send-email-jlopex@gmail.com> (sfid-20110525_210407_046264_235EE93A)
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
	 <1306350193-3003-1-git-send-email-jlopex@gmail.com>
	 (sfid-20110525_210407_046264_235EE93A)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 20:54:19 -0700
Message-ID: <1306382059.3407.12.camel@jlt3.sipsolutions.net> (sfid-20110526_055144_838502_4B4A558B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-25 at 21:03 +0200, Javier Lopez wrote:

> +static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
> +				    struct sk_buff *skb)
> +{
> +	if (wmediumd_pid) {
> +		mac80211_hwsim_tx_frame_nl(hw, skb);
> +		return true;
> +	} else
> +		return mac80211_hwsim_tx_frame_no_nl(hw, skb);
> +}

This is racy. That wouldn't be an issue at all, but you also have

>  	mac80211_hwsim_tx_frame(hw, skb);
> -	dev_kfree_skb(skb);
> +	if (!wmediumd_pid)
> +		dev_kfree_skb(skb);

so that a race could lead to a double-free or a leak (not sure which
one, maybe both depending on which way it races). I suppose _tx_frame()
should just always consume the SKB so you have only one check. And maybe
use ACCESS_ONCE() or something so the compiler doesn't play tricks.

> +	if (nla_len(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]) !=
> +	    sizeof(struct mac_address))
> +		goto out;

The policy should catch this. I think I may have pointed you to this
erroneously, possibly because I missed the policy (don't remember seeing
it before) -- should the policy really be in a header file? Normally
static variables shouldn't really be since they'd get duplicated, though
I must admit in this special case it seems very unlikely that two files
would include the header.

> +out:
> +	return -1;

This is -EPERM ("Permission denied") going to userspace, almost
certainly not what you want.

> +	dev_kfree_skb(skb);
> +	return -1;

Ditto, same in a few other places later too.

> +/* Generic Netlink operations array */
> +static struct genl_ops hwsim_ops[] = {
> +	{
> +		.cmd = HWSIM_CMD_REGISTER,
> +		.flags = 0,
> +		.policy = hwsim_genl_policy,
> +		.doit = hwsim_register_received_nl,
> +		.dumpit = NULL,

No need for explicit 0/NULL initialisation, just FYI (I don't really
mind in this case, doesn't seem excessive). However, are you sure we
should allow any user to run this? While it should be safe, do we want
to risk it? More of a philosophical question I guess.

> +failure:
> +	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +	return -1;

Same here with the error code, this could be propagated as "permission
denied" while loading the module which would be rather odd.

> +
> +
> +#define VERSION_NR 1

Did I miss a use of the version number somewhere? Seems kinda pointless
since if it's really totally incompatible the only reasonable way would
be to renumber the commands or rename the genl family.

johannes

