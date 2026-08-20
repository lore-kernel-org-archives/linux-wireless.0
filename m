Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DC51D89EF;
	Thu, 20 Aug 2026 00:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787186009; cv=none; b=HeP+FNebchAuYorUttnhG6hMcR9JJlfyA5DwOHmTsS0M0gNQtj+yyLSM9A/LX886BtnBxQ1vmP4918OZXIzi6gHQWxm2wio/McbJBNiuIVWIH2x1cBmr/aGpPfxahZ7kLPRdq0qSYmZr5iIuMdPPH9X9x8VI6YW0EiPPR0j8YfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787186009; c=relaxed/simple;
	bh=QAgLnNDiDXzjjZEQUqAZ7Pqs8CybStHSJ/BO7LhFx1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CN9rVBbWGQBt+bm/hwW3O11Ku9xk5XSSPeJgCeBLNyUgm6RttM718eSGn7R6zGiGh3FeXgWSP2CGWmuGzXxFBnyhfT+lb+dtWOIGeGEKcITe/ZRYad4rNXYyB1IG0EU6jG0SkV6N96y+bzZA6dQQaUm5/0SnphknLkmml4wB7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wwqij-000000007Dx-195i;
	Thu, 20 Aug 2026 00:33:25 +0000
Date: Thu, 20 Aug 2026 01:33:22 +0100
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
Subject: [PATCH v2 4/4] Bluetooth: btintel_pcie: use
 device_schedule_reprobe() after reset
Message-ID: <be8fcc664be90ea28b2ce580e146c5fc96499fb4.1787185594.git.daniel@makrotopia.org>
References: <cover.1787185594.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1787185594.git.daniel@makrotopia.org>

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
  synchronizes the IRQs before the reset, the coredump worker stays
  disabled (disable count >= 1) until .remove(), rx_work is flushed,
  and the freshly reset device raises no traffic until the next probe
  re-initialises it. The same exposure already exists today in the
  window between pci_try_reset_function() and the synchronous
  re-probe; the conversion only lengthens it.

- work disable counts: the success-path contract is unchanged in
  substance. The reset work's disable_work_sync() call stays
  unbalanced on success, .remove() disables again, and the fresh
  probe re-INIT_WORKs the coredump worker with disable count 0.

pci_lock_rescan_remove() now only covers the reset itself, no longer
the re-probe. Hot-removal between the reset and the deferred re-probe
is handled by the helper's dead-device check.

If scheduling the re-probe fails in the FLR path, the error is
returned so the reset work re-enables the coredump worker, matching
the existing FLR failure handling; unlike before, 'data' is still
alive in that case. The PLDR path keeps logging only, as before.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/bluetooth/btintel_pcie.c | 51 +++++++++++++++++---------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 2b7231be5973..2bd318f0d36c 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -2582,7 +2582,7 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
 	 * BT needs pci_save_state()/pci_restore_state() because the BT driver
 	 * is still partially attached when the _PRR runs (it hasn't been unbound yet).
 	 * The PCI device needs to remain minimally functional so that
-	 * device_reprobe(&pdev->dev) can work afterward
+	 * the deferred re-probe of the BT device can work afterward
 	 */
 	ret = btintel_pcie_acpi_reset_method(data);
 
@@ -2593,14 +2593,16 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
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
@@ -2622,14 +2624,12 @@ static int btintel_pcie_perform_flr(struct btintel_pcie_data *data)
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
@@ -2657,11 +2657,15 @@ static void btintel_pcie_reset_work(struct work_struct *wk)
 
 	bt_dev_dbg(data->hdev, "Release bluetooth interface");
 
-	/* Both reset paths follow the same contract: on success they
-	 * destroy 'data' via device_reprobe() (a fresh probe re-INIT_WORKs
-	 * the coredump_work with disable count 0), so enable_work() must
-	 * NOT be called on the success path. Only the FLR path can fail
-	 * with 'data' still alive, in which case we balance the
+	/* Both reset paths follow the same contract: on success the
+	 * deferred re-probe scheduled with device_schedule_reprobe()
+	 * destroys 'data' by re-running .probe() (which re-INIT_WORKs the
+	 * coredump_work with disable count 0), so enable_work() must NOT
+	 * be called on the success path. 'data' stays alive until the
+	 * deferred detach runs; in this window new activity is fenced by
+	 * BTINTEL_PCIE_RECOVERY_IN_PROGRESS, the masked interrupts and the
+	 * disabled coredump_work. Only the FLR path can fail with no
+	 * re-probe scheduled, in which case we balance the
 	 * disable_work_sync() above so a later successful reset is not
 	 * permanently blocked.
 	 *
@@ -2941,19 +2945,18 @@ static void btintel_pcie_remove(struct pci_dev *pdev)
 	}
 
 	/* Permanently block coredump triggers and drain the worker before
-	 * tearing down. Must run before cancel_work_sync(&reset_work) so
+	 * tearing down. Must run before disable_work_sync(&reset_work) so
 	 * the disable counter stays >= 1 even after reset_work()'s
 	 * balanced enable_work() (counter 2 -> 1, never reaching 0).
 	 */
 	disable_work_sync(&data->coredump_work);
 
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
