Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43412 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178Ab1JGQoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 12:44:17 -0400
Received: by ywb5 with SMTP id 5so3801334ywb.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 09:44:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/5] rtlwifi: Update to new Realtek version - Part I
Date: Fri,  7 Oct 2011 11:43:19 -0500
Message-Id: <1318005802-29057-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111007_184421_125224_45873F9A)
In-Reply-To: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1318005802-29057-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

This patch incorporate the differences between the 06/20/2011 and
08/16/2011 Realtek releases of the rtlwifi driver.

The changes include:

1. Handling of IEEE80211_HW_CONNECTION_MONITOR.
2. Fix typo to get proper response to nullfunc frames.

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index eafe980..a2704fb 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -311,6 +311,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_BEACON_FILTER |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
+	    IEEE80211_HW_CONNECTION_MONITOR |
+	    /* IEEE80211_HW_SUPPORTS_CQM_RSSI | */
 	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
@@ -850,7 +852,7 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		 *So tcb_desc->hw_rate is just used for
 		 *special data and mgt frames
 		 */
-		if (info->control.rates[0].idx == 0 &&
+		if (info->control.rates[0].idx == 0 ||
 				ieee80211_is_nullfunc(fc)) {
 			tcb_desc->use_driver_rate = true;
 			tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
@@ -1138,7 +1140,7 @@ void rtl_watchdog_wq_callback(void *data)
 	}
 
 	/*
-	 *<3> to check if traffic busy, if
+	 *<2> to check if traffic busy, if
 	 * busytraffic we don't change channel
 	 */
 	if (mac->link_state >= MAC80211_LINKED) {
-- 
1.7.6.4

