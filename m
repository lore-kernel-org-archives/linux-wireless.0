Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9898043637C
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 21:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025507; cv=none; b=V2Hc6cMXNtPOG2iXKCGqTgUUTC5hoDUaVDYYSGro05yp3fDRx8ANMcnol58MBL/J7EHCdFAz8p/BqvkkL4YuEUfVEmma4z3MpmuBd01Vkaq5cmH+4I+XfUGtuiZgmPDdDhoJH20qHXnFwaCy3I3HHihfGXKpqZYTCdAYBpKM3fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025507; c=relaxed/simple;
	bh=Oun0DqHeCwMETcPaSb9KTb2AnAMwyMp483QiKREFRRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9Ri24xKIVVa0zWcDQdEXHQS40SCaPPexmjsjsga2neaBkzWn4GmvlkXvy3ggyz9uSW7XvNGTvS7odeOf/a+t9qLXWi2T7EIHmgxMfwwqyRG/qLfgEIp5baoTUKlRAlW99tj1uV3s/Tfx5QkNmhn3ME41nAV484RYsgfEyp7J5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com; spf=pass smtp.mailfrom=brivo.com; dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b=wZQIgc9K; arc=none smtp.client-ip=74.125.230.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b="wZQIgc9K"
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb769ca17so28484701cf.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 14:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brivo.com; s=google; t=1790025503; x=1790630303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DjId/0Cj6ytuS0j5VADmUPuYZXdk67Lnv48DskXuzJU=;
        b=wZQIgc9KzmhQpjkXcOgbgrdacaJZMqIkz6HxAJGaWo6iR2H2rL+cQBgKOhlWEgboWG
         tXAJpaiukpcAyMaYLnBRrkVBDpc0dSZ1WL5O2Tfdn4E9B4sZ27les9/R949NQ++Y1Z0I
         Ab6hib79/VasBsEQUuueRFVUqkx8lbhO5vh0WgondkgPDVe4GjsUJINb7uhzYu7JbJml
         QF3F6CYqAA6po6LwssoTLY04u5DFGRUZbPgzUdsYalCnswX8OXKgyn2F0iemy286Qz0y
         nkrJrNDgTAXApBFBzPGFjAJ2EhU31u+dzYLYwjnt+UKDmPLYYdAOSAdVaa28J1JNMOuF
         GLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790025503; x=1790630303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DjId/0Cj6ytuS0j5VADmUPuYZXdk67Lnv48DskXuzJU=;
        b=VYd8TwfrKTtHOt209xGuiC9x+5CNh2B5zqXUjibvqJyuTMwc0sImdPxKEfCVOXGUdD
         Q0QehL9cz1NGon1lNBs66m4zy+8bQSSIBpWFzHZcWqEo8Ak9gPNe9VqYWkRLp3Hg/DKE
         1Q6RefKbfnCCisQTlQVQ4r7qC4HJzvdLVY6iCNmxmpZE4iqXKZA21+KjfZlbTr+R2Xiu
         LFJFr7NCw/O1CpSiMHjdND4v9eN3U64E+alaLjPsNpKzgKErlGvow1lALjaWHqERDeyh
         4Qm1pzsMilC3Ouoaq/BxZKXJYLbmq5f5rMMtWn56TSjNSJf7xU89Zb9wXLHJs3DKmjdc
         gaDQ==
X-Forwarded-Encrypted: i=1; AKwUvBxh5uW206xfIO9wcVPm+v+rh44Km3WVcI5gjAMpq3BnQBaKlwAXBXFeNUw3loDK17QGgslMa5ypA7gUoB7J1w==@vger.kernel.org
X-Gm-Message-State: AFuF++mabgUeygMMssN4/w18JjvwzeWShklDhhDNB//rtkA9qCaM2412
	PmXYU2RWee3UF6DCtWAwCHECkWmHlsieAJ2CCGf2+Kvwa7tHj92xa6xD6b0eJ/hl+0yK52baAIT
	7LrMDZdW0ufQRi1dBSksl/yazrnsYC7GZq3S7KTomsw/L2ioamZf+MqQrc9tg8GDdVwXpiDrEYY
	KT6A==
