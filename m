Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21233 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbYD3Iyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 04:54:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: rename thread names
Date: Wed, 30 Apr 2008 10:51:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804301051.47028.hs4233@mail.mn-solutions.de> (sfid-20080430_105435_523864_2EAD0FEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Most thread names start with "k", so we can do the same
* the module is named "libertas", so a "klibertas_XXX" thread
  name more self-describing
* one thread is a "struct task_struct", the other a workqueue,
  let this be reflected in the name

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 08:48:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 09:01:22.000000000 +0200
@@ -1122,15 +1122,14 @@ struct lbs_private *lbs_add_card(void *c
 
 	priv->rtap_net_dev = NULL;
 
-	lbs_deb_thread("Starting main thread...\n");
 	init_waitqueue_head(&priv->waitq);
-	priv->main_thread = kthread_run(lbs_thread, dev, "lbs_main");
+	priv->main_thread = kthread_run(lbs_thread, dev, "klibertasd");
 	if (IS_ERR(priv->main_thread)) {
 		lbs_deb_thread("Error creating main thread.\n");
 		goto err_init_adapter;
 	}
 
-	priv->work_thread = create_singlethread_workqueue("lbs_worker");
+	priv->work_thread = create_singlethread_workqueue("klibertasq");
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
 	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
 	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
