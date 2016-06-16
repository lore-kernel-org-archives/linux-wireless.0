Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44629 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbcFPNY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:24:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5GDHP8S017196
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:24:56 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 23gj5fs041-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:24:56 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/6] mwifiex: factor out mwifiex_cancel_scan
Date: Thu, 16 Jun 2016 18:52:22 +0530
Message-ID: <1466083346-18607-2-git-send-email-akarwar@marvell.com> (sfid-20160616_152501_368992_0FC6F7AE)
In-Reply-To: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
References: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch creates common function mwifiex_cancel_scan to remove
duplication of code.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 40 ++-------------------------
 drivers/net/wireless/marvell/mwifiex/main.h   |  1 +
 drivers/net/wireless/marvell/mwifiex/scan.c   | 26 +++++++++++++++++
 3 files changed, 29 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 6bc2011..c29f26d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1020,8 +1020,6 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
 	unsigned long flags, cmd_flags;
-	struct mwifiex_private *priv;
-	int i;
 
 	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 	/* Cancel current cmd */
@@ -1046,23 +1044,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 
-	mwifiex_cancel_pending_scan_cmd(adapter);
-
-	if (adapter->scan_processing) {
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
-		adapter->scan_processing = false;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-		for (i = 0; i < adapter->priv_num; i++) {
-			priv = adapter->priv[i];
-			if (!priv)
-				continue;
-			if (priv->scan_request) {
-				mwifiex_dbg(adapter, WARN, "info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, 1);
-				priv->scan_request = NULL;
-			}
-		}
-	}
+	mwifiex_cancel_scan(adapter);
 }
 
 /*
@@ -1080,8 +1062,6 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL;
 	unsigned long cmd_flags;
-	struct mwifiex_private *priv;
-	int i;
 
 	if ((adapter->curr_cmd) &&
 	    (adapter->curr_cmd->wait_q_enabled)) {
@@ -1101,23 +1081,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
 	}
 
-	mwifiex_cancel_pending_scan_cmd(adapter);
-
-	if (adapter->scan_processing) {
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
-		adapter->scan_processing = false;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
-		for (i = 0; i < adapter->priv_num; i++) {
-			priv = adapter->priv[i];
-			if (!priv)
-				continue;
-			if (priv->scan_request) {
-				mwifiex_dbg(adapter, WARN, "info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, 1);
-				priv->scan_request = NULL;
-			}
-		}
-	}
+	mwifiex_cancel_scan(adapter);
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 39bb5bc..9f6bb40 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1056,6 +1056,7 @@ int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter);
+void mwifiex_cancel_scan(struct mwifiex_adapter *adapter);
 
 void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
 			      struct cmd_ctrl_node *cmd_node);
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index bc5e52c..e331122 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2001,6 +2001,32 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 	return;
 }
 
+void mwifiex_cancel_scan(struct mwifiex_adapter *adapter)
+{
+	struct mwifiex_private *priv;
+	unsigned long cmd_flags;
+	int i;
+
+	mwifiex_cancel_pending_scan_cmd(adapter);
+
+	if (adapter->scan_processing) {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+		for (i = 0; i < adapter->priv_num; i++) {
+			priv = adapter->priv[i];
+			if (!priv)
+				continue;
+			if (priv->scan_request) {
+				mwifiex_dbg(adapter, INFO,
+					    "info: aborting scan\n");
+				cfg80211_scan_done(priv->scan_request, 1);
+				priv->scan_request = NULL;
+			}
+		}
+	}
+}
+
 /*
  * This function handles the command response of scan.
  *
-- 
1.9.1

