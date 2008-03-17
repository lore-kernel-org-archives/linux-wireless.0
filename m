Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29321 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYCQLsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 07:48:54 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 2] libertas: convert GET_LOG to a direct command
Date: Mon, 17 Mar 2008 12:45:58 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200803131010.32763.hs4233@mail.mn-solutions.de> <1205419021.23812.8.camel@localhost.localdomain>
In-Reply-To: <1205419021.23812.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803171245.58490.hs4233@mail.mn-solutions.de> (sfid-20080317_114857_326877_D09F0282)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH] libertas: convert GET_LOG to a direct command

Now uses __lbs_cmd() to get the "log" (it's actually more a snapshot of
various counters, not a sequential log). Besides the "mechanical" convertion
the patch add the following logical changes:

* Removes the priv->logmsg variable, it was only used in one place anyway,
  also don't blindly get the counters when associating. Getting the
  counters then the user asks via WEXT for them is good enought.
* don't set wstats.discard.fragment with log.rxfrag, because the latter is
  a counter for successfully received packets, not for fragmented packets.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/wext.c	2008-03-17 11:21:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/wext.c	2008-03-17 11:38:04.000000000 +0100
@@ -820,6 +821,7 @@ static struct iw_statistics *lbs_get_wir
 	int stats_valid = 0;
 	u8 rssi;
 	u32 tx_retries;
+	struct cmd_ds_802_11_get_log log;
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
@@ -863,7 +865,11 @@ static struct iw_statistics *lbs_get_wir
 	/* Quality by TX errors */
 	priv->wstats.discard.retries = priv->stats.tx_errors;
 
-	tx_retries = le32_to_cpu(priv->logmsg.retry);
+	memset(&log, 0, sizeof(log));
+	log.hdr.size = cpu_to_le16(sizeof(log));
+	lbs_cmd_with_response(priv, CMD_802_11_GET_LOG, &log);
+
+	tx_retries = le32_to_cpu(log.retry);
 
 	if (tx_retries > 75)
 		tx_qual = (90 - tx_retries) * POOR / 15;
@@ -879,10 +885,9 @@ static struct iw_statistics *lbs_get_wir
 		    (PERFECT - VERY_GOOD) / 50 + VERY_GOOD;
 	quality = min(quality, tx_qual);
 
-	priv->wstats.discard.code = le32_to_cpu(priv->logmsg.wepundecryptable);
-	priv->wstats.discard.fragment = le32_to_cpu(priv->logmsg.rxfrag);
+	priv->wstats.discard.code = le32_to_cpu(log.wepundecryptable);
 	priv->wstats.discard.retries = tx_retries;
-	priv->wstats.discard.misc = le32_to_cpu(priv->logmsg.ackfailure);
+	priv->wstats.discard.misc = le32_to_cpu(log.ackfailure);
 
 	/* Calculate quality */
 	priv->wstats.qual.qual = min_t(u8, quality, 100);
@@ -892,8 +897,6 @@ static struct iw_statistics *lbs_get_wir
 	/* update stats asynchronously for future calls */
 	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
 					0, 0, NULL);
-	lbs_prepare_and_send_command(priv, CMD_802_11_GET_LOG, 0,
-					0, 0, NULL);
 out:
 	if (!stats_valid) {
 		priv->wstats.miss.beacon = 0;
Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-03-17 11:21:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-03-17 11:21:29.000000000 +0100
@@ -628,10 +628,6 @@ void lbs_association_worker(struct work_
 			lbs_prepare_and_send_command(priv,
 				CMD_802_11_RSSI,
 				0, CMD_OPTION_WAITFORRSP, 0, NULL);
-
-			lbs_prepare_and_send_command(priv,
-				CMD_802_11_GET_LOG,
-				0, CMD_OPTION_WAITFORRSP, 0, NULL);
 		} else {
 			ret = -1;
 		}
Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-17 11:21:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-17 11:22:06.000000000 +0100
@@ -454,18 +454,6 @@ static int lbs_cmd_802_11_reset(struct l
 	return 0;
 }
 
-static int lbs_cmd_802_11_get_log(struct lbs_private *priv,
-				   struct cmd_ds_command *cmd)
-{
-	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_GET_LOG);
-	cmd->size =
-		cpu_to_le16(sizeof(struct cmd_ds_802_11_get_log) + S_DS_GEN);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_cmd_802_11_get_stat(struct lbs_private *priv,
 				    struct cmd_ds_command *cmd)
 {
@@ -1384,10 +1372,6 @@ int lbs_prepare_and_send_command(struct 
 		ret = lbs_cmd_802_11_reset(priv, cmdptr, cmd_action);
 		break;
 
-	case CMD_802_11_GET_LOG:
-		ret = lbs_cmd_802_11_get_log(priv, cmdptr);
-		break;
-
 	case CMD_802_11_AUTHENTICATE:
 		ret = lbs_cmd_80211_authenticate(priv, cmdptr, pdata_buf);
 		break;
Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-17 11:21:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-17 11:21:29.000000000 +0100
@@ -303,20 +303,6 @@ static int lbs_ret_802_11_eeprom_access(
 	return 0;
 }
 
-static int lbs_ret_get_log(struct lbs_private *priv,
-			    struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_get_log *logmessage = &resp->params.glog;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	/* Stored little-endian */
-	memcpy(&priv->logmsg, logmessage, sizeof(struct cmd_ds_802_11_get_log));
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_bcn_ctrl(struct lbs_private * priv,
 					struct cmd_ds_command *resp)
 {
@@ -352,10 +338,6 @@ static inline int handle_cmd_response(st
 		ret = lbs_ret_reg_access(priv, respcmd, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_GET_LOG):
-		ret = lbs_ret_get_log(priv, resp);
-		break;
-
 	case CMD_RET_802_11_ASSOCIATE:
 	case CMD_RET(CMD_802_11_ASSOCIATE):
 	case CMD_RET(CMD_802_11_REASSOCIATE):
Index: wireless-testing/drivers/net/wireless/libertas/dev.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/dev.h	2008-03-17 11:21:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/dev.h	2008-03-17 11:21:29.000000000 +0100
@@ -323,8 +323,6 @@ struct lbs_private {
 	u8 *prdeeprom;
 	struct lbs_offset_value offsetvalue;
 
-	struct cmd_ds_802_11_get_log logmsg;
-
 	u32 monitormode;
 	u8 fw_ready;
 };
Index: wireless-testing/drivers/net/wireless/libertas/hostcmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/hostcmd.h	2008-03-17 11:21:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/hostcmd.h	2008-03-17 11:21:29.000000000 +0100
@@ -195,6 +195,8 @@ struct cmd_ds_802_11_scan_rsp {
 };
 
 struct cmd_ds_802_11_get_log {
+	struct cmd_header hdr;
+
 	__le32 mcasttxframe;
 	__le32 failed;
 	__le32 retry;
@@ -701,7 +703,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_ad_hoc_start ads;
 		struct cmd_ds_802_11_reset reset;
 		struct cmd_ds_802_11_ad_hoc_result result;
-		struct cmd_ds_802_11_get_log glog;
 		struct cmd_ds_802_11_authenticate auth;
 		struct cmd_ds_802_11_get_stat gstat;
 		struct cmd_ds_802_3_get_stat gstat_8023;

