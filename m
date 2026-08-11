Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1D72DB788;
	Tue, 11 Aug 2026 00:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786409430; cv=none; b=Jna0eddPsq4ohJs1zRNZORK5fZgps2Yww3A25y4gQSbqiSDXF/kfGH+OxMiHu0CI29XSzVc2G7CGEztYsRgYT0e29uLlij+vXuPzHnBiD4jOPmqG0XqeTdD97BHjoUs2AOwqhcTiA5Ke65ScMHfRLbYqbN4USQDjcTS9CrIH3X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786409430; c=relaxed/simple;
	bh=Okj9DNeUzdOdzTd2wwQTc4c2e6I5H3eHiKM1120lciM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Yu+1aK+5bi6g48E4OnynA+Xsm7SrgEPXDI2ubftlBsPcLcRM2w7Bj7/Ge6eZVRGCNl2k6Hjq9kvz+XSOnDTOyplbqLBkzqlGdlO4P+zUpBAC1f2c72QBJMNEHIJfln6ccXmUvkP2VQzqPpaIRTDsm1vUjt1DpRrwjmHD/nmpMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wtahA-000000001MG-1U9I;
	Tue, 11 Aug 2026 00:50:22 +0000
Date: Tue, 11 Aug 2026 01:49:54 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, driver-core@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: [RFC PATCH 4/4] Bluetooth: btintel_pcie: use
 device_schedule_reprobe() after reset
Message-ID: <anpxsvOTKb1i3OV6@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

btintel_pcie re-probes its own device synchronously from its own reset
work via device_reprobe(), both after an FLR and after an ACPI PLDR.
The synchronous call runs .remove() from inside the reset work, which
requires a hand-rolled correctness contract spanning several comments:
.remove() must skip draining the very reset work it is running from
(the current_work() check), the reset must use pci_try_reset_function()
to dodge a device_lock ABBA against .remove(), and both reset paths
must not touch 'data' after the reprobe call because .remove() has
freed it.

Convert the two self re-probes to device_schedule_reprobe(). The
driver core's builtin work item now triggers .remove(), never the
reset work itself, so the current_work() check in .remove() is dead
and is removed: disable_work_sync(&data->reset_work) now also
guarantees the reset work has fully returned before 'data' is freed.
The Wi-Fi sibling handling in the PLDR path is left untouched; the
sibling is a different device re-probed from a bounded context and has
neither of the bug classes the helper addresses.

Safety of the window between the reset work returning and the deferred
detach running, during which 'data' now stays alive:

- hci callbacks: send_frame fails with -ENODEV while
  BTINTEL_PCIE_RECOVERY_IN_PROGRESS is set, and that bit is only
  cleared by a fresh probe. New reset requests coalesce into the
  in-flight one via the same bit. open/close are no-ops.

- interrupts: the reset work masks all interrupt causes and calls
  synchronize_irq() before the reset, the dump workers stay disabled
  (disable count >= 1) until .remove(), and the freshly reset device
  raises no traffic until the next probe re-initializes it. The same
  exposure already exists today in the window between
  pci_try_reset_function() and the synchronous re-probe; the
  conversion only lengthens it.

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
 drivers/bluetooth/btintel_pcie.c | 48 +++++++++++++++-----------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 005c77a4f5eb..16ed19c2d359 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -2641,7 +2641,7 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
 	 * BT needs pci_save_state()/pci_restore_state() because the BT driver
 	 * is still partially attached when the _PRR runs (it hasn't been unbound yet).
 	 * The PCI device needs to remain minimally functional so that
-	 * device_reprobe(&pdev->dev) can work afterward
+	 * the deferred re-probe of the BT device can work afterward
 	 */
 	ret = btintel_pcie_acpi_reset_method(data);
 
@@ -2652,14 +2652,16 @@ static void btintel_pcie_perform_pldr(struct btintel_pcie_data *data)
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
@@ -2681,14 +2683,12 @@ static int btintel_pcie_perform_flr(struct btintel_pcie_data *data)
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
@@ -2718,11 +2718,15 @@ static void btintel_pcie_reset_work(struct work_struct *wk)
 
 	bt_dev_dbg(data->hdev, "Release bluetooth interface");
 
-	/* Both reset paths follow the same contract: on success they
-	 * destroy 'data' via device_reprobe() (a fresh probe re-INIT_WORKs
-	 * the dump workers with disable count 0), so enable_work() must
-	 * NOT be called on the success path. Only the FLR path can fail
-	 * with 'data' still alive, in which case we balance the
+	/* Both reset paths follow the same contract: on success the
+	 * deferred re-probe scheduled with device_schedule_reprobe()
+	 * destroys 'data' by re-running .probe() (which re-INIT_WORKs the
+	 * dump workers with disable count 0), so enable_work() must NOT
+	 * be called on the success path. 'data' stays alive until the
+	 * deferred detach runs; in this window new activity is fenced by
+	 * BTINTEL_PCIE_RECOVERY_IN_PROGRESS, the masked interrupts and
+	 * the disabled dump workers. Only the FLR path can fail with no
+	 * re-probe scheduled, in which case we balance the
 	 * disable_work_sync() calls above so a later successful reset is
 	 * not permanently blocked.
 	 *
@@ -2766,7 +2770,7 @@ static void btintel_pcie_reset_work(struct work_struct *wk)
  * The bit is cleared only by .remove() / re-probe via fresh devm
  * allocation, which is the intended one-shot semantics: a reset
  * tears down and re-probes 'data', so there is no "in-flight"
- * reset to follow up after device_reprobe() succeeds.
+ * reset to follow up after the deferred re-probe succeeds.
  */
 static void btintel_pcie_request_reset(struct btintel_pcie_data *data,
 				       enum btintel_pcie_reset_type type)
@@ -3082,13 +3086,7 @@ static void btintel_pcie_remove(struct pci_dev *pdev)
 	disable_work_sync(&data->hwexp_work);
 	disable_work_sync(&data->fwtrigger_work);
 
-	/* Cancel pending reset work. Skip only when remove() is called from
-	 * within the reset work itself (PLDR device_reprobe path) to avoid
-	 * deadlock. current_work() returns the work_struct of the caller if
-	 * we are in a workqueue context.
-	 */
-	if (current_work() != &data->reset_work)
-		disable_work_sync(&data->reset_work);
+	disable_work_sync(&data->reset_work);
 
 	btintel_pcie_disable_interrupts(data);
 
-- 
2.55.0
