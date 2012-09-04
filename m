Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19885 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2IDOEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 10:04:40 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 6/8] ath9k_htc: minor cleanup in ath9k_htc_add_station
Date: Tue, 4 Sep 2012 19:33:37 +0530
Message-ID: <1346767419-12359-6-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120904_160444_128312_0BD4954A)
In-Reply-To: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1346767419-12359-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c32f6e3..61d096e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -489,24 +489,20 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
 		memcpy(&tsta.macaddr, sta->addr, ETH_ALEN);
 		memcpy(&tsta.bssid, common->curbssid, ETH_ALEN);
-		tsta.is_vif_sta = 0;
 		ista->index = sta_idx;
+		tsta.is_vif_sta = 0;
+		maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
+				 sta->ht_cap.ampdu_factor);
+		tsta.maxampdu = cpu_to_be16(maxampdu);
 	} else {
 		memcpy(&tsta.macaddr, vif->addr, ETH_ALEN);
 		tsta.is_vif_sta = 1;
+		tsta.maxampdu = cpu_to_be16(0xffff);
 	}
 
 	tsta.sta_index = sta_idx;
 	tsta.vif_index = avp->index;
 
-	if (!sta) {
-		tsta.maxampdu = cpu_to_be16(0xffff);
-	} else {
-		maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
-				 sta->ht_cap.ampdu_factor);
-		tsta.maxampdu = cpu_to_be16(maxampdu);
-	}
-
 	WMI_CMD_BUF(WMI_NODE_CREATE_CMDID, &tsta);
 	if (ret) {
 		if (sta)
-- 
1.7.0.4

