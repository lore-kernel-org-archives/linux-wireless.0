Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1GOQSu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 12:18:50 -0400
Date: Fri, 15 Jul 2011 18:18:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@venema.h4ckr.net,
	Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: APSM, AR9285 and bus hangs
Message-ID: <20110715161857.GA2122@redhat.com> (sfid-20110715_181854_424830_C5A39EA3)
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
 <20110613132009.GA7133@redhat.com>
 <BANLkTi=epV40yWe0piXoaDes_F5jOV_DJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=epV40yWe0piXoaDes_F5jOV_DJQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2011 at 08:02:54AM +0800, Adrian Chadd wrote:
> I think the problem on these laptops is that -disabling- the APSM bits
> causes some systems to hang.

It is interesting if below patch works, people who can reproduce the
problem please give it a try. Except testing, I'm also interested
on comments :-)

---
>From 6f6f488156d60b44adeb68bbd0cb474b92111681 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 15 Jul 2011 17:50:48 +0200
Subject: [PATCH] ath9k: skip ->config_pci_powersave quirks if PCIe port has ASPM disabled

We receive many bug reports about system hang during suspend/resume
when ath9k driver is in use. Adrian Chadd remarked that this problem
happens on systems that have ASPM disabled.

To do not hit the bug, try to skip doing ->config_pci_powersave magic
if PCIe downstream port device, which ath9k device is connected to, has
ASPM disabled.

This is test only patch, for now I'm interesting if it works. If so
proper patch will need to cope with runtime ASPM setting change, and
probably setup some ath9k registers correctly in both case ASPM is
disabled.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    6 +-----
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    6 +-----
 drivers/net/wireless/ath/ath9k/hw.c        |    1 -
 drivers/net/wireless/ath/ath9k/hw.h        |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c       |   20 ++++++++++++++++++++
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 9ff7c30..44d9d8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -309,11 +309,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 	u8 i;
 	u32 val;
 
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
+	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 8efdec2..ad2bb2b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -519,11 +519,7 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 					 int restore,
 					 int power_off)
 {
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
+	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a5f908..8a80e7d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -378,7 +378,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.additional_swba_backoff = 0;
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
-	ah->config.pcie_powersave_enable = 0;
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6acd0f9..7dd78e7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -219,7 +219,6 @@ struct ath9k_ops_config {
 	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
-	u8 pcie_powersave_enable;
 	bool pcieSerDesWrite;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
@@ -673,6 +672,7 @@ struct ath_hw {
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
+	bool aspm_enabled;
 	bool is_monitoring;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 3bad0b2..2f34503 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -123,6 +123,24 @@ static const struct ath_bus_ops ath_pci_bus_ops = {
 	.extn_synch_en = ath_pci_extn_synch_enable,
 };
 
+static void ath_pci_check_aspm(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	struct pci_dev *parent;
+	u8 aspm;
+
+	ah->aspm_enabled = false;
+
+	if (!pci_is_pcie(pdev))
+		return;
+
+	parent = pdev->bus->self;
+	pci_read_config_byte(parent, ATH_PCIE_CAP_LINK_CTRL, &aspm);
+	if (aspm & (ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1))
+		ah->aspm_enabled = true;
+}
+
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
@@ -230,6 +248,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_init;
 	}
 
+	ath_pci_check_aspm(sc);
+
 	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)mem, pdev->irq);
-- 
1.7.1

