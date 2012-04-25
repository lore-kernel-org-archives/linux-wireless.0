Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s20.blu0.hotmail.com ([65.55.111.95]:47016 "EHLO
	blu0-omc2-s20.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:39 -0400
Message-ID: <BLU0-SMTP822240545EFE840A26E035AC270@phx.gbl> (sfid-20120425_081541_663966_7B756771)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 2/6] bcma: Move initialization of SPROM to prevent overwrite
Date: Tue, 24 Apr 2012 23:15:15 -0700
In-Reply-To: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 arch/mips/bcm47xx/setup.c |    4 ++++
 arch/mips/bcm47xx/sprom.c |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 19780aa..67d3d52 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -90,6 +90,7 @@ static int bcm47xx_get_sprom_ssb(struct ssb_bus *bus, struct ssb_sprom *out)
 	char prefix[10];
 
 	if (bus->bustype == SSB_BUSTYPE_PCI) {
+		memset(out, 0, sizeof(struct ssb_sprom));
 		snprintf(prefix, sizeof(prefix), "pci/%u/%u/",
 			 bus->host_pci->bus->number + 1,
 			 PCI_SLOT(bus->host_pci->devfn));
@@ -118,6 +119,7 @@ static int bcm47xx_get_invariants(struct ssb_bus *bus,
 	if (nvram_getenv("boardrev", buf, sizeof(buf)) >= 0)
 		iv->boardinfo.rev = (u16)simple_strtoul(buf, NULL, 0);
 
+	memset(&iv->sprom, 0, sizeof(struct ssb_sprom));
 	bcm47xx_fill_sprom(&iv->sprom, NULL);
 
 	if (nvram_getenv("cardbus", buf, sizeof(buf)) >= 0)
@@ -166,12 +168,14 @@ static int bcm47xx_get_sprom_bcma(struct bcma_bus *bus, struct ssb_sprom *out)
 
 	switch (bus->hosttype) {
 	case BCMA_HOSTTYPE_PCI:
+		memset(out, 0, sizeof(struct ssb_sprom));
 		snprintf(prefix, sizeof(prefix), "pci/%u/%u/",
 			 bus->host_pci->bus->number + 1,
 			 PCI_SLOT(bus->host_pci->devfn));
 		bcm47xx_fill_sprom(out, prefix);
 		return 0;
 	case BCMA_HOSTTYPE_SOC:
+		memset(out, 0, sizeof(struct ssb_sprom));
 		bcm47xx_fill_sprom_ethernet(out, NULL);
 		core = bcma_find_core(bus, BCMA_CORE_80211);
 		if (core) {
diff --git a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
index 5c8dcd2..bc19234 100644
--- a/arch/mips/bcm47xx/sprom.c
+++ b/arch/mips/bcm47xx/sprom.c
@@ -555,8 +555,6 @@ void bcm47xx_fill_sprom_ethernet(struct ssb_sprom *sprom, const char *prefix)
 
 void bcm47xx_fill_sprom(struct ssb_sprom *sprom, const char *prefix)
 {
-	memset(sprom, 0, sizeof(struct ssb_sprom));
-
 	bcm47xx_fill_sprom_ethernet(sprom, prefix);
 
 	nvram_read_u8(prefix, NULL, "sromrev", &sprom->revision, 0);
-- 
1.7.7.6

