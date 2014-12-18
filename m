Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57118 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaLRJGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:00 -0500
Received: by mail-ob0-f172.google.com with SMTP id va8so2354053obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:05:59 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 03/16] rtlwifi: rtl8192ce: Add code to set the keep-alive operation
Date: Thu, 18 Dec 2014 03:05:27 -0600
Message-Id: <1418893540-19944-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100610_567540_07F93E11)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change helps the device maintain a connection.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h | 1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
index b64ae45..e9f4281 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -37,6 +37,7 @@
 #define FW_8192C_POLLING_DELAY			5
 #define FW_8192C_POLLING_TIMEOUT_COUNT		100
 #define NORMAL_CHIP				BIT(4)
+#define H2C_92C_KEEP_ALIVE_CTRL			48
 
 #define IS_FW_HEADER_EXIST(_pfwhdr)	\
 	((le16_to_cpu(_pfwhdr->signature)&0xFFF0) == 0x92C0 ||\
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 5c646d5..b63b78b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -544,8 +544,13 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 						(u8 *)(&fw_current_inps));
 			}
 		break; }
-	case HW_VAR_KEEP_ALIVE:
-		break;
+	case HW_VAR_KEEP_ALIVE: {
+		u8 array[2];
+
+		array[0] = 0xff;
+		array[1] = *((u8 *)val);
+		rtl92c_fill_h2c_cmd(hw, H2C_92C_KEEP_ALIVE_CTRL, 2, array);
+		break; }
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case %d not processed\n", variable);
-- 
2.1.2

