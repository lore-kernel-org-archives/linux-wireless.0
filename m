Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:35982 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab2JTCUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/7] mwifiex: minor cleanup and a fix in scan semaphore usage
Date: Fri, 19 Oct 2012 19:19:17 -0700
Message-Id: <1350699561-852-4-git-send-email-bzhao@marvell.com> (sfid-20121020_042024_557753_86207961)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

mwifiex_request_scan() takes care of synchronous internal scan
performed by driver during association.
Currently the semaphore acquired for the scan is unnecessarily
released at the end of different paths. Also, failure paths
returning error code other than "-1" are not considered.

We will release it at the end of routine to fix above issues.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |    1 -
 drivers/net/wireless/mwifiex/init.c        |    5 -----
 drivers/net/wireless/mwifiex/main.h        |    1 -
 drivers/net/wireless/mwifiex/scan.c        |   10 +---------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    4 ----
 5 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9c8d0b7..4faef1c 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2122,7 +2122,6 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	}
 
 	sema_init(&priv->async_sem, 1);
-	priv->scan_pending_on_block = false;
 
 	dev_dbg(adapter->dev, "info: %s: Marvell 802.11 Adapter\n", dev->name);
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 37f2d95..482faac 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -97,11 +97,6 @@ static void scan_delay_timer_fn(unsigned long data)
 			kfree(priv->user_scan_cfg);
 			priv->user_scan_cfg = NULL;
 		}
-
-		if (priv->scan_pending_on_block) {
-			priv->scan_pending_on_block = false;
-			up(&priv->async_sem);
-		}
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0b747ec..4ed46b6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -482,7 +482,6 @@ struct mwifiex_private {
 	u8 nick_name[16];
 	u16 current_key_index;
 	struct semaphore async_sem;
-	u8 scan_pending_on_block;
 	u8 report_scan_result;
 	struct cfg80211_scan_request *scan_request;
 	struct mwifiex_user_scan_cfg *user_scan_cfg;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8137dfc..b9d41db 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1762,10 +1762,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
-		if (priv->scan_pending_on_block) {
-			priv->scan_pending_on_block = false;
-			up(&priv->async_sem);
-		}
 
 		if (priv->user_scan_cfg) {
 			if (priv->scan_request) {
@@ -1911,7 +1907,6 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 			__func__);
 		return -1;
 	}
-	priv->scan_pending_on_block = true;
 
 	priv->adapter->scan_wait_q_woken = false;
 
@@ -1925,10 +1920,7 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 	if (!ret)
 		ret = mwifiex_wait_queue_complete(priv->adapter);
 
-	if (ret == -1) {
-		priv->scan_pending_on_block = false;
-		up(&priv->async_sem);
-	}
+	up(&priv->async_sem);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 09e6a26..65c12eb 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -85,10 +85,6 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
-		if (priv->scan_pending_on_block) {
-			priv->scan_pending_on_block = false;
-			up(&priv->async_sem);
-		}
 		break;
 
 	case HostCmd_CMD_MAC_CONTROL:
-- 
1.7.0.2

