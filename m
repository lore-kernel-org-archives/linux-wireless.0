Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbXJ3Oy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 10:54:59 -0400
Subject: [PATCH] libertas: properly account for queue commands
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 10:52:46 -0400
Message-Id: <1193755966.29187.9.camel@localhost.localdomain> (sfid-20071030_145503_313539_84E1D000)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Target for 2.6.24 and a candidate for stable as well.

From: Marcelo Tosatti <marcelo@kvack.org>

Properly account for queue commands, this fixes a problem reported
by Holger Schurig when using the debugfs interface.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index ce28417..23783b9 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -901,6 +901,10 @@ static int wlan_cmd_mesh_access(wlan_pri
 	return 0;
 }
 
+/*
+ * Note: NEVER use libertas_queue_cmd() with addtail==0 other than for
+ * the command timer, because it does not account for queued commands.
+ */
 void libertas_queue_cmd(wlan_adapter * adapter, struct cmd_ctrl_node *cmdnode, u8 addtail)
 {
 	unsigned long flags;
@@ -930,10 +934,11 @@ void libertas_queue_cmd(wlan_adapter * a
 
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 
-	if (addtail)
+	if (addtail) {
 		list_add_tail((struct list_head *)cmdnode,
 			      &adapter->cmdpendingq);
-	else
+		adapter->nr_cmd_pending++;
+	} else
 		list_add((struct list_head *)cmdnode, &adapter->cmdpendingq);
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
@@ -1412,7 +1417,6 @@ #define ACTION_NUMLED_TLVTYPE_LEN_FIELDS
 	cmdnode->cmdwaitqwoken = 0;
 
 	libertas_queue_cmd(adapter, cmdnode, 1);
-	adapter->nr_cmd_pending++;
 	wake_up_interruptible(&priv->waitq);
 
 	if (wait_option & CMD_OPTION_WAITFORRSP) {

