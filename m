Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33035 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbYDBPI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 11:08:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix build for non-PCIhost
Date: Wed, 2 Apr 2008 17:03:26 +0200
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <20080401175230.9ffe75cf.sfr@canb.auug.org.au> <20080401092119.3cb214b1.randy.dunlap@oracle.com>
In-Reply-To: <20080401092119.3cb214b1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804021703.27817.mb@bu3sch.de> (sfid-20080402_160902_288362_8B2CF2EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a build error when PCMCIA-host support is built,
but PCI-host support is disabled.
Hell, who on earth would use such a weird configuration. :D

drivers/built-in.o: In function `ssb_attr_sprom_store':
(.text+0x1c4b79): undefined reference to `ssb_devices_freeze'
drivers/built-in.o: In function `ssb_attr_sprom_store':
(.text+0x1c4bb3): undefined reference to `ssb_devices_thaw'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply this to 2.6.26


Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-03-21 21:41:31.000000000 +0100
+++ wireless-testing/drivers/ssb/main.c	2008-04-02 16:50:16.000000000 +0200
@@ -202,7 +202,7 @@ out:
 	return err;
 }
 
-#ifdef CONFIG_SSB_PCIHOST
+#ifdef CONFIG_SSB_SPROM
 int ssb_devices_freeze(struct ssb_bus *bus)
 {
 	struct ssb_device *dev;
@@ -288,7 +288,7 @@ int ssb_devices_thaw(struct ssb_bus *bus
 
 	return 0;
 }
-#endif /* CONFIG_SSB_PCIHOST */
+#endif /* CONFIG_SSB_SPROM */
 
 static void ssb_device_shutdown(struct device *dev)
 {


-- 
Greetings Michael.
