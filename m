Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46347 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753821AbdLLNes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 08:34:48 -0500
Received: by mail-pg0-f67.google.com with SMTP id b11so13409600pgu.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Dec 2017 05:34:48 -0800 (PST)
From: venkat.prashanth2498@gmail.com
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org,
        Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
Subject: [PATCH] Drivers:RTLWIFI:rtl8723ae: add the function name to the printouts
Date: Tue, 12 Dec 2017 19:04:39 +0530
Message-Id: <1513085679-6279-1-git-send-email-venkat.prashanth2498@gmail.com> (sfid-20171212_143506_631773_B53ADC74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>

This is a patch to rtl8723ae/trx.c file that adds the
function name to the printouts.

Signed-off-by: Venkat Prashanth B U <venkat.prashanth2498@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 2f7c144..96c5385 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -389,7 +389,7 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,

 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
-			 "DMA mapping error");
+			 "%s():DMA mapping error", __func__);
 		return;
 	}
 	if (mac->opmode == NL80211_IFTYPE_STATION) {
@@ -557,7 +557,7 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,

 	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
-			 "DMA mapping error");
+			 "%s():DMA mapping error", __func__);
 		return;
 	}
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
--
1.9.1
