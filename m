Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40741 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2HXOXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 10:23:40 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath6kl: trivial cleanup
Date: Fri, 24 Aug 2012 19:53:28 +0530
Message-ID: <1345818208-9129-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120824_162344_067921_DFD4D4D8)
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
index 86aeef4..a971d54 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -369,17 +369,13 @@ static int ath6kl_nliftype_to_drv_iftype(enum nl80211_iftype type, u8 *nw_type)
 {
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
 		*nw_type = INFRA_NETWORK;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		*nw_type = ADHOC_NETWORK;
 		break;
 	case NL80211_IFTYPE_AP:
-		*nw_type = AP_NETWORK;
-		break;
-	case NL80211_IFTYPE_P2P_CLIENT:
-		*nw_type = INFRA_NETWORK;
-		break;
 	case NL80211_IFTYPE_P2P_GO:
 		*nw_type = AP_NETWORK;
 		break;
-- 
1.7.0.4

