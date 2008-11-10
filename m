Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbYKJR51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 12:57:27 -0500
Subject: [PATCH] ath5k: name pci driver "ath5k" too
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Nov 2008 18:56:59 +0100
Message-Id: <1226339820.3650.9.camel@johannes.berg> (sfid-20081110_185731_150095_4F9BF531)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call the ath5k pci driver struct "ath5k" too to be less
confusing in sysfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
resend, forgot the list

 drivers/net/wireless/ath5k/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/drivers/net/wireless/ath5k/base.c	2008-11-10 18:54:15.000000000 +0100
+++ everything/drivers/net/wireless/ath5k/base.c	2008-11-10 18:54:26.000000000 +0100
@@ -200,7 +200,7 @@ static int		ath5k_pci_resume(struct pci_
 #endif /* CONFIG_PM */
 
 static struct pci_driver ath5k_pci_driver = {
-	.name		= "ath5k_pci",
+	.name		= KBUILD_MODNAME,
 	.id_table	= ath5k_pci_id_table,
 	.probe		= ath5k_pci_probe,
 	.remove		= __devexit_p(ath5k_pci_remove),


