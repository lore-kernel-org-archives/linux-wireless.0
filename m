Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17621 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbbBYLVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 06:21:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1PBH0KG017150
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:32 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1srpgjbga8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:31 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<szli@marvell.com>, Amitkumar Karwar <patila@marvell.com>
Subject: [PATCH 3/4] mwifiex: remove_bss_prio_lock
Date: Wed, 25 Feb 2015 22:20:56 +0530
Message-ID: <1424883057-12102-4-git-send-email-patila@marvell.com> (sfid-20150225_122136_833581_B1AD71BE)
In-Reply-To: <1424883057-12102-1-git-send-email-patila@marvell.com>
References: <1424883057-12102-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch does away with spinlock in
mwifiex_wmm_get_highest_priolist_ptr in order to improve TP.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <patila@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 33 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.c     |  2 +-
 drivers/net/wireless/mwifiex/main.h     |  1 +
 drivers/net/wireless/mwifiex/wmm.c      | 11 ++---------
 4 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5f3c1d3..fb55092 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -717,6 +717,9 @@ mwifiex_cfg80211_init_p2p_go(struct mwifiex_private *priv)
 
 static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
+	unsigned long flags;
+
 	priv->mgmt_frame_mask = 0;
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_MGMT_FRAME_REG,
 			     HostCmd_ACT_GEN_SET, 0,
@@ -727,6 +730,25 @@ static int mwifiex_deinit_priv_params(struct mwifiex_private *priv)
 	}
 
 	mwifiex_deauthenticate(priv, NULL);
+
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+	adapter->main_locked = true;
+	if (adapter->mwifiex_processing) {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+		flush_workqueue(adapter->workqueue);
+	} else {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+	}
+
+	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+	adapter->rx_locked = true;
+	if (adapter->rx_processing) {
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+		flush_workqueue(adapter->rx_workqueue);
+	} else {
+		spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+	}
+
 	mwifiex_free_priv(priv);
 	priv->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -740,6 +762,9 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 			     struct net_device *dev,
 			     enum nl80211_iftype type)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
+	unsigned long flags;
+
 	mwifiex_init_priv(priv);
 
 	priv->bss_mode = type;
@@ -770,6 +795,14 @@ mwifiex_init_new_priv_params(struct mwifiex_private *priv,
 		return -EOPNOTSUPP;
 	}
 
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+	adapter->main_locked = false;
+	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
+
+	spin_lock_irqsave(&adapter->rx_proc_lock, flags);
+	adapter->rx_locked = false;
+	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 447eb6f..46e1789 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -217,7 +217,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
 	/* Check if already processing */
-	if (adapter->mwifiex_processing) {
+	if (adapter->mwifiex_processing || adapter->main_locked) {
 		adapter->more_task_flag = true;
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto exit_main_proc;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index b47bffa..cc6a623 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -773,6 +773,7 @@ struct mwifiex_adapter {
 	bool rx_work_enabled;
 	bool rx_processing;
 	bool delay_main_work;
+	bool main_locked;
 	bool rx_locked;
 	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
 	/* spin lock for init/shutdown */
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index ba75a45..ce747f7 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -944,14 +944,11 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	struct mwifiex_ra_list_tbl *ptr;
 	struct mwifiex_tid_tbl *tid_ptr;
 	atomic_t *hqp;
-	unsigned long flags_bss, flags_ra;
+	unsigned long flags_ra;
 	int i, j;
 
 	/* check the BSS with highest priority first */
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
-		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				  flags_bss);
-
 		/* iterate over BSS with the equal priority */
 		list_for_each_entry(adapter->bss_prio_tbl[j].bss_prio_cur,
 				    &adapter->bss_prio_tbl[j].bss_prio_head,
@@ -987,19 +984,15 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 			}
 		}
 
-		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				       flags_bss);
 	}
 
 	return NULL;
 
 found:
-	/* holds bss_prio_lock / ra_list_spinlock */
+	/* holds ra_list_spinlock */
 	if (atomic_read(hqp) > i)
 		atomic_set(hqp, i);
 	spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags_ra);
-	spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-			       flags_bss);
 
 	*priv = priv_tmp;
 	*tid = tos_to_tid[i];
-- 
1.8.1.4

