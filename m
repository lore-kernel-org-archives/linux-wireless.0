Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:62457 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1LTSj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:39:59 -0500
Date: Tue, 20 Dec 2011 19:32:52 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 1/2] mwl8k: Recover from firmware crash
Message-ID: <20111220183252.GE913@wantstofly.org> (sfid-20111220_194003_761731_F31E29D5)
References: <20111220060809.GA4624@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111220060809.GA4624@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 11:38:22AM +0530, Yogesh Ashok Powar wrote:

> In case of firmware crash, reload the firmware and reconfigure it
> by triggering ieee80211_hw_restart; mac80211 utility function.
> 
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>


> @@ -262,6 +262,11 @@ struct mwl8k_priv {
>  	 */
>  	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_WMM_QUEUES];
>  
> +	/* To do the task of reloading the firmware */
> +	struct work_struct fw_reload;
> +
> +	atomic_t  hw_reload_state;

Why is this an atomic_t?


> +/* FW reload states */
> +enum {
> +	FW_RELOAD_INIT = 0,
> +	FW_RELOAD_TEST,
> +	FW_RELOAD_ALL_BLOCK,
> +	FW_RELOAD_FINAL,
> +};
> +
>  /* Request fw image */
>  static int mwl8k_request_fw(struct mwl8k_priv *priv,
>  			    const char *fname, const struct firmware **fw,
> @@ -1516,6 +1529,9 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
>  
>  		oldcount = priv->pending_tx_pkts;
>  
> +		if (!atomic_read(&priv->hw_reload_state))
> +			atomic_set(&priv->hw_reload_state, FW_RELOAD_TEST);

Explicit comparison against FW_RELOAD_INIT ?


> @@ -1827,6 +1850,16 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
>  	bool mgmtframe = false;
>  	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
>  
> +	if (atomic_read(&priv->hw_reload_state) > FW_RELOAD_TEST) {
> +		/*
> +		 * If fw reload is going on there is no point
> +		 * in sending the packets down to the firmware.
> +		 * Free the packets
> +		 */
> +		dev_kfree_skb(skb);
> +		return;

Why don't you stop the queues when commencing firmware reload?


> @@ -2102,6 +2135,13 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
>  	unsigned long timeout = 0;
>  	u8 buf[32];
>  
> +	if (atomic_read(&priv->hw_reload_state) == FW_RELOAD_ALL_BLOCK) {
> +		wiphy_err(hw->wiphy, "Not executing command %s since "
> +				"firmware reload is in progress\n",
> +				mwl8k_cmd_name(cmd->code, buf, sizeof(buf)));
> +		return -EBUSY;
> +	}

Why don't you just hold the firmware lock while reloading the firmware?


> @@ -4510,8 +4552,10 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
>  
>  	mwl8k_cmd_set_mac_addr(hw, vif, "\x00\x00\x00\x00\x00\x00");
>  
> -	priv->macids_used &= ~(1 << mwl8k_vif->macid);
> -	list_del(&mwl8k_vif->list);
> +	if (priv->macids_used) {
> +		priv->macids_used &= ~(1 << mwl8k_vif->macid);
> +		list_del(&mwl8k_vif->list);
> +	}

If mwl8k_remove_interface() is called, ->macids_used is surely nonzero?
What does this change accomplish?


> +static void  mwl8k_reload_fw_work(struct work_struct *work)

Redundant space


> +{
> +	struct mwl8k_priv *priv =
> +			container_of(work, struct mwl8k_priv, fw_reload);

Extra tab


> +	/* If some command is waiting for a response, clear it */
> +	if (priv->hostcmd_wait != NULL)
> +		complete(priv->hostcmd_wait);

And set it to NULL?


> +	if (mwl8k_reload_firmware(hw, di->fw_image_ap))
> +		wiphy_err(hw->wiphy, "Firmware reloading failed\n");
> +	else
> +		wiphy_err(hw->wiphy, "Firmware restarted successfully\n");

Why are you always reloading the Access Point firmware image?  The
STA firmware image never crashes?


> +
> +	return;
>  }

Redundant statement.


>  static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
> @@ -5268,6 +5335,8 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
>  {
>  	struct mwl8k_priv *priv = hw->priv;
>  	int rc;
> +#define MAX_RESATRT_ATTEMEPT_COUNT	5
> +	static int restart_count;

eeeeew.  no, no, no.


>  static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
>  {
>  	int i, rc = 0;
>  	struct mwl8k_priv *priv = hw->priv;
> +	struct mwl8k_vif *mwl8k_vif, *tmp_vif;
>  
>  	mwl8k_stop(hw);
>  	mwl8k_rxq_deinit(hw, 0);
>  
> +	list_for_each_entry_safe(mwl8k_vif, tmp_vif, &priv->vif_list, list) {
> +		priv->macids_used &= ~(1 << mwl8k_vif->macid);
> +		list_del(&mwl8k_vif->list);
> +	}

This seems like a dirty hack to cover up for something else.


> @@ -5624,7 +5729,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
>  	priv->pdev = pdev;
>  	priv->device_info = &mwl8k_info_tbl[id->driver_data];
>  
> -
>  	priv->sram = pci_iomap(pdev, 0, 0x10000);
>  	if (priv->sram == NULL) {
>  		wiphy_err(hw->wiphy, "Cannot map device SRAM\n");

Unrelated whitespace change.

Isn't cozybit involved in this anymore?
