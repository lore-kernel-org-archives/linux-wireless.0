Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879006;
	b=CHqwrVYwTYGAh91Y7axvELhVwMeQkAQQAEarlNOMVo06JDqEE30k7mb0PcZzPAxU4OzE
	 b7/kZadRkiDCGuPaU90DkLwewjRQqREd1/sdadDMGsQEoFNivP55c6sdniPoM8Gwkwuyl
	 8bWx8X1AzJgbohPOvtjpIcST5d9sfX1KMuMNYckzygkVhBOgG4JbQ2c7ao678wK3pqBTH
	 bWqp2XCzfg8CrEU+b0rXNOtF9rp/hP5kmm6HnuVOel5mEC/vtynltkxrv+gmhVtgA4flP
	 pzWya8TAXxBAN4tUjen1zABqU7uEipv8D9Nmfw9EEfBJSuiYdadHQuv10B4XTU+brRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=vJ08kIh3fU2Kv3FC1ulY7FW/KTdOaU3pcZGA/RRKP8I=;
	b=sBtet8eANWhwZaj/k4j2dhFycFSCRrxXVS1TazgSgwB54PbA1OpoqDipfKypOFyRulpT
	 uZTOyKZ8fQPI+DYpuJBdB9fwVnUNq/SFLXJv+LWoFpn8XEbnN+/do3Tnf6EI7arHVQYbs
	 eOaCoLk/Jc+oRb/JjqsspsYwuwD8ymI3Iuned1/8AP+pUc07eyaty4AFpq00ePuULopTC
	 5oF9rlnptNJoQY1ebQwEypnf/5fuX0pIrPXdrZetiExjok9ZCHHW6zuZINR+1V/8FdXxD
	 D/mgqpEDaT83FyyOb34ZjChrW8gkwjshyvPGMpL9J3j0qRTPfwhtyZoAApSHGXFRXtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RW+ezBZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5598606A326;
	Thu,  5 Nov 2026 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RW+ezBZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938F61F000C1;
	Thu,  5 Nov 2026 11:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879005;
	bh=vJ08kIh3fU2Kv3FC1ulY7FW/KTdOaU3pcZGA/RRKP8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW+ezBZ8pbJY1ZKGpmr3QCnCDE5qhcyfC/iDLw5CRPX55jSISwj+Onj7cqhJmJhBe
	 p1xgkSVw2vuokOUt2b3KeFszOqqyKqEfQ7dCU0dEAR/VG2cHBIIIb+0GEQbcanvr44
	 wnPH4XF60NVzfock8sZ4W7ku+xFR1fCx/yPLH4cZNcGI8f/lkuUFdy3pyhbdTa6v4W
	 vzegHifVTFxVQh10YMzMr/BL5lO9k0XLFiaoHGGUfuzaJRyQcA7Kw4oKznvmdhFms8
	 zwvCr3xGVhg5dLTtrSpf6r4ccx5ziMZNwZORATBBZ0tRaOsbJJobrZkQymYRu0vtA0
	 jLz9I/1otcsuQ==
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
Subject: [PATCH 14/17] driver core: Add a global initial device trust policy
Date: Thu,  5 Nov 2026 13:42:27 +0200
Message-ID: <20261105-device-trust-core-v1-14-1e536825b4eb@nvidia.com>
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

Confidential guests may require fresh userspace attestation before
permitting any functional driver to probe. Listing individual devices on
the command line leaves unlisted hardware free to probe, and initrd policy
writes arrive too late for built-in drivers.

A system-wide initial policy is needed to keep unlisted devices waiting
for authorization while allowing explicit exceptions for devices needed
to reach the initrd. Existing boot behavior must remain available when
no global policy is selected.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-devices-trust   |  7 +++--
 Documentation/admin-guide/kernel-parameters.txt | 23 ++++++++++++--
 drivers/base/base.h                             |  3 ++
 drivers/base/trust.c                            | 41 ++++++++++++++++++++-----
 4 files changed, 62 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
index c0ce905b625d0..6f52102a1dfbf 100644
--- a/Documentation/ABI/testing/sysfs-devices-trust
+++ b/Documentation/ABI/testing/sysfs-devices-trust
@@ -17,8 +17,11 @@ Description:
 		value may be selected by the bus before the device is
 		registered; otherwise it is "default". The policy is resolved
 		to an active trust level before the device is probed.
-		A matching device_trust= kernel command-line entry overrides
-		the initial requested policy before registration.
+		A non-default device_trust.default= kernel command-line value
+		replaces the bus policy before registration. A matching
+		device_trust= entry takes precedence over both, regardless
+		of command-line order. Boot policy also applies to new devices
+		discovered after boot.
 		Otherwise, device_trust.driver= can initialize policy on the
 		first binding attempt with a matching driver rule. A successful
 		policy write, including the existing value, suppresses this
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b1d6999a5befa..458f59a8af854 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1267,9 +1267,8 @@ Kernel parameters
 			/sys/bus/<bus>/devices/<device>. The first colon separates
 			the bus name; further colons belong to the device name.
 			Policies are default, disabled, adversary, and full.
