Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22426 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030780AbbJ3NpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 09:45:19 -0400
From: Sunil Dutt <usdutt@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<vkanchan@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>
Subject: [PATCH v2 2/2] mac80211: Add support for aborting an ongoing scan
Date: Fri, 30 Oct 2015 19:14:50 +0530
Message-ID: <1446212690-326-2-git-send-email-usdutt@qti.qualcomm.com> (sfid-20151030_144523_529386_E67B7763)
In-Reply-To: <1446212690-326-1-git-send-email-usdutt@qti.qualcomm.com>
References: <1446212690-326-1-git-send-email-usdutt@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>

This commit adds implementation for abort scan in mac80211.

Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
---
v2: Change return value of ieee80211_abort_scan to void

 net/mac80211/cfg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 713cdbf..4eda313 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3797,6 +3797,15 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+static void ieee80211_abort_scan(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+
+	/* Cancel the ongoing scan */
+	ieee80211_scan_cancel(local);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3881,4 +3890,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.abort_scan = ieee80211_abort_scan,
 };
-- 
1.8.2.1

