Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878959;
	b=yyyZ6xFIV+CS+ZgT30i8nSwpwxwHEymrPes84DB6E1Y2qiyGacSUvgHoMV7LQit8mpEz
	 BXASKNhKSKjKqxL2zO29FH7e8fmG4ctkEiDRUw1trJoSbCZT+ciZC5LO6Vb0o3c9BS2y1
	 CDRp7yUEyT2n60/EhuDiLe8VvkuclNHuSFmMI0ScpFQsij8mAcJCCsTYj4LuQtyqYNNfs
	 y+PjHRBIF9/jIfJ/GaVvgj/GbsgqTu4jQ2+Sax6mWsJRZyEIShL69naJCNlfXm6Vx/4jP
	 /42rrN6Ju89lYK2VH5XqoAzftpAv7O0xzniIkogjKxkh9qCTq8hepxyFwEHlRcW8XOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:X-Change-ID:X-Mailer:
	 Content-Transfer-Encoding;
	bh=nNRa2+aOfCVTNA1AfTcRiILSfCXzP/TbgaPBxe7cp+M=;
	b=PGlT0+FG6PQM/eKW5KEwWbtrK3whPGYFBDtoSkwvipTeKElNJh4ExPGCizCqpBPXQXI3
	 kd3zDnA2LV9ot8c0+dpRV/NhS6AUhihvNEEWl3ZWedM79SyrNgmLR8DjHue5C/1Yg8dzr
	 2Gu2sdVfq9KUeswox9fpFb3WGWFgOQIuanXVUAJedu9SMktMy3RkWLEVgCHZ0uXQSZwi8
	 qcaqT3DmUkeQcbkhY+7DLEBxxfCSCiOrBZti7I3ZS75r83o1lVyAc29wQkQANUTk9pa0E
	 YXBUZ7LOadi010udFp/norwWG6E/jg7YEIREARDnv7HmBzG+u4/TsLoFLacTx2r6SZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHSP6gcj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F8A606A31B;
	Thu,  5 Nov 2026 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LHSP6gcj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8654B1F000C1;
	Thu,  5 Nov 2026 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878958;
	bh=nNRa2+aOfCVTNA1AfTcRiILSfCXzP/TbgaPBxe7cp+M=;
	h=From:To:Cc:Subject:Date;
	b=LHSP6gcjp4mEydZ1ViLj+iZVCehAC2kCPmDZuRfYlJYvaiP1ul7v4Z8h3ReQmyo98
	 Pef+LF0klHcjE/gNRKFhsjH6/va4tiLGx0cX0LenQBttgBh//azxgkbkawJOOL/XmW
	 GMaDKIKxgi23E78tGkXW+Rodfmug5gKbMzabVHpatQxpqzrwVUULv2jR6F9jquxqHf
	 lUuCwhy6URmPE3GIxm/DhywMQpohFyk1oicHLoVlLeIaqy+fFAI0oG/Z7U4oWcNWnJ
	 6TsfxxirEqAnUWR1+nNIO6clHASzuOt4ufMR8wNuNhC7mZXIxm4v4P+YMaeDdN9Jlb
	 CVz9dBmNoauMQ==
From: Leon Romanovsky <leon@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Johan Hovold <johan@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org,
	iommu@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 00/17] driver core: Authorize device trust before driver binding
Date: Thu,  5 Nov 2026 13:42:13 +0200
Message-ID: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260915-device-trust-core-12934e618489
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

Device trust was a concept introduced by Dan in his series here:

  https://lore.kernel.org/all/20260705220819.2472765-1-djbw@kernel.org

This series takes just the Device Trust idea and works to introduce
it aside from the other components.

Device Trust is a general concept that already exists in PCI via the
'untrusted' flag. This series generalizes that into a consistent
cross-bus concept that allow the user to inject their own opinion into
how the kernel should operate the device. Three levels are defined:

 - DISABLED: Device is not operated by the kernel and is kept
   quarantined. Confidential computing kernels will start all
   devices in that mode.

 - ADVERSARY: Device may be malicious and the kernel should defend
   itself, eg by forcing use of a strong iommu, not exposing random
   kernel memory to DMA and maybe even protections in the driver from
   malicious data in DMAs.

 - FULL: The normal kernel operating mode.

Aside from this basic idea of defining the three levels, this series
also introduces a mechanism for userspace to make a policy decision
which level the device should operate in.

