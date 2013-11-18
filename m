Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63710 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KRRL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:11:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 11/12 NEXT] rtlwifi:  Add missing code to PWDB statics routine
Date: Mon, 18 Nov 2013 11:11:35 -0600
Message-Id: <1384794696-20314-12-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_181250_616856_BE63CBF0)
In-Reply-To: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/stats.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/stats.c b/drivers/net/wireless/rtlwifi/stats.c
index 8ed3174..4f083fc 100644
--- a/drivers/net/wireless/rtlwifi/stats.c
+++ b/drivers/net/wireless/rtlwifi/stats.c
@@ -176,6 +176,7 @@ static void rtl_process_pwdb(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
 	struct rtl_sta_info *drv_priv = NULL;
 	struct ieee80211_sta *sta = NULL;
 	long undec_sm_pwdb;
+	long undec_sm_cck;
 
 	rcu_read_lock();
 	if (rtlpriv->mac80211.opmode != NL80211_IFTYPE_STATION)
@@ -185,12 +186,16 @@ static void rtl_process_pwdb(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
 	if (sta) {
 		drv_priv = (struct rtl_sta_info *) sta->drv_priv;
 		undec_sm_pwdb = drv_priv->rssi_stat.undec_sm_pwdb;
+		undec_sm_cck = drv_priv->rssi_stat.undec_sm_cck;
 	} else {
 		undec_sm_pwdb = rtlpriv->dm.undec_sm_pwdb;
+		undec_sm_cck = rtlpriv->dm.undec_sm_cck;
 	}
 
 	if (undec_sm_pwdb < 0)
 		undec_sm_pwdb = pstatus->rx_pwdb_all;
+	if (undec_sm_cck < 0)
+		undec_sm_cck = pstatus->rx_pwdb_all;
 	if (pstatus->rx_pwdb_all > (u32) undec_sm_pwdb) {
 		undec_sm_pwdb = (((undec_sm_pwdb) *
 		      (RX_SMOOTH_FACTOR - 1)) +
@@ -200,6 +205,15 @@ static void rtl_process_pwdb(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
 		undec_sm_pwdb = (((undec_sm_pwdb) * (RX_SMOOTH_FACTOR - 1)) +
 		     (pstatus->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
 	}
+	if (pstatus->rx_pwdb_all > (u32) undec_sm_cck) {
+		undec_sm_cck = (((undec_sm_pwdb) *
+		      (RX_SMOOTH_FACTOR - 1)) +
+		     (pstatus->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+		undec_sm_cck = undec_sm_cck + 1;
+	} else {
+		undec_sm_pwdb = (((undec_sm_cck) * (RX_SMOOTH_FACTOR - 1)) +
+		     (pstatus->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+	}
 
 	if (sta) {
 		drv_priv->rssi_stat.undec_sm_pwdb = undec_sm_pwdb;
-- 
1.8.4

