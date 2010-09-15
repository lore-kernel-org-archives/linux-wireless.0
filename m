Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39311 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0IOT34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 15:29:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: fix sparse warning about wrong enum for band parameter
Date: Wed, 15 Sep 2010 15:16:22 -0400
Message-Id: <1284578182-12684-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-scan.c:386:27: warning: mixing different enum types
drivers/net/wireless/iwlwifi/iwl-scan.c:386:27:     int enum nl80211_band  versus
drivers/net/wireless/iwlwifi/iwl-scan.c:386:27:     int enum ieee80211_band
drivers/net/wireless/iwlwifi/iwl-scan.c:435:57: warning: mixing different enum types
drivers/net/wireless/iwlwifi/iwl-scan.c:435:57:     int enum ieee80211_band  versus
drivers/net/wireless/iwlwifi/iwl-scan.c:435:57:     int enum nl80211_band
drivers/net/wireless/iwlwifi/iwl-scan.c:474:53: warning: mixing different enum types
drivers/net/wireless/iwlwifi/iwl-scan.c:474:53:     int enum ieee80211_band  versus
drivers/net/wireless/iwlwifi/iwl-scan.c:474:53:     int enum nl80211_band
drivers/net/wireless/iwlwifi/iwl-scan.c:588:72: warning: mixing different enum types
drivers/net/wireless/iwlwifi/iwl-scan.c:588:72:     int enum ieee80211_band  versus
drivers/net/wireless/iwlwifi/iwl-scan.c:588:72:     int enum nl80211_band

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 599573f..c54c200 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -350,7 +350,7 @@ EXPORT_SYMBOL(iwl_init_scan_params);
 static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 					  struct ieee80211_vif *vif,
 					  bool internal,
-					  enum nl80211_band band)
+					  enum ieee80211_band band)
 {
 	int ret;
 
-- 
1.7.2.3

