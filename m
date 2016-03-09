Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32353 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbcCIL1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 06:27:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: enable starting BA session with custom timeout
Date: Wed,  9 Mar 2016 13:27:09 +0200
Message-Id: <1457522829-315-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_122718_758549_8AA19E22)
In-Reply-To: <1457522829-315-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1457522829-315-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently the debugfs entry for starting aggregation session
starts it with timeout of 5 seconds. Allow opening a session
with a custom timeout (according to spec 0 is no timeout).
while at it, refactor the function and remove the magic numbers.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/debugfs_sta.c | 47 +++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index a39512f..fbbd66c 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -151,11 +152,12 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 static ssize_t sta_agg_status_write(struct file *file, const char __user *userbuf,
 				    size_t count, loff_t *ppos)
 {
-	char _buf[12] = {}, *buf = _buf;
+	char _buf[25] = {}, *buf = _buf;
 	struct sta_info *sta = file->private_data;
 	bool start, tx;
 	unsigned long tid;
-	int ret;
+	char *pos;
+	int ret, timeout = 5000;
 
 	if (count > sizeof(_buf))
 		return -EINVAL;
@@ -164,37 +166,48 @@ static ssize_t sta_agg_status_write(struct file *file, const char __user *userbu
 		return -EFAULT;
 
 	buf[sizeof(_buf) - 1] = '\0';
+	pos = buf;
+	buf = strsep(&pos, " ");
+	if (!buf)
+		return -EINVAL;
 
-	if (strncmp(buf, "tx ", 3) == 0) {
-		buf += 3;
+	if (!strcmp(buf, "tx"))
 		tx = true;
-	} else if (strncmp(buf, "rx ", 3) == 0) {
-		buf += 3;
+	else if (!strcmp(buf, "rx"))
 		tx = false;
-	} else
+	else
 		return -EINVAL;
 
-	if (strncmp(buf, "start ", 6) == 0) {
-		buf += 6;
+	buf = strsep(&pos, " ");
+	if (!buf)
+		return -EINVAL;
+	if (!strcmp(buf, "start")) {
 		start = true;
 		if (!tx)
 			return -EINVAL;
-	} else if (strncmp(buf, "stop ", 5) == 0) {
-		buf += 5;
+	} else if (!strcmp(buf, "stop")) {
 		start = false;
-	} else
+	} else {
+		return -EINVAL;
+	}
+
+	buf = strsep(&pos, " ");
+	if (!buf)
 		return -EINVAL;
+	if (sscanf(buf, "timeout=%d", &timeout) == 1) {
+		buf = strsep(&pos, " ");
+		if (!buf || !tx || !start)
+			return -EINVAL;
+	}
 
 	ret = kstrtoul(buf, 0, &tid);
-	if (ret)
-		return ret;
-
-	if (tid >= IEEE80211_NUM_TIDS)
+	if (ret || tid >= IEEE80211_NUM_TIDS)
 		return -EINVAL;
 
 	if (tx) {
 		if (start)
-			ret = ieee80211_start_tx_ba_session(&sta->sta, tid, 5000);
+			ret = ieee80211_start_tx_ba_session(&sta->sta, tid,
+							    timeout);
 		else
 			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid);
 	} else {
-- 
2.5.0

