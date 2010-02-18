Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565Ab0BRQMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 11:12:38 -0500
Subject: patch staging-r8187se-remove-write_phy-routine.patch added to gregkh-2.6 tree
To: Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	gregkh@suse.de, linux-wireless@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 18 Feb 2010 08:12:10 -0800
In-Reply-To: <4B78C5A4.1040608@lwfinger.net>
Message-ID: <12665095302998@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    Subject: staging: r8187se: Remove write_phy routine

to my gregkh-2.6 tree.  Its filename is

    staging-r8187se-remove-write_phy-routine.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From Larry.Finger@lwfinger.net  Thu Feb 18 07:43:19 2010
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 14 Feb 2010 21:55:16 -0600
Subject: staging: r8187se: Remove write_phy routine
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bernhard Schiffner <bernhard@schiffner-limbach.de>, wireless <linux-wireless@vger.kernel.org>
Message-ID: <4B78C5A4.1040608@lwfinger.net>


Remove a routine that is not used.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8187se/r8180_core.c |   37 ---------------------------------
 1 file changed, 37 deletions(-)

--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -3165,43 +3165,6 @@ void write_phy_cck (struct net_device *d
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

