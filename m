Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24863 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2KPMxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:53:05 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 5/8] ath6kl: trivial cleanup on interface type selection
Date: Fri, 16 Nov 2012 18:22:57 +0530
Message-ID: <1353070377-6043-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135310_004108_DB644847)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

a minor cleanup in assigning the driver specific network type
based on interface type.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d6e6c2d..b8d99c2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1557,17 +1557,13 @@ static int ath6kl_cfg80211_change_iface(struct wiphy *wiphy,
 set_iface_type:
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		vif->next_mode = INFRA_NETWORK;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		vif->next_mode = ADHOC_NETWORK;
 		break;
 	case NL80211_IFTYPE_AP:
-		vif->next_mode = AP_NETWORK;
-		break;
-	case NL80211_IFTYPE_P2P_CLIENT:
-		vif->next_mode = INFRA_NETWORK;
-		break;
 	case NL80211_IFTYPE_P2P_GO:
 		vif->next_mode = AP_NETWORK;
 		break;
-- 
1.7.0.4

