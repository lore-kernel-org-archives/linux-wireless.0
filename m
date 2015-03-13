Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14919 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbbCMGi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 02:38:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2D6a0NK007322
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:28 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t3pmg8hw3-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:28 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 1/9] mwifiex: lock main process till reinitialization of vif is over
Date: Fri, 13 Mar 2015 17:37:51 +0530
Message-ID: <1426248479-28451-2-git-send-email-patila@marvell.com> (sfid-20150313_073832_921823_9C5E3151)
In-Reply-To: <1426248479-28451-1-git-send-email-patila@marvell.com>
References: <1426248479-28451-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A crash was detected while changing virtual interface type is in
progress. This was tracked to race condition in accessing bss_priority
table while change is in progress. This patch ensures that main_process
and rx_process works are locked while we change virtual interface.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 33 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.c     |  2 +-
 drivers/net/wireless/mwifiex/main.h     |  1 +
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b0778a6..fc3bbe7 100644
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
+	spin_unlock_irqrestore(&adapter->rx_proc_lock, flags);
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
index 42bf884..9c11eb8 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -189,7 +189,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
 	/* Check if already processing */
-	if (adapter->mwifiex_processing) {
+	if (adapter->mwifiex_processing || adapter->main_locked) {
 		adapter->more_task_flag = true;
 		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto exit_main_proc;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a0908c6..04ef618 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -772,6 +772,7 @@ struct mwifiex_adapter {
 	bool rx_processing;
 	bool delay_main_work;
 	bool rx_locked;
+	bool main_locked;
 	struct mwifiex_bss_prio_tbl bss_prio_tbl[MWIFIEX_MAX_BSS_NUM];
 	/* spin lock for init/shutdown */
 	spinlock_t mwifiex_lock;
-- 
1.8.1.4

