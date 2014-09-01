Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11283 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaIAHcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:32:10 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 15/17] mwifiex: remove redundant variable report_scan_result
Date: Mon, 1 Sep 2014 18:29:03 +0530
Message-ID: <1409576345-13717-16-git-send-email-patila@marvell.com> (sfid-20140901_093215_051507_46B6593C)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This variable is never used, get rid of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h        | 1 -
 drivers/net/wireless/mwifiex/scan.c        | 3 ---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 18c327c..4e8e881 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -548,7 +548,6 @@ struct mwifiex_private {
 	u8 nick_name[16];
 	u16 current_key_index;
 	struct semaphore async_sem;
-	u8 report_scan_result;
 	struct cfg80211_scan_request *scan_request;
 	u8 cfg_bssid[6];
 	struct wps wps;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 7c85f61..7b07da2 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1778,9 +1778,6 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 		if (!adapter->ext_scan)
 			mwifiex_complete_scan(priv);
 
-		if (priv->report_scan_result)
-			priv->report_scan_result = false;
-
 		if (priv->scan_request) {
 			dev_dbg(adapter->dev, "info: notifying scan done\n");
 			cfg80211_scan_done(priv->scan_request, 0);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 62866b0..4aad446 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -85,8 +85,6 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		if (priv->report_scan_result)
-			priv->report_scan_result = false;
 		break;
 
 	case HostCmd_CMD_MAC_CONTROL:
-- 
1.8.1.4

