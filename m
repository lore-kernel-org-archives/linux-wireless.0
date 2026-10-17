Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06FA3AFAEA;
	Sat, 17 Oct 2026 08:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792227445; cv=none; b=hiVFVSx4r2sKg+RB2p5T2cwJaxuzgzXS6PAguIad4a9tG66fSY4gknBT2qcGKAnoBH/rJZ0NgVLk6XcJLOOlhfsMAKlHlFjp2EB+lHfDQ+QPuc82eIuwpZ39kyRT0ZTPNr9dipJ7ZA74ExalVoKgCTdE4q5XayYTpEeP6ypv9NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792227445; c=relaxed/simple;
	bh=pJ6eE0bFpMf4TDfDWs3yMeobveFrhNmmkJGNDG5Wveg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXH4Yt2W/NVOwC6OW/OFMmTdp/Ph3aLvr27zd7mQcKmDd0rBOCF5PLj9M1O431PTlQz4LkWNAQMYmSdQnL2Qb+mffIFyxyyh0SUvqTt60VRruhIXNhvfqlork4KjNQpyX7HVSoy2YpEJeiPEWjGmW8TuSSOOB6y2ATC90YC05h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1xI0EC-000000004Ho-19Bj;
	Sat, 17 Oct 2026 08:57:20 +0000
Date: Sat, 17 Oct 2026 09:57:17 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Hans de Goede <hansg@kernel.org>, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 4/4] Bluetooth: btintel_pcie: use
 device_schedule_reprobe() after reset
Message-ID: <9b078a64d003e63c617e8df41118f4ebde89aa2e.1792203271.git.daniel@makrotopia.org>
References: <cover.1792203271.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1792203271.git.daniel@makrotopia.org>

The reset work re-probes its own device with device_reprobe() after an
FLR or a PLDR, so .remove() runs inside it. That needs the
current_work() check in .remove(), and 'data' must not be touched
after the call.

Schedule the re-probe with device_schedule_reprobe(). .remove() then
runs from the driver core's work, the current_work() check goes, and
disable_work_sync(&data->reset_work) waits for the reset work before
'data' is freed. Until the deferred detach 'data' stays alive but idle:
RECOVERY_IN_PROGRESS fails send_frame and coalesces further resets,
interrupts are masked, and the dump and rfkill workers stay disabled.
If scheduling fails in the FLR path, the reset work re-enables them as
on any FLR failure. The PLDR re-probe of the Wi-Fi sibling, a
different device, is unchanged.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: rebased onto bluetooth-next for its hardware rfkill work; commit
    message updated for the reworked helper
v3: rebased onto bluetooth-next, whose btintel_pcie has four dump
    workers (coredump/hwexp/fwtrigger/mbox) rather than the single one
    the mainline snapshot v2 targeted
v2: reconciled to the current tree and adapted the commit message
v1: initial RFC

 drivers/bluetooth/btintel_pcie.c | 47 ++++++++++++++++----------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index df95d16a163c8..9f65eb0ceb0b2 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -4093,7 +4093,7 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
 	 * BT needs pci_save_state()/pci_restore_state() because the BT driver
 	 * is still partially attached when the _PRR runs (it hasn't been unbound yet).
 	 * The PCI device needs to remain minimally functional so that
-	 * device_reprobe(&pdev->dev) can work afterward
+	 * the deferred re-probe of the BT device can work afterward
 	 */
 	ret = btintel_pcie_acpi_reset_method(data);
 
@@ -4104,14 +4104,16 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
 	}
 
 	if (!ret) {
-		if (device_reprobe(&pdev->dev))
-			BT_ERR("BT reprobe failed for BDF:%s", pci_name(pdev));
+		if (device_schedule_reprobe(&pdev->dev, 0))
+			BT_ERR("BT reprobe scheduling failed for BDF:%s",
+			       pci_name(pdev));
 	}
 }
 
 /*
- * Issue a Function Level Reset and hand teardown/re-init off to the PCI
- * core via device_reprobe(), mirroring the PLDR path's contract.
+ * Issue a Function Level Reset and hand teardown/re-init off to the
+ * driver core via device_schedule_reprobe(), mirroring the PLDR path's
+ * contract.
  *
  * Caller must hold pci_lock_rescan_remove() and must have already
  * disabled interrupts and drained both rx_work and coredump_work.
@@ -4133,14 +4135,12 @@ static int btintel_pcie_perform_flr(struct btintel_pcie_data *data)
 		return err;
 	}
 
-	/* device_reprobe() always detaches the driver first (running
-	 * .remove(), which frees 'data'); any re-probe failure leaves the
-	 * device unbound but 'data' is already gone, so just log it.
-	 */
-	if (device_reprobe(&pdev->dev))
-		BT_ERR("BT reprobe failed for BDF:%s", pci_name(pdev));
+	err = device_schedule_reprobe(&pdev->dev, 0);
+	if (err)
+		BT_ERR("BT reprobe scheduling failed for BDF:%s",
+		       pci_name(pdev));
 
-	return 0;
+	return err;
 }
 
 static void btintel_pcie_reset_work(struct work_struct *wk)
@@ -4173,11 +4173,15 @@ static void btintel_pcie_reset_work(struct work_struct *wk)
 	disable_work_sync(&data->mbox_work);
 	bt_dev_dbg(data->hdev, "Release bluetooth interface");
 
-	/* Both reset paths follow the same contract: on success they
-	 * destroy 'data' via device_reprobe() (a fresh probe re-INIT_WORKs
-	 * the dump workers with disable count 0), so enable_work() must
-	 * NOT be called on the success path. Only the FLR path can fail
-	 * with 'data' still alive, in which case we balance the
+	/* Both reset paths follow the same contract: on success the
+	 * deferred re-probe scheduled with device_schedule_reprobe()
+	 * destroys 'data' by re-running .probe() (which re-INIT_WORKs the
+	 * dump workers with disable count 0), so enable_work() must NOT be
+	 * called on the success path. 'data' stays alive until the deferred
+	 * detach runs; in this window new activity is fenced by
+	 * BTINTEL_PCIE_RECOVERY_IN_PROGRESS, the masked interrupts and the
+	 * disabled dump workers. Only the FLR path can fail with no
+	 * re-probe scheduled, in which case we balance the
 	 * disable_work_sync() calls above so a later successful reset is
 	 * not permanently blocked.
 	 *
@@ -4598,13 +4602,8 @@ static void btintel_pcie_remove(struct pci_dev *pdev)
 	disable_work_sync(&data->fwtrigger_work);
 	disable_work_sync(&data->mbox_work);
 
-	/* Cancel pending reset work. Skip only when remove() is called from
-	 * within the reset work itself (PLDR device_reprobe path) to avoid
-	 * deadlock. current_work() returns the work_struct of the caller if
-	 * we are in a workqueue context.
-	 */
-	if (current_work() != &data->reset_work)
-		disable_work_sync(&data->reset_work);
+	/* reset_work may still be running after scheduling the re-probe. */
+	disable_work_sync(&data->reset_work);
 
 	btintel_pcie_mask_hw_rfkill(data);
 	btintel_pcie_synchronize_irqs(data);
-- 
2.56.0
