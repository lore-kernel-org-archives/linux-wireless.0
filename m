Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12407 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZAZPan (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 10:30:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 07:30:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: remove useless ath9k driver version information
Date: Mon, 26 Jan 2009 07:30:03 -0800
Message-ID: <1232983803-18125-1-git-send-email-lrodriguez@atheros.com> (sfid-20090126_163049_631662_AEA5954E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Versioning for ath9k is pointless we have kept it at 0.1
since the initial release so its meaningless. We put more emphasis
on kernel release or dated wireless-testing master tag
as per John's tagging.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 15a7f90..db76016 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2579,13 +2579,12 @@ static int __init ath9k_init(void)
 {
 	int error;
 
-	printk(KERN_INFO "%s: %s\n", dev_info, ATH_PCI_VERSION);
-
 	/* Register rate control algorithm */
 	error = ath_rate_control_register();
 	if (error != 0) {
 		printk(KERN_ERR
-			"Unable to register rate control algorithm: %d\n",
+			"ath9k: Unable to register rate control "
+			"algorithm: %d\n",
 			error);
 		goto err_out;
 	}
@@ -2593,7 +2592,7 @@ static int __init ath9k_init(void)
 	error = ath_pci_init();
 	if (error < 0) {
 		printk(KERN_ERR
-			"ath_pci: No devices found, driver not installed.\n");
+			"ath9k: No PCI devices found, driver not installed.\n");
 		error = -ENODEV;
 		goto err_rate_unregister;
 	}
-- 
1.5.6.4

