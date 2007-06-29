Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764832AbXF2Ng5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 09:36:57 -0400
From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH 3/5] airo: fix a race causing initialization failures
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Matteo Croce <rootkit85@yahoo.it>
Date: Fri, 29 Jun 2007 15:33:41 +0200
Message-ID: <20070629133341.6658.82061.stgit@localhost.localdomain>
In-Reply-To: <20070629131841.6658.76381.stgit@localhost.localdomain>
References: <20070629131841.6658.76381.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matteo Croce reported Aironet initialization failures. They were caused by
a race in airo. airo finds a free interface name, then initializes the card
and finally registers the interface. Another device may get the same name
in the meantime.
The reason airo gets its name early is to use it in informative printks and
to name the resources it requests. The printks will be just fine without
the interface name and the resources can use the driver's name - that's
what other network drivers do anyway.
One of the talkative functions is setup_card(). It is called once before
registration and can be called later again. Let's have an empty dev->name
during the first call, so it doesn't print the ugly "airo(eth%d)" message.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---

 drivers/net/wireless/airo.c |   59 ++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 37aa619..ae8f26e 100644
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
+	printk(type DRV_NAME "(%s): " fmt "\n", name, ##args)
 
 #define airo_print_info(name, fmt, args...) \
 	airo_print(KERN_INFO, name, fmt, ##args)
@@ -2582,8 +2584,7 @@ static int mpi_init_descriptors (struct airo_info *ai)
  * 2) Map PCI memory for issueing commands.
  * 3) Allocate memory (shared) to send and receive ethernet frames.
  */
-static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci,
-		    const char *name)
+static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci)
 {
 	unsigned long mem_start, mem_len, aux_start, aux_len;
 	int rc = -1;
@@ -2597,35 +2598,35 @@ static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci,
 	aux_start = pci_resource_start(pci, 2);
 	aux_len = AUXMEMSIZE;
 
-	if (!request_mem_region(mem_start, mem_len, name)) {
-		airo_print_err(ai->dev->name, "Couldn't get region %x[%x] for %s",
-		       (int)mem_start, (int)mem_len, name);
+	if (!request_mem_region(mem_start, mem_len, DRV_NAME)) {
+		airo_print_err("", "Couldn't get region %x[%x]",
+			(int)mem_start, (int)mem_len);
 		goto out;
 	}
-	if (!request_mem_region(aux_start, aux_len, name)) {
-		airo_print_err(ai->dev->name, "Couldn't get region %x[%x] for %s",
-		       (int)aux_start, (int)aux_len, name);
+	if (!request_mem_region(aux_start, aux_len, DRV_NAME)) {
+		airo_print_err("", "Couldn't get region %x[%x]",
+			(int)aux_start, (int)aux_len);
 		goto free_region1;
 	}
 
 	ai->pcimem = ioremap(mem_start, mem_len);
 	if (!ai->pcimem) {
-		airo_print_err(ai->dev->name, "Couldn't map region %x[%x] for %s",
-		       (int)mem_start, (int)mem_len, name);
+		airo_print_err("", "Couldn't map region %x[%x]",
+			(int)mem_start, (int)mem_len);
 		goto free_region2;
 	}
 	ai->pciaux = ioremap(aux_start, aux_len);
 	if (!ai->pciaux) {
-		airo_print_err(ai->dev->name, "Couldn't map region %x[%x] for %s",
-		       (int)aux_start, (int)aux_len, name);
+		airo_print_err("", "Couldn't map region %x[%x]",
+			(int)aux_start, (int)aux_len);
 		goto free_memmap;
 	}
 
 	/* Reserve PKTSIZE for each fid and 2K for the Rids */
 	ai->shared = pci_alloc_consistent(pci, PCI_SHARED_LEN, &ai->shared_dma);
 	if (!ai->shared) {
-		airo_print_err(ai->dev->name, "Couldn't alloc_consistent %d",
-		       PCI_SHARED_LEN);
+		airo_print_err("", "Couldn't alloc_consistent %d",
+			PCI_SHARED_LEN);
 		goto free_auxmap;
 	}
 
@@ -2770,7 +2771,7 @@ static int airo_networks_allocate(struct airo_info *ai)
 	    kzalloc(AIRO_MAX_NETWORK_COUNT * sizeof(BSSListElement),
 		    GFP_KERNEL);
 	if (!ai->networks) {
-		airo_print_warn(ai->dev->name, "Out of memory allocating beacons");
+		airo_print_warn("", "Out of memory allocating beacons");
 		return -ENOMEM;
 	}
 
@@ -2798,7 +2799,6 @@ static int airo_test_wpa_capable(struct airo_info *ai)
 {
 	int status;
 	CapabilityRid cap_rid;
-	const char *name = ai->dev->name;
 
 	status = readCapabilityRid(ai, &cap_rid, 1);
 	if (status != SUCCESS) return 0;
@@ -2806,12 +2806,12 @@ static int airo_test_wpa_capable(struct airo_info *ai)
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
@@ -2825,14 +2825,10 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	int i, rc;
 
 	/* Create the network device object. */
-        dev = alloc_etherdev(sizeof(*ai));
-        if (!dev) {
+	dev = alloc_netdev(sizeof(*ai), "", ether_setup);
+	if (!dev) {
 		airo_print_err("", "Couldn't alloc_etherdev");
 		return NULL;
-        }
-	if (dev_alloc_name(dev, dev->name) < 0) {
-		airo_print_err("", "Couldn't get name!");
-		goto err_out_free;
 	}
 
 	ai = dev->priv;
@@ -2841,7 +2837,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	ai->jobs = 0;
 	ai->dev = dev;
 	if (pci && (pci->device == 0x5000 || pci->device == 0xa504)) {
-		airo_print_dbg(dev->name, "Found an MPI350 card");
+		airo_print_dbg("", "Found an MPI350 card");
 		set_bit(FLAG_MPI, &ai->flags);
 	}
 	spin_lock_init(&ai->aux_lock);
@@ -2882,7 +2878,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	msleep(400);
 
 	if (!is_pcmcia) {
-		if (!request_region( dev->base_addr, 64, dev->name )) {
+		if (!request_region(dev->base_addr, 64, DRV_NAME)) {
 			rc = -EBUSY;
 			airo_print_err(dev->name, "Couldn't request region");
 			goto err_out_nets;
@@ -2890,8 +2886,8 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	}
 
 	if (test_bit(FLAG_MPI,&ai->flags)) {
-		if (mpi_map_card(ai, pci, dev->name)) {
-			airo_print_err(dev->name, "Could not map memory");
+		if (mpi_map_card(ai, pci)) {
+			airo_print_err("", "Could not map memory");
 			goto err_out_res;
 		}
 	}
@@ -2919,6 +2915,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 		ai->bssListRidLen = sizeof(BSSListRid) - sizeof(BSSListRidExtra);
 	}
 
+	strcpy(dev->name, "eth%d");
 	rc = register_netdev(dev);
 	if (rc) {
 		airo_print_err(dev->name, "Couldn't register_netdev");
@@ -4014,7 +4011,7 @@ static int bap_setup(struct airo_info *ai, u16 rid, u16 offset, int whichbap )
 		}
 		if ( !(max_tries--) ) {
 			airo_print_err(ai->dev->name,
-				"airo: BAP setup error too many retries\n");
+				"BAP setup error too many retries\n");
 			return ERROR;
 		}
 		// -- PC4500 missed it, try again

