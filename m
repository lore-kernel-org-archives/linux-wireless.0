Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20927 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYD3IxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 04:53:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: debug output tweaks for lbs_thread
Date: Wed, 30 Apr 2008 10:50:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804301050.07808.hs4233@mail.mn-solutions.de> (sfid-20080430_105302_580529_4FDCB1A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* make debug output match the variable name
* always report that lbs_remove_rtap() has has been exited

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 09:21:45.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 09:24:05.000000000 +0200
@@ -703,7 +703,7 @@ static int lbs_thread(void *data)
 
 		if (shouldsleep) {
 			lbs_deb_thread("sleeping, connect_status %d, "
-				"ps_mode %d, ps_state %d\n",
+				"psmode %d, psstate %d\n",
 				priv->connect_status,
 				priv->psmode, priv->psstate);
 			spin_unlock_irq(&priv->driver_lock);
@@ -1532,10 +1532,11 @@ static void lbs_remove_rtap(struct lbs_p
 {
 	lbs_deb_enter(LBS_DEB_MAIN);
 	if (priv->rtap_net_dev == NULL)
-		return;
+		goto out;
 	unregister_netdev(priv->rtap_net_dev);
 	free_netdev(priv->rtap_net_dev);
 	priv->rtap_net_dev = NULL;
+out:
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
 