X-Gm-Gg: AYBFou0FcHdlw0WuxaBvH1BFPe75mtynCpGM04kWTIGUpQ+pC2QgNvp5ZyTYAzExJBw
	9+f1grfKlnTFEfiSYtQvPTS/BIzyWCJXRwzTRUr3sCInavkDksFZSVX1pxR+w1wRp6p6fx2mQ2D
	PrYCrtnmti4TfoPYsNoSnDSMhuRF6Rx6+hMSN58G5oJhlQARNV8CDiwyo6iawL7K6dBY7oxpQW5
	VJA/3+YT+H5tuQWxVF92c8ta+8JJvlAuuD1ouQNmccDX81tWVndzEXfEv4GzW8PjEr+Nqp4vYPK
	IxVIjtw43CmPi6fFtKYkpknKLkN2IRL4Ev1IjfeiAkLf6bKQJbD2b2BPhx2QEwkT5R5DfV5b1yI
	FZ5bLwHdPDW219Hie+iTbpDjyZaqpbXIDPLVWgERtzqkOa/1zNsYEb+BuhcjvwbTbcjoV+ILPK5
	LCYphmDQf0+XszWXmzcC2YUhMIJaz4+pi9bm69v1w3JfG93rsEZzWLFmxPTxN6UtLu
X-Received: by 2002:ac8:5d15:0:b0:532:d5c5:8eae with SMTP id d75a77b69052e-532d8d47ff4mr26530271cf.27.1790025503159;
        Mon, 21 Sep 2026 14:18:23 -0700 (PDT)
Received: from strozzi ([66.193.28.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532df63ab0dsm267121cf.26.2026.09.21.14.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:18:22 -0700 (PDT)
From: Sean Anderson <sanderson@brivo.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	brcm80211@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	Sean Anderson <sanderson@brivo.com>,
	Franky Lin <franky.lin@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/4] wifi: brcmfmac: Fix firmware requests racing against SDIO removal
Date: Mon, 21 Sep 2026 17:18:14 -0400
Message-ID: <20260921211817.2432341-5-sanderson@brivo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921211817.2432341-1-sanderson@brivo.com>
References: <20260921211817.2432341-1-sanderson@brivo.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

brcmf_sdio_firmware_callback can race with device removal. If this
happens it can re-register IRQs, dereference NULL pointers, and cause
all sorts of havoc. Prevent this by canceling any outstanding firmware
request as the first step of the removal process.

When canceling the firmware request, we primarily need to ensure fwctx
remains valid for all our calls to request_firmware_nowait_cancel. If we
let it get free'd early then it could get re-used for some unrelated
firmware request. To avoid this, we follow the same pattern that
firmware_loader does. But while firmware_loader needs a spinlock, we can
get away with a single pointer:

- When ctxp is NULL, then we can't be canceled
- When *ctxp == fwctx, we're still alive
- When *ctxp == NULL, someone else has canceled the request (or we have
  run our natural course).
- Whoever clears ctxp is responsible for freeing fwctx.

There can be up to NR_CPUS requests in-flight at any given time, as each
(alt) firmware request can create a new firmware request. Eventually,
one of them will see that ctxp is cleared and stop spawning additional
requests.

If the firmware load fails while we are removing the device, we can no
longer attempt to call device_release_driver. This will deadlock. We
can't do this asynchronously either since we run the risk of releasing a
totally different driver/device combo. We could techincally do this by
dropping device_lock before waiting for the firmware to cancel, but that
seems like a major headache (we would need to make ctxp a separate
reference-counted allocation).

I also implemented this fix for PCIe but I have only build-tested it.
I didn't touch USB as it already uses a completion-based system to
determine when it's OK to remove the driver. I didn't go with this
approach because we could wait indefinitely for the firmware request to
complete (such as if the firmware is on a slow device or loaded by
userspace).

Fixes: bd0e1b1d380e ("brcmfmac: use asynchronous firmware request in SDIO")
Signed-off-by: Sean Anderson <sanderson@brivo.com>
---

 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  7 ++++-
 .../broadcom/brcm80211/brcmfmac/bus.h         |  2 ++
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 26 ++++++++++++++++---
 .../broadcom/brcm80211/brcmfmac/firmware.h    | 16 +++++++++++-
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 11 +++++---
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  8 +++---
 .../broadcom/brcm80211/brcmfmac/usb.c         |  6 +++--
 7 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 71c2f99cdb711..39916f5a699dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1126,7 +1126,12 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	if (bus_if) {
 		sdiodev = bus_if->bus_priv.sdio;
 
-		/* start by unregistering irqs */
+		/* Cancel any outstanding firmware request, as it may try to
+		 * call brcmf_sdiod_intr_register.
+		 */
+		brcmf_fw_cancel(sdiodev->dev, &bus_if->fwctx);
+
+		/* Now we can unregister irqs */
 		brcmf_sdiod_intr_unregister(sdiodev);
 
 		if (func->num != 1)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 9371c1489948c..81c17a8c235cc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -157,6 +157,7 @@ struct brcmf_bus_stats {
  * @chip: device identifier of the dongle chip.
  * @chiprev: revision of the dongle chip.
  * @fwvid: firmware vendor-support identifier of the device.
+ * @fwctx: firmware request cancellation context
  * @always_use_fws_queue: bus wants use queue also when fwsignal is inactive.
  * @wowl_supported: is wowl supported by bus driver.
  * @ops: callbacks for this bus instance.
@@ -178,6 +179,7 @@ struct brcmf_bus {
 	u32 chip;
 	u32 chiprev;
 	enum brcmf_fwvendor fwvid;
+	void *fwctx;
 	bool always_use_fws_queue;
 	bool wowl_supported;
 	bool removing;		/* device removal in progress; quiesce async work */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 22ff326f1924a..d1da65155e544 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -459,6 +459,7 @@ struct brcmf_fw {
 	u32 curpos;
 	unsigned int board_index;
 	void (*done)(struct device *dev, int err, struct brcmf_fw_request *req);
+	void **ctxp;
 };
 
 #ifdef CONFIG_EFI
@@ -693,7 +694,7 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 		fwctx->req = NULL;
 	}
 	fwctx->done(fwctx->dev, ret, fwctx->req);
-	kfree(fwctx);
+	kfree(xchg(fwctx->ctxp, NULL));
 }
 
 static void brcmf_fw_request_done_alt_path(const struct firmware *fw, void *ctx)
@@ -703,7 +704,7 @@ static void brcmf_fw_request_done_alt_path(const struct firmware *fw, void *ctx)
 	const char *board_type, *alt_path;
 	int ret = 0;
 
-	if (fw) {
+	if (fw || !READ_ONCE(*fwctx->ctxp)) {
 		brcmf_fw_request_done(fw, ctx);
 		return;
 	}
@@ -755,7 +756,8 @@ static bool brcmf_fw_request_is_valid(struct brcmf_fw_request *req)
 
 int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 			   void (*fw_cb)(struct device *dev, int err,
-					 struct brcmf_fw_request *req))
+					 struct brcmf_fw_request *req),
+			   void **ctxp)
 {
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
@@ -776,6 +778,8 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	fwctx->dev = dev;
 	fwctx->req = req;
 	fwctx->done = fw_cb;
+	fwctx->ctxp = ctxp;
+	WRITE_ONCE(*ctxp, fwctx);
 
 	/* First try alternative board-specific path if any */
 	if (fwctx->req->board_types[0])
@@ -799,6 +803,22 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	return 0;
 }
 
