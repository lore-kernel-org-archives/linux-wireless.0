Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44526 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZIHRej (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 13:34:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b44/b43/b43legacy: Fix switch warnings introduced by SSB-SDIO
Date: Tue, 8 Sep 2009 19:33:31 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909081933.31981.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some gcc warnings for switch statements.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/drivers/net/b44.c
===================================================================
--- wireless-testing.orig/drivers/net/b44.c	2009-09-08 19:21:34.000000000 +0200
+++ wireless-testing/drivers/net/b44.c	2009-09-08 19:21:37.000000000 +0200
@@ -1302,10 +1302,13 @@ static void b44_chip_reset(struct b44 *b
 		     & MDIO_CTRL_MAXF_MASK)));
 		break;
 	case SSB_BUSTYPE_PCI:
-	case SSB_BUSTYPE_PCMCIA:
 		bw32(bp, B44_MDIO_CTRL, (MDIO_CTRL_PREAMBLE |
 		     (0x0d & MDIO_CTRL_MAXF_MASK)));
 		break;
+	case SSB_BUSTYPE_PCMCIA:
+	case SSB_BUSTYPE_SDIO:
+		WARN_ON(1); /* A device with this bus does not exist. */
+		break;
 	}
 
 	br32(bp, B44_MDIO_CTRL);
@@ -1763,10 +1766,13 @@ static void b44_get_drvinfo (struct net_
 	case SSB_BUSTYPE_PCI:
 		strncpy(info->bus_info, pci_name(bus->host_pci), sizeof(info->bus_info));
 		break;
-	case SSB_BUSTYPE_PCMCIA:
 	case SSB_BUSTYPE_SSB:
 		strncpy(info->bus_info, "SSB", sizeof(info->bus_info));
 		break;
+	case SSB_BUSTYPE_PCMCIA:
+	case SSB_BUSTYPE_SDIO:
+		WARN_ON(1); /* A device with this bus does not exist. */
+		break;
 	}
 }
 
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-08 19:19:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-08 19:25:30.000000000 +0200
@@ -4099,16 +4099,20 @@ static void b43_imcfglo_timeouts_workaro
 	    bus->pcicore.dev->id.revision <= 5) {
 		/* IMCFGLO timeouts workaround. */
 		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
-		tmp &= ~SSB_IMCFGLO_REQTO;
-		tmp &= ~SSB_IMCFGLO_SERTO;
 		switch (bus->bustype) {
 		case SSB_BUSTYPE_PCI:
 		case SSB_BUSTYPE_PCMCIA:
+			tmp &= ~SSB_IMCFGLO_REQTO;
+			tmp &= ~SSB_IMCFGLO_SERTO;
 			tmp |= 0x32;
 			break;
 		case SSB_BUSTYPE_SSB:
+			tmp &= ~SSB_IMCFGLO_REQTO;
+			tmp &= ~SSB_IMCFGLO_SERTO;
 			tmp |= 0x53;
 			break;
+		default:
+			break;
 		}
 		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
 	}
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-08-23 00:06:40.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-09-08 19:26:03.000000000 +0200
@@ -3106,16 +3106,20 @@ static void b43legacy_imcfglo_timeouts_w
 	    bus->pcicore.dev->id.revision <= 5) {
 		/* IMCFGLO timeouts workaround. */
 		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
-		tmp &= ~SSB_IMCFGLO_REQTO;
-		tmp &= ~SSB_IMCFGLO_SERTO;
 		switch (bus->bustype) {
 		case SSB_BUSTYPE_PCI:
 		case SSB_BUSTYPE_PCMCIA:
+			tmp &= ~SSB_IMCFGLO_REQTO;
+			tmp &= ~SSB_IMCFGLO_SERTO;
 			tmp |= 0x32;
 			break;
 		case SSB_BUSTYPE_SSB:
+			tmp &= ~SSB_IMCFGLO_REQTO;
+			tmp &= ~SSB_IMCFGLO_SERTO;
 			tmp |= 0x53;
 			break;
+		default:
+			break;
 		}
 		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
 	}

-- 
Greetings, Michael.
