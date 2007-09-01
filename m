Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7718 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbXIAEhf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:35 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 32611618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:35 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 35/35] Replace scan_runs with scan_need_any
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:34 -0400
Message-ID: <20070901043734.2498.8176.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's more meaningful than a number.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   22 +++++++---------------
 drivers/net/wireless/at76_usb.h |    2 +-
 2 files changed, 8 insertions(+), 16 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index ba0ad2c..9b418bf 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3700,9 +3700,9 @@ static void at76_dwork_get_scan(struct work_struct *work)
 		   further down the line and stop this cycle */
 	}
 	at76_dbg(DBG_PROGRESS,
-		 "%s %s: got cmd_status %d (state %s, scan_runs %d)",
+		 "%s %s: got cmd_status %d (state %s, need_any %d)",
 		 priv->netdev->name, __func__, status,
-		 mac_states[priv->mac_state], priv->scan_runs);
+		 mac_states[priv->mac_state], priv->scan_need_any);
 
 	if (status != CMD_STATUS_COMPLETE) {
 		if ((status != CMD_STATUS_IN_PROGRESS) &&
@@ -3723,9 +3723,8 @@ static void at76_dwork_get_scan(struct work_struct *work)
 
 	if (at76_debug & DBG_BSS_TABLE)
 		at76_dump_bss_table(priv);
-	switch (priv->scan_runs) {
 
-	case 2:
+	if (priv->scan_need_any) {
 		ret = at76_start_scan(priv, 0);
 		if (ret < 0)
 			err("%s: %s: start_scan (ANY) failed with %d",
@@ -3735,22 +3734,15 @@ static void at76_dwork_get_scan(struct work_struct *work)
 			 __func__, __LINE__, SCAN_POLL_INTERVAL);
 		schedule_delayed_work(&priv->dwork_get_scan,
 				      SCAN_POLL_INTERVAL);
-		break;
-
-	case 3:
+		priv->scan_need_any = 0;
+	} else {
 		priv->scan_state = SCAN_COMPLETED;
 		/* report the end of scan to user space */
 		at76_iwevent_scan_complete(priv->netdev);
 		at76_set_mac_state(priv, MAC_JOINING);
 		schedule_work(&priv->work_join);
-		break;
-
-	default:
-		err("unexpected priv->scan_runs %d", priv->scan_runs);
 	}
 
-	priv->scan_runs++;
-
 exit:
 	mutex_unlock(&priv->mtx);
 }
@@ -4034,9 +4026,9 @@ static void at76_work_start_scan(struct work_struct *work)
 	 * otherwise simply rely on at76_bss_list_timeout */
 	if (priv->scan_state == SCAN_IN_PROGRESS) {
 		at76_free_bss_list(priv);
-		priv->scan_runs = 2;
+		priv->scan_need_any = 1;
 	} else
-		priv->scan_runs = 3;
+		priv->scan_need_any = 0;
 
 	ret = at76_start_scan(priv, 1);
 
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index c8cff99..8b51f9a 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -495,7 +495,7 @@ struct at76_priv {
 	int scan_min_time;	/* scan min channel time */
 	int scan_max_time;	/* scan max channel time */
 	int scan_mode;		/* SCAN_TYPE_ACTIVE, SCAN_TYPE_PASSIVE */
-	int scan_runs;		/* counts how many scans are started */
+	int scan_need_any;	/* if set, need to scan for any ESSID */
 
 	/* the list we got from scanning */
 	spinlock_t bss_list_spinlock;	/* protects bss_list operations */
