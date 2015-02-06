Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40727 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbbBFI6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 03:58:55 -0500
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<keescook@chromium.org>, Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: use alloc_workqueue's format strings capabilities for WQ names
Date: Fri, 6 Feb 2015 19:58:05 +0530
Message-ID: <1423232885-10073-1-git-send-email-patila@marvell.com> (sfid-20150206_095904_474800_D7E1C9BC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

alloc_workqueue() has string format formation ability e.g. wqname%ifname
will be treated as wqnameifname. Use this and remove string operations
while defining strings for workqueue names.

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 41c8e25..5f3c1d3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2397,7 +2397,6 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
-#define MWIFIEX_MAX_WQ_LEN  30
 /*
  *  create a new virtual interface with the given name
  */
@@ -2411,7 +2410,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_private *priv;
 	struct net_device *dev;
 	void *mdev_priv;
-	char dfs_cac_str[MWIFIEX_MAX_WQ_LEN], dfs_chsw_str[MWIFIEX_MAX_WQ_LEN];
 
 	if (!adapter)
 		return ERR_PTR(-EFAULT);
@@ -2576,12 +2574,10 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		return ERR_PTR(-EFAULT);
 	}
 
-	strcpy(dfs_cac_str, "MWIFIEX_DFS_CAC");
-	strcat(dfs_cac_str, name);
-	priv->dfs_cac_workqueue = alloc_workqueue(dfs_cac_str,
+	priv->dfs_cac_workqueue = alloc_workqueue("MWIFIEX_DFS_CAC%s",
 						  WQ_HIGHPRI |
 						  WQ_MEM_RECLAIM |
-						  WQ_UNBOUND, 1);
+						  WQ_UNBOUND, 1, name);
 	if (!priv->dfs_cac_workqueue) {
 		wiphy_err(wiphy, "cannot register virtual network device\n");
 		free_netdev(dev);
@@ -2594,11 +2590,9 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	INIT_DELAYED_WORK(&priv->dfs_cac_work, mwifiex_dfs_cac_work_queue);
 
-	strcpy(dfs_chsw_str, "MWIFIEX_DFS_CHSW");
-	strcat(dfs_chsw_str, name);
-	priv->dfs_chan_sw_workqueue = alloc_workqueue(dfs_chsw_str,
+	priv->dfs_chan_sw_workqueue = alloc_workqueue("MWIFIEX_DFS_CHSW%s",
 						      WQ_HIGHPRI | WQ_UNBOUND |
-						      WQ_MEM_RECLAIM, 1);
+						      WQ_MEM_RECLAIM, 1, name);
 	if (!priv->dfs_chan_sw_workqueue) {
 		wiphy_err(wiphy, "cannot register virtual network device\n");
 		free_netdev(dev);
-- 
1.8.1.4

