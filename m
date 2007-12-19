Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbXLSGGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:06:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, viro@zeniv.linux.org.uk,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] ipw2200: prevent alloc of unspecified size on stack
Date: Tue, 18 Dec 2007 22:01:02 -0800
Message-Id: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com> (sfid-20071219_060630_165833_301E8CDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if log_len is larger than 4K then we are killing the stack.
allocate on heap instead and limit size to what practically can
be used (PAGE_SIZE)

Is it possible for this to get into 2.6.24?

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/ipw2200.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 54f44e5..e19e83a 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1233,9 +1233,19 @@ static ssize_t show_event_log(struct device *d,
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
 	u32 log_len = ipw_get_event_log_len(priv);
-	struct ipw_event log[log_len];
+	u32 log_size;
+	struct ipw_event *log;
 	u32 len = 0, i;
 
+	/* not using min() because of its strict type checking */
+	log_size = sizeof(*log) * log_len < PAGE_SIZE ?
+			sizeof(*log) * log_len : PAGE_SIZE;
+	log = kzalloc(log_size, GFP_KERNEL);
+	if (!log) {
+		IPW_ERROR("Unable to allocate memory for log\n");
+		return 0;
+	}
+	log_len = log_size / sizeof(*log);
 	ipw_capture_event_log(priv, log_len, log);
 
 	len += snprintf(buf + len, PAGE_SIZE - len, "%08X", log_len);
@@ -1244,6 +1254,7 @@ static ssize_t show_event_log(struct device *d,
 				"\n%08X%08X%08X",
 				log[i].time, log[i].event, log[i].data);
 	len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+	kfree(log);
 	return len;
 }
 
-- 
1.5.3.4

