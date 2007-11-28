Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6205 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbXK1Q3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:29:30 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: remove user-specified channel list
Date: Wed, 28 Nov 2007 17:30:21 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711281730.21327.hs4233@mail.mn-solutions.de> (sfid-20071128_162934_051995_33AFE8FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the ability to specify channels to scan via debugfs

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/README
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/README	2007-11-28 18:18:45.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/README	2007-11-28 18:20:09.000000000 +0100
@@ -195,8 +195,6 @@ setuserscan
 
          where [ARGS]:
 
-      chan=[chan#][band][mode] where band is [a,b,g] and mode is
-                               blank for active or 'p' for passive
       bssid=xx:xx:xx:xx:xx:xx  specify a BSSID filter for the scan
       ssid="[SSID]"            specify a SSID filter for the scan
       keep=[0 or 1]            keep the previous scan results (1), discard (0)
@@ -204,35 +202,26 @@ setuserscan
       type=[1,2,3]             BSS type: 1 (Infra), 2(Adhoc), 3(Any)
 
     Any combination of the above arguments can be supplied on the command
-      line.  If the chan token is absent, a full channel scan will be
-      completed by the driver.  If dur tokens are absent, the driver default
-      setting will be used.  The bssid and ssid fields, if blank, will
-      produce an unfiltered scan. The type field will default to 3 (Any) and
-      the keep field will default to 0 (Discard).
+    line. If dur tokens are absent, the driver default setting will be used.
+    The bssid and ssid fields, if blank, will produce an unfiltered scan.
+    The type field will default to 3 (Any) and the keep field will default
+    to 0 (Discard).
 
     Examples:
-    1) Perform an active scan on channels 1, 6, and 11 in the 'g' band:
-            echo "chan=1g,6g,11g" > setuserscan
-
-    2) Perform a passive scan on channel 11 for 20 ms:
-            echo "chan=11gp dur=20" > setuserscan
-
-    3) Perform an active scan on channels 1, 6, and 11; and a passive scan on
-       channel 36 in the 'a' band:
-
-            echo "chan=1g,6g,11g,36ap" > setuserscan
+    1) Perform a passive scan on all channels for 20 ms per channel:
+            echo "dur=20" > setuserscan
 
-    4) Perform an active scan on channel 6 and 36 for a specific SSID:
-            echo "chan=6g,36a ssid="TestAP"" > setuserscan
+    2) Perform an active scan for a specific SSID:
+            echo "ssid="TestAP"" > setuserscan
 
-    5) Scan all available channels (B/G, A bands) for a specific BSSID, keep
+    3) Scan all available channels (B/G, A bands) for a specific BSSID, keep
        the current scan table intact, update existing or append new scan data:
             echo "bssid=00:50:43:20:12:82 keep=1" > setuserscan
 
-    6) Scan channel 6, for all infrastructure networks.
+    4) Scan for all infrastructure networks.
        Keep the previous scan table intact. Update any duplicate BSSID/SSID
        matches with the new scan data:
-            echo "chan=6g type=1 keep=1" > setuserscan
+            echo "type=1 keep=1" > setuserscan
 
     All entries in the scan table (not just the new scan data when keep=1)
     will be displayed upon completion by use of the getscantable ioctl.
Index: wireless-2.6/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/debugfs.c	2007-11-28 18:22:36.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/debugfs.c	2007-11-28 18:23:27.000000000 +0100
@@ -196,43 +196,6 @@ out_unlock:
 	return count;
 }
 
