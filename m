Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51429 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaBKKSU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 05:18:20 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k: support only one P2P interface
Date: Tue, 11 Feb 2014 11:18:09 +0100
Message-Id: <1392113890-5097-1-git-send-email-nbd@openwrt.org> (sfid-20140211_111827_533104_9CFEA103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for adding P2P powersave and multi-channel support.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1fc2e5a..72ace06 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -862,13 +862,13 @@ void ath9k_reload_chainmask_settings(struct ath_softc *sc)
 
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
1.8.3.4 (Apple Git-47)

