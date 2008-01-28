Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1205 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYA1Q1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:27:53 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: rename/document scan_channel
Date: Mon, 28 Jan 2008 17:28:05 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801281728.05763.hs4233@mail.mn-solutions.de> (sfid-20080128_162808_600120_05337603)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename last_scanned_channel to scan_channel, just so that a
grep for struct bss_descriptor's last_scanned element doesn't
show up so many positives.

Also documented the variable and moved it to other scan related
entries in lbs_private.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/debugfs.c	2008-01-28 17:44:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/debugfs.c	2008-01-28 17:46:05.000000000 +0100
@@ -314,7 +314,7 @@ static ssize_t lbs_setuserscan(struct fi
 
 	lbs_scan_networks(priv, scan_cfg, 1);
 	wait_event_interruptible(priv->cmd_pending,
-				 priv->surpriseremoved || !priv->last_scanned_channel);
+				 priv->surpriseremoved || !priv->scan_channel);
 
 	if (priv->surpriseremoved)
 		goto out_scan_cfg;
Index: wireless-2.6/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h	2008-01-28 17:45:29.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/dev.h	2008-01-28 17:46:05.000000000 +0100
@@ -143,9 +143,12 @@ struct lbs_private {
 	wait_queue_head_t waitq;
 	struct workqueue_struct *work_thread;
 
+	/** Scanning */
 	struct delayed_work scan_work;
 	struct delayed_work assoc_work;
 	struct work_struct sync_channel;
+	/* remember which channel was scanned last, != 0 if currently scanning */
+	int scan_channel;
 
 	/** Hardware access */
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
@@ -321,7 +324,6 @@ struct lbs_private {
 	struct cmd_ds_802_11_get_log logmsg;
 
 	u32 monitormode;
-	int last_scanned_channel;
 	u8 fw_ready;
 };
 
Index: wireless-2.6/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c	2008-01-28 17:45:29.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/scan.c	2008-01-28 17:46:05.000000000 +0100
@@ -612,13 +612,13 @@ int lbs_scan_networks(struct lbs_private
 	}
 
 	/* Prepare to continue an interrupted scan */
-	lbs_deb_scan("chan_count %d, last_scanned_channel %d\n",
-		     chan_count, priv->last_scanned_channel);
+	lbs_deb_scan("chan_count %d, scan_channel %d\n",
+		     chan_count, priv->scan_channel);
 	curr_chans = chan_list;
 	/* advance channel list by already-scanned-channels */
-	if (priv->last_scanned_channel > 0) {
-		curr_chans += priv->last_scanned_channel;
-		chan_count -= priv->last_scanned_channel;
+	if (priv->scan_channel > 0) {
+		curr_chans += priv->scan_channel;
+		chan_count -= priv->scan_channel;
 	}
 
 	/* Send scan command(s)
@@ -644,10 +644,10 @@ int lbs_scan_networks(struct lbs_private
 		    !full_scan &&
 		    !priv->surpriseremoved) {
 			/* -1 marks just that we're currently scanning */
-			if (priv->last_scanned_channel < 0)
-				priv->last_scanned_channel = to_scan;
+			if (priv->scan_channel < 0)
+				priv->scan_channel = to_scan;
 			else
-				priv->last_scanned_channel += to_scan;
+				priv->scan_channel += to_scan;
 			cancel_delayed_work(&priv->scan_work);
 			queue_delayed_work(priv->work_thread, &priv->scan_work,
 				msecs_to_jiffies(300));
@@ -671,7 +671,7 @@ int lbs_scan_networks(struct lbs_private
 #endif
 
 out2:
-	priv->last_scanned_channel = 0;
+	priv->scan_channel = 0;
 
 out:
 	if (priv->connect_status == LBS_CONNECTED) {
@@ -1393,7 +1393,7 @@ int lbs_set_scan(struct net_device *dev,
 		queue_delayed_work(priv->work_thread, &priv->scan_work,
 			msecs_to_jiffies(50));
 	/* set marker that currently a scan is taking place */
-	priv->last_scanned_channel = -1;
+	priv->scan_channel = -1;
 
 	if (priv->surpriseremoved)
 		return -EIO;
@@ -1427,7 +1427,7 @@ int lbs_get_scan(struct net_device *dev,
 	lbs_deb_enter(LBS_DEB_SCAN);
 
 	/* iwlist should wait until the current scan is finished */
-	if (priv->last_scanned_channel)
+	if (priv->scan_channel)
 		return -EAGAIN;
 
 	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
