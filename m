Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:50145
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751492AbaJVN2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 09:28:01 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@do-not-panic.com
Subject: [PATCH] ath: use CTL region from cfg80211 if unset in EEPROM
Date: Wed, 22 Oct 2014 15:27:53 +0200
Message-Id: <1413984473-95505-1-git-send-email-nbd@openwrt.org> (sfid-20141022_152809_114296_CA122DD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many AP devices do not have the proper regulatory domain programmed in
EEPROM. Instead they expect the software to set the appropriate region.
For these devices, the country code defaults to US, and the driver uses
the US CTL tables as well.
On devices bought in Europe this can lead to tx power being set too high
on the band edges, even if the cfg80211 regdomain is set correctly.
Fix this issue by taking into account the DFS region, but only when the
EEPROM regdomain is set to default.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h  |  1 +
 drivers/net/wireless/ath/regd.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 9c56ecb..999d24f 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -80,6 +80,7 @@ struct reg_dmn_pair_mapping {
 
 struct ath_regulatory {
 	char alpha2[2];
+	enum nl80211_dfs_regions region;
 	u16 country_code;
 	u16 max_power_level;
 	u16 current_rd;
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 415393d..06ea6cc 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -515,6 +515,7 @@ void ath_reg_notifier_apply(struct wiphy *wiphy,
 	if (!request)
 		return;
 
+	reg->region = request->dfs_region;
 	switch (request->initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		/*
@@ -779,6 +780,19 @@ u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
 		return SD_NO_CTL;
 	}
 
+	if (ath_regd_get_eepromRD(reg) == CTRY_DEFAULT) {
+		switch (reg->region) {
+		case NL80211_DFS_FCC:
+			return CTL_FCC;
+		case NL80211_DFS_ETSI:
+			return CTL_ETSI;
+		case NL80211_DFS_JP:
+			return CTL_MKK;
+		default:
+			break;
+		}
+	}
+
 	switch (band) {
 	case IEEE80211_BAND_2GHZ:
 		return reg->regpair->reg_2ghz_ctl;
-- 
2.0.4

