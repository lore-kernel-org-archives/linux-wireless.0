Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55156 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031219AbXDQRGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2007 13:06:45 -0400
Message-ID: <4624FF0C.5000105@lwfinger.net>
Date: Tue, 17 Apr 2007 12:08:28 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev  1 PHYs
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>	<20070413000950.GC3470@tuxdriver.com> <461EDB39.6080806@lwfinger.net>
In-Reply-To: <461EDB39.6080806@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

In case you cannot find it, here is a copy of David's patch.

Larry

 From David Woodhouse.

It's very simple... if we use inw instead of readw for the faulting I/O
access, then the machine check gets trapped. We can do this because on
PPC, PCI I/O is actually memory-mapped. The CPU doesn't have a separate
I/O space and instructions. So we just compensate for the address at
which PCI I/O is mapped, and abuse inw().

Then we make bcm43xx_phy_read() print the register it tried to access
whenever it gets 0xFFFF, and stick a WARN_ON(1) in the machine check
handler when it detects a machine check caused by an I/O access...

--- ../linux-2.6.20.ppc64/./drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c	2007-04-14 
21:51:02.000000000 +0100
+++ ./drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c	2007-04-16 01:39:44.000000000 +0100
@@ -269,10 +270,13 @@ static inline u16 adjust_phyreg_for_phyt
  u16 bcm43xx_phy_read(struct bcm43xx_wldev *dev, u16 offset)
  {
  	struct bcm43xx_phy *phy = &dev->phy;
-
+	uint16_t foo;
  	offset = adjust_phyreg_for_phytype(phy, offset);
  	bcm43xx_write16(dev, BCM43xx_MMIO_PHY_CONTROL, offset);
-	return bcm43xx_read16(dev, BCM43xx_MMIO_PHY_DATA);
+	foo = bcm43xx_read16(dev, BCM43xx_MMIO_PHY_DATA);
+	if (foo == 0xffff)
+		printk(KERN_DEBUG "Read phy reg %x; got 0xFFFF.\n", offset);
+	return foo;
  }

  void bcm43xx_phy_write(struct bcm43xx_wldev *dev, u16 offset, u16 val)
--- ../linux-2.6.20.ppc64/./drivers/ssb/pci.c	2007-04-14 21:51:02.000000000 +0100
+++ ./drivers/ssb/pci.c	2007-04-15 23:44:27.000000000 +0100
@@ -475,6 +475,7 @@ static u16 ssb_pci_read16(struct ssb_dev
  		if (unlikely(ssb_pci_switch_core(bus, dev)))
  			return 0xFFFF;
  	}
+	return inw(bus->mmio + offset - isa_io_base);
  	return readw(bus->mmio + offset);
  }

--- ../linux-2.6.20.ppc64/./arch/powerpc/kernel/traps.c	2007-04-14 21:50:40.000000000 +0100
+++ ./arch/powerpc/kernel/traps.c	2007-04-15 23:45:48.000000000 +0100
@@ -343,8 +343,10 @@ void machine_check_exception(struct pt_r
  		return;
  	}

-	if (check_io_access(regs))
+	if (check_io_access(regs)) {
+		WARN_ON(1);
  		return;
+	}

  #if defined(CONFIG_4xx) && !defined(CONFIG_440A)
  	if (reason & ESR_IMCP) {

-- 
dwmw2

_______________________________________________
Bcm43xx-dev mailing list
Bcm43xx-dev@lists.berlios.de
https://lists.berlios.de/mailman/listinfo/bcm43xx-dev

