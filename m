Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60725 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLRJGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:09 -0500
Received: by mail-ob0-f171.google.com with SMTP id uz6so2366507obc.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:09 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 13/16] rtlwifi: rtl8821ae: Add VHT rate descriptors
Date: Thu, 18 Dec 2014 03:05:37 -0600
Message-Id: <1418893540-19944-14-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_101346_838613_42C162A5)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Device RTL8821AE is the first if the rtlwifi devices to implement 802.11ac
capability. As a result, VHT rate descriptors are needed. In addition, the
driver is converted to use the descriptors in rtlwifi.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8821ae/def.h | 23 -----------------------
 drivers/net/wireless/rtlwifi/wifi.h          | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/def.h b/drivers/net/wireless/rtlwifi/rtl8821ae/def.h
index 53dc522..ee7c208 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/def.h
@@ -373,29 +373,6 @@ enum rtl_desc_qsel {
 	QSLT_CMD = 0x13,
 };
 
-enum rtl_desc8821ae_rate {
-	DESC_RATEVHT1SS_MCS0 = 0x2c,
-	DESC_RATEVHT1SS_MCS1 = 0x2d,
-	DESC_RATEVHT1SS_MCS2 = 0x2e,
-	DESC_RATEVHT1SS_MCS3 = 0x2f,
-	DESC_RATEVHT1SS_MCS4 = 0x30,
-	DESC_RATEVHT1SS_MCS5 = 0x31,
-	DESC_RATEVHT1SS_MCS6 = 0x32,
-	DESC_RATEVHT1SS_MCS7 = 0x33,
-	DESC_RATEVHT1SS_MCS8 = 0x34,
-	DESC_RATEVHT1SS_MCS9 = 0x35,
-	DESC_RATEVHT2SS_MCS0 = 0x36,
-	DESC_RATEVHT2SS_MCS1 = 0x37,
-	DESC_RATEVHT2SS_MCS2 = 0x38,
-	DESC_RATEVHT2SS_MCS3 = 0x39,
-	DESC_RATEVHT2SS_MCS4 = 0x3a,
-	DESC_RATEVHT2SS_MCS5 = 0x3b,
-	DESC_RATEVHT2SS_MCS6 = 0x3c,
-	DESC_RATEVHT2SS_MCS7 = 0x3d,
-	DESC_RATEVHT2SS_MCS8 = 0x3e,
-	DESC_RATEVHT2SS_MCS9 = 0x3f,
-};
-
 enum rx_packet_type {
 	NORMAL_RX,
 	TX_REPORT1,
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 26fd960..7a718fd 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -611,6 +611,27 @@ enum rtl_desc92_rate {
 	DESC_RATEMCS15 = 0x1b,
 	DESC_RATEMCS15_SG = 0x1c,
 	DESC_RATEMCS32 = 0x20,
+
+	DESC_RATEVHT1SS_MCS0 = 0x2c,
+	DESC_RATEVHT1SS_MCS1 = 0x2d,
+	DESC_RATEVHT1SS_MCS2 = 0x2e,
+	DESC_RATEVHT1SS_MCS3 = 0x2f,
+	DESC_RATEVHT1SS_MCS4 = 0x30,
+	DESC_RATEVHT1SS_MCS5 = 0x31,
+	DESC_RATEVHT1SS_MCS6 = 0x32,
+	DESC_RATEVHT1SS_MCS7 = 0x33,
+	DESC_RATEVHT1SS_MCS8 = 0x34,
+	DESC_RATEVHT1SS_MCS9 = 0x35,
+	DESC_RATEVHT2SS_MCS0 = 0x36,
+	DESC_RATEVHT2SS_MCS1 = 0x37,
+	DESC_RATEVHT2SS_MCS2 = 0x38,
+	DESC_RATEVHT2SS_MCS3 = 0x39,
+	DESC_RATEVHT2SS_MCS4 = 0x3a,
+	DESC_RATEVHT2SS_MCS5 = 0x3b,
+	DESC_RATEVHT2SS_MCS6 = 0x3c,
+	DESC_RATEVHT2SS_MCS7 = 0x3d,
+	DESC_RATEVHT2SS_MCS8 = 0x3e,
+	DESC_RATEVHT2SS_MCS9 = 0x3f,
 };
 
 enum rtl_var_map {
-- 
2.1.2

