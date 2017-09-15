Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdIOHXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 03:23:53 -0400
Subject: [PATCH] Revert "PCI: Avoid race while enabling upstream bridges"
From: Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Luca Coelho <luca@coelho.fi>
Date: Fri, 15 Sep 2017 02:23:52 -0500
Message-ID: <20170915072352.10453.31977.stgit@bhelgaas-glaptop.roam.corp.google.com> (sfid-20170915_092421_871959_972505CF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 40f11adc7cd9281227f0a6a627d966dd0a5f0cd9.

Jens found that iwlwifi firmware loading failed on a Lenovo X1 Carbon,
gen4:

  iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-34.ucode failed with error -2
  iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-33.ucode failed with error -2
  iwlwifi 0000:04:00.0: Direct firmware load for iwlwifi-8000C-32.ucode failed with error -2
  iwlwifi 0000:04:00.0: loaded firmware version 31.532993.0 op_mode iwlmvm
  iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
  ...
  iwlwifi 0000:04:00.0: Failed to load firmware chunk!
  iwlwifi 0000:04:00.0: Could not load the [0] uCode section
  iwlwifi 0000:04:00.0: Failed to start INIT ucode: -110
  iwlwifi 0000:04:00.0: Failed to run INIT ucode: -110

He bisected it to 40f11adc7cd9 ("PCI: Avoid race while enabling upstream
bridges").  Revert that commit to fix the regression.

Link: http://lkml.kernel.org/r/4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk
Fixes: 40f11adc7cd9 ("PCI: Avoid race while enabling upstream bridges")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Srinath Mannam <srinath.mannam@broadcom.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Luca Coelho <luca@coelho.fi>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/pci/pci.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b0002daa50f3..6078dfc11b11 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -52,7 +52,6 @@ static void pci_pme_list_scan(struct work_struct *work);
 static LIST_HEAD(pci_pme_list);
 static DEFINE_MUTEX(pci_pme_list_mutex);
 static DECLARE_DELAYED_WORK(pci_pme_work, pci_pme_list_scan);
-static DEFINE_MUTEX(pci_bridge_mutex);
 
 struct pci_pme_device {
 	struct list_head list;
@@ -1351,16 +1350,10 @@ static void pci_enable_bridge(struct pci_dev *dev)
 	if (bridge)
 		pci_enable_bridge(bridge);
 
-	/*
-	 * Hold pci_bridge_mutex to prevent a race when enabling two
-	 * devices below the bridge simultaneously.  The race may cause a
-	 * PCI_COMMAND_MEMORY update to be lost (see changelog).
-	 */
-	mutex_lock(&pci_bridge_mutex);
 	if (pci_is_enabled(dev)) {
 		if (!dev->is_busmaster)
 			pci_set_master(dev);
-		goto end;
+		return;
 	}
 
 	retval = pci_enable_device(dev);
@@ -1368,8 +1361,6 @@ static void pci_enable_bridge(struct pci_dev *dev)
 		dev_err(&dev->dev, "Error enabling bridge (%d), continuing\n",
 			retval);
 	pci_set_master(dev);
-end:
-	mutex_unlock(&pci_bridge_mutex);
 }
 
 static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
@@ -1394,7 +1385,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 		return 0;		/* already enabled */
 
 	bridge = pci_upstream_bridge(dev);
-	if (bridge && !pci_is_enabled(bridge))
+	if (bridge)
 		pci_enable_bridge(bridge);
 
 	/* only skip sriov related */
