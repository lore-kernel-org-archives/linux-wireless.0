Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34609 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753848AbdGJMqG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:46:06 -0400
Received: by mail-pf0-f196.google.com with SMTP id c24so14381086pfe.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:46:00 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 17/17] rsi: regulatory enhancements
Date: Mon, 10 Jul 2017 18:10:48 +0530
Message-Id: <1499690448-9956-18-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144616_062864_E69E2C8A)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Below regulatory changes are included this patch
* Country code is saved as it will be used in bgscan.
* Region codes are mapped according to RSI region codes.
* Radar flag settings are moved under the check if 5GHZ band
  is enabled.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 49 ++++++++++++++++++++++-------
 drivers/net/wireless/rsi/rsi_main.h         |  8 +++++
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index d094b0a..c91d6ef 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1163,6 +1163,21 @@ static int rsi_mac80211_get_antenna(struct ieee80211_hw *hw,
 	return 0;	
 }
 
+static int rsi_map_region_code(enum nl80211_dfs_regions region_code)
+{
+	switch (region_code) {
+	case NL80211_DFS_FCC:
+		return RSI_REGION_FCC;
+	case NL80211_DFS_ETSI:
+		return RSI_REGION_ETSI;
+	case NL80211_DFS_JP:
+		return RSI_REGION_TELEC;
+	case NL80211_DFS_UNSET:
+		return RSI_REGION_WORLD;
+	}
+	return RSI_REGION_WORLD;
+}
+
 static void rsi_reg_notify(struct wiphy *wiphy,
 			   struct regulatory_request *request)
 {
@@ -1170,23 +1185,33 @@ static void rsi_reg_notify(struct wiphy *wiphy,
 	struct ieee80211_channel *ch;
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct rsi_hw * adapter = hw->priv; 
+	struct rsi_common *common = adapter->priv;
 	int i;
-
-	sband = wiphy->bands[NL80211_BAND_5GHZ];
 	
-	for (i = 0; i < sband->n_channels; i++) {
-		ch = &sband->channels[i];
-		if (ch->flags & IEEE80211_CHAN_DISABLED)
-			continue;
+	mutex_lock(&common->mutex);
+
+	rsi_dbg(INFO_ZONE, "country = %s dfs_region = %d\n",
+		request->alpha2, request->dfs_region);
+
+	if (common->num_supp_bands > 1) {
+		sband = wiphy->bands[NL80211_BAND_5GHZ];
 
-		if (ch->flags & IEEE80211_CHAN_RADAR)
-			ch->flags |= IEEE80211_CHAN_NO_IR;
+		for (i = 0; i < sband->n_channels; i++) {
+			ch = &sband->channels[i];
+			if (ch->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			if (ch->flags & IEEE80211_CHAN_RADAR)
+				ch->flags |= IEEE80211_CHAN_NO_IR;
+		}
 	}
+	adapter->dfs_region = rsi_map_region_code(request->dfs_region);
+	rsi_dbg(INFO_ZONE, "RSI region code = %d\n", adapter->dfs_region);
 	
-	rsi_dbg(INFO_ZONE,
-		"country = %s dfs_region = %d\n",
-		request->alpha2, request->dfs_region);
-	adapter->dfs_region = request->dfs_region;
+	adapter->country[0] = request->alpha2[0];
+	adapter->country[1] = request->alpha2[1];
+
+	mutex_unlock(&common->mutex);
 }
 
 static struct ieee80211_ops mac80211_ops = {
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 485b97a..6a8e8e7 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -170,6 +170,13 @@ struct xtended_desc {
 	u16 reserved;
 };
 
+enum rsi_dfs_regions {
+	RSI_REGION_FCC = 0,
+	RSI_REGION_ETSI,
+	RSI_REGION_TELEC,
+	RSI_REGION_WORLD
+};
+
 struct rsi_hw;
 
 struct rsi_common {
@@ -287,6 +294,7 @@ struct rsi_hw {
 	struct eepromrw_info eeprom;
 	u32 interrupt_status;
 	u8 dfs_region;
+	char country[2];
 	void *rsi_dev;
 	struct rsi_host_intf_ops *host_intf_ops;
 	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
-- 
2.7.4
