Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52000 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbbGCJvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 05:51:24 -0400
Message-ID: <1435917081.2059.33.camel@sipsolutions.net> (sfid-20150703_115133_367002_BB3C3D65)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Fri, 03 Jul 2015 11:51:21 +0200
In-Reply-To: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +/* Bit definitio for MACREG_REG_A2H_INTERRUPT_CAUSE (A2HRIC) */

typo

> +/* Bit definitio for MACREG_REG_H2A_INTERRUPT_CAUSE (H2ARIC) */

same here

> +struct mwl_chip_info {
> +	char *part_name;
> +	char *fw_image;
> +};

const char *?

> +struct mwl_tx_hndl {
> +	struct sk_buff *psk_buff;
> +	u8 *sta_info;

u8 * seems very strange for sta_info?

> +	struct mwl_tx_desc *pdesc;
> +	struct mwl_tx_hndl *pnext;
> +};

You probably shouldn't hand-write your own linked list
implementation... You could possibly even put all this into the skb->cb
and get rid of the extra struct entirely, just using an skb list?

> +struct mwl_rx_hndl {
> +	struct sk_buff *psk_buff;    /* associated sk_buff for Linux  
     */
> +	struct mwl_rx_desc *pdesc;
> +	struct mwl_rx_hndl *pnext;
> +};

Ditto here.


> +	struct mwl_tx_pwr_tbl tx_pwr_tbl[SYSADPT_MAX_NUM_CHANNELS];
> +	u32 cdd;                     /* 0: off, 1: on */

bool?

> +	spinlock_t sta_lock;         /* for private sta info        
 */
> +	struct list_head sta_list;   /* List of stations            
 */

Could consider using the mac80211 station iteration
ieee80211_iterate_stations_atomic().

> +struct beacon_info {
> +	bool valid;
> +	u16 cap_info;
> +	u8 b_rate_set[SYSADPT_MAX_DATA_RATES_G];
> +	u8 op_rate_set[SYSADPT_MAX_DATA_RATES_G];
> +	u16 ie_wmm_len;               /* Keep WMM IE */
> +	u8 *ie_wmm_ptr;
> +	u16 ie_rsn_len;               /* Keep WPA IE */
> +	u8 *ie_rsn_ptr;
> +	u16 ie_rsn48_len;             /* Keep WPA2 IE */
> +	u8 *ie_rsn48_ptr;
> +	u16 ie_ht_len;                /* Keep HT IE */
> +	u8 *ie_ht_ptr;
> +	u8 ie_list_ht[148];
> +	u16 ie_vht_len;               /* Keep VHT IE */
> +	u8 *ie_vht_ptr;
> +	u8 ie_list_vht[24];
> +};

That struct is packed really inefficiently with pointers and u16s
interleaved. Those u16s can also be u8s.

