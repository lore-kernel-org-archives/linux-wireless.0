Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45752 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbbBYTeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 14:34:12 -0500
Received: by pdjz10 with SMTP id z10so7016687pdj.12
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 11:34:12 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Add case in rtl92cu_get_hw_reg
Date: Thu, 26 Feb 2015 04:34:01 +0900
Message-Id: <1424892841-6446-1-git-send-email-ap420073@gmail.com> (sfid-20150225_203417_655449_4B1B27E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add HAL_DEF_WOWLAN case in rtl92cu_get_hw_reg

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index fe4b699..96bae39 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1589,6 +1589,8 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_DATA_FILTER:
 		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
 		break;
+	case HAL_DEF_WOWLAN:
+		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case not processed\n");
-- 
1.9.1

