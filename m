Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbXLJRQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:16:16 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 21/48] libertas: endianness fixes
Message-Id: <E1J1kpQ-0006lo-52@shinybook.infradead.org> (sfid-20071210_171620_299975_BA3D5BD4)
Date: Mon, 10 Dec 2007 10:45:56 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Fri, 7 Dec 2007 15:30:44 +0000

Recently I found that that sparse by default doesn't endianness
checks. So I changed my compilation habit to be

make modules C=1 SUBDIRS=drivers/net/wireless/libertas
CHECKFLAGS="-D__CHECK_ENDIAN__"

so that I get the little-endian checks from sparse as well. That
showed up a good bunch of problems.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/11d.c     |    2 +-
 drivers/net/wireless/libertas/cmd.c     |   28 ++++++++++++++--------------
 drivers/net/wireless/libertas/cmdresp.c |    2 +-
 drivers/net/wireless/libertas/hostcmd.h |    8 ++++----
 drivers/net/wireless/libertas/if_sdio.c |    2 +-
 drivers/net/wireless/libertas/if_usb.c  |    4 ++--
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/libertas/11d.c b/drivers/net/wireless/libertas/11d.c
index 377dcb5..013965d 100644
--- a/drivers/net/wireless/libertas/11d.c
+++ b/drivers/net/wireless/libertas/11d.c
@@ -518,7 +518,7 @@ int lbs_cmd_802_11d_domain_info(struct lbs_private *priv,
 		cmd->size =
 		    cpu_to_le16(sizeof(pdomaininfo->action) + S_DS_GEN);
 		lbs_deb_hex(LBS_DEB_11D, "802_11D_DOMAIN_INFO", (u8 *) cmd,
-			(int)(cmd->size));
+			le16_to_cpu(cmd->size));
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index ebfcb7b..cf1ab8a 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -431,7 +431,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 		u8 mode = (u8) (size_t) pdata_buf;
 		pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 		pSNMPMIB->oid = cpu_to_le16((u16) DESIRED_BSSTYPE_I);
