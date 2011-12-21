Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:45334 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751839Ab1LUL1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 06:27:15 -0500
Date: Wed, 21 Dec 2011 16:56:11 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 1/2] mwl8k: Recover from firmware crash
Message-ID: <20111221112610.GA2069@hertz.marvell.com> (sfid-20111221_122719_433543_4DD6DB8E)
References: <20111220060809.GA4624@hertz.marvell.com>
 <20111220183252.GE913@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111220183252.GE913@wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 10:32:52AM -0800, Lennert Buytenhek wrote:
> On Tue, Dec 20, 2011 at 11:38:22AM +0530, Yogesh Ashok Powar wrote:
> 
> > In case of firmware crash, reload the firmware and reconfigure it
> > by triggering ieee80211_hw_restart; mac80211 utility function.
> > 
> > Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> > Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> 
> 
> > @@ -262,6 +262,11 @@ struct mwl8k_priv {
> >  	 */
> >  	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_WMM_QUEUES];
> >  
> > +	/* To do the task of reloading the firmware */
> > +	struct work_struct fw_reload;
> > +
> > +	atomic_t  hw_reload_state;
> 
> Why is this an atomic_t?
Hmm, the main intention was to try and avoid locking since this variable gets
accessed in multiple contexts i.e. tasklets, reload wk. However, it seems that
there is this particular race condition that will not be addressed with atomic_t
i.e. between state changes from FW_RELOAD_TEST ->FW_RELOAD_ALL_BLOCK and
FW_RELOAD_TEST -> FW_RELOAD_INIT. We will address this in patch set V2. 

> 
> 
> > +/* FW reload states */
> > +enum {
> > +	FW_RELOAD_INIT = 0,
> > +	FW_RELOAD_TEST,
> > +	FW_RELOAD_ALL_BLOCK,
> > +	FW_RELOAD_FINAL,
> > +};
> > +
> >  /* Request fw image */
> >  static int mwl8k_request_fw(struct mwl8k_priv *priv,
> >  			    const char *fname, const struct firmware **fw,
> > @@ -1516,6 +1529,9 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
> >  
> >  		oldcount = priv->pending_tx_pkts;
> >  
> > +		if (!atomic_read(&priv->hw_reload_state))
> > +			atomic_set(&priv->hw_reload_state, FW_RELOAD_TEST);
> 
> Explicit comparison against FW_RELOAD_INIT ?
Will handle this in V2.

> 
> 
> > @@ -1827,6 +1850,16 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
> >  	bool mgmtframe = false;
> >  	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
> >  
> > +	if (atomic_read(&priv->hw_reload_state) > FW_RELOAD_TEST) {
> > +		/*
> > +		 * If fw reload is going on there is no point
> > +		 * in sending the packets down to the firmware.
> > +		 * Free the packets
> > +		 */
> > +		dev_kfree_skb(skb);
> > +		return;
> 
> Why don't you stop the queues when commencing firmware reload?
We can stop the queues in mwl8k_tx_wait_empty when we queue the reload work,
but those will be enabled by ieee80211_wake_queues again in mwl8k_fw_lock.

> 
> 
> > @@ -2102,6 +2135,13 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
> >  	unsigned long timeout = 0;
> >  	u8 buf[32];
> >  
> > +	if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_ALL_BLOCK) {
> > +		wiphy_err(hw->wiphy, "Not executing command %s since "
> > +				"firmware reload is in progress\n",
> > +				mwl8k_cmd_name(cmd->code, buf, sizeof(buf)));
> > +		return -EBUSY;
> > +	}
> 
> Why don't you just hold the firmware lock while reloading the firmware?
mwl8k_fw_lock will fail since mwl8k_tx_wait_empty would fail if the firmware
is stuck.

> 
> 
> > @@ -4510,8 +4552,10 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
> >  
> >  	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
> >  
> > -	priv->macids_used &= ~(1 << mwl8k_vif->macid);
> > -	list_del(&mwl8k_vif->list);
> > +	if (priv->macids_used) {
> > +		priv->macids_used &= ~(1 << mwl8k_vif->macid);
> > +		list_del(&mwl8k_vif->list);
> > +	}
> 
> If mwl8k_remove_interface() is called, ->macids_used is surely nonzero?
> What does this change accomplish?
All the existing interfaces are re-added by the ieee80211_reconfig; which
means driver should remove existing interfaces before call ieee80211_restart_hw.

Hence there is need to add macids_used check before list del to make sure that
list_del is not called twice.

Eg., In a scenario where hw_restart is on and someone tries to remove_interface.

> 
> 
> > +static void  mwl8k_reload_fw_work(struct work_struct *work)
> 
> Redundant space
> 
> 
> > +{
> > +	struct mwl8k_priv *priv =
> > +			container_of(work, struct mwl8k_priv, fw_reload);
> 
> Extra tab
> 
> 
> > +	/* If some command is waiting for a response, clear it */
> > +	if (priv->hostcmd_wait != NULL)
> > +		complete(priv->hostcmd_wait);
> 
> And set it to NULL?
Right, will add this in V2

> 
> 
> > +	if (mwl8k_reload_firmware(hw, di->fw_image_ap))
> > +		wiphy_err(hw->wiphy, "Firmware reloading failed\n");
> > +	else
> > +		wiphy_err(hw->wiphy, "Firmware restarted successfully\n");
> 
> Why are you always reloading the Access Point firmware image?  The
> STA firmware image never crashes?
That's a valid point. We want to add this feature only for the AP firmware. 
In patch set V2, we will add the code to trigger firmware reload only when
the ap firmware crash is detected.
