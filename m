Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.rwth-aachen.de ([134.130.7.73]:44683 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab2LQEKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2012 23:10:47 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_36aBPtioqDkmtqNsBAcoPw)"
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0MF5005M4OVW0K00@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 17 Dec 2012 04:40:44 +0100 (CET)
Received: from pebbles.localnet ([unknown] [92.228.165.25])
 by relay-auth-1.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0MF5005GQOVM3900@relay-auth-1.ms.rz.rwth-aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 17 Dec 2012 04:40:44 +0100 (CET)
From: Stefan =?ISO-8859-1?Q?Br=FCns?= <stefan.bruens@rwth-aachen.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Throughput regression in b43 caused by spurious avoidance
 implementation
Date: Mon, 17 Dec 2012 04:39:23 +0100
Message-id: <7518862.S5jbS4KJYD@pebbles> (sfid-20121217_051052_688821_2AE69F09)
In-reply-to: <CACna6rwH5ixD=f_oXse9AZpK_SNoMEXu=n-2c4ba5gFy1u3prQ@mail.gmail.com>
References: <1698401.RCfH1UvLZM@pebbles>
 <CACna6rwH5ixD=f_oXse9AZpK_SNoMEXu=n-2c4ba5gFy1u3prQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_36aBPtioqDkmtqNsBAcoPw)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT

Hi Rafal, hi list,

had a look at it myself, the culprit is the missing setting operations in case 
CONFIG_B43_SSB is used.

The attached patch fixes the problem in my case, chip_id 0x4322, bus=SSB, 
channel=6/13.

Regards,

Stefan

--Boundary_(ID_36aBPtioqDkmtqNsBAcoPw)
Content-type: text/x-patch; charset=UTF-8; name=ssb_ppl_support.diff
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ssb_ppl_support.diff

--- phy_n.c_orig	2012-12-17 03:38:22.338451489 +0100
+++ phy_n.c	2012-12-17 04:28:02.308743464 +0100
@@ -4518,10 +4518,20 @@
 	b43_phy_write(dev, B43_NPHY_BW6, e->phy_bw6);
 }
 
+/* copied verbatim from ssb/driver_chipcommon_pmu.c */
+static void ssb_chipco_pll_write(struct ssb_chipcommon *cc,
+                                 u32 offset, u32 value)
+{
+        chipco_write32(cc, SSB_CHIPCO_PLLCTL_ADDR, offset);
+        chipco_write32(cc, SSB_CHIPCO_PLLCTL_DATA, value);
+}
+
+
 /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
 static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 {
 	struct bcma_drv_cc __maybe_unused *cc;
+	struct ssb_chipcommon __maybe_unused *ssb_cc;
 	u32 __maybe_unused pmu_ctl;
 
 	switch (dev->dev->bus_type) {
@@ -4583,6 +4593,28 @@
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
 		/* FIXME */
+		b43info(dev->wl, "Spur avoid: bus type=%i (SSB, experimental)"
+			"chip_id=%i/0x%x avoid=%i\n", dev->dev->bus_type,
+			dev->dev->chip_id, dev->dev->chip_id, avoid);
+		ssb_cc = &dev->dev->sdev->bus->chipco;
+		if (dev->dev->chip_id == 0x4322 ||
+			   dev->dev->chip_id == 0x4340 ||
+			   dev->dev->chip_id == 0x4341) {
+			ssb_chipco_pll_write(ssb_cc, 0x0, 0x11100070);
+			ssb_chipco_pll_write(ssb_cc, 0x1, 0x1014140a);
+			ssb_chipco_pll_write(ssb_cc, 0x5, 0x88888854);
+			if (avoid)
+				ssb_chipco_pll_write(ssb_cc, 0x2, 0x05201828);
+			else
+				ssb_chipco_pll_write(ssb_cc, 0x2, 0x05001828);
+			/* guessed by comparing {bcma,ssb}_driver_chipcommon.h */
+			#define SSB_CHIPCO_PMU_CTL_PLL_UPD 0x400;
+			pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
+		} else {
+			b43err(dev->wl, "unsupported!\n");
+			return;
+		}
+		chipco_set32(ssb_cc, SSB_CHIPCO_PMU_CTL, pmu_ctl);
 		break;
 #endif
 	}
@@ -4635,6 +4667,11 @@
 
 	b43_nphy_tx_lp_fbw(dev);
 
+	b43info(dev->wl, "phy.rev=%i phy.n->spavoid=%i(%s) ch=%i\n",
+	    dev->phy.rev, dev->phy.n->spur_avoid, 
+	    (dev->phy.n->spur_avoid == B43_SPUR_AVOID_AUTO)?"auto":"?",
+	    ch);
+
 	if (dev->phy.rev >= 3 &&
 	    dev->phy.n->spur_avoid != B43_SPUR_AVOID_DISABLE) {
 		bool avoid = false;

--Boundary_(ID_36aBPtioqDkmtqNsBAcoPw)--
