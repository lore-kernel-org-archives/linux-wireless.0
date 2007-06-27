Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbXF0VPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 17:15:54 -0400
Message-ID: <4682D367.1080000@redhat.com>
Date: Wed, 27 Jun 2007 23:15:19 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Subject: [PATCH 1/4] airo: don't use the interface name so much before registration
References: <4682D323.2010605@redhat.com>
In-Reply-To: <4682D323.2010605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matteo Croce reported Aironet initialization failures. They were caused by
a race in airo. airo finds a free interface name, then initializes the card
and finally registers the interface. Another device may get the same name in
the meantime.
The reason airo gets its name early is to use it in informative printks and
to name the resources it requests. The printks will be just fine without
the interface name and the resources can use the driver's name - that's
what other network drivers do anyway.
Note that we still use the interface name in request_irq and for the
kernel thread. The race is not fixed by this change, but it's a first step.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

---
 drivers/net/wireless/airo.c |   50 ++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 2d3a180..38346a5 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -52,6 +52,8 @@
 
 #include "airo.h"
 
+#define DRV_NAME "airo"
+
 #ifdef CONFIG_PCI
 static struct pci_device_id card_ids[] = {
 	{ 0x14b9, 1, PCI_ANY_ID, PCI_ANY_ID, },
@@ -71,7 +73,7 @@ static int airo_pci_suspend(struct pci_dev *pdev, pm_message_t state);
 static int airo_pci_resume(struct pci_dev *pdev);
 
 static struct pci_driver airo_driver = {
-	.name     = "airo",
+	.name     = DRV_NAME,
 	.id_table = card_ids,
 	.probe    = airo_pci_probe,
 	.remove   = __devexit_p(airo_pci_remove),
@@ -1250,7 +1252,7 @@ static int flashputbuf(struct airo_info *ai);
 static int flashrestart(struct airo_info *ai,struct net_device *dev);
 
 #define airo_print(type, name, fmt, args...) \
-	{ printk(type "airo(%s): " fmt "\n", name, ##args); }
+	{ printk(type DRV_NAME "(%s): " fmt "\n", name, ##args); }
 
 #define airo_print_info(name, fmt, args...) \
 	airo_print(KERN_INFO, name, fmt, ##args)
@@ -2554,8 +2556,7 @@ static int mpi_init_descriptors (struct airo_info *ai)
  * 2) Map PCI memory for issueing commands.
  * 3) Allocate memory (shared) to send and receive ethernet frames.
  */
-static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci,
-		    const char *name)
+static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci)
 {
 	unsigned long mem_start, mem_len, aux_start, aux_len;
 	int rc = -1;
@@ -2569,34 +2570,34 @@ static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci,
 	aux_start = pci_resource_start(pci, 2);
 	aux_len = AUXMEMSIZE;
 
-	if (!request_mem_region(mem_start, mem_len, name)) {
-		airo_print_err(ai->dev->name, "Couldn't get region %x[%x] for %s",
-		       (int)mem_start, (int)mem_len, name);
+	if (!request_mem_region(mem_start, mem_len, DRV_NAME)) {
+		airo_print_err("", "Couldn't get region %x[%x]",
+		       (int)mem_start, (int)mem_len);
 		goto out;
 	}
-	if (!request_mem_region(aux_start, aux_len, name)) {
-		airo_print_err(ai->dev->name, "Couldn't get region %x[%x] for %s",
-		       (int)aux_start, (int)aux_len, name);
+	if (!request_mem_region(aux_start, aux_len, DRV_NAME)) {
+		airo_print_err("", "Couldn't get region %x[%x]",
+		       (int)aux_start, (int)aux_len);
 		goto free_region1;
 	}
 
 	ai->pcimem = ioremap(mem_start, mem_len);
 	if (!ai->pcimem) {
-		airo_print_err(ai->dev->name, "Couldn't map region %x[%x] for %s",
-		       (int)mem_start, (int)mem_len, name);
+		airo_print_err("", "Couldn't map region %x[%x]",
+		       (int)mem_start, (int)mem_len);
 		goto free_region2;
 	}
 	ai->pciaux = ioremap(aux_start, aux_len);
 	if (!ai->pciaux) {
-		airo_print_err(ai->dev->name, "Couldn't map region %x[%x] for %s",
-		       (int)aux_start, (int)aux_len, name);
+		airo_print_err("", "Couldn't map region %x[%x]",
+		       (int)aux_start, (int)aux_len);
 		goto free_memmap;
 	}
 
 	/* Reserve PKTSIZE for each fid and 2K for the Rids */
 	ai->shared = pci_alloc_consistent(pci, PCI_SHARED_LEN, &ai->shared_dma);
 	if (!ai->shared) {
-		airo_print_err(ai->dev->name, "Couldn't alloc_consistent %d",
+		airo_print_err("", "Couldn't alloc_consistent %d",
 		       PCI_SHARED_LEN);
 		goto free_auxmap;
 	}
@@ -2742,7 +2743,7 @@ static int airo_networks_allocate(struct airo_info *ai)
 	    kzalloc(AIRO_MAX_NETWORK_COUNT * sizeof(BSSListElement),
 		    GFP_KERNEL);
 	if (!ai->networks) {
-		airo_print_warn(ai->dev->name, "Out of memory allocating beacons");
+		airo_print_warn("", "Out of memory allocating beacons");
 		return -ENOMEM;
 	}
 
@@ -2770,7 +2771,6 @@ static int airo_test_wpa_capable(struct airo_info *ai)
 {
 	int status;
 	CapabilityRid cap_rid;
-	const char *name = ai->dev->name;
 
 	status = readCapabilityRid(ai, &cap_rid, 1);
 	if (status != SUCCESS) return 0;
@@ -2778,12 +2778,12 @@ static int airo_test_wpa_capable(struct airo_info *ai)
 	/* Only firmware versions 5.30.17 or better can do WPA */
 	if ((cap_rid.softVer > 0x530)
 	  || ((cap_rid.softVer == 0x530) && (cap_rid.softSubVer >= 17))) {
-		airo_print_info(name, "WPA is supported.");
+		airo_print_info("", "WPA is supported.");
 		return 1;
 	}
 
 	/* No WPA support */
-	airo_print_info(name, "WPA unsupported (only firmware versions 5.30.17"
+	airo_print_info("", "WPA unsupported (only firmware versions 5.30.17"
 		" and greater support WPA.  Detected %s)", cap_rid.prodVer);
 	return 0;
 }
@@ -2813,7 +2813,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	ai->jobs = 0;
 	ai->dev = dev;
 	if (pci && (pci->device == 0x5000 || pci->device == 0xa504)) {
-		airo_print_dbg(dev->name, "Found an MPI350 card");
+		airo_print_dbg("", "Found an MPI350 card");
 		set_bit(FLAG_MPI, &ai->flags);
 	}
 	spin_lock_init(&ai->aux_lock);
@@ -2862,16 +2862,16 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 		goto err_out_nets;
 	}
 	if (!is_pcmcia) {
-		if (!request_region( dev->base_addr, 64, dev->name )) {
+		if (!request_region(dev->base_addr, 64, DRV_NAME)) {
 			rc = -EBUSY;
-			airo_print_err(dev->name, "Couldn't request region");
+			airo_print_err("", "Couldn't request region");
 			goto err_out_irq;
 		}
 	}
 
 	if (test_bit(FLAG_MPI,&ai->flags)) {
-		if (mpi_map_card(ai, pci, dev->name)) {
-			airo_print_err(dev->name, "Could not map memory");
+		if (mpi_map_card(ai, pci)) {
+			airo_print_err("", "Could not map memory");
 			goto err_out_res;
 		}
 	}
@@ -4004,7 +4004,7 @@ static int bap_setup(struct airo_info *ai, u16 rid, u16 offset, int whichbap )
 		}
 		if ( !(max_tries--) ) {
 			airo_print_err(ai->dev->name,
-				"airo: BAP setup error too many retries\n");
+				"BAP setup error too many retries\n");
 			return ERROR;
 		}
 		// -- PC4500 missed it, try again


