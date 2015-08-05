Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34279 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbbHEQS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:18:57 -0400
Received: by obre1 with SMTP id e1so35454783obr.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 09:18:56 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2 NEXT 5/7] rtlwifi: rtl8192ee: Implement new rekey logic
Date: Wed,  5 Aug 2015 11:18:38 -0500
Message-Id: <1438791520-13216-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150805_181902_166136_570F4C04)
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
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c  | 1 +
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
index 232865c..4091430 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
@@ -859,6 +859,7 @@ static void _rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
 	case C2H_8192E_TX_REPORT:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE ,
 			 "[C2H], C2H_8723BE_TX_REPORT!\n");
+		rtl_tx_report_handler(hw, tmp_buf, c2h_cmd_len);
 		break;
 	case C2H_8192E_BT_INFO:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
index d39ee67..49aec97 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
@@ -731,6 +731,14 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
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
 		SET_TX_DESC_TX_RATE(pdesc, ptcb_desc->hw_rate);
 
 		if (ieee80211_is_mgmt(fc)) {
-- 
2.1.4

