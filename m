Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00614145B27;
	Thu, 20 Aug 2026 00:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787185947; cv=none; b=XZ12l9XDDdOhBbjCG6TZ76Pv5vAMkClSisl/rnfw+OFry1letJjPOpSwaatkTzzEuT6YmxzBkDiyGY8xiHdpuSkPFKYzWdq5A3arz/GocFYdxwjxOnJh/Z+IKUzVzHaeBKgkRtkOy8Ln8JML0dysCv9EKdG1/40Z2DKqlb0mi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787185947; c=relaxed/simple;
	bh=/z03sx9hdGw6YJSBUL5u2FZjjb9OwGzbteA279601a0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EO2oB3XpVxbuxuS1NvyNNFAACqLeEtXhhRu+Uq33rg6f38wb5mMQrzR0KWtvOTx0lDN4Eblg9vn3z4RXG2vhbKOZElcGGP0LUsIGBbjJSyHqKxTcLy33XHvESYuApW3TNulaNvfqY4+6I8ilUeT4deXuyq/RzzfSZHXJGaI4u74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wwqhZ-000000007CJ-0pVm;
	Thu, 20 Aug 2026 00:32:13 +0000
Date: Thu, 20 Aug 2026 01:32:04 +0100
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
Subject: [PATCH v2 0/4] device_schedule_reprobe(): core helper and conversions
Message-ID: <cover.1787185594.git.daniel@makrotopia.org>
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
mechanical conversions. Patch 4 (btintel_pcie) also retires that
driver's remove()-from-own-work contract, replacing the current_work()
dance with the deferred re-probe; it changes more and can be dropped
without affecting patches 1-3.

As Hans put it on the RFC: the tree already has device_reprobe() with
15 callers, so this just adds a way to run one from a worker safely
rather than having each of the open-coded copies reimplement the
locking.

This was first floated as an RFC [1]. In parallel the helper rode
along in the mxl862xx DSA firmware-update series as its patch 3, and
the v11 [2] and v12 [3] postings put it through further review: an
automated review of v12 caught a parent use-after-free (the work locks
the parent, but only the child was pinned) and a missing parent lock
across device_attach() on need_parent_lock buses. Both are fixed here.
net-next is closed and the mxl862xx feature waits for the next window,
so the helper is submitted on its own now; mxl862xx converts to it
once it lands.

Testing: Patches 1-3 were runtime-tested (backported to 7.0.11) on
Intel AX101 hardware with PROVE_LOCKING and DEBUG_OBJECTS_WORK,
driving iwlwifi's crash escalation into the re-probe path: normal
detach+rebind, an unbind racing a pending re-probe (the unbind is not
undone), rmmod with a re-probe pending (now succeeds instead of
EBUSY), and reboot with a re-probe pending; no lockdep or debugobjects
reports. The same helper was exercised by the mxl862xx v11/v12
hardware testing across repeated devlink firmware-flash and re-probe
cycles, including a re-probe pending across unbind, rmmod and reboot.
hci_h5 and btintel_pcie are compile-tested only.

Changes since the RFC (v1) [1]:
 - rebased from net-next onto v7.2-rc7
 - pin the parent device across the deferred work and re-lock it
   across device_attach() on need_parent_lock buses (found by the
   automated review of the mxl862xx v12 posting)
 - schedule the work on system_dfl_wq instead of the deprecated
   system_unbound_wq
 - thread the series properly (the RFC's patches were unthreaded)
 - drop RFC status

[1] https://lore.kernel.org/all/anpxFdwNxk0XwPjQ@makrotopia.org/
[2] https://lore.kernel.org/all/cover.1786773971.git.daniel@makrotopia.org/
[3] https://lore.kernel.org/all/cover.1786922210.git.daniel@makrotopia.org/

Daniel Golle (4):
  driver core: add device_schedule_reprobe()
  wifi: iwlwifi: use device_schedule_reprobe()
  Bluetooth: hci_h5: use device_schedule_reprobe()
  Bluetooth: btintel_pcie: use device_schedule_reprobe() after reset

 drivers/base/base.h                           |  5 +
 drivers/base/core.c                           |  3 +
 drivers/base/dd.c                             | 99 +++++++++++++++++++
 drivers/bluetooth/btintel_pcie.c              | 51 +++++-----
 drivers/bluetooth/hci_h5.c                    | 43 ++------
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 40 +-------
 include/linux/device.h                        |  2 +
 7 files changed, 144 insertions(+), 99 deletions(-)


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
2.55.0
