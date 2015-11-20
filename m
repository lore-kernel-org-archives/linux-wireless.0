Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbbKTLWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 06:22:16 -0500
Message-ID: <1448018530.3141.25.camel@sipsolutions.net> (sfid-20151120_122219_963959_8072EA31)
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Fri, 20 Nov 2015 12:22:10 +0100
In-Reply-To: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 03:51 +0000, David Lin wrote:
> 
> +static int print_mac_addr(char *p, u8 *mac_addr)
> +{
> +	int i;
> +	char *str = p;
> +
> +	str += sprintf(str, "mac address: %02x", mac_addr[0]);
> +	for (i = 1; i < ETH_ALEN; i++)
> +		str += sprintf(str, ":%02x", mac_addr[i]);
> +	str += sprintf(str, "\n");
> +
> +	return (str - p);
> +}

You can use %pM here (and perhaps get rid of the function then)

> +void mwl_debugfs_remove(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv = hw->priv;
> +
> +	debugfs_remove(priv->debugfs_phy);

doesn't that have to be _recursive()?

> +#define MWL_DRV_NAME     KBUILD_MODNAME
> +#define MWL_DRV_VERSION	 "10.3.0.14"

versions like that are generally fairly useless since you don't update
them for every commit ...

> +struct mwl_tx_desc {
> +	u8 data_rate;
> +	u8 tx_priority;
> +	__le16 qos_ctrl;
[...]

I still wouldn't mix device/firmware API with driver-use structures in
the same file, it gets confusing. It's your driver though, so if you
really want to confuse yourselves ... assuming you're going to maintain
it :)

> +struct mwl_sta {
> +	struct list_head list;
> +	bool is_mesh_node;
> +	bool is_ampdu_allowed;
> +	struct mwl_tx_info tx_stats[MWL_MAX_TID];
> +	bool is_amsdu_allowed;
> +	spinlock_t amsdu_lock;      /* for amsdu
> aggregation       */
> +	struct mwl_amsdu_ctrl amsdu_ctrl;
> +	u16 iv16;
> +	u32 iv32;
> +};

I still don't see how this iv stuff in the *station* can possibly be
right. I think I also pointed out earlier that you can just let
mac80211 assign the PN/IV.

> +static int mwl_fwcmd_wait_complete(struct mwl_priv *priv, unsigned
> short cmd)
> +{
> 
[...]
> +	mdelay(3);
> +
> +	return 0;
> +}
> +
> +static int mwl_fwcmd_exec_cmd(struct mwl_priv *priv, unsigned short
> cmd)
> +{
[...]
> +		if (mwl_fwcmd_wait_complete(priv, 0x8000 | cmd)) {
[...]
> +}
> +
> +static int mwl_fwcmd_802_11_radio_control(struct mwl_priv *priv,
> +					  bool enable, bool force)
> +{
[...]
> +	spin_lock_bh(&priv->fwcmd_lock);
[...]
> +	if (mwl_fwcmd_exec_cmd(priv,
> HOSTCMD_CMD_802_11_RADIO_CONTROL)) {
> +		spin_unlock_bh(&priv->fwcmd_lock);

This seems like a terrible idea. Spinning for 3 milliseconds (and more)
while blocking local soft-irqs is really bad for general latency on the
system. I don't like it at all.

And there doesn't really seem to be much reason for it either as far as
I can tell - almost all places can (as I pointed out before) live with
this being a mutex, you just need special handling in very few places
that really do want to send a command while not being able to sleep.

> +++ b/drivers/net/wireless/marvell/mwlwifi/hostcmd.h

This looks like you do have a file for commands - maybe move that TX
thing above here?

> +const struct ieee80211_ops mwl_mac80211_ops = {
> +	.tx                 = mwl_mac80211_tx,
> +	.start              = mwl_mac80211_start,
> +	.stop               = mwl_mac80211_stop,
> +	.add_interface      = mwl_mac80211_add_interface,
> +	.remove_interface   = mwl_mac80211_remove_interface,
> +	.config             = mwl_mac80211_config,
> +	.bss_info_changed   = mwl_mac80211_bss_info_changed,
> +	.configure_filter   = mwl_mac80211_configure_filter,
> +	.set_key            = mwl_mac80211_set_key,
> +	.set_rts_threshold  = mwl_mac80211_set_rts_threshold,
> +	.sta_add            = mwl_mac80211_sta_add,
> +	.sta_remove         = mwl_mac80211_sta_remove,
> +	.conf_tx            = mwl_mac80211_conf_tx,
> +	.get_stats          = mwl_mac80211_get_stats,
> +	.get_survey         = mwl_mac80211_get_survey,
> +	.ampdu_action       = mwl_mac80211_ampdu_action,
> +};

Apart from .tx and .configure_filter, all of these can sleep I think.

> +	rc = mwl_init_firmware(priv, fw_name);
> 
Since you do this in .probe, you should consider loading the firmware
asynchronously.

> +#ifdef CONFIG_SUPPORT_MFG

This Kconfig variable doesn't exist.

> +static inline bool mwl_rx_process_mesh_amsdu(struct mwl_priv *priv,
> +					     struct sk_buff *skb,

	
	
	
Please instead teach mac80211 to do it right.

> +	if (ieee80211_is_data(wh->frame_control)) {
> +		if (is_multicast_ether_addr(wh->addr1)) {
> +			if (ccmp) {
> +				mwl_tx_insert_ccmp_hdr(dma_data-
> >data,
> +						       mwl_vif-
> >keyidx,
> +						       mwl_vif-
> >iv16,
> +						       mwl_vif-
> >iv32);
> +				INCREASE_IV(mwl_vif->iv16, mwl_vif-
> >iv32);
> +			}

Can't you let mac80211 deal with this?

Now I actually am beginning to understand - you need this for GTK only,
so it might even work in the station ... but still, don't do it, set
the flag to make mac80211 do it on the GTK.

> +	if (mgmtframe) {
> +		u16 capab;
> +
> +		if (unlikely(ieee80211_is_action(wh->frame_control)
> &&
> +			     mgmt->u.action.category ==
> WLAN_CATEGORY_BACK &&
> +			     mgmt->u.action.u.addba_req.action_code
> ==
> +			     WLAN_ACTION_ADDBA_REQ)) {
> +			capab = le16_to_cpu(mgmt-
> >u.action.u.addba_req.capab);
> +			tid = (capab &
> IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
> +			index = mwl_tx_tid_queue_mapping(tid);
> +			capab |= 1;
> +			mgmt->u.action.u.addba_req.capab =
> cpu_to_le16(capab);
> +		}

What's going on here? Why are you modifying the action frames on the
fly??!

johannes
