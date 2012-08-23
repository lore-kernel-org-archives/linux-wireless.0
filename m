Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51205 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab2HWNYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 09:24:36 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 4/6] ath9k_htc: minor cleanup in ath9k_htc_add_station
Date: Thu, 23 Aug 2012 18:53:56 +0530
Message-ID: <1345728238-5313-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120823_152439_478159_F97C4E79)
In-Reply-To: <1345728238-5313-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1345728238-5313-1-git-send-email-mohammed@qca.qualcomm.com>
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
index 51c69f2..73cbee5 100644
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

