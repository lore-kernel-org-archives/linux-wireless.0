Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:29669 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZJSLkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 07:40:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: remove "struct cmd_ds_gen"
Date: Mon, 19 Oct 2009 13:39:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910191339.56210.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH] libertas: remove "struct cmd_ds_gen"

It was only used as a source for S_DS_GEN, but the size of this struct
is equal to the size of "struct cmd_header".

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/host.h
+++ linux-wl/drivers/net/wireless/libertas/host.h
@@ -389,19 +389,6 @@
 	u32 value;
 } __attribute__ ((packed));
 
-/* Define general data structure */
-/* cmd_DS_GEN */
-struct cmd_ds_gen {
-	__le16 command;
-	__le16 size;
-	__le16 seqnum;
-	__le16 result;
-	void *cmdresp[0];
-} __attribute__ ((packed));
-
-#define S_DS_GEN sizeof(struct cmd_ds_gen)
-
-
 /*
  * Define data structure for CMD_GET_HW_SPEC
  * This structure defines the response for the GET_HW_SPEC command
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -279,7 +279,7 @@
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 
 	if (cmd_action == CMD_ACT_GET) {
-		cmd.hdr.size = cpu_to_le16(S_DS_GEN + 2);
+		cmd.hdr.size = cpu_to_le16(sizeof(struct cmd_header) + 2);
 	} else {
 		memset(cmd.keyParamSet, 0, sizeof(cmd.keyParamSet));
 
@@ -456,7 +456,8 @@
 
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->command = cpu_to_le16(CMD_802_11_RSSI);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rssi) +
+		sizeof(struct cmd_header));
 	cmd->params.rssi.N = cpu_to_le16(DEFAULT_BCN_AVG_FACTOR);
 
 	/* reset Beacon SNR/NF/RSSI values */
@@ -514,7 +515,7 @@
 	lbs_deb_enter(LBS_DEB_CMD);
 	cmd->size =
 	    cpu_to_le16(sizeof(struct cmd_ds_802_11_beacon_control)
-			     + S_DS_GEN);
+			     + sizeof(struct cmd_header));
 	cmd->command = cpu_to_le16(CMD_802_11_BEACON_CTRL);
 
 	bcn_ctrl->action = cpu_to_le16(cmd_action);
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -240,7 +240,7 @@
 
 	cmd->command = cpu_to_le16(CMD_802_11_PS_MODE);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_ps_mode) +
-				S_DS_GEN);
+				sizeof(struct cmd_header));
 	psm->action = cpu_to_le16(cmd_action);
 	psm->multipledtim = 0;
 	switch (cmd_action) {
@@ -535,7 +535,7 @@
 	cmd->command = cpu_to_le16(CMD_802_11_MONITOR_MODE);
 	cmd->size =
 	    cpu_to_le16(sizeof(struct cmd_ds_802_11_monitor_mode) +
-			     S_DS_GEN);
+			     sizeof(struct cmd_header));
 
 	monitor->action = cpu_to_le16(cmd_action);
 	if (cmd_action == CMD_ACT_SET) {
@@ -644,7 +644,7 @@
 
 			cmdptr->size =
 			    cpu_to_le16(sizeof (struct cmd_ds_mac_reg_access)
-					+ S_DS_GEN);
+					+ sizeof(struct cmd_header));
 			macreg =
 			    (struct cmd_ds_mac_reg_access *)&cmdptr->params.
 			    macreg;
@@ -663,7 +663,7 @@
 			cmdptr->size =
 			    cpu_to_le16(sizeof
 					     (struct cmd_ds_bbp_reg_access)
-					     + S_DS_GEN);
+					     + sizeof(struct cmd_header));
 			bbpreg =
 			    (struct cmd_ds_bbp_reg_access *)&cmdptr->params.
 			    bbpreg;
@@ -682,7 +682,7 @@
 			cmdptr->size =
 			    cpu_to_le16(sizeof
 					     (struct cmd_ds_rf_reg_access) +
-					     S_DS_GEN);
+					     sizeof(struct cmd_header));
 			rfreg =
 			    (struct cmd_ds_rf_reg_access *)&cmdptr->params.
 			    rfreg;
@@ -709,7 +709,8 @@
 	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
 	cmd->command = cpu_to_le16(CMD_BT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access) + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_bt_access) +
+		sizeof(struct cmd_header));
 	cmd->result = 0;
 	bt_access->action = cpu_to_le16(cmd_action);
 
@@ -746,7 +747,8 @@
 	lbs_deb_enter_args(LBS_DEB_CMD, "action %d", cmd_action);
 
 	cmd->command = cpu_to_le16(CMD_FWT_ACCESS);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) + S_DS_GEN);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_fwt_access) +
+		sizeof(struct cmd_header));
 	cmd->result = 0;
 
 	if (pdata_buf)
@@ -1162,7 +1164,7 @@
 
 		cmdptr->command = cpu_to_le16(cmd_no);
 		cmdptr->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_afc) +
-					   S_DS_GEN);
+					   sizeof(struct cmd_header));
 
 		memmove(&cmdptr->params.afc,
 			pdata_buf, sizeof(struct cmd_ds_802_11_afc));
@@ -1174,7 +1176,7 @@
 		cmdptr->command = cpu_to_le16(CMD_802_11_TPC_CFG);
 		cmdptr->size =
 		    cpu_to_le16(sizeof(struct cmd_ds_802_11_tpc_cfg) +
-				     S_DS_GEN);
+				     sizeof(struct cmd_header));
 
 		memmove(&cmdptr->params.tpccfg,
 			pdata_buf, sizeof(struct cmd_ds_802_11_tpc_cfg));
@@ -1195,7 +1197,7 @@
 		break;
 	case CMD_802_11_DEEP_SLEEP:
 		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
-		cmdptr->size = cpu_to_le16(S_DS_GEN);
+		cmdptr->size = cpu_to_le16(sizeof(struct cmd_header));
 		break;
 	default:
 		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -1291,11 +1291,11 @@
 	/* The size of the TLV buffer is equal to the entire command response
 	 *   size (scanrespsize) minus the fixed fields (sizeof()'s), the
 	 *   BSS Descriptions (bssdescriptsize as bytesLef) and the command
-	 *   response header (S_DS_GEN)
+	 *   response header (sizeof(struct cmd_header))
 	 */
 	tlvbufsize = scanrespsize - (bytesleft + sizeof(scanresp->bssdescriptsize)
 				     + sizeof(scanresp->nr_sets)
-				     + S_DS_GEN);
+				     + sizeof(struct cmd_header));
 
 	/*
 	 *  Process each scan response returned (scanresp->nr_sets). Save


-- 
http://www.holgerschurig.de
