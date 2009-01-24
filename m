Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZAXOMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:12:01 -0500
Subject: [PATCH 2/7 v2] airo: re-arrange WPA capability checks
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232748914.447.2.camel@localhost.localdomain>
References: <1232748914.447.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:10:42 -0500
Message-Id: <1232806242.2870.2.camel@localhost.localdomain> (sfid-20090124_151206_596125_2471FF2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The capability register has to be read for other (upcoming) stuff, so fold
the WPA test function back into _init_airo_card() and move the netdevice
registration stuff above it so that the netdevice has a name by the time
the card's capabilities are printed out.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a192c44..a08aadf 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2734,28 +2734,6 @@ static void airo_networks_initialize(struct airo_info *ai)
 			      &ai->network_free_list);
 }
 
-static int airo_test_wpa_capable(struct airo_info *ai)
-{
-	int status;
-	CapabilityRid cap_rid;
-
-	status = readCapabilityRid(ai, &cap_rid, 1);
-	if (status != SUCCESS) return 0;
-
-	/* Only firmware versions 5.30.17 or better can do WPA */
-	if (le16_to_cpu(cap_rid.softVer) > 0x530
-	  || (le16_to_cpu(cap_rid.softVer) == 0x530
-	      && le16_to_cpu(cap_rid.softSubVer) >= 17)) {
-		airo_print_info("", "WPA is supported.");
-		return 1;
-	}
-
-	/* No WPA support */
-	airo_print_info("", "WPA unsupported (only firmware versions 5.30.17"
-		" and greater support WPA.  Detected %s)", cap_rid.prodVer);
-	return 0;
-}
-
 static struct net_device *_init_airo_card( unsigned short irq, int port,
 					   int is_pcmcia, struct pci_dev *pci,
 					   struct device *dmdev )
@@ -2763,6 +2741,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	struct net_device *dev;
 	struct airo_info *ai;
 	int i, rc;
+	CapabilityRid cap_rid;
 
 	/* Create the network device object. */
 	dev = alloc_netdev(sizeof(*ai), "", ether_setup);
@@ -2832,7 +2811,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	}
 
 	if (probe) {
-		if ( setup_card( ai, dev->dev_addr, 1 ) != SUCCESS ) {
+		if (setup_card(ai, dev->dev_addr, 1) != SUCCESS) {
 			airo_print_err(dev->name, "MAC could not be enabled" );
 			rc = -EIO;
 			goto err_out_map;
@@ -2842,28 +2821,47 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 		set_bit(FLAG_FLASHING, &ai->flags);
 	}
 
+	strcpy(dev->name, "eth%d");
+	rc = register_netdev(dev);
+	if (rc) {
+		airo_print_err(dev->name, "Couldn't register_netdev");
+		goto err_out_map;
+	}
+	ai->wifidev = init_wifidev(ai, dev);
+	if (!ai->wifidev)
+		goto err_out_reg;
+
+	rc = readCapabilityRid(ai, &cap_rid, 1);
+	if (rc != SUCCESS) {
+		rc = -EIO;
+		goto err_out_wifi;
+	}
+
+	airo_print_info(dev->name, "Firmware version %x.%x.%02x",
+	                ((le16_to_cpu(cap_rid.softVer) >> 8) & 0xF),
+	                (le16_to_cpu(cap_rid.softVer) & 0xFF),
+	                le16_to_cpu(cap_rid.softSubVer));
+
 	/* Test for WPA support */
-	if (airo_test_wpa_capable(ai)) {
+	/* Only firmware versions 5.30.17 or better can do WPA */
+	if (le16_to_cpu(cap_rid.softVer) > 0x530
+	 || (le16_to_cpu(cap_rid.softVer) == 0x530
+	      && le16_to_cpu(cap_rid.softSubVer) >= 17)) {
+		airo_print_info(ai->dev->name, "WPA supported.");
+
 		set_bit(FLAG_WPA_CAPABLE, &ai->flags);
 		ai->bssListFirst = RID_WPA_BSSLISTFIRST;
 		ai->bssListNext = RID_WPA_BSSLISTNEXT;
 		ai->bssListRidLen = sizeof(BSSListRid);
 	} else {
+		airo_print_info(ai->dev->name, "WPA unsupported with firmware "
+			"versions older than 5.30.17.");
+
 		ai->bssListFirst = RID_BSSLISTFIRST;
 		ai->bssListNext = RID_BSSLISTNEXT;
 		ai->bssListRidLen = sizeof(BSSListRid) - sizeof(BSSListRidExtra);
 	}
 
-	strcpy(dev->name, "eth%d");
-	rc = register_netdev(dev);
-	if (rc) {
-		airo_print_err(dev->name, "Couldn't register_netdev");
-		goto err_out_map;
-	}
-	ai->wifidev = init_wifidev(ai, dev);
-	if (!ai->wifidev)
-		goto err_out_reg;
-
 	set_bit(FLAG_REGISTERED,&ai->flags);
 	airo_print_info(dev->name, "MAC enabled %pM", dev->dev_addr);
 

