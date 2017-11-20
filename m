Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36765 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751073AbdKTMyc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 07:54:32 -0500
Received: by mail-pf0-f196.google.com with SMTP id i15so7251222pfa.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 04:54:32 -0800 (PST)
From: venkat.prashanth2498@gmail.com
To: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
Subject: [PATCH v1] rtlwifi:rtl8723ae: Fix embedded function names with __func__
Date: Mon, 20 Nov 2017 18:23:57 +0530
Message-Id: <1511182437-5870-1-git-send-email-venkat.prashanth2498@gmail.com> (sfid-20171120_135436_032196_5D76111F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>

Prefer and make it generic by using %s and __func__ to print functions name
instead of embedding functions name in print statements 

Signed-off-by: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index f713c72..bd56bb6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -389,7 +389,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
 
 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
-			 "DMA mapping error\n");
+			 "%s():DMA Mapping Error", __func__);
 		return;
 	}
 	if (mac->opmode == NL80211_IFTYPE_STATION) {
@@ -498,7 +498,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
 		if (ieee80211_is_data_qos(fc)) {
 			if (mac->rdg_en) {
 				RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
-					 "Enable RDG function.\n");
+			"%s():Enable RDG function.\n", __func__);
 				SET_TX_DESC_RDG_ENABLE(pdesc, 1);
 				SET_TX_DESC_HTC(pdesc, 1);
 			}
@@ -537,7 +537,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
 		SET_TX_DESC_BMC(pdesc, 1);
 	}
 
-	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "\n");
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "%s():\n", __func__);
 }
 
 void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
@@ -557,7 +557,7 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
 
 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
-			 "DMA mapping error\n");
+			 "%s():DMA Mapping Error", __func__);
 		return;
 	}
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
-- 
1.9.1
