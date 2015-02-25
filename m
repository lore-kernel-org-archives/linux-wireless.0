Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35486 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbbBYR7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 12:59:07 -0500
Received: by pdbfl12 with SMTP id fl12so6497260pdb.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 09:59:07 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Add case in rtl92cu_get_hw_reg
Date: Thu, 26 Feb 2015 02:58:53 +0900
Message-Id: <1424887133-5670-1-git-send-email-ap420073@gmail.com> (sfid-20150225_185911_806842_D730023F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl_op_stop get wowlan state but rtl92cu_get_hw_reg has not process.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index fe4b699..f6ad959 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1589,6 +1589,12 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_DATA_FILTER:
 		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
 		break;
+	case HAL_DEF_WOWLAN:
+		if (ppsc->wo_wlan_mode)
+			*((bool *)(val)) = true;
+		else
+			*((bool *)(val)) = false;
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case not processed\n");
-- 
1.9.1

