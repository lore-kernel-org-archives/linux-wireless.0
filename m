Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:59019 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYKZRNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 12:13:10 -0500
Received: by gxk4 with SMTP id 4so581397gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 09:13:08 -0800 (PST)
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] ipw2200: rework scan handling while associated
Date: Wed, 26 Nov 2008 18:05:38 +0100
Cc: ipw2100-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811261805.39953.helmut.schaa@gmail.com> (sfid-20081126_181314_990261_5485225E)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch touches three different aspects:

1) If the firmware does not notify the driver about the scan completion withing
   the timeout, do not restart the firmware but simply cancel the scan. Hence,
   the association isn't dropped.

2) If one beacon was missed during a scan the driver will cancel the scan
   immediately. Hence, while associated most scans will not finish
   successfully (although the firmware tries to switch back to the operating
   channel at TBTT). Increase the number of allowed beacon misses to 3 to
   improve scanning while associated.

3) Fix passive a-band scanning timeout (only 2915). During a scan (while
   associated) the firmware will switch back to the operating channel to
   receive the beacon frame at each TBTT. The driver passes the times to the
   firmware how long it has to stay on a scanned channel depending on the
   channel flags (active vs. passive). The dwell time for passive channels
   is currently set to 120 (TUs). However, if the beacon interval is smaller
   than 120 the firmware will switch back to the operating channel before it
   stayed on the channel for 120 TUs. Thereupon the firmware will scan the
   same channel again but will again not be able to stay on that channel for
   120 TUs and enters an infinite loop until either the scan is canceled or
   the firmware gets restarted (that's my interpretation of what I was able
   to notice while sniffing the traffic).

   In order to avoid that infinite loop this patch adapts the dwell time for
   passive channels to beacon_interval - 10 if the card is in associated state.
   Of course the probability for finding an AP on a passive channel is reduced
   but it allows the scan to finish sucessfully even while associated.

Signed-off-by: helmut.schaa@googlemail.com
---

Could somebody please review the patch?
Should I split the patch into three single patches?
Thanks.

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index c73173a..f17b5b2 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2310,10 +2310,10 @@ static void ipw_scan_check(void *data)
 {
 	struct ipw_priv *priv = data;
 	if (priv->status & (STATUS_SCANNING | STATUS_SCAN_ABORTING)) {
-		IPW_DEBUG_SCAN("Scan completion watchdog resetting "
-			       "adapter after (%dms).\n",
+		IPW_DEBUG_SCAN("Scan completion watchdog: aborting "
+			       "scan after (%dms).\n",
 			       jiffies_to_msecs(IPW_SCAN_CHECK_WATCHDOG));
-		queue_work(priv->workqueue, &priv->adapter_restart);
+		queue_work(priv->workqueue, &priv->abort_scan);
 	}
 }
 
@@ -4346,7 +4346,8 @@ static void ipw_handle_missed_beacon(struct ipw_priv *priv,
 		return;
 	}
 
-	if (priv->status & STATUS_SCANNING) {
+	if (priv->status & STATUS_SCANNING &&
+	    missed_count > priv->cancel_scan_threshold) {
 		/* Stop scan to keep fw from getting
 		 * stuck (only if we aren't roaming --
 		 * otherwise we'll never scan more than 2 or 3
@@ -6281,6 +6282,18 @@ static void ipw_add_scan_channels(struct ipw_priv *priv,
 	}
 }
 
+static int ipw_passive_dwell_time(struct ipw_priv *priv)
+{
+	/* staying on passive channels longer than the beacon interval causes
+	 * the firmware to enter an infinite loop. Hence, don't stay on passive
+	 * longer than the beacon interval.
+	 */
+	if (priv->status & STATUS_ASSOCIATED && priv->assoc_network->beacon_interval > 10)
+		return priv->assoc_network->beacon_interval - 10;
+	else
+		return 120;
+}
+
 static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 {
 	struct ipw_scan_request_ext scan;
@@ -6327,7 +6340,7 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 	  	IPW_DEBUG_WX("use passive scanning\n");
 	  	scan_type = IPW_SCAN_PASSIVE_FULL_DWELL_SCAN;
 		scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =
-			cpu_to_le16(120);
+			cpu_to_le16(ipw_passive_dwell_time(priv));
 		ipw_add_scan_channels(priv, &scan, scan_type);
 		goto send_request;
 	}
@@ -6343,7 +6356,8 @@ static int ipw_request_scan_helper(struct ipw_priv *priv, int type, int direct)
 	scan.dwell_time[IPW_SCAN_ACTIVE_BROADCAST_AND_DIRECT_SCAN] =
 		cpu_to_le16(20);
 
-  	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] = cpu_to_le16(120);
+  	scan.dwell_time[IPW_SCAN_PASSIVE_FULL_DWELL_SCAN] =
+		cpu_to_le16(ipw_passive_dwell_time(priv));
 	scan.dwell_time[IPW_SCAN_ACTIVE_DIRECT_SCAN] = cpu_to_le16(20);
 
 #ifdef CONFIG_IPW2200_MONITOR
@@ -8628,6 +8642,7 @@ static int ipw_sw_reset(struct ipw_priv *priv, int option)
 
 	priv->disassociate_threshold = IPW_MB_DISASSOCIATE_THRESHOLD_DEFAULT;
 	priv->roaming_threshold = IPW_MB_ROAMING_THRESHOLD_DEFAULT;
+	priv->cancel_scan_threshold = IPW_MB_SCAN_CANCEL_THRESHOLD;
 
 	priv->rts_threshold = DEFAULT_RTS_THRESHOLD;
 	priv->short_retry_limit = DEFAULT_SHORT_RETRY_LIMIT;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index 0a84d52..ec133b9 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -245,6 +245,7 @@ enum connection_manager_assoc_states {
 #define HOST_NOTIFICATION_S36_MEASUREMENT_REFUSED       31
 
 #define HOST_NOTIFICATION_STATUS_BEACON_MISSING         1
+#define IPW_MB_SCAN_CANCEL_THRESHOLD                    3
 #define IPW_MB_ROAMING_THRESHOLD_MIN                    1
 #define IPW_MB_ROAMING_THRESHOLD_DEFAULT                8
 #define IPW_MB_ROAMING_THRESHOLD_MAX                    30
@@ -1218,6 +1219,7 @@ struct ipw_priv {
 	u32 hcmd_seq;		  /**< sequence number for hcmd */
 	u32 disassociate_threshold;
 	u32 roaming_threshold;
+	u32 cancel_scan_threshold;
 
 	struct ipw_associate assoc_request;
 	struct ieee80211_network *assoc_network;
