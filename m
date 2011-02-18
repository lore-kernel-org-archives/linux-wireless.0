Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36436 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab1BRQxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 11:53:47 -0500
Received: by fxm20 with SMTP id 20so3978088fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 08:53:46 -0800 (PST)
Message-ID: <4D5EA1D4.9080600@lwfinger.net>
Date: Fri, 18 Feb 2011 10:44:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/14] rtlwifi: rtl8192cu: Add routine trx
References: <4d5d90c9.sN3PKFogcRQR8mbQ%Larry.Finger@lwfinger.net> <20110218112633.GA2270@redhat.com>
In-Reply-To: <20110218112633.GA2270@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2011 05:26 AM, Stanislaw Gruszka wrote:
> On Thu, Feb 17, 2011 at 03:19:05PM -0600, Larry Finger wrote:
>> +static enum rtl_desc_qsel _rtl8192cu_mq_to_descq(struct ieee80211_hw *hw,
>> +					 u16 fc, u16 mac80211_queue_index)
>> +{
>> +	enum rtl_desc_qsel qsel;
>> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
>> +
>> +	if (unlikely(ieee80211_is_beacon(fc))) {
>> +		qsel = QSLT_BEACON;
>> +		goto out;
>> +	}
>> +	if (ieee80211_is_mgmt(fc)) {
> [snip]
>> +	u16 fc = le16_to_cpu(hdr->frame_control);
>> +	enum rtl_desc_qsel fw_qsel = _rtl8192cu_mq_to_descq(hw, fc,
>
> We have that bug on all over the code, ieee80211_is_* expect le16 value
> whereas we pass cpu endian value. Driver is completely broken on that
> respect, it will not work on big endian machines.
>
> What should be done is use "sparse" (i.e. make C=1) and fix all
> endian bugs. That will not assure driver will work on BE machines,
> but at least we will fix obvious bugs.

There are a lot of endian warnings besides the frame_header ones. Fixing many of 
them will require rewriting those macros that you mentioned in an earlier 
message. My efforts on those usually end up breaking the drivers and I had hoped 
to defer that effort, but it seems that the time has come. While I'm doing that, 
will you look at my first cut at fixing endian issues to make sure I'm doing it 
correctly?

Thanks,

Larry

=============================

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -144,7 +144,7 @@ static void _rtl_init_hw_ht_capab(struct
  		ht_cap->mcs.rx_mask[1] = 0xFF;
  		ht_cap->mcs.rx_mask[4] = 0x01;

-		ht_cap->mcs.rx_highest = MAX_BIT_RATE_40MHZ_MCS15;
+		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
  	} else if (get_rf_type(rtlphy) == RF_1T1R) {

  		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("1T1R\n"));
@@ -153,7 +153,7 @@ static void _rtl_init_hw_ht_capab(struct
  		ht_cap->mcs.rx_mask[1] = 0x00;
  		ht_cap->mcs.rx_mask[4] = 0x01;

-		ht_cap->mcs.rx_highest = MAX_BIT_RATE_40MHZ_MCS7;
+		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS7);
  	}
  }

@@ -498,7 +498,7 @@ void rtl_get_tcb_desc(struct ieee80211_h
  	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
  	struct ieee80211_rate *txrate;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;

  	memset(tcb_desc, 0, sizeof(struct rtl_tcb_desc));

@@ -570,7 +570,7 @@ bool rtl_tx_mgmt_proc(struct ieee80211_h
  	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
  	struct rtl_priv *rtlpriv = rtl_priv(hw);
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;

  	if (ieee80211_is_auth(fc)) {
  		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
@@ -587,7 +587,7 @@ bool rtl_action_proc(struct ieee80211_hw
  	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
  	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u8 *act = (u8 *) (((u8 *) skb->data + MAC80211_3ADDR_LEN));
  	u8 category;

@@ -632,7 +632,7 @@ u8 rtl_is_special_data(struct ieee80211_
  	struct rtl_priv *rtlpriv = rtl_priv(hw);
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
  	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u16 ether_type;
  	u8 mac_hdr_len = ieee80211_get_hdrlen_from_skb(skb);
  	const struct iphdr *ip;
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -434,9 +434,9 @@ static int rtl_op_conf_tx(struct ieee802

  	aci = _rtl_get_hal_qnum(queue);
  	mac->ac[aci].aifs = param->aifs;
-	mac->ac[aci].cw_min = param->cw_min;
-	mac->ac[aci].cw_max = param->cw_max;
-	mac->ac[aci].tx_op = param->txop;
+	mac->ac[aci].cw_min = cpu_to_le16(param->cw_min);
+	mac->ac[aci].cw_max = cpu_to_le16(param->cw_max);
+	mac->ac[aci].tx_op = cpu_to_le16(param->txop);
  	memcpy(&mac->edca_param[aci], param, sizeof(*param));
  	rtlpriv->cfg->ops->set_qos(hw, aci);
  	return 0;
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -476,9 +476,9 @@ static void _rtl_pci_tx_isr(struct ieee8

  		skb = __skb_dequeue(&ring->queue);
  		pci_unmap_single(rtlpci->pdev,
-				 le32_to_cpu(rtlpriv->cfg->ops->
+				 rtlpriv->cfg->ops->
  					     get_desc((u8 *) entry, true,
-						      HW_DESC_TXBUFF_ADDR)),
+						      HW_DESC_TXBUFF_ADDR),
  				 skb->len, PCI_DMA_TODEVICE);

  		RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_TRACE,
@@ -557,7 +557,7 @@ static void _rtl_pci_rx_interrupt(struct
  			return;
  		} else {
  			struct ieee80211_hdr *hdr;
-			u16 fc;
+			__le16 fc;
  			struct sk_buff *new_skb = NULL;

  			rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
@@ -583,7 +583,7 @@ static void _rtl_pci_rx_interrupt(struct
  			 */

  			hdr = (struct ieee80211_hdr *)(skb->data);
-			fc = le16_to_cpu(hdr->frame_control);
+			fc = hdr->frame_control;

  			if (!stats.crc) {
  				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
@@ -1052,9 +1052,9 @@ static void _rtl_pci_free_tx_ring(struct
  		struct sk_buff *skb = __skb_dequeue(&ring->queue);

  		pci_unmap_single(rtlpci->pdev,
-				 le32_to_cpu(rtlpriv->cfg->
+				 rtlpriv->cfg->
  					     ops->get_desc((u8 *) entry, true,
-						   HW_DESC_TXBUFF_ADDR)),
+						   HW_DESC_TXBUFF_ADDR),
  				 skb->len, PCI_DMA_TODEVICE);
  		kfree_skb(skb);
  		ring->idx = (ring->idx + 1) % ring->entries;
@@ -1186,11 +1186,11 @@ int rtl_pci_reset_trx_ring(struct ieee80
  				    __skb_dequeue(&ring->queue);

  				pci_unmap_single(rtlpci->pdev,
-						 le32_to_cpu(rtlpriv->cfg->ops->
+						 rtlpriv->cfg->ops->
  							 get_desc((u8 *)
  							 entry,
  							 true,
-							 HW_DESC_TXBUFF_ADDR)),
+							 HW_DESC_TXBUFF_ADDR),
  						 skb->len, PCI_DMA_TODEVICE);
  				kfree_skb(skb);
  				ring->idx = (ring->idx + 1) % ring->entries;
@@ -1204,7 +1204,7 @@ int rtl_pci_reset_trx_ring(struct ieee80
  	return 0;
  }

-static unsigned int _rtl_mac_to_hwqueue(u16 fc,
+static unsigned int _rtl_mac_to_hwqueue(__le16 fc,
  		unsigned int mac80211_queue_index)
  {
  	unsigned int hw_queue_index;
@@ -1254,7 +1254,7 @@ static int rtl_pci_tx(struct ieee80211_h
  	unsigned int queue_index, hw_queue;
  	unsigned long flags;
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u8 *pda_addr = hdr->addr1;
  	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
  	/*ssn */
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -126,7 +126,7 @@ static u32 _usb_read_sync(struct usb_dev

  	wvalue = (u16)addr;
  	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	ret = le32_to_cpu(*data);
+	ret = *data;
  	kfree(data);
  	return ret;
  }
@@ -163,7 +163,7 @@ static void _usb_write_async(struct usb_
  	request = REALTEK_USB_VENQT_CMD_REQ;
  	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
  	wvalue = (u16)(addr&0x0000ffff);
-	data = cpu_to_le32(val);
+	data = val;
  	_usbctrl_vendorreq_async_write(udev, request, wvalue, index, &data,
  				       len);
  }
@@ -437,7 +437,7 @@ static void _rtl_usb_rx_process_agg(stru
  	u8 *rxdesc = skb->data;
  	struct ieee80211_hdr *hdr;
  	bool unicast = false;
-	u16 fc;
+	__le16 fc;
  	struct ieee80211_rx_status rx_status = {0};
  	struct rtl_stats stats = {
  		.signal = 0,
@@ -449,7 +449,7 @@ static void _rtl_usb_rx_process_agg(stru
  	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
  	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
  	hdr = (struct ieee80211_hdr *)(skb->data);
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
  	if (!stats.crc) {
  		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));

@@ -480,7 +480,7 @@ static void _rtl_usb_rx_process_noagg(st
  	u8 *rxdesc = skb->data;
  	struct ieee80211_hdr *hdr;
  	bool unicast = false;
-	u16 fc;
+	__le16 fc;
  	struct ieee80211_rx_status rx_status = {0};
  	struct rtl_stats stats = {
  		.signal = 0,
@@ -492,7 +492,7 @@ static void _rtl_usb_rx_process_noagg(st
  	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
  	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
  	hdr = (struct ieee80211_hdr *)(skb->data);
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
  	if (!stats.crc) {
  		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));

@@ -853,7 +853,7 @@ static void _rtl_usb_tx_preprocess(struc
  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
  	struct rtl_tx_desc *pdesc = NULL;
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u8 *pda_addr = hdr->addr1;
  	/* ssn */
  	u8 *qc = NULL;
@@ -892,7 +892,7 @@ static int rtl_usb_tx(struct ieee80211_h
  	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
  	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u16 hw_queue;

  	if (unlikely(is_hal_stop(rtlhal)))
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -36,7 +36,7 @@
  #include "trx.h"
  #include "led.h"

-static enum rtl_desc_qsel _rtl92ce_map_hwqueue_to_fwqueue(u16 fc,
+static enum rtl_desc_qsel _rtl92ce_map_hwqueue_to_fwqueue(__le16 fc,
  							  unsigned int
  							  skb_queue)
  {
@@ -617,13 +617,13 @@ static void _rtl92ce_translate_rx_signal
  	u8 *tmp_buf;
  	u8 *praddr;
  	u8 *psaddr;
-	u16 fc, type;
+	__le16 fc, type;
  	bool packet_matchbssid, packet_toself, packet_beacon;

  	tmp_buf = skb->data + pstats->rx_drvinfo_size + pstats->rx_bufshift;

  	hdr = (struct ieee80211_hdr *)tmp_buf;
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
  	type = WLAN_FC_GET_TYPE(fc);
  	praddr = hdr->addr1;
  	psaddr = hdr->addr2;
@@ -736,12 +736,11 @@ void rtl92ce_tx_fill_desc(struct ieee802
  	u8 *qc = ieee80211_get_qos_ctl(hdr);
  	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
  	u16 seq_number;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u8 rate_flag = info->control.rates[0].flags;

  	enum rtl_desc_qsel fw_qsel =
-	    _rtl92ce_map_hwqueue_to_fwqueue(le16_to_cpu(hdr->frame_control),
-					    queue_index);
+	    _rtl92ce_map_hwqueue_to_fwqueue(fc, queue_index);

  	bool firstseg = ((hdr->seq_ctrl &
  			  cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
@@ -901,7 +900,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee
  					    PCI_DMA_TODEVICE);

  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;

  	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -418,10 +418,13 @@ void rtl92c_set_qos(struct ieee80211_hw
  	rtl92c_dm_init_edca_turbo(hw);
  	u4b_ac_param = (u32) mac->ac[aci].aifs;
  	u4b_ac_param |=
-	    ((u32) mac->ac[aci].cw_min & 0xF) << AC_PARAM_ECW_MIN_OFFSET;
+	    ((u32) le16_to_cpu(mac->ac[aci].cw_min) & 0xF) <<
+	    AC_PARAM_ECW_MIN_OFFSET;
  	u4b_ac_param |=
-	    ((u32) mac->ac[aci].cw_max & 0xF) << AC_PARAM_ECW_MAX_OFFSET;
-	u4b_ac_param |= (u32) mac->ac[aci].tx_op << AC_PARAM_TXOP_LIMIT_OFFSET;
+	    ((u32) le16_to_cpu(mac->ac[aci].cw_max) & 0xF) <<
+	    AC_PARAM_ECW_MAX_OFFSET;
+	u4b_ac_param |= (u32) le16_to_cpu(mac->ac[aci].tx_op) <<
+			 AC_PARAM_TXOP_LIMIT_OFFSET;
  	RT_TRACE(rtlpriv, COMP_QOS, DBG_LOUD,
  		 ("queue:%x, ac_param:%x\n", aci, u4b_ac_param));
  	switch (aci) {
@@ -1109,21 +1112,23 @@ void rtl92c_translate_rx_signal_stuff(st
  	u8 *tmp_buf;
  	u8 *praddr;
  	u8 *psaddr;
-	u16 fc, type;
+	__le16 fc;
+	u16 type, cpu_fc;
  	bool packet_matchbssid, packet_toself, packet_beacon;

  	tmp_buf = skb->data + pstats->rx_drvinfo_size + pstats->rx_bufshift;
  	hdr = (struct ieee80211_hdr *)tmp_buf;
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
+	cpu_fc = le16_to_cpu(fc);
  	type = WLAN_FC_GET_TYPE(fc);
  	praddr = hdr->addr1;
  	psaddr = hdr->addr2;
  	packet_matchbssid =
  	    ((IEEE80211_FTYPE_CTL != type) &&
  	     (!compare_ether_addr(mac->bssid,
-				  (fc & IEEE80211_FCTL_TODS) ?
-				  hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ?
-				  hdr->addr2 : hdr->addr3)) &&
+			  (cpu_fc & IEEE80211_FCTL_TODS) ?
+			  hdr->addr1 : (cpu_fc & IEEE80211_FCTL_FROMDS) ?
+			  hdr->addr2 : hdr->addr3)) &&
  	     (!pstats->hwerror) && (!pstats->crc) && (!pstats->icv));

  	packet_toself = packet_matchbssid &&
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -217,7 +217,7 @@ err_out:
  	return error;
  }

-u16 rtl8192cu_mq_to_hwq(u16 fc, u16 mac80211_queue_index)
+u16 rtl8192cu_mq_to_hwq(__le16 fc, u16 mac80211_queue_index)
  {
  	u16 hw_queue_index;

@@ -253,7 +253,7 @@ out:
  }

  static enum rtl_desc_qsel _rtl8192cu_mq_to_descq(struct ieee80211_hw *hw,
-					 u16 fc, u16 mac80211_queue_index)
+					 __le16 fc, u16 mac80211_queue_index)
  {
  	enum rtl_desc_qsel qsel;
  	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -369,7 +369,7 @@ static void _rtl_rx_process(struct ieee8
  	};
  	struct rx_fwinfo_92c *p_drvinfo;
  	bool bv;
-	u16 fc;
+	__le16 fc;
  	struct ieee80211_hdr *hdr;

  	memset(rx_status, 0, sizeof(rx_status));
@@ -419,7 +419,7 @@ static void _rtl_rx_process(struct ieee8
  	}
  	skb_pull(skb, (drvinfo_len + RTL_RX_DESC_SIZE));
  	hdr = (struct ieee80211_hdr *)(skb->data);
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
  	bv = ieee80211_is_probe_resp(fc);
  	if (bv)
  		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
@@ -509,7 +509,7 @@ void rtl92cu_tx_fill_desc(struct ieee802
  	u8 *qc = ieee80211_get_qos_ctl(hdr);
  	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
  	u16 seq_number;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
  	u8 rate_flag = info->control.rates[0].flags;
  	u16 pktlen = skb->len;
  	enum rtl_desc_qsel fw_qsel = _rtl8192cu_mq_to_descq(hw, fc,
@@ -651,7 +651,7 @@ void rtl92cu_tx_fill_cmddesc(struct ieee
  	struct rtl_priv *rtlpriv = rtl_priv(hw);
  	u8 fw_queue = QSLT_BEACON;
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;

  	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
  	if (firstseg)
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -378,7 +378,7 @@ struct rx_drv_info_92c {


  int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw);
-u16 rtl8192cu_mq_to_hwq(u16 fc, u16 mac80211_queue_index);
+u16 rtl8192cu_mq_to_hwq(__le16 fc, u16 mac80211_queue_index);
  bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
  			   struct rtl_stats *stats,
  			   struct ieee80211_rx_status *rx_status,
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.h
@@ -114,7 +114,7 @@ struct rtl_usb {
  	u32 irq_mask[2];
  	bool irq_enabled;

-	u16 (*usb_mq_to_hwq)(u16 fc, u16 mac80211_queue_index);
+	u16 (*usb_mq_to_hwq)(__le16 fc, u16 mac80211_queue_index);

  	/* Tx */
  	u8 out_ep_nums ;
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1427,7 +1427,7 @@ struct rtl_hal_usbint_cfg {

  	/* endpoint mapping */
  	int (*usb_endpoint_mapping)(struct ieee80211_hw *hw);
-	u16 (*usb_mq_to_hwq)(u16 fc, u16 mac80211_queue_index);
+	u16 (*usb_mq_to_hwq)(__le16 fc, u16 mac80211_queue_index);
  };

  struct rtl_hal_cfg {
@@ -1760,7 +1760,7 @@ Set subfield of little-endian 4-byte val
  #define RTL_WATCH_DOG_TIME	2000
  #define MSECS(t)		msecs_to_jiffies(t)
  #define WLAN_FC_GET_VERS(fc)	((fc) & IEEE80211_FCTL_VERS)
-#define WLAN_FC_GET_TYPE(fc)	((fc) & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_TYPE(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_FTYPE)
  #define WLAN_FC_GET_STYPE(fc)	((fc) & IEEE80211_FCTL_STYPE)
  #define WLAN_FC_MORE_DATA(fc)	((fc) & IEEE80211_FCTL_MOREDATA)
  #define SEQ_TO_SN(seq)		(((seq) & IEEE80211_SCTL_SEQ) >> 4)
