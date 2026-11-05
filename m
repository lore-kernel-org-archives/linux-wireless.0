Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879018;
	b=CC1u1H3ZLOSyNe8s4o4n4L1ohL9YeKgvcwa3KyKAoTZwuE6PLcDQ1+u18cVX9XYKVFqi
	 XPYuHk3Q5ao6ZDX0zjXwKzHqX36LuKPWRui9bBS9yDeTakPkuUXmzWS+rvDGwlPo2+1wk
	 5wDEu3oH99nCoP40E4Ib7QmAwMrGkLCaZUrMxseu8W6To2nFF/KFsemJ61bHAUJtfCm3f
	 7w7ptGchduTT1zqaZO16DijTfTkKzRlfvQqgjzn3Yo2lI9rTaDuULEvHXrIPkwdHD50oC
	 CvJK+Th4pXykWK8zIqx6YoJ8hnFYmV4q3D0SthJMVCjnAJIWyalSSXesWRnm6yW230A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=t2tbrNTzTBb7SOH1qu4EnEUzLM1HndvW30ICEhou5U4=;
	b=5YuLSOmPKmHEszin9v+uHW6xGT14yMCG47miMg0ErPMikwl/DwjcA+SZsoWgMeEaESjs
	 7hNt3vb+3l9PhQi78pEpkPZ9Nhpw20iDXW8oglTngbEIOtiQGWcv7xRT56j2Fv5HrvcdJ
	 lIbYXT3eJVIuDb8FgAfenXRdz8NlpdKFJ1CZAMB81oiCBGCDS/s7FXhXQOeUSHHinMTQc
	 drAWUq34zk8s7iRgejoWXGG0WmgUZIpNrTO/aN5xkImVDgYbf3ZrwNJbOj3A4TwMqggsP
	 +V8tozViho8Vst/Iumv8GvGZkL+aIQl0s9kGbsOGpF0FMBk6eAnTlLxGWc0sNg0mRig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZiNX5zc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47DD606A31B;
	Thu,  5 Nov 2026 11:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZiNX5zc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECBA1F00919;
	Thu,  5 Nov 2026 11:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879017;
	bh=t2tbrNTzTBb7SOH1qu4EnEUzLM1HndvW30ICEhou5U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiNX5zc8uwNBhuWTAVNyYwSxcH697PB5GHkizTawgERBI/pICAewW6FnKEGj1anEX
	 mCbUAr7iXQupakKGCitiNo9TF39xe+xB12Kilh4j/0mpTEMrOVZTG9ytbMJRFT4Pva
	 RQFFbMxgxU9PV7vWZG46u6TNjfcgxrwBMkJgu5Rz6hHdgTOjzF5DGlbS/8M05wybxF
	 wVJWYfgUFQFAHmyjpTE8CwnKaNlX7ovh6EWrR0UI5KWBbIniJkDwSyxY/DghEwzJxc
	 BaIt98Uva8hlGa2U632mYbF4ukcGnTWRCCw1sX1J/NEpAoaooYygGD32xKZ6WDvpc1
	 LrC/gjjjSu+Ug==
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
Subject: [PATCH 16/17] driver core: Document trust admission and initrd authorization
Date: Thu,  5 Nov 2026 13:42:29 +0200
Message-ID: <20261105-device-trust-core-v1-16-1e536825b4eb@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
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
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Policy agents and bus drivers need a shared definition of authorization,
commitment and active trust across boot and device lifetime.

Document the admission state machine and disabled-to-authorized initrd
sequence, including built-in probes and pending work. Explain DMA domain
preparation, binding restrictions, device replacement and current userspace
integration requirements. Distinguish attestation and containment from the
permission to bind a functional driver.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../driver-api/driver-model/device-trust.rst       | 294 +++++++++++++++++++++
 Documentation/driver-api/driver-model/index.rst    |   1 +
 2 files changed, 295 insertions(+)

