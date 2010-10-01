Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57279 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0JAPU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 11:20:59 -0400
Received: by mail-qy0-f181.google.com with SMTP id 9so1079767qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 08:20:59 -0700 (PDT)
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Bill Jordan <bjordan@rajant.com>
Subject: [PATCH 1/3] ath9k: add WDS interfaces to ath9k
Date: Fri,  1 Oct 2010 11:20:39 -0400
Message-Id: <1285946441-20152-2-git-send-email-bjordan@rajant.com>
In-Reply-To: <1285946441-20152-1-git-send-email-bjordan@rajant.com>
References: <1285946441-20152-1-git-send-email-bjordan@rajant.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable WDS for the ath9k driver.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index de33938..c2792c9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -639,6 +639,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a133878..d67067f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1384,6 +1384,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_STATION:
 		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
+	case NL80211_IFTYPE_WDS:
+		ic_opmode = NL80211_IFTYPE_WDS;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
-- 
1.7.2.3

