Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740Ab1DYRxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:41 -0400
Date: Mon, 25 Apr 2011 12:53:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/18] rtlwifi: Convert usb routines for addition of
 rtl8192se and rtl8192de
Message-ID: <4db5b519.CIMEt3gjfBZzSz/G%Larry.Finger@lwfinger.net> (sfid-20110425_195346_840967_7335E33B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Convert usb routines for addition of RTL8192SE and RTL8192DE code

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 pci.c  |    2 --
 usb.c  |   16 +++++++++++++++-
 usb.h  |    2 ++
 wifi.h |    7 -------
 4 files changed, 17 insertions(+), 10 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -852,6 +852,7 @@ static void _rtl_usb_tx_preprocess(struc
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rtl_tx_desc *pdesc = NULL;
+	struct rtl_tcb_desc tcb_desc;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 	u8 *pda_addr = hdr->addr1;
@@ -860,6 +861,17 @@ static void _rtl_usb_tx_preprocess(struc
 	u8 tid = 0;
 	u16 seq_number = 0;
 
+	if (ieee80211_is_auth(fc)) {
+		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
+		rtl_ips_nic_on(hw);
+	}
+
+	if (rtlpriv->psc.sw_ps_enabled) {
+		if (ieee80211_is_data(fc) && !ieee80211_is_nullfunc(fc) &&
+		    !ieee80211_has_pm(fc))
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+	}
+
 	rtl_action_proc(hw, skb, true);
 	if (is_multicast_ether_addr(pda_addr))
 		rtlpriv->stats.txbytesmulticast += skb->len;
@@ -876,7 +888,7 @@ static void _rtl_usb_tx_preprocess(struc
 		seq_number <<= 4;
 	}
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, info, skb,
-					hw_queue);
+					hw_queue, &tcb_desc);
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		if (qc)
 			mac->tids[tid].seq_number = seq_number;
@@ -1032,3 +1044,5 @@ int rtl_usb_resume(struct usb_interface
 	return 0;
 }
 EXPORT_SYMBOL(rtl_usb_resume);
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.h
@@ -164,3 +164,5 @@ int rtl_usb_suspend(struct usb_interface
 int rtl_usb_resume(struct usb_interface *pusb_intf);
 
 #endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -1569,10 +1569,8 @@ int rtl_pci_tx(struct ieee80211_hw *hw,
 	if (ieee80211_is_data(fc))
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 
-#if 0	/* temporary */
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc,
 			info, skb, hw_queue, ptcb_desc);
-#endif
 
 	__skb_queue_tail(&ring->queue, skb);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1378,18 +1378,11 @@ struct rtl_hal_ops {
 	void (*update_rate_table) (struct ieee80211_hw *hw);
 #endif
 	void (*update_rate_mask) (struct ieee80211_hw *hw, u8 rssi_level);
-#if 0	/* temporary */
 	void (*fill_tx_desc) (struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			      struct ieee80211_tx_info *info,
 			      struct sk_buff *skb, u8 hw_queue,
 			      struct rtl_tcb_desc *ptcb_desc);
-#else
-	void (*fill_tx_desc) (struct ieee80211_hw *hw,
-			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			      struct ieee80211_tx_info *info,
-			      struct sk_buff *skb, unsigned int queue_index);
-#endif
 	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 *pDesc,
 				  u32 buffer_len, bool bIsPsPoll);
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,

