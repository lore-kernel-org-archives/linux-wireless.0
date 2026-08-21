Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E673624C5;
	Fri, 21 Aug 2026 03:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281745; cv=none; b=CNKeaq8ec1GG1BigFx8C6wNo4sPeC4e0EZzejmWS3ETCK0qbfxtjHd+lbgFDMXQWrwCwidregyO8xmDZ9TnlTSOF9YxNdEn9bcgEUkRNv5p7X/8UPjMxVRw65fFpUTeKM3WzoMUhH/wSicFGTyRJK+g8jmcIyedzOjGl3Unt8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281745; c=relaxed/simple;
	bh=G+mG2/kDQLIbjH/ympSUi/zNtcvx2RTFCSQDiqJo8J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cNvdDpJ1nhXU9KVCItfeXoc4oQEKtv9RHcWQfwFBbzPMFBv2Nut0FJz4VIXBxBe0JCdf0x5Dzwnx3ImcQbRoxT+1qeHM+nFbMvYUHz6FX+JtjmPTjB8XDyEBMTUAOw4RtAKg4bvmlvxQuCNLAoK0EDM9KBKNvwe0tWYybZ3PiV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wxFcr-000000005Uf-17pl;
	Fri, 21 Aug 2026 03:09:01 +0000
Date: Fri, 21 Aug 2026 04:08:58 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: [PATCH v3 4/4] Bluetooth: btintel_pcie: use
 device_schedule_reprobe() after reset
Message-ID: <3f190c8e1644d0b9c86c6c0d2bfca952b7eb7026.1787281239.git.daniel@makrotopia.org>
References: <cover.1787281239.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787281239.git.daniel@makrotopia.org>

btintel_pcie re-probes its own device synchronously from its own reset
work via device_reprobe(), both after an FLR and after an ACPI PLDR.
The synchronous call runs .remove() from inside the reset work, which
requires a hand-rolled correctness contract spanning several comments:
.remove() must skip draining the very reset work it is running from
(the current_work() check), the reset must use pci_try_reset_function()
to dodge a device_lock ABBA against .remove(), and both reset paths
must not touch 'data' after the reprobe call because .remove() has
freed it.

Convert the two BT self re-probes to device_schedule_reprobe(). The
driver core's builtin work item now triggers .remove(), never the
reset work itself, so the current_work() check in .remove() is dead
and is removed: disable_work_sync(&data->reset_work) now also
guarantees the reset work has fully returned before 'data' is freed.
The Wi-Fi sibling re-probe in the PLDR path is left untouched; the
sibling is a different device re-probed from a bounded context and has
neither of the bug classes the helper addresses.

Safety of the window between the reset work returning and the deferred
detach running, during which 'data' now stays alive:

- hci callbacks: send_frame fails with -ENODEV while
  BTINTEL_PCIE_RECOVERY_IN_PROGRESS is set, and that bit is only
  cleared by a fresh probe. New reset requests coalesce into the
  in-flight one via the same bit. open/close are no-ops.

- interrupts: the reset work masks all interrupt causes and
  synchronizes the IRQs before the reset, the dump workers stay
  disabled (disable count >= 1) until .remove(), rx_work is flushed,
  and the freshly reset device raises no traffic until the next probe
  re-initialises it. The same exposure already exists today in the
  window between pci_try_reset_function() and the synchronous
  re-probe; the conversion only lengthens it.

- work disable counts: the success-path contract is unchanged in
  substance. The reset work's disable_work_sync() calls stay
  unbalanced on success, .remove() disables again, and the fresh
  probe re-INIT_WORKs the dump workers with disable count 0.

pci_lock_rescan_remove() now only covers the reset itself, no longer
the re-probe. Hot-removal between the reset and the deferred re-probe
is handled by the helper's dead-device check.

If scheduling the re-probe fails in the FLR path, the error is
returned so the reset work re-enables the dump workers, matching the
existing FLR failure handling; unlike before, 'data' is still alive
in that case. The PLDR path keeps logging only, as before.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v3: rebased onto bluetooth-next, whose btintel_pcie has four dump
    workers (coredump/hwexp/fwtrigger/mbox) rather than the single one
    the mainline snapshot v2 targeted
v2: reconciled to the current tree and adapted the commit message
v1: initial RFC

 drivers/bluetooth/btintel_pcie.c | 49 +++++++++++++++++---------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index baa621b3fef9..29be05d41429 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -3012,7 +3012,7 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
 	 * BT needs pci_save_state()/pci_restore_state() because the BT driver
 	 * is still partially attached when the _PRR runs (it hasn't been unbound yet).
 	 * The PCI device needs to remain minimally functional so that
-	 * device_reprobe(&pdev->dev) can work afterward
+	 * the deferred re-probe of the BT device can work afterward
 	 */
 	ret = btintel_pcie_acpi_reset_method(data);
 
@@ -3023,14 +3023,16 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
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
@@ -3052,14 +3054,12 @@ static int btintel_pcie_perform_flr(struct btintel_pcie_data *data)
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
@@ -3090,11 +3090,15 @@ static void btintel_pcie_reset_work(struct work_struct *wk)
 
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
@@ -3460,13 +3464,12 @@ static void btintel_pcie_remove(struct pci_dev *pdev)
 	disable_work_sync(&data->fwtrigger_work);
 	disable_work_sync(&data->mbox_work);
 
-	/* Cancel pending reset work. Skip only when remove() is called from
-	 * within the reset work itself (PLDR device_reprobe path) to avoid
-	 * deadlock. current_work() returns the work_struct of the caller if
-	 * we are in a workqueue context.
+	/* The deferred re-probe triggers .remove() from the driver core's
+	 * work item, never from reset_work itself, so this no longer runs
+	 * nested in reset_work; disable_work_sync() also guarantees the
+	 * reset work has fully returned before 'data' is freed.
 	 */
-	if (current_work() != &data->reset_work)
-		disable_work_sync(&data->reset_work);
+	disable_work_sync(&data->reset_work);
 
 	btintel_pcie_disable_interrupts(data);
 
-- 
2.55.0
