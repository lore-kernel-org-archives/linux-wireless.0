Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36299 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992459AbbHHQx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 12:53:56 -0400
Received: by obnw1 with SMTP id w1so98533274obn.3
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2015 09:53:56 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V3 NEXT 6/7] rtlwifi: rtl8723be: Implement new rekey logic
Date: Sat,  8 Aug 2015 11:53:38 -0500
Message-Id: <1439052819-30196-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150808_185405_956393_A633AEB7)
In-Reply-To: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
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
V3 - no changes
---
 drivers/net/wireless/rtlwifi/rtl8723be/fw.c  |  1 +
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c |  8 ++++++++
 drivers/net/wireless/rtlwifi/rtl8723be/trx.h | 12 ++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/rtlwifi/rtl8723be/fw.c
index d5da0f3..be15d3d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/fw.c
@@ -600,6 +600,7 @@ static void _rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw,
 	case C2H_8723B_TX_REPORT:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "[C2H], C2H_8723BE_TX_REPORT!\n");
+		rtl_tx_report_handler(hw, tmp_buf, c2h_cmd_len);
 		break;
 	case C2H_8723B_BT_INFO:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
index 338ec9a..fe8e3f4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
@@ -488,6 +488,14 @@ void rtl8723be_tx_fill_desc(struct ieee80211_hw *hw,
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
 		if (ptcb_desc->hw_rate > DESC92C_RATEMCS0)
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.h b/drivers/net/wireless/rtlwifi/rtl8723be/trx.h
index 45949ac..c20fb45 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/trx.h
@@ -187,6 +187,18 @@
 #define SET_TX_DESC_RTS_SC(__pdesc, __val)		\
 	SET_BITS_TO_LE_4BYTE(__pdesc+20, 13, 4, __val)
 
+#define SET_TX_DESC_SW_DEFINE(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 0, 12, __val)
+#define SET_TX_DESC_MBSSID(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 12, 4, __val)
+#define SET_TX_DESC_ANTSEL_A(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 16, 3, __val)
+#define SET_TX_DESC_ANTSEL_B(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 19, 3, __val)
+#define SET_TX_DESC_ANTSEL_C(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 22, 3, __val)
+#define SET_TX_DESC_ANTSEL_D(__pdesc, __val)		\
+	SET_BITS_TO_LE_4BYTE(__pdesc + 24, 25, 3, __val)
 
 #define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
 	SET_BITS_TO_LE_4BYTE(__pdesc+28, 0, 16, __val)
-- 
2.1.4

