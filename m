Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50638 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYKFVtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 16:49:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 13:49:32 -0800
Date: Thu, 6 Nov 2008 13:49:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k : Display MAC/BB and RF version at
	startup (v2)
Message-ID: <20081106214929.GJ6169@tesla> (sfid-20081106_224935_545551_D50DE022)
References: <490F63B6.8080600@free.fr> <878ws0ar2u.fsf@nokia.com> <20081105030223.GD16413@tesla> <49119C3D.1060406@free.fr> <49136119.6060407@free.fr> <43e72e890811061347m3bd7ece8sad85c3d808abf49c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890811061347m3bd7ece8sad85c3d808abf49c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 06, 2008 at 01:47:40PM -0800, Luis Rodriguez wrote:
> On Thu, Nov 6, 2008 at 1:26 PM, Benoit PAPILLAULT
> <benoit.papillault@free.fr> wrote:
> > This patch decodes the MAC/BB version (for instance: AR5416) and the RF
> > part version (for instance: AR5133). It has been tested on AR5416/AR5133
> > which is a 2.4/5GHz 11n device. It also makes the differences between
> > AR5416 (PCI) and AR5418 (PCI Express). Both are named AR5416 in
> > the register definitions.
> >
> > Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> 
> thanks, I'm going to test it on our later hardware, but patch fails
> with git am (and therefore with patch itself):
> 
> mcgrof@mosca ~/wireless-testing (git::11dv3)$ patch -p1 <
> /home/mcgrof/name-ath9k.patch
> patching file drivers/net/wireless/ath9k/hw.c
> patching file drivers/net/wireless/ath9k/main.c
> patch: **** malformed patch at line 105: pci_device_id *id)

After tinkering with it applies though, seems your > 80 columns get
wrapped.

From: Benoit PAPILLAULT <benoit.papillault@free.fr>
PATCH] ath9k : Display MAC/BB and RF version at

This patch decodes the MAC/BB version (for instance: AR5416) and the RF
part version (for instance: AR5133). It has been tested on AR5416/AR5133
which is a 2.4/5GHz 11n device. It also makes the differences between
AR5416 (PCI) and AR5418 (PCI Express). Both are named AR5416 in
the register definitions.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

diff --git a/drivers/net/wireless/ath9k/hw.c
b/drivers/net/wireless/ath9k/hw.c
index ded9453..f2916a5 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -382,8 +382,9 @@ static const char *ath9k_hw_devname(u16 devid)
 {
 	switch (devid) {
 	case AR5416_DEVID_PCI:
-	case AR5416_DEVID_PCIE:
 		return "Atheros 5416";
+	case AR5416_DEVID_PCIE:
+		return "Atheros 5418";
 	case AR9160_DEVID_PCI:
 		return "Atheros 9160";
 	case AR9280_DEVID_PCI:
diff --git a/drivers/net/wireless/ath9k/main.c
b/drivers/net/wireless/ath9k/main.c
index c67dadc..2913c13 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -18,6 +18,7 @@

 #include <linux/nl80211.h>
 #include "core.h"
+#include "reg.h"

 #define ATH_PCI_VERSION "0.1"

@@ -1519,15 +1520,74 @@ static struct ieee80211_ops ath9k_ops = {
 	.set_frag_threshold = ath9k_no_fragmentation,
 };

+static struct {
+	u32 version;
+	const char * name;
+} ath_mac_bb_names[] = {
+	{ AR_SREV_VERSION_5416_PCI,	"5416" },
+	{ AR_SREV_VERSION_5416_PCIE,	"5418" },
+	{ AR_SREV_VERSION_9100,		"9100" },
+	{ AR_SREV_VERSION_9160,		"9160" },
+	{ AR_SREV_VERSION_9280,		"9280" },
+	{ AR_SREV_VERSION_9285,		"9285" }
+};
+
+static struct {
+	u16 version;
+	const char * name;
+} ath_rf_names[] = {
+	{ 0,				"5133" },
+	{ AR_RAD5133_SREV_MAJOR,	"5133" },
+	{ AR_RAD5122_SREV_MAJOR,	"5122" },
+	{ AR_RAD2133_SREV_MAJOR,	"2133" },
+	{ AR_RAD2122_SREV_MAJOR,	"2122" }
+};
+
+/*
+ * Return the MAC/BB name. "????" is returned if the MAC/BB is unknown.
+ */
+
+static const char *
+ath_mac_bb_name(u32 mac_bb_version)
+{
+	int i;
+
+	for (i=0; i<ARRAY_SIZE(ath_mac_bb_names); i++) {
+		if (ath_mac_bb_names[i].version == mac_bb_version) {
+			return ath_mac_bb_names[i].name;
+		}
+	}
+
+	return "????";
+}
+
+/*
+ * Return the RF name. "????" is returned if the RF is unknown.
+ */
+
+static const char *
+ath_rf_name(u16 rf_version)
+{
+	int i;
+
+	for (i=0; i<ARRAY_SIZE(ath_rf_names); i++) {
+		if (ath_rf_names[i].version == rf_version) {
+			return ath_rf_names[i].name;
+		}
+	}
+
+	return "????";
+}
+
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
-	const char *athname;
 	u8 csz;
 	u32 val;
 	int ret = 0;
+	struct ath_hal *ah;

 	if (pci_enable_device(pdev))
 		return -EIO;
@@ -1614,11 +1674,15 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bad4;
 	}

-	athname = ath9k_hw_probe(id->vendor, id->device);
-
-	printk(KERN_INFO "%s: %s: mem=0x%lx, irq=%d\n",
+	ah = sc->sc_ah;
+	printk(KERN_INFO
+	       "%s: Atheros AR%s MAC/BB Rev:%x "
+	       "AR%s RF Rev:%x: mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       athname ? athname : "Atheros ???",
+	       ath_mac_bb_name(ah->ah_macVersion),
+	       ah->ah_macRev,
+	       ath_rf_name((ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR)),
+	       ah->ah_phyRev,
 	       (unsigned long)mem, pdev->irq);

 	return 0;