+void brcmf_fw_cancel(struct device *dev, void **ctxp)
+{
+	struct brcmf_fw *fwctx;
+
+	fwctx = xchg(ctxp, NULL);
+	if (!fwctx)
+		return;
+
+	/* Keep canceling requests until they see that we cleared ctxp */
+	while (request_firmware_nowait_cancel(dev, fwctx,
+					      brcmf_fw_request_done_alt_path))
+		;
+	request_firmware_nowait_cancel(dev, fwctx, brcmf_fw_request_done);
+	kfree(fwctx);
+}
+
 struct brcmf_fw_request *
 brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 		       const struct brcmf_firmware_mapping mapping_table[],
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 4002d326fd21b..932899d4086b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -87,9 +87,23 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
  * Request firmware(s) asynchronously. When the asynchronous request
  * fails it will not use the callback, but call device_release_driver()
  * instead which will call the driver .remove() callback.
+ *
+ * ctxp is a (pointer to an) opaque pointer that may be passed to
+ * brcmf_fw_cancel().
  */
 int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 			   void (*fw_cb)(struct device *dev, int err,
-					 struct brcmf_fw_request *req));
+					 struct brcmf_fw_request *req),
+			   void **ctxp);
+
+/**
+ * brcmf_fw_cancel() - Cancel an outstanding firmware request
+ * @dev: Device requesting the firmware
+ * @ctxp: Opaque context pointer filled in by brcmf_fw_get_firmwares()
+ *
+ * Cancel an outstanding firmware request identified by @dev and @ctxp, which
+ * should be the same as passed to brcmf_fw_get_firmwares().
+ */
+void brcmf_fw_cancel(struct device *dev, void **ctxp);
 
 #endif /* BRCMFMAC_FIRMWARE_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b970f28..9eae712b0d98c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1555,6 +1555,8 @@ static int brcmf_pcie_reset(struct device *dev)
 	struct brcmf_fw_request *fwreq;
 	int err;
 
