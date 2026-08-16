Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86FE3CC303
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 06:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786861537; cv=none; b=OGRTlazPdfrWsGwlI3Q2GoIDnwF8y387+36l+AhD5BMhpvG1QarSosEISsKthuBxYuS0hqLd8OsObG8jXbGkv+y0VN3hL4jJDLQTGg2UkJ5L8EcIRT42FN+wMvM6Bg8QIi5v/CazGJRM7uy/daNHMi1TAAJ6+HRjUl80vLV/+98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786861537; c=relaxed/simple;
	bh=2wV8IIgCHWrUm3bq9AvfjyaE3lZ1nFLWkPxf3A5I0KA=;
	h=From:Date:Message-ID:To:Cc:Subject:Content-Type:MIME-Version; b=Rez/hRiWti6IO1wjjJjOpUet/PrH4JmpPxSbMl2SIPLavs9b4eTxJAi+Wlbvgupayp5TodL8+sxhbh7KfKuL7b5kdte3c73DzBIkKgX8EbbOwzOVap0w/7Te0GhKKd5UIoTw8VN/ByhmmFTWuxPweq2lyW+jbWYJshZbnaEMQyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maxengel.com; spf=pass smtp.mailfrom=maxengel.com; dkim=pass (2048-bit key) header.d=maxengel.com header.i=@maxengel.com header.b=pxQp1MTF; arc=none smtp.client-ip=79.135.106.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maxengel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maxengel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maxengel.com header.i=@maxengel.com header.b="pxQp1MTF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxengel.com;
	s=protonmail3; t=1786861524; x=1787120724;
	bh=d10zNDVZ3yGcgDm6yMZneJ6r5uLza/tMnOQK3/ZXxYw=;
	h=From:Date:Message-ID:To:Cc:Subject:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=pxQp1MTFQn3XuutFfyCp66ulZR4DcCHSObvRB4ZJ2xfhir2y3iHZcIx4SOBm5IUaV
	 XPLb/XWUI0DD8zmD4+od5P8KipbDLMtJ676Iy2Fzp+Rwn2eLHFu+/Jcv/v/TwCfSLV
	 0bD+V050Drq1zHxWfQD3XcMMmOHl7h0rdIHHMGT6YdqTTR5WBWT0GQOlvdXe54AXQD
	 nRyxXTxKvXuk2D7cSVVcLmV4IfxWLKTMnkcx53HZktgJB8wCnxOS5Av6VHZ3/JTV44
	 SC6SOzca2dkMEb2JTy5NOV7Zido5uFQlundRGaaRTsqw/IOtL2Fid4rFTpzhjBXfv+
	 TbRZt4hYE6EPg==
X-Pm-Submission-Id: 4hN5YZ4pJTz1DDs6
From: Max Engel <dev@maxengel.com>
Date: Sun, 16 Aug 2026 06:25:20 +0000
Message-ID: <178686152030.336421.12015467912819395181@maxengel.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] wifi: brcmfmac: schedule bus reset when the device is
 unresponsive after wake
Content-Type: text/plain; charset="utf-8"
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
interrupt (HMB_DATA_FWHALT) - which a chip that is off the bus can never
deliver. Schedule the same worker from the KSO wake path when the
failure is conclusive: wake direction, retries exhausted, and the CSR
reading back all-ones.

Repeated failures are harmless: schedule_work() on an already-queued
work item is a no-op, and the reset tears down and re-probes the device.

Field reports of the same class of wedge exist beyond this board
(PNDeb/pinenote-debian-image#105; openwrt#23069 explicitly requests a
host-triggered reset path).

Signed-off-by: Max Engel <dev@maxengel.com>
---
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -770,6 +770,28 @@
 	if (try_cnt > MAX_KSO_ATTEMPTS)
 		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
+	/* A wake attempt that gives up (whether by exhausting the KSO
+	 * retries or by bailing out on consecutive access errors) with the
+	 * sleep CSR reading back all-ones means the device has dropped off
+	 * the bus entirely, e.g. it lost state across a system suspend
+	 * despite keep-power-in-suspend (observed on CYW43455/BCM4345C0 on
+	 * rk3566). No in-band recovery is possible: the interface is gone
+	 * and a module reload fails to re-probe (-ETIMEDOUT on every
+	 * function). The bus reset worker already performs the only known
+	 * remedy (mmc_hw_reset -> pwrseq WL_REG_ON power cycle), but its
+	 * sole SDIO trigger is the firmware-halt mailbox interrupt, which
+	 * a chip that is off the bus can never deliver. Schedule it from
+	 * here instead.
+	 */
+	if (on && err && rd_val == 0xff) {
+		struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
+
+		if (drvr && drvr->bus_reset.func) {
+			brcmf_err("device unresponsive after wake, scheduling bus reset\n");
+			schedule_work(&drvr->bus_reset);
+		}
+	}
+
 	if (on)
 		sdio_retune_release(bus->sdiodev->func1);
 
