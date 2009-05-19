Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24302 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZESBn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 21:43:58 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] cfg80211: fix compile error with CONFIG_CFG80211_DEBUGFS
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Date: Mon, 18 May 2009 21:43:52 -0400
Message-ID: <20090519014352.19524.10495.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If CONFIG_CFG80211_DEBUGFS is enabled and CONFIG_MAC80211_DEBUGFS is
not, compilation fails in net/wireless/debugfs.c:

net/wireless/debugfs.c: In function 'cfg80211_debugfs_drv_add':
net/wireless/debugfs.c:117: error: 'struct cfg80211_registered_device'
has no member named 'debugfs'

The debugfs filed is needed if and only if CONFIG_CFG80211_DEBUGFS is
enabled, so use that instead of CONFIG_MAC80211_DEBUGFS.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 net/wireless/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9511c2b..ab512bc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -51,7 +51,7 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	unsigned long suspend_at;
 
-#ifdef CONFIG_MAC80211_DEBUGFS
+#ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
 		struct dentry *rts_threshold;
