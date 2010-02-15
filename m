Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:65328 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab0BODzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 22:55:19 -0500
Message-ID: <4B78C5A4.1040608@lwfinger.net>
Date: Sun, 14 Feb 2010 21:55:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] staging: r8187se: Remove write_phy routine
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove a routine that is not used.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 r8180_core.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)


Index: linux-2.6/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
+++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
@@ -3207,43 +3207,6 @@ void write_phy_cck (struct net_device *d
 	rtl8185_write_phy(dev, adr, data | 0x10000);
 }

-/* 70*3 = 210 ms
- * I hope this is enougth
- */
-#define MAX_PHY 70
-void write_phy(struct net_device *dev, u8 adr, u8 data)
-{
-	u32 phy;
-	int i;
-
-	phy = 0xff0000;
-	phy |= adr;
-	phy |= 0x80; /* this should enable writing */
-	phy |= (data<<8);
-
-	//PHY_ADR, PHY_R and PHY_W  are contig and treated as one dword
-	write_nic_dword(dev,PHY_ADR, phy);
-
-	phy= 0xffff00;
-	phy |= adr;
-
-	write_nic_dword(dev,PHY_ADR, phy);
-	for(i=0;i<MAX_PHY;i++){
-		phy=read_nic_dword(dev,PHY_ADR);
-		phy= phy & 0xff0000;
-		phy= phy >> 16;
-		if(phy == data){ //SUCCESS!
-			force_pci_posting(dev);
-			mdelay(3); //random value
-			return;
-		}else{
-			force_pci_posting(dev);
-			mdelay(3); //random value
-		}
-	}
-	DMESGW ("Phy writing %x %x failed!", adr,data);
-}
-
 void rtl8185_set_rate(struct net_device *dev)
 {
 	int i;

