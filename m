Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35555 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbbHCVQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 17:16:06 -0400
Received: by obbop1 with SMTP id op1so109024593obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 14:16:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	David Binderman <dcb314@hotmail.com>
Subject: [PATCH NEXT] rtlwifi: rtl8192c-common: Fix two typos
Date: Mon,  3 Aug 2015 16:15:53 -0500
Message-Id: <1438636553-28465-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_231611_607625_9872A46F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this driver, two variables are masked by one quantity, and then tested
against a second number with more bits that the mask. Accordingly, the
test always fails. To minimize the possibility of such typos, a symbolic
definition of the mask is created and used.

The separate load and mask operations are also combined into a single
statement.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Binderman <dcb314@hotmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 0aca6f4..61c857b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -39,6 +39,7 @@
 #define BT_RSSI_STATE_SPECIAL_LOW	BIT_OFFSET_LEN_MASK_32(2, 1)
 #define BT_RSSI_STATE_BG_EDCA_LOW	BIT_OFFSET_LEN_MASK_32(3, 1)
 #define BT_RSSI_STATE_TXPOWER_LOW	BIT_OFFSET_LEN_MASK_32(4, 1)
+#define BT_MASK				0x00ffffff
 
 #define RTLPRIV			(struct rtl_priv *)
 #define GET_UNDECORATED_AVERAGE_RSSI(_priv)	\
@@ -1536,13 +1537,11 @@ static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
 		return false;
 
 	bt_state = rtl_read_byte(rtlpriv, 0x4fd);
-	bt_tx = rtl_read_dword(rtlpriv, 0x488);
-	bt_tx = bt_tx & 0x00ffffff;
-	bt_pri = rtl_read_dword(rtlpriv, 0x48c);
-	bt_pri = bt_pri & 0x00ffffff;
+	bt_tx = rtl_read_dword(rtlpriv, 0x488) & BT_MASK;
+	bt_pri = rtl_read_dword(rtlpriv, 0x48c) & BT_MASK;
 	polling = rtl_read_dword(rtlpriv, 0x490);
 
-	if (bt_tx == 0xffffffff && bt_pri == 0xffffffff &&
+	if (bt_tx == BT_MASK && bt_pri == BT_MASK &&
 	    polling == 0xffffffff && bt_state == 0xff)
 		return false;
 
-- 
2.1.4

