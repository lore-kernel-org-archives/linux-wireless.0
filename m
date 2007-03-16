Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbXCPLnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 07:43:31 -0400
Message-ID: <45FA82C3.2070502@redhat.com>
Date: Fri, 16 Mar 2007 12:42:59 +0100
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: breed@users.sourceforge.net, dcbw@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH 2/3] airo: Fix an error path memory leak
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The airo driver leaks memory if request_irq() fails.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 71ac1f1..0d5b433 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2850,7 +2850,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	if (rc) {
 		airo_print_err(dev->name, "register interrupt %d failed, rc %d",
 				irq, rc);
-		goto err_out_unlink;
+		goto err_out_nets;
 	}
 	if (!is_pcmcia) {
 		if (!request_region( dev->base_addr, 64, dev->name )) {
@@ -2933,6 +2933,8 @@ err_out_res:
 	        release_region( dev->base_addr, 64 );
 err_out_irq:
 	free_irq(dev->irq, dev);
+err_out_nets:
+	airo_networks_free(ai);
 err_out_unlink:
 	del_airo_dev(dev);
 err_out_thr:


