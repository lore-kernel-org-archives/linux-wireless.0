Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1D7426438
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 05:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792302959; cv=none; b=fHKLFOCOfQrEq+9GjyDJ68miDennqb5mwMKsSdzGey7v25moR35GGuaCWMPEPTI8navCb5cXyef/ISHJsMIP/mU7aCeu6b4dIfM+a9+rcID8zW1aJajPCBDH6qxSjSTDyBdv5GBb7Fn1snaB73wsgVb1iN9723Zy6jEU9ULurmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792302959; c=relaxed/simple;
	bh=ya8LKZ3R57YBWc+ME9AgGAmjnVu0K/pc6XFf59KU4S4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hWFgGbm8qahF4MZiFahrkN4gBX0kc+27MgnNfgBEZY+eGW5S+HTC04TASlIenGAUuBPmel/RXtDO+YTsMdZQGAIt6yplmdjfIWaCodmg3Pnc8DT+e5uMSusuk5ZyRP/IvYQkpGM1tf2y+bjzk4NTt3JYYgsiUkojnpc/uGKPrPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maxengel.com; spf=pass smtp.mailfrom=maxengel.com; dkim=pass (2048-bit key) header.d=maxengel.com header.i=@maxengel.com header.b=NCscWb9e; arc=none smtp.client-ip=109.224.244.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maxengel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maxengel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maxengel.com header.i=@maxengel.com header.b="NCscWb9e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxengel.com;
	s=protonmail3; t=1792302946; x=1792562146;
	bh=XxRuoJOTWg0KFcCIhdiVIDhwWULZPDK8+uoiZqrNDc8=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NCscWb9eh7z23kQdVTfSONpeUCSFezvJWxyKWlLEsRYwjss0gVWSkbfQVf/Ed8qPM
	 QkjvNIYujdSXv70vUHmxfQcuSwjAOEyafskeWyWDj4N4qL8eH1FenFL1nH3MvqUeXh
	 TAVpKPgOC6/ZC3vxlwGdvzH5FA4U9JGcIoIR7cf3x4nbmhajS7Rz2ytoKD9qBinkrl
	 ebf6KDSKSTk5/EoX36rqQZlA8tYgj0wGKZjUidwOzbrSu+WzSi30p+XGkNdidObNGb
	 4+vEnAKsodUDHeiVxFL9m1rH0UwDrv4MAXaPdaIt8/OBCklqgyAPAhZkVAQp0NJ4Tx
	 1z8Pxzzd36rFg==
X-Pm-Submission-Id: 4j6nwJ3r0Qz2ScQL
From: Max Engel <dev@maxengel.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2] wifi: brcmfmac: request bus reset when the device is
 unresponsive after wake
Date: Sun, 18 Oct 2026 05:55:42 +0000
Message-ID: <179230294232.2815959.4255945147086159884@maxengel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On the PINE64 PineNote (CYW43455 / BCM4345C0 on an rk3566 SDIO bus,
keep-power-in-suspend), the chip intermittently loses all state across a
system suspend: the suspend-entry KSO write succeeds cleanly, but at the
first post-resume wake attempt every SLEEPCSR read returns 0xff
(all-ones, i.e. the device is electrically absent from the bus) and KSO
retries exhaust with -ETIMEDOUT. From there the driver limps (halting
operation after repeated backplane failures), the interface never
recovers, and a module reload fails to re-probe all three SDIO
functions. The only working in-kernel remedy is the existing bus reset
worker (mmc_hw_reset -> pwrseq WL_REG_ON power cycle), measured on this
hardware to recover the device in ~7 s without a reboot.

That worker's only SDIO trigger today is the firmware-halt mailbox
interrupt (HMB_DATA_FWHALT), which a chip that is off the bus can never
deliver. Request the same reset from the KSO wake path when the failure
is conclusive: wake direction, the wait given up with an error, and the
CSR reading back all-ones.

Request it through brcmf_fw_crashed(), the common entry point, so it
takes the same path as the firmware-halt case, including the
serialization against teardown in brcmf_bus_schedule_reset(). The
coredump brcmf_fw_crashed() takes cannot succeed over a dead bus, so add
a coredump argument and pass false from this caller. The existing
callers pass true and behave as before.

Repeated failures are harmless: scheduling an already-queued work item
is a no-op, and the reset tears down and re-probes the device.