+	brcmf_fw_cancel(dev, &bus_if->fwctx);
+
 	brcmf_pcie_intr_disable(devinfo);
 
 	brcmf_pcie_bus_console_read(devinfo, true);
@@ -1572,7 +1574,8 @@ static int brcmf_pcie_reset(struct device *dev)
 		return -ENOMEM;
 	}
 
-	err = brcmf_fw_get_firmwares(dev, fwreq, brcmf_pcie_setup);
+	err = brcmf_fw_get_firmwares(dev, fwreq, brcmf_pcie_setup,
+				     &bus_if->fwctx);
 	if (err) {
 		dev_err(dev, "Failed to prepare FW request\n");
 		kfree(fwreq);
@@ -2231,7 +2234,6 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	brcmf_err(bus, "Dongle setup failed\n");
 	brcmf_pcie_bus_console_read(devinfo, true);
 	brcmf_fw_crashed(dev);
-	device_release_driver(dev);
 }
 
 static struct brcmf_fw_request *
@@ -2554,7 +2556,8 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto fail_brcmf;
 	}
 
-	ret = brcmf_fw_get_firmwares(bus->dev, fwreq, brcmf_pcie_setup);
+	ret = brcmf_fw_get_firmwares(bus->dev, fwreq, brcmf_pcie_setup,
+				     &bus->fwctx);
 	if (ret < 0) {
 		kfree(fwreq);
 		goto fail_brcmf;
@@ -2595,6 +2598,8 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 	brcmf_pcie_bus_console_read(devinfo, false);
 	brcmf_pcie_fwcon_timer(devinfo, false);
 
+	brcmf_fw_cancel(bus->dev, &bus->fwctx);
+
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
 	if (devinfo->ci)
 		brcmf_pcie_intr_disable(devinfo);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 381801af3ac98..1c32fe5828a2f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4417,8 +4417,6 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	sdio_release_host(sdiod->func1);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
-	device_release_driver(&sdiod->func2->dev);
-	device_release_driver(dev);
 }
 
 static struct brcmf_fw_request *
@@ -4546,7 +4544,8 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	}
 
 	ret = brcmf_fw_get_firmwares(sdiodev->dev, fwreq,
-				     brcmf_sdio_firmware_callback);
+				     brcmf_sdio_firmware_callback,
+				     &sdiodev->bus_if->fwctx);
 	if (ret != 0) {
 		brcmf_err("async firmware request failed: %d\n", ret);
 		kfree(fwreq);
@@ -4581,6 +4580,9 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 			bus->watchdog_tsk = NULL;
 		}
 
+		brcmf_fw_cancel(bus->sdiodev->dev,
+				&bus->sdiodev->bus_if->fwctx);
+
 		/* De-register interrupt handler */
 		brcmf_sdiod_intr_unregister(bus->sdiodev);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index b41949a9bdc8e..e8c0db0c82689 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1306,7 +1306,8 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
 	}
 
 	/* request firmware here */
-	ret = brcmf_fw_get_firmwares(dev, fwreq, brcmf_usb_probe_phase2);
+	ret = brcmf_fw_get_firmwares(dev, fwreq, brcmf_usb_probe_phase2,
+				     &bus->fwctx);
 	if (ret) {
 		brcmf_err("firmware request failed: %d\n", ret);
 		kfree(fwreq);
@@ -1524,7 +1525,8 @@ static int brcmf_usb_reset_resume(struct usb_interface *intf)
 	if (!fwreq)
 		return -ENOMEM;
 
-	ret = brcmf_fw_get_firmwares(&usb->dev, fwreq, brcmf_usb_probe_phase2);
+	ret = brcmf_fw_get_firmwares(&usb->dev, fwreq, brcmf_usb_probe_phase2,
+				     &devinfo->bus_pub->bus->fwctx);
 	if (ret < 0)
 		kfree(fwreq);
 
-- 
2.53.0

