Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59257 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbaDEWhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 18:37:13 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 1/2] ath9k: support only one P2P interface
Date: Sun,  6 Apr 2014 00:37:02 +0200
Message-Id: <1396737423-70276-1-git-send-email-nbd@openwrt.org> (sfid-20140406_003736_363657_FD2DBF0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for adding P2P powersave and multi-channel support.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c0a4e86..c3dc2c5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -644,13 +644,13 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
 
 static const struct ieee80211_iface_limit if_limits[] = {
 	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_WDS) },
 	{ .max = 8,	.types =
 #ifdef CONFIG_MAC80211_MESH
 				 BIT(NL80211_IFTYPE_MESH_POINT) |
 #endif
-				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
-- 
1.8.5.2 (Apple Git-48)

