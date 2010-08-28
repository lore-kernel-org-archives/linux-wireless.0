Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58520 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0H1HNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 03:13:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 1/3] ath9k: fix regression which disabled ps on ath9k on all cards
Date: Sat, 28 Aug 2010 03:13:08 -0400
Message-Id: <1282979590-31113-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch titled "ath9k: Add new file init.c" shuffled some code
around but in dong so for some reason also removed the revision
check for disablign power save. Add this revision check again
so we can get power save re-enabled again by default on cards
newer than AR5416 and AR5418.

$ git describe --contains 556242049cc3992d0ee625e9f15c4b00ea4baac8
v2.6.34-rc1~233^2~49^2~343

Before on all cards:

$ iw dev wlan39 get power_save
Power save: off

Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 243c177..4129390 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -641,7 +641,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	if (AR_SREV_5416(sc->sc_ah))
+		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->queues = 4;
 	hw->max_rates = 4;
-- 
1.7.0.4

