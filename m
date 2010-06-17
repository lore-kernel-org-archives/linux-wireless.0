Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34002 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0FQJ05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 05:26:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 02:26:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19481.60102.659111.953695@gargle.gargle.HOWL>
Date: Thu, 17 Jun 2010 14:58:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_htc: Add AP mode to supported modes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 148b433..e1840b1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -700,7 +700,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP);
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 05445d8..2869cff 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1283,6 +1283,9 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_ADHOC:
 		hvif.opmode = cpu_to_be32(HTC_M_IBSS);
 		break;
+	case NL80211_IFTYPE_AP:
+		hvif.opmode = cpu_to_be32(HTC_M_HOSTAP);
+		break;
 	default:
 		ath_print(common, ATH_DBG_FATAL,
 			"Interface type %d not yet supported\n", vif->type);
-- 
1.7.1

