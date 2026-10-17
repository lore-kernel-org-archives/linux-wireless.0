Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CEE37F33D;
	Sat, 17 Oct 2026 08:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792227326; cv=none; b=l7gFMm2J/VrZ9WekrZGdFmHJ5QzcEBSGR4JpTKjANUHT2s6uKmCFwUMOQuMVeqpbG3l0VuFjWgW+L61Re9ihHd7sSP6IaWa4P9vltUJEag1OK/fnrLuYZmFtQ8yGHfas2yIsxPwv//VIWsncI9ApAYN536XendS3WHs61ddjVX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792227326; c=relaxed/simple;
	bh=E0fjcsu40T6/F313XMJJ/NVd+RUC6tIve+FBSv42krc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=opRkH0w1oyWOKCVGcjMLOTx4kL1xUsTAoXDNjz6z5vGlTjEI5YvJZDYsaXv0yOYgrGjiEwNWxFEk2ehIvcbRG2vRWYRpg4J0CNla5JB+q9kKIQQapiR/KBVZ1aZLVrDwIzmfnoFR9JbhN6rhj17yIS01KSWLXLGgunCLh72miuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1xI0CG-000000004Fu-3V2H;
	Sat, 17 Oct 2026 08:55:20 +0000
Date: Sat, 17 Oct 2026 09:55:17 +0100
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
Subject: [PATCH v4 0/4] device_schedule_reprobe(): core helper and conversions
Message-ID: <cover.1792203271.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

iwlwifi and hci_h5 re-probe their own device from a work item in module
text ending in module_put(THIS_MODULE), which a concurrent rmmod can
race, and nothing ties the re-probe to the binding that asked for it.
btintel_pcie re-probes synchronously from its own reset work. This
series adds device_schedule_reprobe() to the driver core and converts
all three.

Tested on an Intel AX101 with patches 1 to 3, PROVE_LOCKING and
DEBUG_OBJECTS_WORK: a re-probe, and an unbind, rmmod, PCI removal,
suspend and reboot with one pending. The unbind and the removals
cancelled it, and it ran after resume. The stock iwlwifi code undid
the unbind, and rmmod with its work held just past module_put() oopsed
in lockdep. Patches 3 and 4 are untested for lack of hardware.

Changes since v3 [4]:
 - patch 1 was reworked as patch 3/6 of the mxl862xx devlink flash
   series, v13 to v19 [5][6], which netdev has deferred until this
   lands; its history summarises the changes
 - patch 1: Hans de Goede's tags dropped [7]; patch 3 keeps his, its
   code being unchanged, but a re-test would be welcome
 - patches 2 and 3: Fixes: tags
 - patches 2 to 4: commit messages updated; rebased onto bluetooth-next

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
[4] https://lore.kernel.org/all/cover.1787281239.git.daniel@makrotopia.org/
[5] https://lore.kernel.org/all/cover.1788783126.git.daniel@makrotopia.org/
[6] https://lore.kernel.org/all/cover.1791035885.git.daniel@makrotopia.org/
[7] https://lore.kernel.org/all/aqlPPyblTK8c6-zZ@makrotopia.org/

---
On LLM use: device_schedule_reprobe() was designed and first
implemented by hand. Its later revisions answer AI review (Sashiko on
the mxl862xx postings, and local runs of the same prompts); an LLM
helped reproduce those findings and draft the changes and changelogs.
Every decision and the final review were mine; the Assisted-by tag on
patch 1 records this.

Daniel Golle (4):
  driver core: add device_schedule_reprobe()
  wifi: iwlwifi: use device_schedule_reprobe()
  Bluetooth: hci_h5: use device_schedule_reprobe()
  Bluetooth: btintel_pcie: use device_schedule_reprobe() after reset

 drivers/base/base.h                           |   4 +
 drivers/base/dd.c                             | 171 ++++++++++++++++++
 drivers/bluetooth/btintel_pcie.c              |  47 +++--
 drivers/bluetooth/hci_h5.c                    |  43 +----
 .../net/wireless/intel/iwlwifi/iwl-trans.c    |  40 +---
 include/linux/device.h                        |   2 +
 6 files changed, 208 insertions(+), 99 deletions(-)


base-commit: 185c11232d5f586489bb3b74e6bcc7a6560ddd40
-- 
2.56.0
