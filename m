Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:58796 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbXJ0XNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:13:36 -0400
Date: Sun, 28 Oct 2007 02:13:32 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 3/7] ath5k: Remove obsolete sysctl stuff
Message-ID: <20071027231332.GC5973@localhost.domain.invalid> (sfid-20071028_001339_682775_19CAA71A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove sysctl tables.

We shouldn't use /proc to configure things.

Changes-licensed-under: 3-clause-BSD
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 73c0a38..382bb23 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -203,50 +203,6 @@ MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
 
 
 /*
- * Sysctl tables
- */
-static int mincalibrate = 1;
-static int maxcalibrate = INT_MAX / 1000;
-static ctl_table ath5k_static_sysctls[] = {
-#if AR_DEBUG
-	{
-	  .procname	= "debug",
-	  .mode		= 0644,
-	  .data		= &ath5k_debug,
-	  .maxlen	= sizeof(ath5k_debug),
-	  .proc_handler	= proc_dointvec
-	},
-#endif
-	{
-	  .procname	= "calibrate",
-	  .mode		= 0644,
-	  .data		= &ath5k_calinterval,
-	  .maxlen	= sizeof(ath5k_calinterval),
-	  .extra1	= &mincalibrate,
-	  .extra2	= &maxcalibrate,
-	  .proc_handler	= proc_dointvec_minmax
-	},
-	{ 0 }
-};
-static ctl_table ath5k_ath5k_table[] = {
-	{
-	  .procname	= "ath",
-	  .mode		= 0555,
-	  .child	= ath5k_static_sysctls
-	}, { 0 }
-};
-static ctl_table ath5k_root_table[] = {
-	{
-	  .ctl_name	= CTL_DEV,
-	  .procname	= "dev",
-	  .mode		= 0555,
-	  .child	= ath5k_ath5k_table
-	}, { 0 }
-};
-static struct ctl_table_header *ath5k_sysctl_header;
-
-
-/*
  * Prototypes - PCI stack related functions
  */
 static int __devinit	ath5k_pci_probe(struct pci_dev *pdev,
@@ -417,7 +373,6 @@ init_ath5k_pci(void)
 		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
 		return ret;
 	}
-	ath5k_sysctl_header = register_sysctl_table(ath5k_root_table);
 
 	return 0;
 }
@@ -425,8 +380,6 @@ init_ath5k_pci(void)
 static void __exit
 exit_ath5k_pci(void)
 {
-	if (ath5k_sysctl_header)
-		unregister_sysctl_table(ath5k_sysctl_header);
 	pci_unregister_driver(&ath5k_pci_drv_id);
 }
 
@@ -765,8 +718,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	sc->led_on = 0; /* low true */
 	/*
 	 * Auto-enable soft led processing for IBM cards and for
-	 * 5211 minipci cards.  Users can also manually enable/disable
-	 * support with a sysctl.
+	 * 5211 minipci cards.
 	 */
 	if (pdev->device == PCI_DEVICE_ID_ATHEROS_AR5212_IBM ||
 			pdev->device == PCI_DEVICE_ID_ATHEROS_AR5211) {