-			Entries override bus-initialized requested policy;
-			unlisted devices retain their existing policy.
-			Per-device entries take precedence over device_trust.driver.
+			Entries override device_trust.default, device_trust.driver,
+			and bus-initialized policy, regardless of option order.
 			The last entry for a device wins. If specified more than
 			once, the last valid list replaces all earlier lists.
 			Malformed lists are warned about and ignored in full.
@@ -1285,6 +1284,24 @@ Kernel parameters
 			device_trust=pci:0000:01:00.0=adversary,pci:0000:02:00.0=disabled
 			See Documentation/driver-api/driver-model/device-trust.rst.
 
+	device_trust.default=
+			[KNL] Set initial trust policy for devices without a
+			matching device_trust= entry, including hotplugged devices.
+			A matching device_trust.driver= rule can replace this
+			initial policy at the first binding attempt.
+			Format: { default | disabled | adversary | full }
+			default preserves bus-initialized policy (the default).
+			Other values override bus-initialized policy before
+			probing, including for built-in drivers.
+			The last valid value wins; invalid values are warned
+			about and ignored.
+			Without a matching driver rule, disabled prevents binding
+			until userspace authorizes each device by writing adversary
+			or full to trust_policy. Boot-critical devices need explicit
+			device or driver rules to operate before userspace. DMA
+			containment remains a bus and IOMMU responsibility.
+			See Documentation/driver-api/driver-model/device-trust.rst.
+
 	device_trust.driver=
 			[KNL] Set initial device trust policy by driver name,
 			including for drivers built into the kernel.
diff --git a/drivers/base/base.h b/drivers/base/base.h
index dd78857abf74f..5ff3217eb916e 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -193,6 +193,9 @@ bool device_trust_claim_allowed(const struct device *dev,
 				const struct device_driver *drv,
 				const char *device_options,
 				const char *driver_options);
+void device_trust_apply_boot_policy(struct device *dev,
+				    enum device_trust_policy policy,
+				    const char *options);
 #endif
 
 /* All active trust level transitions are serialized by the device lock. */
diff --git a/drivers/base/trust.c b/drivers/base/trust.c
index 4bcda888591a5..c2463b51c3a03 100644
--- a/drivers/base/trust.c
+++ b/drivers/base/trust.c
@@ -249,6 +249,7 @@ const struct attribute_group device_trust_attr_group = {
 
 static const char *device_trust_cmdline __ro_after_init;
 static const char *device_trust_driver_cmdline __ro_after_init;
+static enum device_trust_policy device_trust_default_policy __ro_after_init;
 
 static int device_trust_parse_policy(const char *options, const char *target_bus,
 				     const char *target_name,
@@ -410,18 +411,44 @@ static int __init device_trust_driver_setup(char *str)
 }
 __setup("device_trust.driver=", device_trust_driver_setup);
 
+static int __init device_trust_default_setup(char *str)
+{
+	int policy = match_string(device_trust_policy_names,
+				  ARRAY_SIZE(device_trust_policy_names), str);
+
+	if (policy < 0) {
+		pr_warn("device_trust: ignoring invalid default policy '%s'\n", str);
+		return 1;
+	}
+
+	device_trust_default_policy = policy;
+	return 1;
+}
+__setup("device_trust.default=", device_trust_default_setup);
+
+VISIBLE_IF_KUNIT void device_trust_apply_boot_policy(struct device *dev,
+						   enum device_trust_policy policy,
+						   const char *options)
+{
+	if (dev->p && dev->p->trust_initialized)
+		return;
+
+	if (policy != DEVICE_TRUST_POLICY_DEFAULT)
+		dev->trust_policy = policy;
+	if (options &&
+	    device_trust_parse_cmdline(options, dev, &dev->trust_policy) > 0 &&
+	    dev->p)
+		dev->p->trust_policy_override = true;
+}
+EXPORT_SYMBOL_IF_KUNIT(device_trust_apply_boot_policy);
+
 /**
  * device_trust_init - Apply boot policy before registration or bus policy use
  * @dev: unregistered device with its bus, name, and default policy set
  */
 void device_trust_init(struct device *dev)
 {
-	if (dev->p && dev->p->trust_initialized)
-		return;
-
-	if (device_trust_cmdline &&
-	    device_trust_parse_cmdline(device_trust_cmdline, dev,
-				       &dev->trust_policy) > 0 && dev->p)
-		dev->p->trust_policy_override = true;
+	device_trust_apply_boot_policy(dev, device_trust_default_policy,
+				       device_trust_cmdline);
 }
 EXPORT_SYMBOL_GPL(device_trust_init);

-- 
2.56.0

