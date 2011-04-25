Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1DYRxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:43 -0400
Date: Mon, 25 Apr 2011 12:53:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/18] rtlwifi: rtl8192c-common: Change common firmware
 routines for addition of rtl8192se and rtl8192de
Message-ID: <4db5b524.KlKTFdrT9Ve2K7m/%Larry.Finger@lwfinger.net> (sfid-20110425_195348_556424_93D6FEEE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change common firmware routines for addition of RTL8192SE and
RTL8192DE code.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 fw_common.c |   83 +++++++++++++++++++++++++++++++++++++-----------------------
 fw_common.h |    5 ++-
 2 files changed, 55 insertions(+), 33 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -223,29 +223,15 @@ int rtl92c_download_fw(struct ieee80211_
 	u8 *pfwdata;
 	u32 fwsize;
 	enum version_8192c version = rtlhal->version;
-	const struct firmware *firmware;
 
 	printk(KERN_INFO "rtl8192c: Loading firmware file %s\n",
 	       rtlpriv->cfg->fw_name);
-	if (request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			    rtlpriv->io.dev)) {
-		printk(KERN_ERR "rtl8192c: Firmware loading failed\n");
+	if (!rtlhal->pfirmware)
 		return 1;
-	}
-
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Firmware is too big!\n"));
-		release_firmware(firmware);
-		return 1;
-	}
-
-	memcpy(rtlhal->pfirmware, firmware->data, firmware->size);
-	fwsize = firmware->size;
-	release_firmware(firmware);
 
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *) rtlhal->pfirmware;
+	fwsize = rtlhal->fwsize;
 
 	if (IS_FW_HEADER_EXIST(pfwheader)) {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
@@ -553,6 +539,39 @@ void rtl92c_set_fw_pwrmode_cmd(struct ie
 }
 EXPORT_SYMBOL(rtl92c_set_fw_pwrmode_cmd);
 
+static bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
+				struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl8192_tx_ring *ring;
+	struct rtl_tx_desc *pdesc;
+	u8 own;
+	unsigned long flags;
+	struct sk_buff *pskb = NULL;
+
+	ring = &rtlpci->tx_ring[BEACON_QUEUE];
+
+	pskb = __skb_dequeue(&ring->queue);
+	if (pskb)
+		kfree_skb(pskb);
+
+	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
+
+	pdesc = &ring->desc[0];
+	own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc, true, HW_DESC_OWN);
+
+	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, (u8 *) pdesc, 1, 1, skb);
+
+	__skb_queue_tail(&ring->queue, skb);
+
+	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
+	rtlpriv->cfg->ops->tx_polling(hw, BEACON_QUEUE);
+
+	return true;
+}
+
 #define BEACON_PG		0 /*->1*/
 #define PSPOLL_PG		2
 #define NULL_PG			3
@@ -670,7 +689,7 @@ static u8 reserved_page_packet[TOTAL_RES
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 };
 
-void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
+void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -679,12 +698,12 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 	u32 totalpacketlen;
 	bool rtstatus;
 	u8 u1RsvdPageLoc[3] = {0};
-	bool b_dlok = false;
+	bool dlok = false;
 
 	u8 *beacon;
-	u8 *p_pspoll;
+	u8 *pspoll;
 	u8 *nullfunc;
-	u8 *p_probersp;
+	u8 *probersp;
 	/*---------------------------------------------------------
 				(1) beacon
 	---------------------------------------------------------*/
@@ -695,10 +714,10 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 	/*-------------------------------------------------------
 				(2) ps-poll
 	--------------------------------------------------------*/
-	p_pspoll = &reserved_page_packet[PSPOLL_PG * 128];
-	SET_80211_PS_POLL_AID(p_pspoll, (mac->assoc_id | 0xc000));
-	SET_80211_PS_POLL_BSSID(p_pspoll, mac->bssid);
-	SET_80211_PS_POLL_TA(p_pspoll, mac->mac_addr);
+	pspoll = &reserved_page_packet[PSPOLL_PG * 128];
+	SET_80211_PS_POLL_AID(pspoll, (mac->assoc_id | 0xc000));
+	SET_80211_PS_POLL_BSSID(pspoll, mac->bssid);
+	SET_80211_PS_POLL_TA(pspoll, mac->mac_addr);
 
 	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1RsvdPageLoc, PSPOLL_PG);
 
@@ -715,10 +734,10 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 	/*---------------------------------------------------------
 				(4) probe response
 	----------------------------------------------------------*/
-	p_probersp = &reserved_page_packet[PROBERSP_PG * 128];
-	SET_80211_HDR_ADDRESS1(p_probersp, mac->bssid);
-	SET_80211_HDR_ADDRESS2(p_probersp, mac->mac_addr);
-	SET_80211_HDR_ADDRESS3(p_probersp, mac->bssid);
+	probersp = &reserved_page_packet[PROBERSP_PG * 128];
+	SET_80211_HDR_ADDRESS1(probersp, mac->bssid);
+	SET_80211_HDR_ADDRESS2(probersp, mac->mac_addr);
+	SET_80211_HDR_ADDRESS3(probersp, mac->bssid);
 
 	SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(u1RsvdPageLoc, PROBERSP_PG);
 
@@ -736,12 +755,12 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 	memcpy((u8 *) skb_put(skb, totalpacketlen),
 	       &reserved_page_packet, totalpacketlen);
 
-	rtstatus = rtlpriv->cfg->ops->cmd_send_packet(hw, skb);
+	rtstatus = _rtl92c_cmd_send_packet(hw, skb);
 
 	if (rtstatus)
-		b_dlok = true;
+		dlok = true;
 
-	if (b_dlok) {
+	if (dlok) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 			 ("Set RSVD page location to Fw.\n"));
 		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
@@ -764,3 +783,5 @@ void rtl92c_set_fw_joinbss_report_cmd(st
 	rtl92c_fill_h2c_cmd(hw, H2C_JOINBSSRPT, 1, u1_joinbssrpt_parm);
 }
 EXPORT_SYMBOL(rtl92c_set_fw_joinbss_report_cmd);
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -27,8 +27,8 @@
  *
  *****************************************************************************/
 
-#ifndef __RTL92C__FW__H__
-#define __RTL92C__FW__H__
+#ifndef __RTL92C__FW__COMMON__H__
+#define __RTL92C__FW__COMMON__H__
 
 #define FW_8192C_SIZE				0x3000
 #define FW_8192C_START_ADDRESS			0x1000
@@ -96,3 +96,4 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
 
 #endif
+
