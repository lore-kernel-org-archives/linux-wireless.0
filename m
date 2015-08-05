Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36513 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbbHEQS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:18:59 -0400
Received: by oigu206 with SMTP id u206so12152141oig.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 09:18:58 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2 NEXT 7/7] rtlwifi: rtl8821ae: Implement new rekey logic
Date: Wed,  5 Aug 2015 11:18:40 -0500
Message-Id: <1438791520-13216-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150805_181910_130042_EC60D385)
In-Reply-To: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: pkshih <pkshih@realtek.com>

Use the new capability in rtlwifi to prevent rekeying before EAPOL msg 4/4
has been sent.

Signed-off-by: pkshih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - no changes
---
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c |  8 ++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.h | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
index 174743a..a03015c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
@@ -740,6 +740,14 @@ void rtl8821ae_tx_fill_desc(struct ieee80211_hw *hw,
 			SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 		}
 
+		/* tx report */
+		if (ptcb_desc->use_spe_rpt) {
+			u16 sn = rtl_get_tx_report_sn(hw);
+
+			SET_TX_DESC_SPE_RPT(pdesc, 1);
+			SET_TX_DESC_SW_DEFINE(pdesc, sn);
+		}
+
 		/* ptcb_desc->use_driver_rate = true; */
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 		if (ptcb_desc->hw_rate > DESC_RATEMCS0)
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.h b/drivers/net/wireless/rtlwifi/rtl8821ae/trx.h
index 3140904..4717801 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/trx.h
@@ -185,6 +185,19 @@
 #define SET_TX_DESC_RTS_SC(__pdesc, __val)	\
 	SET_BITS_TO_LE_4BYTE(__pdesc+20, 13, 4, __val)
 
+#define SET_TX_DESC_SW_DEFINE(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 0, 12, __val)
+#define SET_TX_DESC_ANTSEL_A(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 16, 3, __val)
+#define SET_TX_DESC_ANTSEL_B(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 19, 3, __val)
+#define SET_TX_DESC_ANTSEL_C(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 22, 3, __val)
+#define SET_TX_DESC_ANTSEL_D(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 25, 3, __val)
+#define SET_TX_DESC_MBSSID(__pdesc, __val)	\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 12, 4, __val)
+
 #define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
 	SET_BITS_TO_LE_4BYTE(__pdesc+28, 0, 16, __val)
 
-- 
2.1.4