> +struct mwl_vif {
> +	struct list_head list;

Could also consider using iterate_active_interfaces() and friends.

> +	struct ieee80211_vif *vif;

and you should probably embed the struct into the vif->priv, then you
don't need a vif pointer in it (use container_of)

> +	u16 seqno;       /* Non AMPDU sequence number assigned by
driver.  */

That seems a bit strange - why not just leave it up to mac80211 then?

> +	/* Indicate if this is station mode */
> +	bool is_sta;

use vif->type instead

> +struct mwl_amsdu_frag {
> +	struct sk_buff *skb;
> +	u8 pad;
> +	u8 *cur_pos;
> +	u8 num;
> +	u32 jiffies;

unsigned long

also struct ordering is really about as bad as it could be with lots of
padding

> +struct mwl_sta {
> +	struct list_head list;
> +	struct ieee80211_sta *sta;

same here - embed the struct into sta->priv and get rid of the sta
pointer

> +/* Transmission information to transmit a socket buffer. */
> +struct mwl_tx_ctrl {
> +	void *sta;
> +	void *vif;
> +	void *k_conf;

void pointers don't seem so great
But perhaps you do want them to avoid mistakes, but you should add a
comment then.
If you're not sure what mistakes I'm talking about - consider an
interface or station that's removed while the packet is pending TX.

> +static inline struct mwl_vif *mwl_dev_get_vif(const struct
ieee80211_vif *vif)
> +{
> +	return (struct mwl_vif *)&vif->drv_priv;
> +}
> +
> +static inline struct mwl_sta *mwl_dev_get_sta(const struct
ieee80211_sta *sta)
> +{
> +	return (struct mwl_sta *)&sta->drv_priv;
> +}

Oh wait, so you *do* embed the structs - you can use container_of() to
go the other way then and get rid of the pointers.

> +static int mwl_fwcmd_wait_complete(struct mwl_priv *priv, unsigned
short cmd)
> +{
> +	unsigned int curr_iteration = MAX_WAIT_FW_COMPLETE_ITERATIONS;
> +
> +	unsigned short int_code = 0;
> +
> +	do {
> +		int_code = le16_to_cpu(*((__le16 *)&priv
->pcmd_buf[0]));
> +		mdelay(1);
> +	} while ((int_code != cmd) && (--curr_iteration));
> +
> +	if (curr_iteration == 0) {
> +		wiphy_err(priv->hw->wiphy, "cmd 0x%04x=%s timed
out\n",
> +			  cmd, mwl_fwcmd_get_cmd_string(cmd));
> +		return -EIO;
> +	}
> +
> +	mdelay(3);

Both mdelay(1) and mdelay(3) are EXTREMELY long for atomic context,
this is made much worse by the iteration counter starting at 10000,
which means that this function can, in the failure case, block the
system for 10 seconds!
That seems excessive, particularly when it's called from atomic
context.

Do you really need that btw? might be far better to sleep for some
event/interrupt here. Almost all mac80211 API functions can sleep, and
you probably (hopefully) aren't getting here for TX/RX.


> +static int mwl_fwcmd_get_tx_powers(struct mwl_priv *priv, u16
*powlist, u16 ch,
> +				   u16 band, u16 width, u16 sub_ch)
> +{
> +	struct hostcmd_cmd_802_11_tx_power *pcmd;
> +	int i;
> +
> +	pcmd = (struct hostcmd_cmd_802_11_tx_power *)&priv
->pcmd_buf[0];
> +
> +	spin_lock(&priv->fwcmd_lock);

Maybe then that could also be a mutex instead.

> +static u8 mwl_fwcmd_get_80m_pri_chnl_offset(u8 channel)
> +{
> +	u8 act_primary = ACT_PRIMARY_CHAN_0;
> +
> +	switch (channel) {
> +	case 36:
> +		act_primary = ACT_PRIMARY_CHAN_0;
> +		break;

This is kinda messed up - why aren't you using something like channel
->hw_channel or whatever it's called?

> +static int mwl_fwcmd_set_ies(struct mwl_priv *priv, struct mwl_vif
*mwl_vif)
> +{
> +	struct hostcmd_cmd_set_ies *pcmd;
> +
> +	if (!mwl_vif->beacon_info.valid)
> +		return -EINVAL;
> +
> +	if (mwl_vif->beacon_info.ie_ht_len > sizeof(pcmd->ie_list_ht))
> +		goto einval;
> +
> +	if (mwl_vif->beacon_info.ie_vht_len > sizeof(pcmd
->ie_list_vht))
> +		goto einval;
> +
> +	pcmd = (struct hostcmd_cmd_set_ies *)&priv->pcmd_buf[0];
> +
> +	spin_lock(&priv->fwcmd_lock);
> +
> +	memset(pcmd, 0x00, sizeof(*pcmd));
> +	pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_SET_IES);
> +	pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> +	pcmd->cmd_hdr.macid = mwl_vif->macid;
> +
> +	pcmd->action = cpu_to_le16(HOSTCMD_ACT_GEN_SET);
> +
> +	pcmd->ie_list_len_ht = cpu_to_le16(mwl_vif
->beacon_info.ie_ht_len);
> +	memcpy(pcmd->ie_list_ht, mwl_vif->beacon_info.ie_ht_ptr,
> +	       mwl_vif->beacon_info.ie_ht_len);
> +
> +	pcmd->ie_list_len_vht = cpu_to_le16(mwl_vif
->beacon_info.ie_vht_len);
> +	memcpy(pcmd->ie_list_vht, mwl_vif->beacon_info.ie_vht_ptr,
> +	       mwl_vif->beacon_info.ie_vht_len);
> +
> +	if (priv->chip_type == MWL8897) {
> +		pcmd->ie_list_len_proprietary =
> +			cpu_to_le16(mwl_vif->beacon_info.ie_wmm_len);
> +		memcpy(pcmd->ie_list_proprietary,
> +		       mwl_vif->beacon_info.ie_wmm_ptr,
> +		       mwl_vif->beacon_info.ie_wmm_len);
> +	}

Why would the firmware even care about the split into the various IEs?

You're potentially losing information here by treating *only* the WMM
IE as the "remaining" - you really should try harder to preserve the
IEs coming from hostapd completely.

> +void mwl_fwcmd_int_disable(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv;
> +
> +	priv = hw->priv;

You can roll that into one line btw, in many many places, to reduce the
length of your code.

> +#if SYSADPT_NUM_OF_DESC_DATA > 3

It doesn't seem right for this to be a compile-time flag? If it's
needed for different devices then it should be a run-time choice, if
it's just a constant why bother with the #if, and if it's some sort of
compile-time option then shouldn't it be a CONFIG_*?


> +int mwl_fwcmd_set_hw_specs(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv;
> +	struct hostcmd_cmd_set_hw_spec *pcmd;
> +	int i;
> +
> +	priv = hw->priv;
> +
> +	pcmd = (struct hostcmd_cmd_set_hw_spec *)&priv->pcmd_buf[0];
> +
> +	spin_lock(&priv->fwcmd_lock);
> +
> +	memset(pcmd, 0x00, sizeof(*pcmd));
> +	pcmd->cmd_hdr.cmd = cpu_to_le16(HOSTCMD_CMD_SET_HW_SPEC);
> +	pcmd->cmd_hdr.len = cpu_to_le16(sizeof(*pcmd));
> +	pcmd->wcb_base[0] = cpu_to_le32(priv
->desc_data[0].pphys_tx_ring);
> +#if SYSADPT_NUM_OF_DESC_DATA > 3
> +	for (i = 1; i < SYSADPT_TOTAL_TX_QUEUES; i++)
> +		pcmd->wcb_base[i] =
> +			cpu_to_le32(priv->desc_data[i].pphys_tx_ring);
> +#endif

Also here, with the additional wrinkle that you'll get a compiler
warning (unused variable 'i') when it's <= 3.

> +static int mwl_mac80211_start(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv;
> +	int rc;
> +
> +	priv = hw->priv;
> +
> +	rc = request_irq(priv->pdev->irq, mwl_isr,
> +			 IRQF_SHARED, MWL_DRV_NAME, hw);
> +	if (rc) {
> +		priv->irq = -1;
> +		wiphy_err(hw->wiphy, "fail to register IRQ
handler\n");
> +		return rc;
> +	}
> +	priv->irq = priv->pdev->irq;

Why do you do this every time you bring up the device? It's smarter to
do this once for registration.

> +	/* Enable TX reclaim and RX tasklets. */
> +	tasklet_enable(&priv->tx_task);
> +	tasklet_enable(&priv->rx_task);
> +
> +	/* Enable interrupts */
> +	mwl_fwcmd_int_enable(hw);

Obviously you don't have to *enable* interrupts, until here, but re
-registering all the time seems strange.

> +	/* Disable TX reclaim and RX tasklets. */
> +	tasklet_disable(&priv->tx_task);
> +	tasklet_disable(&priv->rx_task);
> +
> +	/* Return all skbs to mac80211 */
> +	mwl_tx_done((unsigned long)hw);

Err, why would you have an internal function that takes an 'unsigned
long' instead of a properly typed pointer??

> +	if (!macid--) {

That's ... awkward. Better rewrite it to check first and then decrement
later.

> +	if (vif->type == NL80211_IFTYPE_STATION) {
> +		ether_addr_copy(mwl_vif->sta_mac, vif->addr);
> +		mwl_vif->is_sta = true;
> +		mwl_fwcmd_bss_start(hw, vif, true);
> +		mwl_fwcmd_set_infra_mode(hw, vif);
> +		mwl_fwcmd_set_mac_addr_client(hw, vif, vif->addr);
> +	}
> +
> +	if (vif->type == NL80211_IFTYPE_AP) {
> +		ether_addr_copy(mwl_vif->bssid, vif->addr);
> +		mwl_fwcmd_set_new_stn_add_self(hw, vif);
> +	}

switch?

> +	if (vif->type == NL80211_IFTYPE_STATION)
> +		mwl_fwcmd_remove_mac_addr(hw, vif, vif->addr);
> +
> +	if (vif->type == NL80211_IFTYPE_AP)
> +		mwl_fwcmd_set_new_stn_del(hw, vif, vif->addr);

ditto

> +	wiphy_debug(hw->wiphy, "interface: %d, change: 0x%x\n",
> +		    vif->type, changed);
> +
> +	if (vif->type == NL80211_IFTYPE_STATION)
> +		mwl_mac80211_bss_info_changed_sta(hw, vif, info,
changed);
> +
> +	if (vif->type == NL80211_IFTYPE_AP)
> +		mwl_mac80211_bss_info_changed_ap(hw, vif, info,
changed);

ditto

> +static int mwl_mac80211_ampdu_action(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     enum ieee80211_ampdu_mlme_action
action,
> +				     struct ieee80211_sta *sta,
> +				     u16 tid, u16 *ssn, u8 buf_size)
> +{
[...]
> +	spin_lock(&priv->stream_lock);
[...]
> +			stream = mwl_fwcmd_add_stream(hw, sta, tid);

This is about the only place that actually sends a command while it
can't sleep. It seems you should be able to restructure this function
to avoid that, so that you don't have to use a spinlock for command
sending and don't need all that busy-polling but can properly go to
sleep while waiting for the firmware to respond to a command.

> +const struct ieee80211_ops mwl_mac80211_ops = {
> +	.tx                 = mwl_mac80211_tx,
> +	.start              = mwl_mac80211_start,
> +	.stop               = mwl_mac80211_stop,
> +	.add_interface      = mwl_mac80211_add_interface,
> +	.remove_interface   = mwl_mac80211_remove_interface,
> +	.config             = mwl_mac80211_config,
> +	.bss_info_changed   = mwl_mac80211_bss_info_changed,
> +	.configure_filter   = mwl_mac80211_configure_filter,
> +	.set_key            = mwl_mac80211_set_key,
> +	.set_rts_threshold  = mwl_mac80211_set_rts_threshold,
> +	.sta_add            = mwl_mac80211_sta_add,
> +	.sta_remove         = mwl_mac80211_sta_remove,
> +	.conf_tx            = mwl_mac80211_conf_tx,
> +	.get_stats          = mwl_mac80211_get_stats,
> +	.get_survey         = mwl_mac80211_get_survey,
> +	.ampdu_action       = mwl_mac80211_ampdu_action,
> +};

All the callbacks that you use can sleep (apart from TX where you don't
send firmware commands), so really all you have to do is restructure
the aggregation code slightly.

> diff --git a/drivers/net/wireless/mwlwifi/mac80211.h
b/drivers/net/wireless/mwlwifi/mac80211.h
> new file mode 100644
> index 0000000..0267dd85
> --- /dev/null
> +++ b/drivers/net/wireless/mwlwifi/mac80211.h
> @@ -0,0 +1,25 @@
> +/*
> + * Copyright (C) 2006-2015, Marvell International Ltd.
> + *
> + * This software file (the "File") is distributed by Marvell
International
> + * Ltd. under the terms of the GNU General Public License Version 2,
June 1991
> + * (the "License").  You may use, redistribute and/or modify this
File in
> + * accordance with the terms and conditions of the License, a copy
of which
> + * is available by writing to the Free Software Foundation, Inc.
> + *
> + * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND
THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR
PURPOSE
> + * ARE EXPRESSLY DISCLAIMED.  The License provides additional
details about
> + * this warranty disclaimer.
> + */
> +
> +/* Description:  This file defines mac80211 related functions. */
> +
> +#ifndef _mac80211_h_
> +#define _mac80211_h_
> +
> +#include <net/mac80211.h>
> +
> +extern const struct ieee80211_ops mwl_mac80211_ops;
> +
> +#endif /* _mac80211_h_ */

That file seems somewhat pointless :)
Just put the one line into dev.h?

> +	wiphy_info(priv->hw->wiphy, "priv->iobase1 = %p\n", priv
->iobase1);

At "info" level, that seems a bit overkill.

> +	priv->pcmd_buf =
> +		(unsigned short *)dma_alloc_coherent(&priv->pdev->dev,
> +						     CMD_BUF_SIZE,
> +						     &priv
->pphys_cmd_buf,
> +						     GFP_KERNEL);
> +
> +	if (!priv->pcmd_buf) {
> +		wiphy_err(priv->hw->wiphy,
> +			  "%s: cannot alloc memory for command
buffer\n",
> +			  MWL_DRV_NAME);
> +		goto err_iounmap_iobase1;
> +	}
> +
> +	wiphy_info(priv->hw->wiphy,
> +		   "priv->pcmd_buf = %p  priv->pphys_cmd_buf = %p\n",
> +		   priv->pcmd_buf,
> +		   (void *)priv->pphys_cmd_buf);

Ditto. Nobody will ever want to see this.

Also, there's usually no need to print anything on allocation failures
as they're very noisy already.

> +     rc = pci_set_dma_mask(pdev, 0xffffffff);

You should use one of the DMA mask constants.

> +	if (desc->prx_ring) {
> +		desc->rx_buf_size = SYSADPT_MAX_AGGR_SIZE;
> +
> +		for (i = 0; i < SYSADPT_MAX_NUM_RX_DESC; i++) {
> +			rx_hndl = &desc->rx_hndl[i];
> +			rx_hndl->psk_buff =
> +				dev_alloc_skb(desc->rx_buf_size);
> +
> +			if (!rx_hndl->psk_buff) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "rxdesc %i: no skbuff
available\n",
> +					  i);
> +				return -ENOMEM;
> +			}
> +
> +			if (skb_linearize(rx_hndl->psk_buff)) {
> +				dev_kfree_skb_any(rx_hndl->psk_buff);
> +				rx_hndl->psk_buff = NULL;
> +				wiphy_err(priv->hw->wiphy,
> +					  "need linearize memory\n");
> +				return -ENOMEM;
> +			}

This is still completely pointless.

> +			skb_reserve(rx_hndl->psk_buff,
> +				    SYSADPT_MIN_BYTES_HEADROOM);
> +			desc->prx_ring[i].rx_control =
> +				EAGLE_RXD_CTRL_DRIVER_OWN;
> +			desc->prx_ring[i].status =
EAGLE_RXD_STATUS_OK;
> +			desc->prx_ring[i].qos_ctrl = 0x0000;
> +			desc->prx_ring[i].channel = 0x00;
> +			desc->prx_ring[i].rssi = 0x00;
> +			desc->prx_ring[i].pkt_len =
> +				cpu_to_le16(SYSADPT_MAX_AGGR_SIZE);
> +			dma = pci_map_single(priv->pdev,
> +					     rx_hndl->psk_buff->data,
> +					     desc->rx_buf_size,
> +					     PCI_DMA_FROMDEVICE);

You need to check the return value (properly - use the right function,
not != NULL!)

> +	if (desc->prx_ring) {
> +		for (i = 0; i < SYSADPT_MAX_NUM_RX_DESC; i++) {
> +			rx_hndl = &desc->rx_hndl[i];
> +			if (!rx_hndl->psk_buff)
> +				continue;
> +
> +			if (skb_shinfo(rx_hndl->psk_buff)->nr_frags)
> +				skb_shinfo(rx_hndl->psk_buff)
->nr_frags = 0;
> +
> +			if (skb_shinfo(rx_hndl->psk_buff)->frag_list)
> +				skb_shinfo(rx_hndl->psk_buff)
->frag_list = NULL;

How do you think this would make any sense??


> +		if (pdesc->status != GENERAL_DECRYPT_ERR) {
> +			if (((pdesc->status & (~DECRYPT_ERR_MASK)) &
> +			    TKIP_DECRYPT_MIC_ERR) && !((pdesc->status
&
> +			    (WEP_DECRYPT_ICV_ERR |
TKIP_DECRYPT_ICV_ERR)))) {

The code formatting for this condition is very very strange.

> +static int mwl_rx_refill(struct mwl_priv *priv, struct mwl_rx_hndl
*rx_hndl)
> +{
> +	struct mwl_desc_data *desc;
> +
> +	desc = &priv->desc_data[0];
> +
> +	rx_hndl->psk_buff = dev_alloc_skb(desc->rx_buf_size);
> +
> +	if (!rx_hndl->psk_buff)
> +		goto nomem;
> +
> +	if (skb_linearize(rx_hndl->psk_buff)) {
> +		dev_kfree_skb_any(rx_hndl->psk_buff);
> +		wiphy_err(priv->hw->wiphy, "need linearize memory\n");
> +		goto nomem;
> +	}

Still make no sense.

> +	rx_hndl->pdesc->pphys_buff_data =
> +		cpu_to_le32(pci_map_single(priv->pdev,
> +					   rx_hndl->psk_buff->data,
> +					   desc->rx_buf_size,
> +					   PCI_DMA_BIDIRECTIONAL));

Also need to check the return value. BIDIRECTIONAL also seems wrong.


> +int mwl_rx_init(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv;
> +	int rc;
> +
> +	priv = hw->priv;
> +
> +	rc = mwl_rx_ring_alloc(priv);
> +	if (rc) {
> +		wiphy_err(hw->wiphy, "allocating RX ring failed\n");
> +	} else {
> +		rc = mwl_rx_ring_init(priv);
> +		if (rc) {
> +			mwl_rx_ring_free(priv);
> +			wiphy_err(hw->wiphy,
> +				  "initializing RX ring failed\n");
> +		}
> +	}

Better write this as 

 rc = alloc()
 if (rc)
   return;
 rc = init()
 if (rc)
   return;

etc.

> +			if (ieee80211_has_tods(wh->frame_control))
> +				mwl_vif = mwl_rx_find_vif_bss(priv, wh
->addr1);
> +			else
> +				mwl_vif = mwl_rx_find_vif_bss(priv, wh
->addr2);
> +
> +			if (mwl_vif && mwl_vif->is_hw_crypto_enabled)
{
> +				/* When MMIC ERROR is encountered
> +				 * by the firmware, payload is
> +				 * dropped and only 32 bytes of
> +				 * mwl8k Firmware header is sent
> +				 * to the host.
> +				 *
> +				 * We need to add four bytes of
> +				 * key information.  In it
> +				 * MAC80211 expects keyidx set to
> +				 * 0 for triggering Counter
> +				 * Measure of MMIC failure.
> +				 */

Umm. That's only true for PTKs.

> +static int mwl_tx_ring_alloc(struct mwl_priv *priv)
> +{
> +	struct mwl_desc_data *desc;
> +	int num;
> +	u8 *mem;
> +
> +	desc = &priv->desc_data[0];
> +
> +	mem = (u8 *)dma_alloc_coherent(&priv->pdev->dev,
> +		MAX_NUM_TX_RING_BYTES * SYSADPT_NUM_OF_DESC_DATA,
> +		&desc->pphys_tx_ring, GFP_KERNEL);

That cast is pointless, the function returns void *.

> +static inline void mwl_tx_insert_ccmp_hdr(u8 *pccmp_hdr,
> +					  u8 key_id, u16 iv16, u32
iv32)
> +{
> +	*((u16 *)pccmp_hdr) = iv16;
> +	pccmp_hdr[2] = 0;
> +	pccmp_hdr[3] = EXT_IV | (key_id << 6);
> +	*((u32 *)&pccmp_hdr[4]) = iv32;
> +}

Why don't you let mac80211 do this? You also have clear alignment and
endian issues here, so mac80211 will do it better...

> +	if (tx_stats->start_time == 0)
> +		tx_stats->start_time = jiffies;

Btw, don't remember if I commented on this before - but you can't store
jiffies in a u32, need unsigned long.


> +	if (tx_hndl->pdesc->status !=
> +	    EAGLE_TXD_STATUS_IDLE) {

what's with the linebreak?


> +	if (ieee80211_is_data(wh->frame_control)) {
> +		if (is_multicast_ether_addr(wh->addr1)) {
> +			if (ccmp) {
> +				mwl_tx_insert_ccmp_hdr(dma_data->data,
> +						       mwl_vif
->keyidx,
> +						       mwl_vif->iv16,
> +						       mwl_vif->iv32);
> +				INCREASE_IV(mwl_vif->iv16, mwl_vif
->iv32);
> +			}
> +		} else {
> +			if (ccmp) {
> +				if (mwl_vif->is_sta) {
> +					mwl_tx_insert_ccmp_hdr(dma_dat
a->data,
> +							       mwl_vif
->keyidx,
> +							       mwl_vif
->iv16,
> +							       mwl_vif
->iv32);
> +					INCREASE_IV(mwl_vif->iv16,
> +						    mwl_vif->iv32);
> +				} else {
> +					struct mwl_sta *sta_info;
> +
> +					sta_info =
mwl_dev_get_sta(sta);
> +
> +					mwl_tx_insert_ccmp_hdr(dma_dat
a->data,
> +							       0,
> +							      
 sta_info->iv16,
> +							      
 sta_info->iv32);
> +					INCREASE_IV(sta_info->iv16,
> +						    sta_info->iv32);
> +				}
> +			}
> +		}
> +	}

All of this is very very dubious. Why not let mac80211 handle it?

> +	tx_desc->pkt_ptr =
> +		cpu_to_le32(pci_map_single(priv->pdev, tx_skb->data,
> +					   tx_skb->len,
PCI_DMA_TODEVICE));

missing error check

> +int mwl_tx_init(struct ieee80211_hw *hw)
> +{
> +	struct mwl_priv *priv;
> +	int rc;
> +
> +	priv = hw->priv;
> +
> +	skb_queue_head_init(&priv->delay_q);
> +
> +	rc = mwl_tx_ring_alloc(priv);
> +	if (rc) {
> +		wiphy_err(hw->wiphy, "allocating TX ring failed\n");
> +	} else {
> +		rc = mwl_tx_ring_init(priv);
> +		if (rc) {
> +			mwl_tx_ring_free(priv);
> +			wiphy_err(hw->wiphy, "initializing TX ring
failed\n");
> +		}
> +	}
> +
> +	return rc;
> +}

Same comment as on RX.

> +	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
> +		index = IEEE80211_AC_VO;
> +		eapol_frame = true;
> +	}

There's a tx_info flag for this that's a bit more generic.

johannes
