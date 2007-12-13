Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55996 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762840AbXLMHAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:00 -0500
Subject: [PATCH 89/48] libertas: make worker thread not freezable
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3E-0005uI-Uz@shinybook.infradead.org> (sfid-20071213_070018_541016_26D7CACA)
Date: Thu, 13 Dec 2007 02:00:08 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 16:04:12 -0500

We want it to send the HOST_SLEEP_ACTIVATE command on the way down...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index f9bdd12..dd432ea 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -6,7 +6,6 @@
 
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
-#include <linux/freezer.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
@@ -653,8 +652,6 @@ static int lbs_thread(void *data)
 
 	init_waitqueue_entry(&wait, current);
 
-	set_freezable();
-
 	for (;;) {
 		int shouldsleep;
 
@@ -698,7 +695,6 @@ static int lbs_thread(void *data)
 
 		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&priv->waitq, &wait);
-		try_to_freeze();
 
 		lbs_deb_thread("main-thread 333: intcounter=%d currenttxskb=%p dnld_sent=%d\n",
 			       priv->intcounter, priv->currenttxskb, priv->dnld_sent);
-- 
1.5.3.4

