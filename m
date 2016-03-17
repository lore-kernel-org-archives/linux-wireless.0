Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:33400 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031482AbcCQSlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:19 -0400
Received: by mail-ob0-f194.google.com with SMTP id z10so5779555obg.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/9] rtlwifi: rtl8192c-common: Fix Smatch warning
Date: Thu, 17 Mar 2016 13:40:59 -0500
Message-Id: <1458240064-31422-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194126_025564_7DEC7CE5)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch lists the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c:243 rtl92c_dm_false_alarm_counter_statistics() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index 03cbe4c..316be5f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -240,7 +240,7 @@ static void rtl92c_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 	ret_value = rtl_get_bbreg(hw, ROFDM_PHYCOUNTER3, MASKDWORD);
 	falsealm_cnt->cnt_mcs_fail = (ret_value & 0xffff);
 
-	 ret_value = rtl_get_bbreg(hw, ROFDM0_FRAMESYNC, MASKDWORD);
+	ret_value = rtl_get_bbreg(hw, ROFDM0_FRAMESYNC, MASKDWORD);
 	falsealm_cnt->cnt_fast_fsync_fail = (ret_value & 0xffff);
 	falsealm_cnt->cnt_sb_search_fail = ((ret_value & 0xffff0000) >> 16);
 
-- 
2.1.4