This is important for Confidential Computing systems that need to
evaluate a device, do a cryptographic authentication, enable PCIe link
encryption, and other steps designed to protect the system. These
operations need to be done in userspace before any DMA access to the
device is allowed.

Using this series the user can boot the kernel with a default trust
policy of DISABLED, allowing only a small number of devices like
interrupt controllers, timers and iommus to start. Then the kernel can
get into the initrd where a userspace policy agent and implement
whatever decisions are required.

For Confidential Computing it is important that the policy logic be
robustly inclusive. If the kernel autoprobes any sort of real HW
device without going through the policy phase it could become an
attack vector.

Finally the policy agent can set the trust level and then cause a
driver to bind in the normal way. User control of driver binding was
already setup in 2007 via commit b8c5cec23d5c ("Driver core: udev
triggered device-<>driver binding") which relied on the
drivers_autoprobe to work.

At least for Confidential Computing a high security policy in
userspace would leave unexpected devices as DISABLED, authenticated
PCI devices as FULL and everything else ADVERSARIAL.

A draft starting point for a policy agent has been prepared:

 https://github.com/rleon/systemd/commits/accept-d-trust-level

As a proposed systemd service that manages the process.

Thanks

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (17):
      Input: gameport - attach manual drivers through the driver core
      Input: serio - attach manual drivers through the driver core
      net: phy: Attach generic PHY drivers through the driver core
      wifi: mac80211_hwsim: lock device for manual driver binding
      USB: Lock registered interfaces during manual driver binding
      PNP: Attach card devices through the driver core
      cdx: Propagate DMA configuration errors
      driver core: Allow userspace to detect EPROBE_DEFER when using sysfs drivers_probe
      driver core: Introduce a generic device trust level
      driver core: Expose device trust authorization through sysfs
      driver core: Accept device trust policy on the kernel command line
      driver core: Accept device trust policy by driver name
      driver core: Preserve trust commitment beyond driver binding
      driver core: Add a global initial device trust policy
      driver core: Cover trust authorization and binding with KUnit
      driver core: Document trust admission and initrd authorization
      PCI: Replace untrusted state with device trust

 Documentation/ABI/testing/sysfs-bus-drivers-probe  |   13 +
 Documentation/ABI/testing/sysfs-devices-trust      |   61 +
 Documentation/admin-guide/kernel-parameters.txt    |   64 +
 .../driver-api/driver-model/device-trust.rst       |  294 ++++
 Documentation/driver-api/driver-model/index.rst    |    1 +
 MAINTAINERS                                        |    2 +
 drivers/base/Makefile                              |    2 +-
 drivers/base/base.h                                |   37 +
 drivers/base/bus.c                                 |    9 +-
 drivers/base/core.c                                |   18 +-
 drivers/base/dd.c                                  |   88 +-
 drivers/base/test/Makefile                         |    1 +
 drivers/base/test/device-trust-test.c              | 1607 ++++++++++++++++++++
 drivers/base/trust.c                               |  455 ++++++
 drivers/bluetooth/btusb_main.c                     |   42 +-
 drivers/cdx/cdx.c                                  |    2 +-
 drivers/input/gameport/gameport.c                  |   21 +-
 drivers/input/serio/serio.c                        |   24 +-
 drivers/iommu/amd/iommu.c                          |    3 +-
 drivers/iommu/dma-iommu.c                          |   14 +-
 drivers/iommu/intel/iommu.c                        |   17 +-
 drivers/iommu/iommu.c                              |   17 +-
 drivers/net/phy/phy_device.c                       |   39 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |    2 +
 drivers/pci/ats.c                                  |    4 +-
 drivers/pci/pci.c                                  |    5 +-
 drivers/pci/probe.c                                |   26 +-
 drivers/pci/quirks.c                               |    7 +-
 drivers/pnp/card.c                                 |   12 +-
 drivers/usb/core/driver.c                          |   30 +-
 drivers/usb/core/message.c                         |   10 +
 drivers/usb/core/usb.h                             |    2 +
 include/linux/device.h                             |   16 +
 include/linux/device/bus.h                         |   10 +
 include/linux/device/trust.h                       |   48 +
 include/linux/pci.h                                |   30 +-
 36 files changed, 2886 insertions(+), 147 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260915-device-trust-core-12934e618489

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

