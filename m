Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58589 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbBVVYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 16:24:51 -0500
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/2 fix for 3.20] vt6655: Fix late setting of byRFType.
Date: Sun, 22 Feb 2015 21:24:12 +0000
Message-Id: <1424640252-3202-2-git-send-email-tvboxspy@gmail.com> (sfid-20150222_222456_237624_259C29EE)
In-Reply-To: <1424640252-3202-1-git-send-email-tvboxspy@gmail.com>
References: <1424640252-3202-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byRFType is not set prior to registration of mac80211 causing
unpredictable operation after channel scans.

With byRFType unset all channels are enabled this causes tx power
to be set to values not present its eeprom.

Move setting of this variable to vt6655_probe.

byRFType must have a mask set. byRevId not used by driver and
is removed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f5c5872..03b2a90 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -330,16 +330,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	/* zonetype initial */
 	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
 
-	/* Get RFType */
-	pDevice->byRFType = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_RFTYPE);
-
-	/* force change RevID for VT3253 emu */
-	if ((pDevice->byRFType & RF_EMU) != 0)
-			pDevice->byRevId = 0x80;
-
-	pDevice->byRFType &= RF_MASK;
-	pr_debug("pDevice->byRFType = %x\n", pDevice->byRFType);
-
 	if (!pDevice->bZoneRegExist)
 		pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
 
@@ -1780,6 +1770,12 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	MACvInitialize(priv->PortOffset);
 	MACvReadEtherAddress(priv->PortOffset, priv->abyCurrentNetAddr);
 
+	/* Get RFType */
+	priv->byRFType = SROMbyReadEmbedded(priv->PortOffset, EEP_OFS_RFTYPE);
+	priv->byRFType &= RF_MASK;
+
+	dev_dbg(&pcid->dev, "RF Type = %x\n", priv->byRFType);
+
 	device_get_options(priv);
 	device_set_options(priv);
 	/* Mask out the options cannot be set to the chip */
-- 
2.1.0