diff --git a/Documentation/driver-api/driver-model/device-trust.rst b/Documentation/driver-api/driver-model/device-trust.rst
new file mode 100644
index 0000000000000..1013784daeaca
--- /dev/null
+++ b/Documentation/driver-api/driver-model/device-trust.rst
@@ -0,0 +1,294 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Device trust
+============
+
+Device trust controls how the kernel uses a device. It does not verify the
+device's identity or firmware. Driver core tracks the requested policy,
+permission to bind, and active trust level separately.
+
+Policy and active trust
+=======================
+
+The writable ``trust_policy`` attribute accepts ``default``, ``disabled``,
+``adversary``, or ``full``. The bus may set the initial policy; otherwise it
+starts as ``default``. Boot options can override it for all devices, a
+named driver, or an individual device. See `Boot policy`_ for precedence.
+
+The read-only ``trust`` attribute reports the active trust level:
+
+``DEVICE_TRUST_DISABLED`` (``disabled``)
+  There is no active driver setup or binding. The requested policy decides
+  whether a later bind is allowed.
+
+``DEVICE_TRUST_ADVERSARY`` (``adversary``)
+  The kernel treats the device as potentially malicious. The bus and DMA
+  layers must enforce the restrictions needed to operate it.
+
+``DEVICE_TRUST_FULL`` (``full``)
+  The device uses the normal privileges allowed by the bus and DMA policy.
+
+Policy resolution
+=================
+
+A bus can implement ``bus_type::trust_resolve`` to choose the active level
+from the device, candidate driver, and requested policy. For ``default``,
+it may use topology or firmware information. Other policies must resolve
+to the matching level or fail.
+
+The callback must not enable the device or grant DMA access. Those steps
+belong in setup callbacks, after resolution and before probe.
+
+Without this callback, ``default`` and ``full`` resolve to
+``DEVICE_TRUST_FULL``, and ``adversary`` to ``DEVICE_TRUST_ADVERSARY``.
+Explicit ``disabled`` blocks binding. The bus remains responsible for
+enforcing the chosen level's restrictions.
+
+Admission and policy writes
+===========================
+
+Authorization is userspace's choice of adversary or full for a disabled
+device. Commitment happens when the kernel accepts a policy and operating
+level, before starting driver setup. Both limit later policy changes.
+
+The states below are internal; they are not additional sysfs values.
+``P`` is the requested policy and ``L`` is the committed operating level.
+
+.. list-table:: Admission states
+   :header-rows: 1
+   :widths: 25 40 35
+
+   * - State
+     - Meaning
+     - Policy writes
+   * - SELECTABLE
+     - The device has not been authorized or committed.
+     - Any policy is allowed. Selecting disabled enters WAITING.
+   * - WAITING
+     - Policy is disabled - no operating level is committed.
+     - Choose adversary or full to enter AUTHORIZED(P).
+   * - AUTHORIZED(P)
+     - Userspace has chosen adversary or full from WAITING.
+     - The policy cannot change, even before setup begins.
+   * - COMMITTED(P, L)
+     - The kernel has accepted P and L for setup.
+     - Neither the policy nor the operating level can change.
+
+Bus defaults and boot options set the initial state: disabled starts in
+WAITING; other policies start in SELECTABLE. Driver boot rules apply later,
+when a matching driver attempts to bind. They may still replace this
+initial state, including WAITING, unless a per-device boot entry or a
+successful policy write takes precedence.
+
+Userspace cannot move WAITING back to SELECTABLE by writing ``default``.
+Choosing adversary or full from WAITING locks that policy immediately.
+
+After boot initialization, the state transitions are::
+
+  SELECTABLE ----select disabled----> WAITING
+      |                                 |
+      |                             authorize
+      |                           adversary/full
+      |                                 |
+      |                                 v
+      |                            AUTHORIZED(P)
+      |                                 |
+      +------ permitted resolution -----+
+                       |
+                       v
+                 COMMITTED(P, L)
+
+Binding and device lifetime
+============================
+
+A manual bind that reaches WAITING returns ``-EPERM`` before driver or DMA
+setup. Automatic matching skips the rejected driver and tries the next
+candidate. Repeated rejected attempts leave the policy writable for later
+authorization.
+
+Active trust stays at L through DMA setup, probe, operation, removal, and
+``bus_type::dma_cleanup``. It returns to disabled only after cleanup ends.
+
+The state lasts for the device object's lifetime, including the switch
+from initrd to the root filesystem. Unbinding and rebinding a registered
+device does not reset it. A removed device cannot be registered again; a
+new object starts with bus and boot policy.
+
+A driver can claim a USB interface before it is registered. The claim fails
+if the interface's own policy is disabled. A driver rule and other claims
+are admitted when the interface is registered, and a refusal then releases
+the claim. The policy of a claimed interface cannot be changed, and
+registration does not admit it while ``drivers_autoprobe`` is disabled.
+
+Boot policy
+===========
+
+Built-in drivers can probe before userspace starts. Use boot options to
+set their initial policy. All three options accept default, disabled,
+adversary, and full.
+
+``device_trust.default=`` sets policy for all devices. If omitted or set
+to default, it preserves bus policy. Other values replace bus policy,
+including topology and removability defaults. The last valid value wins;
+invalid values are reported and ignored.
+
+``device_trust=`` sets policy for individual devices::
+
+  device_trust=pci:0000:01:00.0=adversary,pci:0000:02:00.0=disabled
+
+Each entry is ``<bus>:<device>=<policy>``. Names must match
+``/sys/bus/<bus>/devices/<device>`` exactly. The first colon separates the
+bus name; later colons are part of the device name. Names cannot contain
+whitespace, control characters, commas, equals signs, or double quotes.
+Wildcards are not supported.
+
+A device entry overrides driver rules, the global setting, and bus policy,
+regardless of option order. Explicit default asks the bus or generic
+resolver to choose a level, even if the global setting is disabled. The
+last entry for a device wins. If the option is repeated, the last valid
+list replaces all earlier lists. A malformed list is ignored in full,
+with a warning.
+
+``device_trust.driver=`` sets policy by driver name::
+
+  device_trust.driver=pci:e1000=disabled,pci:nvme=full
+
+Each entry is ``<bus>:<driver>=<policy>``. Use exact names from
+``/sys/bus/<bus>/drivers/<driver>``, not module names or aliases. The name
+restrictions and list handling are the same as for device entries. The
+two lists are independent. Driver rules cover built-in drivers, modules,
+and hotplug.
+
+The first bind attempt with a matching driver rule applies it before
+resolution and setup. It overrides bus and global defaults, including
+global disabled. It cannot override a per-device entry, any successful
+sysfs policy write, or an existing authorization or commitment. It applies
+only once per device object, even if resolution or setup fails.
+
+After a disabled driver rule applies, rejected probes and driver changes
+leave the device in WAITING until userspace authorizes it. Before any rule
+applies, a driver with no matching rule may still bind. Use global or
+per-device disabled to block every driver.
+
+For example, an initrd can hold all devices except one needed at boot::
+
+  device_trust.default=disabled device_trust=pci:0000:00:01.0=full
+
+Include exceptions for every device and supplier needed to reach the
+initrd and perform attestation. These exceptions allow operation before
+fresh initrd attestation. Unlisted devices stay disabled even if their
+bus would normally choose adversary or full.
+
+Global and per-device rules apply before device registration. Buses that
+need policy earlier call ``device_trust_init()`` after setting the bus,
+name, and initial policy. PCI does this during discovery, before header
+fixups, ACS setup, and IOMMU configuration. PCI applies topology and
+removability defaults only to default policy. A child's explicit boot
+entry overrides inherited policy. Driver rules wait until a candidate
+driver is known and cannot change these earlier discovery choices.
+
+All boot rules remain available for newly discovered devices. Reapplying
+initialization to an already registered device does not reset its state.
+These options are not runtime controls or proof of hardware identity.
+Disabled blocks early binding and allows later authorization. Adversary
+and full permit early binding without fresh initrd attestation.
+
+DMA containment
+===============
+
+Disabled blocks driver binding, not DMA that hardware starts on its own.
+The bus and IOMMU must provide containment while a device waits for
+authorization.
+
+For PCI devices whose policy is disabled or adversary at discovery, the
+IOMMU core selects a strict translated default domain for the whole group.
+AMD domain selection and Intel bypass checks apply the same restriction.
+This prepares a disabled device for later adversary authorization without
+granting permission to bind. Later full authorization may keep these
+restrictions. PCI does not record the ATS capability of such a device, even
+after a later full authorization, and sets ACS Translation Blocking for it
+where the path supports it.
+
+Adversary does not require an IOMMU. Without an IOMMU group, or with IOMMU
+support compiled out, binding uses the platform's normal DMA configuration.
+Adversary policy alone does not provide DMA isolation.
+
+Binding does not check the IOMMU domain. Neither a driver rule nor a sysfs
+policy write reconfigures it, so a policy selected after discovery may
+bind with an identity or deferred-invalidation domain. Select the policy
+with ``device_trust=`` or ``device_trust.default=`` for it to apply at
+discovery. Outside PCI, discovery does not select a domain. Changing a
+group's domain type through sysfs is not checked against trust. A setup
+failure after commitment leaves the chosen mode fixed; it cannot fall back
+to full.
+
+Adversarial IOMMU mappings that are not aligned to IOMMU pages need an
+active SWIOTLB bounce-buffer pool. Low-memory x86 systems may need
+``swiotlb=force`` to keep this pool available. Without it, mappings can fail
+even after the driver binds.
+
+Drivers marked ``driver_managed_dma`` bypass the kernel DMA API's default
+domain handling and must provide their own DMA containment. Drivers that
+do not use DMA need no domain.
+
+Initrd attestation sequence
+===========================
+
+For a device that uses normal driver attachment, such as a PCI function:
+
+1. Boot with ``device_trust.default=disabled`` to hold all devices, or
+   ``device_trust=pci:0000:01:00.0=disabled`` to hold one. Add exceptions
+   needed to reach the initrd and provide DMA containment while waiting.
+   ``device_trust.driver=pci:e1000=disabled`` can instead hold a known
+   driver; global disabled also covers other drivers. Disabled attempts
+   remain in WAITING, including attempts by built-in drivers.
+2. In the initrd, control probing and attest the current device through a
+   transport that works without its functional driver. Keep policy disabled
+   during verification and preparation. Leave it disabled if verification
+   fails or is unavailable. Removal or replacement invalidates the result;
+   a reused bus address is not proof of identity. Repeat attestation if a
+   reset or preparation step invalidates the evidence.
+3. Once all checks and preparation are complete, write adversary or full
+   to ``trust_policy``. This locks the choice and allows binding.
+4. Request binding through ``drivers_probe`` or another attach path. The
+   kernel commits the operating level before setup. Retries keep the same
+   policy and level. An attachment deferred before the driver's probe
+   callback returns ``-EAGAIN``; retry later. A successful write does not
+   guarantee that a driver bound, so check the device's ``driver`` link.
+
+Queued or concurrent probes may start as soon as step 3 completes, before
+step 4. Evidence must still be valid when authorizing the device.
+Boot exceptions that permit adversary or full allow early operation
+without fresh initrd attestation.
+
+The kernel interface provides neither an attestation transport nor a verifier.
+
+Driver use and independent properties
+=====================================
+
+Drivers read active trust with ``device_get_trust_level()`` or
+``device_is_adversarial()``. They may cache it while bound, but must not
+change requested policy or treat trust as proof of other security
+properties. Use the adversary check for features such as peer-to-peer DMA,
+device memory, PASID/SVA, or paths that bypass the DMA API. General DMA
+containment belongs in bus and IOMMU code.
+
+Discovery code uses ``device_policy_is_adversarial()`` to check requested
+policy before binding or after unbind. This helper does not resolve
+default policy or report active trust.
+
+Code that needs the level fixed for the device's lifetime can use
+``device_get_committed_trust_level()``. It returns disabled before
+commitment and the fixed level afterwards, including after failed setup
+or unbind. It does not permit operation while unbound.
+
+Trust does not describe transport protection, TDISP T=1/RUN, link
+encryption, private MMIO, verified evidence, or access to private versus
+shared memory. T=1 can use either adversary or full. In particular,
+``force_dma_unencrypted()`` describes DMA addressability and must not be
+derived from trust.
+
+Policy writes cannot revoke authorization or switch an operating device
+between adversary and full. Stopping it requires a separate procedure to
+quiesce the driver, tear down DMA, and contain the device on its bus.
diff --git a/Documentation/driver-api/driver-model/index.rst b/Documentation/driver-api/driver-model/index.rst
index abeb4b36636b6..af547cd13b2c4 100644
--- a/Documentation/driver-api/driver-model/index.rst
+++ b/Documentation/driver-api/driver-model/index.rst
@@ -9,6 +9,7 @@ Driver Model
    bus
    design-patterns
    device
+   device-trust
    devres
    driver
    overview

-- 
2.56.0

