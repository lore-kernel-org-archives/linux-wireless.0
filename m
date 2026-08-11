Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AED52DFA4A;
	Tue, 11 Aug 2026 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786409390; cv=none; b=nADs/PmHnphqf+e/U4dPYn+G2JibFyGzOh5TCXLeq3DUdKH8ipKfgScLmEDO+xNjZDPRN5wus1GKLag6/YJbfSQV+g5OCLfkPpRuRKBg21bvvURuVBnnsSt2nTgnWjiiKL5FTX20YdmHw7pid0qr3vE4EFI4k2HVuhg3Hyi/d/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786409390; c=relaxed/simple;
	bh=OGZMJMXOLgCiZn0H5zqu7cHxgHSiKoeBOGs2e0c5FZs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Mp4Fj+A09NLNlurMCsQAhoxv1Va6fcilh0pvyxLvJwX06t7M7enbuauO/0n7iK6sIiCGsScZ66Suwbj2082L00l5SAAJmBekgOLdW3rhqzvLhrViXySrTv3Q7uOd+mbNSrgnFcRIa2L5abVLYuTInUHNxrCfAxCHSJWspS8EHlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wtagY-000000001Lf-1uTK;
	Tue, 11 Aug 2026 00:49:42 +0000
Date: Tue, 11 Aug 2026 01:49:31 +0100
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
Subject: [RFC PATCH 3/4] Bluetooth: hci_h5: use device_schedule_reprobe()
Message-ID: <anpxmyWKgUL6uYFN@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

h5_btrtl_resume() open-codes a deferred re-probe for RTL devices that
lose their firmware state over suspend: it takes a module reference,
allocates a work item, and the work function calls device_reprobe()
and then ends with put_device(); kfree(); module_put(THIS_MODULE); in
module text. That final module_put() is racy: once the reference
count is decremented a concurrent rmmod can free the module text
before the work function's epilogue has finished executing. The work
also does not synchronize against shutdown or unbind, so a stale
re-probe could undo an administrative unbind or detach a device whose
->shutdown() callback has already run.

Convert to the new device_schedule_reprobe() helper, whose work
function is builtin text and which skips the re-probe when the device
was removed, shutdown reached it, or it is no longer bound to the
driver that scheduled the re-probe.

The old worker suppressed its error message for -EPROBE_DEFER; the
helper needs no equivalent because its attach half is
device_attach(), which folds probe deferral into the deferred-probe
machinery silently.

Behavioral changes:

- A pending re-probe no longer pins the module: rmmod with a re-probe
  pending now succeeds immediately and the re-probe becomes a no-op,
  instead of rmmod failing with EBUSY.

- A re-probe scheduled before a system shutdown or before an
  administrative unbind no longer detaches and rebinds the device
  afterwards.

- A re-probe racing the next suspend now detaches immediately while
  the probe is deferred until the following resume by the
  defer_all_probes machinery, instead of probing mid-suspend.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/bluetooth/hci_h5.c | 41 +++++---------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 60b90f1e11fc..3330f696fa3b 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -1047,46 +1047,15 @@ static int h5_btrtl_suspend(struct h5 *h5)
 	return 0;
 }
 
-struct h5_btrtl_reprobe {
-	struct device *dev;
-	struct work_struct work;
-};
-
-static void h5_btrtl_reprobe_worker(struct work_struct *work)
-{
-	struct h5_btrtl_reprobe *reprobe =
-		container_of(work, struct h5_btrtl_reprobe, work);
-	int ret;
-
-	ret = device_reprobe(reprobe->dev);
-	if (ret && ret != -EPROBE_DEFER)
-		dev_err(reprobe->dev, "Reprobe error %d\n", ret);
-
-	put_device(reprobe->dev);
-	kfree(reprobe);
-	module_put(THIS_MODULE);
-}
-
 static int h5_btrtl_resume(struct h5 *h5)
 {
-	if (test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
-		struct h5_btrtl_reprobe *reprobe;
-
-		reprobe = kzalloc_obj(*reprobe);
-		if (!reprobe)
-			return -ENOMEM;
-
-		__module_get(THIS_MODULE);
+	if (test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+		return device_schedule_reprobe(&h5->hu->serdev->dev, 0);
 
-		INIT_WORK(&reprobe->work, h5_btrtl_reprobe_worker);
-		reprobe->dev = get_device(&h5->hu->serdev->dev);
-		queue_work(system_long_wq, &reprobe->work);
-	} else {
-		gpiod_set_value_cansleep(h5->device_wake_gpio, 1);
+	gpiod_set_value_cansleep(h5->device_wake_gpio, 1);
 
-		if (test_bit(H5_HW_FLOW_CONTROL, &h5->flags))
-			serdev_device_set_flow_control(h5->hu->serdev, true);
-	}
+	if (test_bit(H5_HW_FLOW_CONTROL, &h5->flags))
+		serdev_device_set_flow_control(h5->hu->serdev, true);
 
 	return 0;
 }
-- 
2.55.0
