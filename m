Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41637 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab1BKUeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:34:04 -0500
Date: Fri, 11 Feb 2011 14:34:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 4/5 V2] rtlwifi: rtl8192ce: Refactor rtl8192ce/fw
Message-ID: <4d559d3b./xm6NliD8tdgZJD9%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make rtlwifi/rtl8192ce/fw.{h,c} match what will be needed for
rtlwifi/rtl8192cu.{h,c}.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - incorporate the comments by Stanislaw Gruszka.

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
@@ -133,17 +133,15 @@ static void _rtl92c_write_fw(struct ieee
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	bool is_version_b;
 	u8 *bufferPtr = (u8 *) buffer;
 
 	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, ("FW size is %d bytes,\n", size));
 
-	is_version_b = IS_CHIP_VER_B(version);
-	if (is_version_b) {
+	if (IS_CHIP_VER_B(version)) {
 		u32 pageNums, remainSize;
 		u32 page, offset;
 
-		if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
+		if (IS_HARDWARE_TYPE_8192CE(rtlhal))
 			_rtl92c_fill_dummy(bufferPtr, &size);
 
 		pageNums = size / FW_8192C_PAGE_SIZE;
@@ -231,14 +229,14 @@ int rtl92c_download_fw(struct ieee80211_
 	u32 fwsize;
 	int err;
 	enum version_8192c version = rtlhal->version;
+	const struct firmware *firmware;
 
-	const struct firmware *firmware = NULL;
-
+	printk(KERN_INFO "rtl8192cu: Loading firmware file %s\n",
+	       rtlpriv->cfg->fw_name);
 	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
 			       rtlpriv->io.dev);
 	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Failed to request firmware!\n"));
+		printk(KERN_ERR "rtl8192cu: Firmware loading failed\n");
 		return 1;
 	}
 
@@ -560,39 +558,6 @@ void rtl92c_set_fw_pwrmode_cmd(struct ie
 
 }
 
-static bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
-				    struct sk_buff *skb)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	struct rtl8192_tx_ring *ring;
-	struct rtl_tx_desc *pdesc;
-	u8 own;
-	unsigned long flags;
-	struct sk_buff *pskb = NULL;
-
-	ring = &rtlpci->tx_ring[BEACON_QUEUE];
-
-	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
-		kfree_skb(pskb);
-
-	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
-
-	pdesc = &ring->desc[0];
-	own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc, true, HW_DESC_OWN);
-
-	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, (u8 *) pdesc, 1, 1, skb);
-
-	__skb_queue_tail(&ring->queue, skb);
-
-	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-
-	rtlpriv->cfg->ops->tx_polling(hw, BEACON_QUEUE);
-
-	return true;
-}
-
 #define BEACON_PG		0 /*->1*/
 #define PSPOLL_PG		2
 #define NULL_PG			3
@@ -776,7 +741,7 @@ void rtl92c_set_fw_rsvdpagepkt(struct ie
 	memcpy((u8 *) skb_put(skb, totalpacketlen),
 	       &reserved_page_packet, totalpacketlen);
 
-	rtstatus = _rtl92c_cmd_send_packet(hw, skb);
+	rtstatus = rtlpriv->cfg->ops->cmd_send_packet(hw, skb);
 
 	if (rtstatus)
 		b_dlok = true;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -1029,3 +1029,37 @@ void rtl92ce_tx_polling(struct ieee80211
 			       BIT(0) << (hw_queue));
 	}
 }
+
+bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
+			     struct sk_buff *skb)
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
+	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
+
+	pskb = __skb_dequeue(&ring->queue);
+	if (pskb)
+		kfree_skb(pskb);
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
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -711,4 +711,6 @@ void rtl92ce_tx_polling(struct ieee80211
 void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool b_firstseg, bool b_lastseg,
 			     struct sk_buff *skb);
+bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -135,6 +135,7 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.set_bbreg = rtl92c_phy_set_bb_reg,
 	.get_rfreg = rtl92c_phy_query_rf_reg,
 	.set_rfreg = rtl92c_phy_set_rf_reg,
+	.cmd_send_packet = _rtl92c_cmd_send_packet,
 };
 
 static struct rtl_mod_params rtl92ce_mod_params = {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
@@ -33,5 +33,7 @@
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw);
 void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw);
 void rtl92c_init_var_map(struct ieee80211_hw *hw);
+bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
+			     struct sk_buff *skb);
 
 #endif
