Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5976 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXLEQ5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 11:57:54 -0500
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH 5/5] libertas: handy function to call firmware commands
Date: Wed, 5 Dec 2007 17:58:11 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200712051758.11442.h.schurig@mn-solutions.de> (sfid-20071205_165757_296112_88CBD9DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using an arbitrary firmware command was actually very painful. One
had to change big switch() statements in cmd.c, cmdresp.c, add
structs to the big union in "struct cmd_ds_command" and add the
define for the CMD_802_11_xxx to the proper place.

With this function, this is now much easier. For now, it implements
a blocking (a.k.a. CMD_OPTION_WAITFORRSP) way where one deals directly
with command requests and response buffers. You can do everything in
one place:

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Example of how to get background scan results:

/* You need still to define something :-) */
#define CMD_802_11_BG_SCAN_QUERY 0x006c
struct cmd_ds_802_11_bg_scan_query {
	u8 flush;
};
struct cmd_ds_802_11_bg_scan_query_rsp {
	__le32 report_cond;
	__le16 bss_size;
	u8 num_sets;
	u8 bss[0];
};

/* set maximum size of response */
int rsp_size =3D sizeof(struct cmd_ds_802_11_bg_scan_query_rsp) + 1024;
struct cmd_ds_802_11_bg_scan_query_rsp *rsp =3D kzalloc(rsp_size, GFP_K=
ERNEL)

struct cmd_ds_802_11_bg_scan_query cmd;
cmd.flush =3D 0;

/* After calling lbs_cmd(), rsp_size contains the size of the actual
 * firmware response. Use it when you have variable results */
res =3D lbs_cmd(priv, CMD_802_11_BG_SCAN_QUERY, &cmd, sizeof(cmd), rsp,=
 &rsp_size);
if (res =3D=3D 0)
	printk("num_sets %d, resp_size %d\n", resp->num_sets, resp_size);


Index: wireless-2.6/drivers/net/wireless/libertas/decl.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/decl.h	2007-12-05 1=
8:10:38.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/decl.h	2007-12-05 18:11:=
44.000000000 +0100
@@ -16,6 +16,7 @@ struct lbs_adapter;
 struct sk_buff;
 struct net_device;
 struct cmd_ctrl_node;
+struct cmd_ds_command;
=20
 int lbs_set_mac_packet_filter(struct lbs_private *priv);
=20
@@ -23,6 +24,11 @@ void lbs_send_tx_feedback(struct lbs_pri
=20
 int lbs_free_cmd_buffer(struct lbs_private *priv);
=20
+int lbs_cmd(struct lbs_private *priv,
+	u16 command,
+	void *cmd, int cmd_size,
+	void *resp, int *resp_size);
+
 int lbs_prepare_and_send_command(struct lbs_private *priv,
 	u16 cmd_no,
 	u16 cmd_action,
Index: wireless-2.6/drivers/net/wireless/libertas/hostcmd.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/hostcmd.h	2007-12-0=
5 18:10:38.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/hostcmd.h	2007-12-05 18:=
11:44.000000000 +0100
@@ -66,13 +66,13 @@ struct rxpd {
 };
=20
 struct cmd_ctrl_node {
-	/* CMD link list */
 	struct list_head list;
-	/*CMD wait option: wait for finish or no wait */
+	/* wait for finish or not */
 	u16 wait_option;
-	/* command parameter */
+	/* command response */
 	void *pdata_buf;
-	/*command data */
+	int *pdata_size;
+	/* command data */
 	u8 *bufvirtualaddr;
 	/* wait queue */
 	u16 cmdwaitqwoken;
@@ -100,9 +100,12 @@ struct cmd_ds_gen {
 	__le16 size;
 	__le16 seqnum;
 	__le16 result;
+	void *cmdresp[0];
 };
=20
 #define S_DS_GEN sizeof(struct cmd_ds_gen)
+
+
 /*
  * Define data structure for CMD_GET_HW_SPEC
  * This structure defines the response for the GET_HW_SPEC command
Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-12-0=
5 18:10:38.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-12-05 18:=
11:44.000000000 +0100
@@ -799,7 +799,7 @@ int lbs_process_rx_command(struct lbs_pr
 	}
=20
 	/* Store the response code to cur_cmd_retcode. */
-	adapter->cur_cmd_retcode =3D result;;
+	adapter->cur_cmd_retcode =3D result;
=20
 	if (respcmd =3D=3D CMD_RET(CMD_802_11_PS_MODE)) {
 		struct cmd_ds_802_11_ps_mode *psmode =3D &resp->params.psmode;
@@ -880,11 +880,22 @@ int lbs_process_rx_command(struct lbs_pr
 		goto done;
 	}
=20
-	spin_unlock_irqrestore(&adapter->driver_lock, flags);
-
-	ret =3D handle_cmd_response(respcmd, resp, priv);
-
-	spin_lock_irqsave(&adapter->driver_lock, flags);
+	if (adapter->cur_cmd->pdata_size) {
+		struct cmd_ds_gen *r =3D (struct cmd_ds_gen *)resp;
+		u16 sz =3D cpu_to_le16(resp->size);
+		if (sz > *adapter->cur_cmd->pdata_size) {
+			lbs_pr_err("response 0x%04x doesn't fit into "
+				"buffer (%d > %d)\n", respcmd,
+				sz, *adapter->cur_cmd->pdata_size);
+			sz =3D *adapter->cur_cmd->pdata_size;
+		}
+		memcpy(adapter->cur_cmd->pdata_buf, r->cmdresp, sz);
+		*adapter->cur_cmd->pdata_size =3D sz;
+	} else {
+		spin_unlock_irqrestore(&adapter->driver_lock, flags);
+		ret =3D handle_cmd_response(respcmd, resp, priv);
+		spin_lock_irqsave(&adapter->driver_lock, flags);
+	}
 	if (adapter->cur_cmd) {
 		/* Clean up and Put current command back to cmdfreeq */
 		__lbs_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2007-12-05 18=
:11:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2007-12-05 18:13:1=
0.000000000 +0100
@@ -2007,3 +2007,99 @@ void lbs_ps_confirm_sleep(struct lbs_pri
=20
 	lbs_deb_leave(LBS_DEB_HOST);
 }
+
+
+/**
+ *  @brief Simple way to call firmware functions
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param psmode  	one of the many CMD_802_11_xxxx
+ *  @param cmd          pointer to the parameters structure for above =
command
+ *                      (this should not include the command, size, se=
quence
+ *                      and result fields from struct cmd_ds_gen)
+ *  @param cmd_size     size structure pointed to by cmd
+ *  @param rsp          pointer to an area where the result should be =
placed
+ *  @param rsp_size     pointer to the size of the rsp area. If the fi=
rmware
+ *                      returns fewer bytes, then this *rsp_size will =
be
+ *                      changed to the actual size.
+ *  @return 	   	-1 in case of a higher level error, otherwise
+ *                      the result code from the firmware
+ */
+int lbs_cmd(struct lbs_private *priv,
+	u16 command,
+	void *cmd, int cmd_size,
+	void *rsp, int *rsp_size)
+{
+	struct lbs_adapter *adapter =3D priv->adapter;
+	struct cmd_ctrl_node *cmdnode;
+	struct cmd_ds_gen *cmdptr;
+	unsigned long flags;
+	int ret =3D 0;
+
+	lbs_deb_enter(LBS_DEB_HOST);
+	lbs_deb_host("rsp at %p, rsp_size at %p\n", rsp, rsp_size);
+
+	if (!adapter || !rsp_size) {
+		lbs_deb_host("PREP_CMD: adapter is NULL\n");
+		ret =3D -1;
+		goto done;
+	}
+
+	if (adapter->surpriseremoved) {
+		lbs_deb_host("PREP_CMD: card removed\n");
+		ret =3D -1;
+		goto done;
+	}
+
+	cmdnode =3D lbs_get_cmd_ctrl_node(priv);
+
+	if (cmdnode =3D=3D NULL) {
+		lbs_deb_host("PREP_CMD: cmdnode is NULL\n");
+
+		/* Wake up main thread to execute next command */
+		wake_up_interruptible(&priv->waitq);
+		ret =3D -1;
+		goto done;
+	}
+
+	cmdptr =3D (struct cmd_ds_gen *)cmdnode->bufvirtualaddr;
+	cmdnode->wait_option =3D CMD_OPTION_WAITFORRSP;
+	cmdnode->pdata_buf =3D rsp;
+	cmdnode->pdata_size =3D rsp_size;
+
+	/* Set sequence number, clean result, move to buffer */
+	adapter->seqnum++;
+	cmdptr->command =3D cpu_to_le16(command);
+	cmdptr->size    =3D cmd_size + S_DS_GEN;
+	cmdptr->seqnum =3D cpu_to_le16(adapter->seqnum);
+	cmdptr->result =3D 0;
+	memcpy(cmdptr->cmdresp, cmd, cmd_size);
+
+	lbs_deb_host("PREP_CMD: command 0x%04x\n", command);
+
+	/* here was the big old switch() statement, which is now obsolete,
+	 * because the caller of lbs_cmd() sets up all of *cmd for us. */
+
+	cmdnode->cmdwaitqwoken =3D 0;
+	lbs_queue_cmd(adapter, cmdnode, 1);
+	wake_up_interruptible(&priv->waitq);
+
+	might_sleep();
+	wait_event_interruptible(cmdnode->cmdwait_q, cmdnode->cmdwaitqwoken);
+
+	spin_lock_irqsave(&adapter->driver_lock, flags);
+	if (adapter->cur_cmd_retcode) {
+		lbs_deb_host("PREP_CMD: command failed with return code %d\n",
+		       adapter->cur_cmd_retcode);
+		adapter->cur_cmd_retcode =3D 0;
+		ret =3D -1;
+	}
+	spin_unlock_irqrestore(&adapter->driver_lock, flags);
+
+done:
+	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lbs_cmd);
+
+

--=20
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10           ACHTUNG: die Stra=DFe hat sich ge=E4ndert
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Gesch=E4ftsf=FChrer: H.Herzig, P.Schrittenlocher
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
