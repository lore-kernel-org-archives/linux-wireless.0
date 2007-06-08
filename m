Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968142AbXFHRFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 13:05:13 -0400
Date: Sat, 9 Jun 2007 01:04:30 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/6] mac80211: Fix one more sparse error
Message-ID: <20070608170430.GA17289@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix one more sparse error and comment variable for debugfs_rename TODO.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/debugfs_netdev.c |    2 ++
 net/mac80211/debugfs_sta.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 5e50817..52a32e4 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -734,7 +734,9 @@ static int netdev_notify(struct notifier_block * nb,
 			 void *ndev)
 {
 	struct net_device *dev = ndev;
+	/* TODO
 	char buf[10+IFNAMSIZ];
+	*/
 
 	if (state != NETDEV_CHANGENAME)
 		return 0;
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index fc1a024..6cfe35a 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -158,7 +158,7 @@ static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
 	struct sta_info *sta = file->private_data;
 	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%x ",
-			       sta->last_seq_ctrl[i]);
+			       le16_to_cpu(sta->last_seq_ctrl[i]));
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
-- 
1.5.0.rc2.g73a2
