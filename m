Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B3F35E1B9;
	Fri, 21 Aug 2026 03:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281714; cv=none; b=dr6ok1fPOLdTel3y8X2JG9mVVoAqUSWfnn1aPSCKZSS9emXLqOIQwosnt73ow7qLLbtscNLGucKOXFqXGmj9PMdVK1IdxGRK6lhcIc2oubLxyAf5SJVBIJx/DyFNg+KP6t0WYMpVaxWc9hbqcuHws4DJl5mfJtW7hT0Hua9l7tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281714; c=relaxed/simple;
	bh=CBDVKp9MlCzdwdAZgdYt7cIMkOdyGaTV/im6jhI9diA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tRBDQ1/75LT9XbJKud2B8iasrjappnoAgLLc1iyhww0dczEf2TjukMoJ+Sk59HwzuKnwuFyrxZEFFJZQuJEaNbtvOjAhvqLvKm3kPTkbSncQRAzuCQl7lvTL0onoqWbASUffrdblOnijiactT8FiZiI4lXdmOFX9MzFp/UEWNBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wxFcD-000000005TT-0RJQ;
	Fri, 21 Aug 2026 03:08:21 +0000
Date: Fri, 21 Aug 2026 04:08:12 +0100
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
Subject: [PATCH v3 0/4] device_schedule_reprobe(): core helper and conversions
Message-ID: <cover.1787281239.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Three in-tree drivers (iwlwifi, hci_h5, btintel_pcie) schedule a
deferred re-probe of their own device from a work item whose work
function lives in module text. The hand-rolled copies share two bug
classes: the work function ends with module_put(THIS_MODULE), racing a
concurrent rmmod freeing the module text (the race
module_put_and_kthread_exit() exists to close for kthreads), and
nothing synchronizes the deferred detach against device_shutdown() or
an administrative unbind.

Patch 1 moves the deferred work into the driver core.
device_schedule_reprobe() runs builtin code, so no module reference is
needed; it checks under a single __device_driver_lock() hold that the
device is still bound to the driver that scheduled the re-probe, and
skips the detach once device_shutdown() has reached the device (a new
one-bit shutdown_done flag in struct device_private). It pins both the
device and its parent for the lifetime of the work and re-locks the
parent across the attach on buses that require it. Patches 2 and 3 are
mechanical conversions; patch 4 (btintel_pcie) also retires that
driver's remove()-from-own-work contract.

This is a cross-tree series. Each patch applies cleanly on the tree
that owns it:

  patch 1 (driver core)      -> driver-core
  patch 2 (iwlwifi)          -> wireless-next
  patches 3, 4 (bluetooth)   -> bluetooth-next

It is based on bluetooth-next so patches 3 and 4 apply there; patch 1
applies equally on driver-core and patch 2 on wireless-next (verified
against all three trees). Patches 2-4 depend on the helper from patch
1, so they need it in their tree -- or an immutable branch/tag of it --
before they build.

As Hans put it on the RFC: the tree already has device_reprobe() with
15 callers, so this just adds a way to run one from a worker safely
rather than having each open-coded copy reimplement the locking.

History: this was first floated as an RFC (v1) [1]. In parallel the
helper rode along in the mxl862xx DSA firmware-update series, whose
review [2] caught a parent use-after-free (the work locks the parent,
but only the child was pinned) and a missing parent lock across
device_attach() on need_parent_lock buses -- both fixed here. net-next
is closed and the mxl862xx feature waits for the next window, so the
helper is submitted on its own now; mxl862xx is going to use it once it
lands.

Testing: Hans de Goede reviewed and tested patches 1 and 3 on hci_h5
hardware that hits the resume re-probe path. Patches 1-3 were also
runtime-tested (backported to 7.0.11) on Intel AX101 with PROVE_LOCKING
and DEBUG_OBJECTS_WORK, driving iwlwifi's crash escalation into the
re-probe path: normal detach+rebind, an unbind racing a pending
re-probe (not undone), rmmod with a re-probe pending (now succeeds
instead of EBUSY), and reboot with a re-probe pending; no lockdep or
debugobjects reports. The helper was exercised further by the mxl862xx
v11/v12 hardware testing. btintel_pcie (patch 4) is compile-tested
only.

Changes since v2 [3]:
 - patch 1: use dev_err_probe() for the re-probe error path so a
   re-probe deferred at resume no longer logs a spurious error; pick up
   Hans de Goede's Tested-by/Reviewed-by
 - patch 3: pick up Hans de Goede's Tested-by/Reviewed-by
 - patch 4: rebased onto bluetooth-next, whose btintel_pcie has four
   dump workers rather than the single one the v2 mainline snapshot had
 - base the series on bluetooth-next instead of v7.2-rc7 so the
   bluetooth patches apply for their maintainers

Changes since the RFC (v1) [1]:
 - pin the parent device across the deferred work and re-lock it across
   device_attach() on need_parent_lock buses (found reviewing the
   mxl862xx posting [2])
 - schedule the work on system_dfl_wq instead of the deprecated
   system_unbound_wq
 - thread the series properly (the RFC's patches were unthreaded)
 - drop RFC status

[1] https://lore.kernel.org/all/anpxFdwNxk0XwPjQ@makrotopia.org/
[2] https://lore.kernel.org/all/cover.1786922210.git.daniel@makrotopia.org/
[3] https://lore.kernel.org/all/cover.1787185594.git.daniel@makrotopia.org/

Daniel Golle (4):
  driver core: add device_schedule_reprobe()
  wifi: iwlwifi: use device_schedule_reprobe()
  Bluetooth: hci_h5: use device_schedule_reprobe()
  Bluetooth: btintel_pcie: use device_schedule_reprobe() after reset

 drivers/base/base.h                           |   5 +
 drivers/base/core.c                           |   3 +
 drivers/base/dd.c                             | 102 ++++++++++++++++++
 drivers/bluetooth/btintel_pcie.c              |  49 +++++----
 drivers/bluetooth/hci_h5.c                    |  43 ++------
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  40 +------
 include/linux/device.h                        |   2 +
 7 files changed, 146 insertions(+), 98 deletions(-)


base-commit: 486f8908aa587ab2a213bbef39311743e4f8f57a
-- 
2.55.0
