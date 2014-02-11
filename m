Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51952 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBKKi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 05:38:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Subject: [PATCH] mac80211: add beacon_loss debugfs file
Date: Tue, 11 Feb 2014 12:36:18 +0200
Message-Id: <1392114978-26697-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140211_113829_162900_B54A5CD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add beacon_loss debugfs file that emulates
ieee80211_beacon_loss call from the driver.

This can be used for various testing scenarios.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 net/mac80211/debugfs_netdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 68d00a7..3da74ae 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -358,6 +358,18 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 }
 IEEE80211_IF_FILE_W(tkip_mic_test);
 
+static ssize_t ieee80211_if_parse_beacon_loss(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	if (!ieee80211_sdata_running(sdata) || !sdata->vif.bss_conf.assoc)
+		return -ENOTCONN;
+
+	ieee80211_beacon_loss(&sdata->vif);
+
+	return buflen;
+}
+IEEE80211_IF_FILE_W(beacon_loss);
+
 static ssize_t ieee80211_if_fmt_uapsd_queues(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
@@ -569,6 +581,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(beacon_timeout);
 	DEBUGFS_ADD_MODE(smps, 0600);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
+	DEBUGFS_ADD_MODE(beacon_loss, 0200);
 	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
 	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
 }
-- 
1.8.3.2

