Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:25778 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbXJFBTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 21:19:34 -0400
Received: by wx-out-0506.google.com with SMTP id h31so634115wxd
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2007 18:19:33 -0700 (PDT)
Date: Fri, 5 Oct 2007 21:20:57 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 6/6] ath5k: Do not let the driver through for not yet
	supported radios
Message-ID: <20071006012057.GF25022@pogo> (sfid-20071006_021936_789835_4C2C344D)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo> <20071006011949.GD25022@pogo> <20071006012017.GE25022@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071006012017.GE25022@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IBM AR5424 card uses the same vendor:device ID as an old AR5212. AR5424
is not yet supported though. We detect this and report it.

OpenBSD has similar checks but they check for 64-bit.

Changes to ath5k_base.[ch]
Changes-licensed-under: 3-clause-BSD

Changes to hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    1 +
 drivers/net/wireless/ath5k/base.h |    1 +
 drivers/net/wireless/ath5k/hw.c   |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index caf9562..97a7613 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2423,6 +2423,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 	sc->iobase = mem;
 	sc->cachelsz = csz * sizeof(u32); /* convert to bytes */
 	sc->opmode = IEEE80211_IF_TYPE_STA;
+	sc->pci_express = !!pci_find_capability(pdev, PCI_CAP_ID_EXP);
 	mutex_init(&sc->lock);
 	spin_lock_init(&sc->rxbuflock);
 	spin_lock_init(&sc->txbuflock);
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 1bd1d1f..fde51f1 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -131,6 +131,7 @@ struct ath_softc {
 	struct ieee80211_rate	rates[AR5K_MAX_RATES * NUM_IEEE80211_MODES];
 	enum ieee80211_if_types	opmode;
 	struct ath_hw		*ah;		/* Atheros HW */
+	unsigned int		pci_express : 1;/* indicates PCI Express */
 
 	int			debug;
 
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 445fa96..5f2edce 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -240,6 +240,28 @@ struct ath_hw *ath5k_hw_attach(u16 device,
 		 */
 		hal->ah_single_chip = true;
 		break;
+	case PCI_DEVICE_ID_ATHEROS_AR5212_IBM:
+		/*
+		* IBM ThinkPads use the same device ID for different
+		* chipset versions... we differentiate by pci_express
+		*/
+		if (sc->pci_express) {
+			/*
+			* PCI Express "Mini Card" interface based on the
+			* AR5424 chipset.
+			*/
+			hal->ah_single_chip = true;
+			/* not yet supported */
+			dev_info(&sc->pdev->dev, 
+				"PCI-Express AR5424 not yet supported\n");
+				ret = -EINVAL;
+			goto err_free;
+		} else {
+			/* Classic Mini PCI interface based on AR5212 */
+			hal->ah_single_chip = false;
+		}
+		break;
+
 	default:
 		/*
 		 * Multi chip solutions
-- 
1.5.2.5

