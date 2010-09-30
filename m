Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38217 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0I3V3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:29:38 -0400
Received: by qyk33 with SMTP id 33so2482278qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:29:37 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 17:29:37 -0400
Message-ID: <AANLkTi=cN7ZKa488MmXYDu_ywW95E8TcqJW4yfyKr0JR@mail.gmail.com>
Subject: [PATCH] ath9k: Enable WDS for the ath9k
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As requested, I'm breaking up my previous patch.

This patch enables WDS for the ath9k driver.

For WDS to fully work, patches to mac80211 are also needed
(submitted separately).

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c
b/drivers/net/wireless/ath/ath9k/init.c
index de33938..c2792c9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -639,6 +639,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc,
struct ieee80211_hw *hw)

 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
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
