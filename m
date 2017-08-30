Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38896 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdH3Jnx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:53 -0400
Received: by mail-pf0-f194.google.com with SMTP id r187so3999245pfr.5
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:52 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 7/8] rsi: aggregation changes for p2p mode
Date: Wed, 30 Aug 2017 15:08:27 +0530
Message-Id: <1504085908-2163-8-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114413_178550_77C0DA11)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

P2P Go condition is added wherever AP mode is there
in aggregation path.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 09ad909..79426a2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1005,7 +1005,8 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 	if (ssn != NULL)
 		seq_no = *ssn;
 
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_P2P_GO)) {
 		rsta = rsi_find_sta(common, sta->addr);
 		if (!rsta) {
 			rsi_dbg(ERR_ZONE, "No station mapped\n");
@@ -1039,9 +1040,11 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 		break;
 
 	case IEEE80211_AMPDU_TX_START:
-		if (vif->type == NL80211_IFTYPE_STATION)
+		if ((vif->type == NL80211_IFTYPE_STATION) ||
+		    (vif->type == NL80211_IFTYPE_P2P_CLIENT))
 			common->vif_info[ii].seq_start = seq_no;
-		else if (vif->type == NL80211_IFTYPE_AP)
+		else if ((vif->type == NL80211_IFTYPE_AP) ||
+			 (vif->type == NL80211_IFTYPE_P2P_GO))
 			rsta->seq_start[tid] = seq_no;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		status = 0;
@@ -1061,9 +1064,11 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 		break;
 
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		if (vif->type == NL80211_IFTYPE_STATION)
+		if ((vif->type == NL80211_IFTYPE_STATION) ||
+		    (vif->type == NL80211_IFTYPE_P2P_CLIENT))
 			seq_start = common->vif_info[ii].seq_start;
-		else if (vif->type == NL80211_IFTYPE_AP)
+		else if ((vif->type == NL80211_IFTYPE_AP) ||
+			 (vif->type == NL80211_IFTYPE_P2P_GO))
 			seq_start = rsta->seq_start[tid];
 		status = rsi_send_aggregation_params_frame(common,
 							   tid,
-- 
2.7.4
