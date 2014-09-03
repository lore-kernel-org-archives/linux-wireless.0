Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59253 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaICDJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 2/6] ath9k: Fix beacons for managed mode
Date: Wed,  3 Sep 2014 08:39:21 +0530
Message-Id: <1409713765-9358-3-git-send-email-sujith@msujith.org> (sfid-20140903_050935_893515_8FCB9F5B)
In-Reply-To: <1409713765-9358-1-git-send-email-sujith@msujith.org>
References: <1409713765-9358-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If the current opmode is managed, the ATH_OP_BEACONS flag
needs to be set only when there is a primary station interface
and it is associated/active.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d9be831..0b3d4d8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1067,8 +1067,8 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	if (ah->opmode == NL80211_IFTYPE_STATION) {
 		bool changed = (iter_data.primary_sta != ctx->primary_sta);
 
-		iter_data.beacons = true;
 		if (iter_data.primary_sta) {
+			iter_data.beacons = true;
 			ath9k_set_assoc_state(sc, iter_data.primary_sta,
 					      changed);
 			if (!ctx->primary_sta ||
-- 
2.1.0

