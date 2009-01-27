Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZA0WZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/7] iwlwifi: suppress unused variable warning when compiling w/o IWLWIFI_DEBUG
Date: Tue, 27 Jan 2009 14:27:53 -0800
Message-Id: <1233095278-5850-3-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232516_107143_9C0FCF8C)
In-Reply-To: <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch adds __maybe_unused attribute to priv variables used in
functions that used it solely for debug printouts

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index b93f5ba..45ce3ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -183,7 +183,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 	int unflushed = 0;
 	int i;
 	unsigned long flags;
-	struct iwl_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 
 	/*
 	 * For each rate, if we have collected data on that rate
@@ -216,7 +216,7 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
 	struct iwl3945_rs_sta *rs_sta = (void *)data;
-	struct iwl_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 	int unflushed = 0;
 	unsigned long flags;
 	u32 packet_count, duration, pps;
@@ -290,7 +290,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 {
 	unsigned long flags;
 	s32 fail_count;
-	struct iwl_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 
 	if (!retries) {
 		IWL_DEBUG_RATE("leave: retries == 0 -- should be at least 1\n");
@@ -438,7 +438,7 @@ static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 {
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
 	struct iwl3945_rs_sta *rs_sta = priv_sta;
-	struct iwl_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 
 	psta->rs_sta = NULL;
 
@@ -556,7 +556,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 {
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
-	struct iwl_priv *priv = rs_sta->priv;
+	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 
 	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6a2c8a3..72ff20e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5270,8 +5270,8 @@ static ssize_t store_antenna(struct device *d,
 			     struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
+	struct iwl_priv *priv __maybe_unused = dev_get_drvdata(d);
 	int ant;
-	struct iwl_priv *priv = dev_get_drvdata(d);
 
 	if (count == 0)
 		return 0;
-- 
1.5.4.3