-		pSNMPMIB->bufsize = sizeof(u8);
+		pSNMPMIB->bufsize = cpu_to_le16(sizeof(u8));
 		if (mode == IW_MODE_ADHOC) {
 			ucTemp = SNMP_MIB_VALUE_ADHOC;
 		} else {
@@ -451,8 +451,8 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 			pSNMPMIB->oid = cpu_to_le16((u16) DOT11D_I);
 
 			if (cmd_action == CMD_ACT_SET) {
-				pSNMPMIB->querytype = CMD_ACT_SET;
-				pSNMPMIB->bufsize = sizeof(u16);
+				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
+				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
 				ulTemp = *(u32 *)pdata_buf;
 				*((__le16 *)(pSNMPMIB->value)) =
 				    cpu_to_le16((u16) ulTemp);
@@ -484,7 +484,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 		{
 
 			u32 ulTemp;
-			pSNMPMIB->oid = le16_to_cpu((u16) RTSTHRESH_I);
+			pSNMPMIB->oid = cpu_to_le16(RTSTHRESH_I);
 
 			if (cmd_action == CMD_ACT_GET) {
 				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_GET);
@@ -759,7 +759,7 @@ static int lbs_cmd_reg_access(struct lbs_private *priv,
 
 	offval = (struct lbs_offset_value *)pdata_buf;
 
-	switch (cmdptr->command) {
+	switch (le16_to_cpu(cmdptr->command)) {
 	case CMD_MAC_REG_ACCESS:
 		{
 			struct cmd_ds_mac_reg_access *macreg;
@@ -999,7 +999,7 @@ void lbs_queue_cmd(struct lbs_adapter *adapter,
 	}
 
 	/* Exit_PS command needs to be queued in the header always. */
-	if (cmdptr->command == CMD_802_11_PS_MODE) {
+	if (le16_to_cpu(cmdptr->command) == CMD_802_11_PS_MODE) {
 		struct cmd_ds_802_11_ps_mode *psm = &cmdptr->params.psmode;
 		if (psm->action == cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
 			if (adapter->psstate != PS_STATE_FULL_POWER)
@@ -1062,15 +1062,14 @@ static int DownloadcommandToStation(struct lbs_private *priv,
 	adapter->cur_cmd_retcode = 0;
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
-	cmdsize = cmdptr->size;
-	command = cpu_to_le16(cmdptr->command);
+	cmdsize = le16_to_cpu(cmdptr->size);
+	command = le16_to_cpu(cmdptr->command);
 
 	lbs_deb_host("DNLD_CMD: command 0x%04x, size %d, jiffies %lu\n",
-		    command, le16_to_cpu(cmdptr->size), jiffies);
+		    command, cmdsize, jiffies);
 	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", cmdnode->bufvirtualaddr, cmdsize);
 
 	cmdnode->cmdwaitqwoken = 0;
-	cmdsize = cpu_to_le16(cmdsize);
 
 	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmdptr, cmdsize);
 
@@ -1426,9 +1425,10 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 
 #define ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN 8
 			cmdptr->size =
-			    cpu_to_le16(gpio->header.len + S_DS_GEN +
-					     ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
-			gpio->header.len = cpu_to_le16(gpio->header.len);
+			    cpu_to_le16(le16_to_cpu(gpio->header.len)
+				+ S_DS_GEN
+				+ ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
+			gpio->header.len = gpio->header.len;
 
 			ret = 0;
 			break;
@@ -2019,7 +2019,7 @@ static int lbs_cmd_callback(uint16_t respcmd, struct cmd_ds_command *resp, struc
 { 
 	struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
 	struct lbs_adapter *adapter = priv->adapter;
-	u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
+	u16 sz = le16_to_cpu(resp->size) - S_DS_GEN;
 
 	if (sz > *adapter->cur_cmd->pdata_size) {
 		lbs_pr_err("response 0x%04x doesn't fit into buffer (%d > %d)\n",
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 20ca38c..f6c1016 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -561,7 +561,7 @@ static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
 	lbs_deb_enter(LBS_DEB_CMD);
 
 	if (dst_event->action == cpu_to_le16(CMD_ACT_GET)) {
-		dst_event->events = le16_to_cpu(cmd_event->events);
+		dst_event->events = cmd_event->events;
 		memcpy(dst_event->tlv, cmd_event->tlv, sizeof(dst_event->tlv));
 	}
 
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 5ef65ae..efdb720 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -419,13 +419,13 @@ struct cmd_ds_802_11_rf_antenna {
 };
 
 struct cmd_ds_802_11_monitor_mode {
-	u16 action;
-	u16 mode;
+	__le16 action;
+	__le16 mode;
 };
 
 struct cmd_ds_set_boot2_ver {
-	u16 action;
-	u16 version;
+	__le16 action;
+	__le16 version;
 };
 
 struct cmd_ds_802_11_ps_mode {
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 0f0296b..6f5a517 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -454,7 +454,7 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 
 		chunk_size = min(size, (size_t)60);
 
-		*((u32*)chunk_buffer) = cpu_to_le32(chunk_size);
+		*((__le32*)chunk_buffer) = cpu_to_le32(chunk_size);
 		memcpy(chunk_buffer + 4, firmware, chunk_size);
 /*
 		lbs_deb_sdio("sending %d bytes chunk\n", chunk_size);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index e9190a6..a17371f 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -107,7 +107,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 	int rsp_len = sizeof(b2_cmd);
 
 	b2_cmd.action = 0;
-	b2_cmd.version = cpu_to_le16(priv->boot2_version);
+	b2_cmd.version = priv->boot2_version;
 
 	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd),
 		    &b2_cmd, &rsp_len)) {
@@ -227,7 +227,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->hw_host_to_card = if_usb_host_to_card;
 	priv->hw_get_int_status = if_usb_get_int_status;
 	priv->hw_read_event_cause = if_usb_read_event_cause;
-	priv->boot2_version = le16_to_cpu(udev->descriptor.bcdDevice);
+	priv->boot2_version = udev->descriptor.bcdDevice;
 
 	/* Delay 200 ms to waiting for the FW ready */
 	if_usb_submit_rx_urb(cardp);
-- 
1.5.3.4