Field reports of the same class of wedge exist beyond this board
(PNDeb/pinenote-debian-image#105; openwrt#23069 explicitly requests a
host-triggered reset path).

Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Max Engel <dev@maxengel.com>
---
v2:
- Request the reset through brcmf_fw_crashed() instead of reaching into
  drvr from sdio.c, with a new coredump argument so this caller can skip
  the coredump, which cannot succeed over a dead bus (Arend).
- Rebased onto wireless-next, where scheduling the reset goes through
  brcmf_bus_schedule_reset().
- Testing: v2 is compile-tested on wireless-next. The detection and the
  reset it triggers are unchanged from v1, which recovered two
  post-suspend wedges on the PineNote without a reboot; only the way the
  reset is requested differs.
- Drafted with an AI coding assistant (Claude) from v1 and Arend's
  review, then reviewed by me; hence the Assisted-by tag. v1 was
  prepared with the same assistant and should have carried the tag too.

v1: https://lore.kernel.org/linux-wireless/178686152030.336421.12015467912819395181@maxengel.com/

 .../wireless/broadcom/brcm80211/brcmfmac/bus.h   |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c  |  5 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c  |  4 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 16 +++++++++++++++-
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 9371c14..71d781b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -313,7 +313,7 @@ void brcmf_dev_reset(struct device *dev);
 /* Request from bus module to initiate a coredump */
 void brcmf_dev_coredump(struct device *dev);
 /* Indication that firmware has halted or crashed */
-void brcmf_fw_crashed(struct device *dev);
+void brcmf_fw_crashed(struct device *dev, bool coredump);
 
 /* Configure the "global" bus state used by upper layers */
 void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 92ec269..00b674a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1445,7 +1445,7 @@ void brcmf_dev_coredump(struct device *dev)
 		brcmf_dbg(TRACE, "failed to create coredump\n");
 }
 
-void brcmf_fw_crashed(struct device *dev)
+void brcmf_fw_crashed(struct device *dev, bool coredump)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr;
@@ -1462,7 +1462,8 @@ void brcmf_fw_crashed(struct device *dev)
 
 	bphy_err(drvr, "Firmware has halted or crashed\n");
 
-	brcmf_dev_coredump(dev);
+	if (coredump)
+		brcmf_dev_coredump(dev);
 
 	brcmf_bus_schedule_reset(bus_if);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 17bae04..f8dc10f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -827,7 +827,7 @@ static void brcmf_pcie_handle_mb_data(struct brcmf_pciedev_info *devinfo)
 	}
 	if (dtoh_mb_data & BRCMF_D2H_DEV_FWHALT) {
 		brcmf_dbg(PCIE, "D2H_MB_DATA: FW HALT\n");
-		brcmf_fw_crashed(&devinfo->pdev->dev);
+		brcmf_fw_crashed(&devinfo->pdev->dev, true);
 	}
 }
 
@@ -2230,7 +2230,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 fail:
 	brcmf_err(bus, "Dongle setup failed\n");
 	brcmf_pcie_bus_console_read(devinfo, true);
-	brcmf_fw_crashed(dev);
+	brcmf_fw_crashed(dev, true);
 	device_release_driver(dev);
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index cea52d4..d97d630 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -771,6 +771,20 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 	if (try_cnt > MAX_KSO_ATTEMPTS)
 		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
+	/* A wake attempt that gives up, by exhausting the KSO retries or by
+	 * bailing out on consecutive access errors, with the sleep CSR
+	 * reading back all-ones means the device has dropped off the bus,
+	 * e.g. it lost state across a system suspend despite
+	 * keep-power-in-suspend. No in-band recovery is possible. Request
+	 * the bus reset the firmware-halt path uses, which a device that is
+	 * off the bus can never signal itself. Skip the coredump: it cannot
+	 * succeed over a dead bus.
+	 */
+	if (on && err && rd_val == 0xff) {
+		brcmf_err("device unresponsive after wake, requesting bus reset\n");
+		brcmf_fw_crashed(&bus->sdiodev->func1->dev, false);
+	}
+
 	if (on)
 		sdio_retune_release(bus->sdiodev->func1);
 
@@ -1131,7 +1145,7 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 	/* dongle indicates the firmware has halted/crashed */
 	if (hmb_data & HMB_DATA_FWHALT) {
 		brcmf_dbg(SDIO, "mailbox indicates firmware halted\n");
-		brcmf_fw_crashed(&sdiod->func1->dev);
+		brcmf_fw_crashed(&sdiod->func1->dev, true);
 	}
 
 	/* Dongle recomposed rx frames, accept them again */
base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.53.0
