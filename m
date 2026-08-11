Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C22E542C;
	Tue, 11 Aug 2026 00:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786409270; cv=none; b=Ia9Irh83u0WisdkJHalSmAeql8ca/f5XIIXhd0KL6cNg2F56U1BKm3FUnFMouWQQUD8pjmH6lLp4Nu55zzIh0wnrPCTu6NSCGjfKCEkjOVALxE7ipRewkbVC+HHa+HkRdGYUCkEm2Mb/w8ZatOG6OrEDwFL+X2QQV329g7/UIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786409270; c=relaxed/simple;
	bh=hZCc3+/7fiKHfzoZpA4FmywnCEr6I2Rvr13bxqcrhOM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SLYyGSItjJsc4ZUZsL7HKVjfoySpsc3xj+p+GWmf58EcSftylO+rpEy3JWgpT2jaYQfnQKyTZIJ4OrqhLZdXJM2bUwa4Nxvq53lzCENNEPMIa76ZLQHvurXq5F+vtDWY/Qi5j9iKihpBh+Ol1tqM0HDUJKwW2kx/LPEymYiPE+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wtaeT-000000001Ka-45n1;
	Tue, 11 Aug 2026 00:47:34 +0000
Date: Tue, 11 Aug 2026 01:47:17 +0100
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
Subject: [RFC PATCH 0/4] device_schedule_reprobe(): core helper and
 conversions
Message-ID: <anpxFdwNxk0XwPjQ@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Three in-tree drivers (iwlwifi, hci_h5, btintel_pcie) schedule a
deferred re-probe of their own device from a work item in module
text. The hand-rolled copies share two bug classes: the work function
ends with module_put(THIS_MODULE), racing a concurrent rmmod freeing
the module text (the race module_put_and_kthread_exit() exists to
close for kthreads), and nothing synchronizes the deferred detach
against device_shutdown() or an administrative unbind.

Patch 1 moves the deferred work into the driver core.
device_schedule_reprobe() runs builtin code, so no module reference
is needed; it checks under a single __device_driver_lock() hold that
the device is still bound to the driver that scheduled the re-probe,
and skips the detach once device_shutdown() has reached the device
(a new one-bit shutdown_done flag in struct device_private). Patches
2 and 3 are mechanical conversions. Patch 4 (btintel_pcie) also
removes that driver's remove()-from-own-work contract; it changes
more and can be dropped without affecting patches 1-3.

This grew out of review of the mxl862xx DSA series [1][2], which
copied the iwlwifi pattern. There ->shutdown() clears drvdata so that
->remove() becomes a no-op, a stale re-probe escalates to
use-after-free, and its v10 cover letter walks through why a driver
cannot fully close the race itself: device_shutdown() holds
device_lock() across ->shutdown() and device_reprobe() takes the same
lock, so any driver-side check remains a TOCTOU. The helper closes it
in the core; mxl862xx will convert once it lands.

Testing: checkpatch --strict and kernel-doc clean. Patches 1-3 were
runtime-tested (backported to 7.0.11) on Intel AX101 hardware with
PROVE_LOCKING and DEBUG_OBJECTS_WORK, driving iwlwifi's crash
escalation into the re-probe path: normal detach+rebind, an unbind
racing a pending re-probe (the unbind is not undone), rmmod with a
re-probe pending (now succeeds instead of EBUSY), and reboot with a
re-probe pending; no lockdep or debugobjects reports. hci_h5 and
btintel_pcie are compile-tested only.

[1] https://lore.kernel.org/all/cover.1786294649.git.daniel@makrotopia.org/
[2] https://sashiko.dev/#/patchset/cover.1786294649.git.daniel%40makrotopia.org

Daniel Golle (4):
  driver core: add device_schedule_reprobe()
  wifi: iwlwifi: use device_schedule_reprobe()
  Bluetooth: hci_h5: use device_schedule_reprobe()
  Bluetooth: btintel_pcie: use device_schedule_reprobe() after reset

 drivers/base/base.h                           |  5 ++
 drivers/base/core.c                           |  3 +
 drivers/base/dd.c                             | 82 +++++++++++++++++++
 drivers/bluetooth/btintel_pcie.c              | 48 ++++++-----
 drivers/bluetooth/hci_h5.c                    | 41 ++--------
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 40 +--------
 include/linux/device.h                        |  2 +
 7 files changed, 122 insertions(+), 99 deletions(-)

-- 
2.55.0
