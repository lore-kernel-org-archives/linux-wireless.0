Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab0BOPLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 10:11:47 -0500
Date: Mon, 15 Feb 2010 09:11:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3 V2] staging: r8187se: Remove write_phy routine
Message-ID: <4b796431.q2VeV+yAMJiEjqm7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
