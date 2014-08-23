Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33057 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHWH7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:48 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 17/18] ath9k: Fix function argument type
Date: Sat, 23 Aug 2014 13:29:22 +0530
Message-Id: <1408780763-27974-18-git-send-email-sujith@msujith.org> (sfid-20140823_101533_610324_3A2F4B0B)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k_vif_iter() was earlier used as an iterator
routine when calling a mac80211 utility. This is no
longer the case and hence we can mention the argument
type explicitly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e31f130..bc7a780 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -893,9 +893,9 @@ static bool ath9k_uses_beacons(int type)
 	}
 }
 
-static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+static void ath9k_vif_iter(struct ath9k_vif_iter_data *iter_data,
+			   u8 *mac, struct ieee80211_vif *vif)
 {
-	struct ath9k_vif_iter_data *iter_data = data;
 	int i;
 
 	if (iter_data->has_hw_macaddr) {
-- 
2.0.4