-static int lbs_parse_chan(char *buf, size_t count,
-			struct lbs_ioctl_user_scan_cfg *scan_cfg, int dur)
-{
-	char *start, *end, *hold, *str;
-	int i = 0;
-
-	start = strstr(buf, "chan=");
-	if (!start)
-		return -EINVAL;
-	start += 5;
-	end = strchr(start, ' ');
-	if (!end)
-		end = buf + count;
-	hold = kzalloc((end - start)+1, GFP_KERNEL);
-	if (!hold)
-		return -ENOMEM;
-	strncpy(hold, start, end - start);
-	hold[(end-start)+1] = '\0';
-	while(hold && (str = strsep(&hold, ","))) {
-		int chan;
-		char band, passive = 0;
-		sscanf(str, "%d%c%c", &chan, &band, &passive);
-		scan_cfg->chanlist[i].channumber = chan;
-		scan_cfg->chanlist[i].scantype = passive ? 1 : 0;
-		if (band == 'b' || band == 'g')
-			scan_cfg->chanlist[i].radiotype = 0;
-		else if (band == 'a')
-			scan_cfg->chanlist[i].radiotype = 1;
-
-		scan_cfg->chanlist[i].scantime = dur;
-		i++;
-	}
-
-	kfree(hold);
-	return i;
-}
-
 static void lbs_parse_bssid(char *buf, size_t count,
 	struct lbs_ioctl_user_scan_cfg *scan_cfg)
 {
@@ -345,7 +308,6 @@ static ssize_t lbs_setuserscan(struct fi
 	scan_cfg->bsstype = LBS_SCAN_BSS_TYPE_ANY;
 
 	dur = lbs_parse_dur(buf, count, scan_cfg);
-	lbs_parse_chan(buf, count, scan_cfg, dur);
 	lbs_parse_bssid(buf, count, scan_cfg);
 	scan_cfg->clear_bssid = lbs_parse_clear(buf, count, "clear_bssid=");
 	lbs_parse_ssid(buf, count, scan_cfg);
Index: wireless-2.6/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/scan.c	2007-11-28 18:21:10.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/scan.c	2007-11-28 18:23:01.000000000 +0100
@@ -415,11 +415,6 @@ lbs_scan_setup_scan_config(struct lbs_pr
 	struct mrvlietypes_ssidparamset *pssidtlv;
 	struct lbs_scan_cmd_config *pscancfgout = NULL;
 	u8 *ptlvpos;
-	int chanidx;
-	int scantype;
-	int scandur;
-	int channel;
-	int radiotype;
 
 	lbs_deb_enter(LBS_DEB_SCAN);
 
@@ -504,58 +499,8 @@ lbs_scan_setup_scan_config(struct lbs_pr
 	 */
 	*ppchantlvout = (struct mrvlietypes_chanlistparamset *) ptlvpos;
 
-	if (!puserscanin || !puserscanin->chanlist[0].channumber) {
-		/* Create a default channel scan list */
-		lbs_deb_scan("creating full region channel list\n");
-		lbs_scan_create_channel_list(priv, pscanchanlist,
-					      *pfilteredscan);
-		goto out;
-	}
-
-	for (chanidx = 0;
-	     chanidx < LBS_IOCTL_USER_SCAN_CHAN_MAX
-	     && puserscanin->chanlist[chanidx].channumber; chanidx++) {
-
-		channel = puserscanin->chanlist[chanidx].channumber;
-		(pscanchanlist + chanidx)->channumber = channel;
-
-		radiotype = puserscanin->chanlist[chanidx].radiotype;
-		(pscanchanlist + chanidx)->radiotype = radiotype;
-
-		scantype = puserscanin->chanlist[chanidx].scantype;
-
-		if (scantype == CMD_SCAN_TYPE_PASSIVE) {
-			(pscanchanlist +
-			 chanidx)->chanscanmode.passivescan = 1;
-		} else {
-			(pscanchanlist +
-			 chanidx)->chanscanmode.passivescan = 0;
-		}
-
-		if (puserscanin->chanlist[chanidx].scantime) {
-			scandur = puserscanin->chanlist[chanidx].scantime;
-		} else {
-			if (scantype == CMD_SCAN_TYPE_PASSIVE) {
-				scandur = MRVDRV_PASSIVE_SCAN_CHAN_TIME;
-			} else {
-				scandur = MRVDRV_ACTIVE_SCAN_CHAN_TIME;
-			}
-		}
-
-		(pscanchanlist + chanidx)->minscantime =
-		    cpu_to_le16(scandur);
-		(pscanchanlist + chanidx)->maxscantime =
-		    cpu_to_le16(scandur);
-	}
-
-	/* Check if we are only scanning the current channel */
-	if ((chanidx == 1) &&
-	    (puserscanin->chanlist[0].channumber ==
-			       priv->adapter->curbssparams.channel)) {
-		*pscancurrentonly = 1;
-		lbs_deb_scan("scanning current channel only");
-	}
-
+	lbs_scan_create_channel_list(priv, pscanchanlist,
+				      *pfilteredscan);
 out:
 	return pscancfgout;
 }
Index: wireless-2.6/drivers/net/wireless/libertas/scan.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/scan.h	2007-11-28 18:20:13.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/scan.h	2007-11-28 18:20:50.000000000 +0100
@@ -121,11 +121,6 @@ struct lbs_ioctl_user_scan_cfg {
 
 	/* Clear existing scan results matching this SSID */
 	u8 clear_ssid;
-
-    /**
-     *  @brief Variable number (fixed maximum) of channels to scan up
-     */
-	struct lbs_ioctl_user_scan_chan chanlist[LBS_IOCTL_USER_SCAN_CHAN_MAX];
 };
 
 /**
