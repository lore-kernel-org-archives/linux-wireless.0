Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f13.google.com ([209.85.218.13]:42520 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYLJMSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 07:18:50 -0500
Received: by bwz6 with SMTP id 6so1102992bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 04:18:48 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCHv2] ipw2200: fix scanning while associated
Date: Wed, 10 Dec 2008 13:17:26 +0100
Cc: yi.zhu@intel.com, ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812101317.26454.helmut.schaa@gmail.com> (sfid-20081210_131855_036386_C7CD9323)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes sporadic firmware restarts when scanning while associated.

The firmware will quietly cancel a scan (while associated) if the dwell time
for a channel to be scanned is larger than the time it may stay away from the
operating channel (because of DTIM catching). Unfortunately the driver is not
notified about the canceled scan and therefore the scan watchdog timeout will
be hit and the driver causes a firmware restart which results in
disassociation. This mainly happens on passive channels which use a dwell time
of 120 whereas a typical beacon interval is around 100.

The patch changes the dwell time for passive channels to be slightly smaller
than the actual beacon interval to work around the firmware issue. Furthermore
the number of allowed beacon misses is increased from one to three as otherwise
most scans (while associated) won't complete successfully.

However scanning while associated will still fail in corner cases such as a
beacon intervals below 30.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index dc6eb49..8e7affa 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -4347,7 +4347,8 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
 		return;
 	}
 
-	if (priv->status & STATUS_SCANNING) {
+	if (priv->status & STATUS_SCANNING &&
+	    missed_count > IPW_MB_SCAN_CANCEL_THRESHOLD) {
 		/* Stop scan to keep fw from getting
 		 * stuck (only if we aren't roaming --
 		 * otherwise we'll never scan more than 2 or 3
@@ -6282,6 +6283,20 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 	}
 }
 
+static int ipw_passive_dwell_time(struct ipw_priv *priv)
+{
+	/* staying on passive channels longer than the DTIM interval during a
+	 * scan, while associated, causes the firmware to cancel the scan
+	 * without notification. Hence, don't stay on passive channels longer
+	 * than the beacon interval.
+	 */
+	if (priv->status & STATUS_ASSOCIATED
+	    && priv->assoc_network->beacon_interval > 10)
+		return priv->assoc_network->beacon_interval - 10;
+	else
+		return 120;
+}
+
 static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 {
 	struct ipw_scan_request_ext scan;
@@ -6328,7 +6343,7 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 	  	IPW_DEBUG_WX("use passive scanning\n");
 	  	scan_type = IPW_SCAN_PASSIVE_FULL_DWELL_SCAN;
 		scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =
-			cpu_to_le16(120);
+			cpu_to_le16(ipw_passive_dwell_time(priv));
 		ipw_add_scan_channels(priv, &scan, scan_type);
 		goto send_request;
 	}
@@ -6344,7 +6359,8 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 	scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN] =
 		cpu_to_le16(20);
 
-  	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] = cpu_to_le16(120);
+  	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =
+		cpu_to_le16(ipw_passive_dwell_time(priv));
 	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] = cpu_to_le16(20);
 
 #ifdef CONFIG_IPW2200_MONITOR
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index 0a84d52..277b274 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -245,6 +245,7 @@ enum connection_manager_assoc_states {
 #define HOST_NOTIFICATION_S36_MEASUREMENT_REFUSED       31
 
 #define HOST_NOTIFICATION_STATUS_BEACON_MISSING         1
+#define IPW_MB_SCAN_CANCEL_THRESHOLD                    3
 #define IPW_MB_ROAMING_THRESHOLD_MIN                    1
 #define IPW_MB_ROAMING_THRESHOLD_DEFAULT                8
 #define IPW_MB_ROAMING_THRESHOLD_MAX                    30
