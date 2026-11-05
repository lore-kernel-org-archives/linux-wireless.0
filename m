Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878995;
	b=wlj4Xy1T7kPEYjLnJ7d4fiGkv6fdztbZPrIfY5amkkOjl00MEv4W3jPQ7DVA2PtAASEH
	 O79D4qd+yRhtLqtzD1LVtm/J1YAp/nZ0vHAKswIhQJfDm8IkYpsj1xdF5v5K39b1xQ4Gk
	 P3aiH7Dk9IxHdHtRWuyRh/4xYcgrL9x3g/AQ0mO+n8oy0cVlZb97AGnK77UpctnrTtfWt
	 BdOZX0HTtd3h7kVgadJPrPgBGHwxByEV1/OhWvmYC0mCxI+xf4Umlc3miqPKrnpgst13o
	 PzuJJq1v/MWtyz21VwzGH3PTjvaf9mRJb1biumHjgCe+JGpJNzJBo6OcWe2WvPZTjmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=gaNFsq01nxojVQZO824AFivnqlGF9+tE3dhV8mgf0eU=;
	b=TE9HV7GhFT/9/cw9ah6wgDeRhvGMvAKVJz7dnHOwaHMhwSpKhd4XN0Jj/fRXPTizxij7
	 792FsCdqwVjvi58JgZn4EnOKXsdZXbA5kQFewixFE64kJQtZwAlu75X4Wy51xbVvJU7kB
	 fJ1LYKnjKQdjPT1aUDUqQajaD0Dtif27wo6GuXIBb5MNRrad1F8GfIu0C6F8CrTAI0FXh
	 jB4FmN5+MEg0UdAv/pwtyO5mBN/5jFoapBz7cMSvPGqcfXat1sS90hOFMgSG9ba4LmKPP
	 /nP5V7tjDLLlBDamRMNJYRSVCKB5+e6vqST1vp+MMyhKoNGXKhvwTPo+fKkTEy1uQfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ktoaPP4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F85E60A5BC6;
	Thu,  5 Nov 2026 11:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ktoaPP4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68861F000C1;
	Thu,  5 Nov 2026 11:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878994;
	bh=gaNFsq01nxojVQZO824AFivnqlGF9+tE3dhV8mgf0eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktoaPP4+NaFWiX019juh4oJ2h/91Nfjhnwow3WxUWL6nWj0ms/ohZP715F++yTsQi
	 /Yu4HGtAFUGPF5FcTmBw1K1DJqOYvWM2yHiJ25TAI8JnFRkDHICEwlWE4slFGqX84o
	 +fxIZZZEq5BOn46+UwPm5bWtNo6w5DBpOllGrnQJzG3BKfVCREkRfyzHWsvm/J76tJ
	 9LixfW3aQjmVrIyCs6i5Llc3cQrFvPJFcf9AGpC+mUhL1YD+38WZOzkNzb1SCOrr9x
	 0CwzPkGBdbsMPKX2kHV8PNkhWak6V3P3F76N4M7lehBTgWVMisuRe60tG6tZbFXpU9
	 weEj/puhF9w7Q==
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
Subject: [PATCH 11/17] driver core: Accept device trust policy on the kernel command line
Date: Thu,  5 Nov 2026 13:42:24 +0200
Message-ID: <20261105-device-trust-core-v1-11-1e536825b4eb@nvidia.com>
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

Built-in drivers can probe before initrd policy agents start. Fresh
attestation therefore requires disabled policy before those attempts.

Add device_trust=<bus>:<device>=<policy>[,...] to initialize requested
policy before registration. Apply PCI overrides during discovery so IOMMU
and ACS decisions use the same initial policy as binding. Retain rules for
hotplug, preserve admission history when a device object is reused, and
leave unlisted devices unchanged.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-devices-trust   |  2 +
 Documentation/admin-guide/kernel-parameters.txt | 25 +++++++
 drivers/base/base.h                             |  2 +
 drivers/base/core.c                             |  1 +
 drivers/base/trust.c                            | 90 +++++++++++++++++++++++++
 drivers/pci/probe.c                             |  1 +
 include/linux/device/trust.h                    |  1 +
 7 files changed, 122 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
index 97e07a174769c..87d3410f6bd90 100644
--- a/Documentation/ABI/testing/sysfs-devices-trust
+++ b/Documentation/ABI/testing/sysfs-devices-trust
@@ -17,6 +17,8 @@ Description:
 		value may be selected by the bus before the device is
 		registered; otherwise it is "default". The policy is resolved
 		to an active trust level before the device is probed.
+		A matching device_trust= kernel command-line entry overrides
+		the initial requested policy before registration.
 
 		The values are "default", "disabled", "adversary", and
 		"full". "default" lets the bus select the active trust level.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..ed307427a5ca4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1259,6 +1259,31 @@ Kernel parameters
 	dell_smm_hwmon.fan_max=
 			[HW] Maximum configurable fan speed.
 
+	device_trust=	[KNL]
+			Set requested device trust policy before driver probing,
+			including for drivers built into the kernel.
+			Format: <bus>:<device>=<policy>[,...]
+			The bus and device names must match exactly, as in
+			/sys/bus/<bus>/devices/<device>. The first colon separates
+			the bus name; further colons belong to the device name.
+			Policies are default, disabled, adversary, and full.
+			Entries override bus-initialized requested policy;
+			unlisted devices retain their existing policy.
+			The last entry for a device wins. If specified more than
+			once, the last valid list replaces all earlier lists.
+			Malformed lists are warned about and ignored in full.
+			Names containing whitespace, control characters, commas,
+			equals signs, or double quotes cannot be specified.
+			Rules also apply to devices added after boot.
+			Explicit disabled blocks early binding but permits later
+			authorization by writing adversary or full to trust_policy.
+			Rejected disabled probes leave this opportunity intact.
+			Authorization fixes the policy before probing; adversary
+			or full at boot permits early probes without attestation.
+			Example:
+			device_trust=pci:0000:01:00.0=adversary,pci:0000:02:00.0=disabled
+			See Documentation/driver-api/driver-model/device-trust.rst.
+
 	dfltcc=		[HW,S390]
 			Format: { on | off | def_only | inf_only | always }
 			on:       s390 zlib hardware support for compression on
diff --git a/drivers/base/base.h b/drivers/base/base.h
index c88b3302969f2..a286f48a69747 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -184,6 +184,8 @@ extern const struct attribute_group device_trust_attr_group;
 
 #if IS_ENABLED(CONFIG_KUNIT)
 int device_trust_set_policy(struct device *dev, enum device_trust_policy policy);
+int device_trust_parse_cmdline(const char *options, const struct device *dev,
+			       enum device_trust_policy *policy);
 #endif
 
 /* All active trust level transitions are serialized by the device lock. */
diff --git a/drivers/base/core.c b/drivers/base/core.c
index dca0179714c82..bd96d84c2ac2c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3688,6 +3688,7 @@ int device_add(struct device *dev)
 	if (error)
 		goto name_error;
 
+	device_trust_init(dev);
 	device_trust_init_state(dev);
 
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
diff --git a/drivers/base/trust.c b/drivers/base/trust.c
index 884e7c2dfbbb6..246d2516fb3af 100644
--- a/drivers/base/trust.c
+++ b/drivers/base/trust.c
@@ -1,8 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/ctype.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/export.h>
+#include <linux/init.h>
+#include <linux/string.h>
 #include <linux/sysfs.h>
 #include <kunit/visibility.h>
 
@@ -224,3 +227,90 @@ static struct attribute *device_trust_attrs[] = {
 const struct attribute_group device_trust_attr_group = {
 	.attrs = device_trust_attrs,
 };
+
+static const char *device_trust_cmdline __ro_after_init;
+
+VISIBLE_IF_KUNIT int device_trust_parse_cmdline(const char *options,
+						const struct device *dev,
+						enum device_trust_policy *policy)
+{
+	enum device_trust_policy selected = DEVICE_TRUST_POLICY_DEFAULT;
+	const char *entry = options;
+	bool matched = false;
+
+	if (!entry || !*entry)
+		return -EINVAL;
+
+	for (;;) {
+		const char *end = entry + strcspn(entry, ",");
+		const char *bus_end, *name, *level, *p;
+		unsigned int i;
+
+		bus_end = memchr(entry, ':', end - entry);
+		if (!bus_end || bus_end == entry ||
+		    memchr(entry, '=', bus_end - entry))
+			return -EINVAL;
+		name = bus_end + 1;
+		level = memchr(name, '=', end - name);
+		if (!level || level == name || level + 1 == end)
+			return -EINVAL;
+
+		for (p = entry; p < end; p++)
+			if (isspace(*p) || iscntrl(*p) || *p == '"')
+				return -EINVAL;
+
+		for (i = 0; i < ARRAY_SIZE(device_trust_policy_names); i++)
+			if (strlen(device_trust_policy_names[i]) == end - level - 1 &&
+			    !strncmp(level + 1, device_trust_policy_names[i],
+				     end - level - 1))
+				break;
+		if (i == ARRAY_SIZE(device_trust_policy_names))
+			return -EINVAL;
+
+		if (dev && dev->bus && dev_name(dev) &&
+		    strlen(dev->bus->name) == bus_end - entry &&
+		    !strncmp(dev->bus->name, entry, bus_end - entry) &&
+		    strlen(dev_name(dev)) == level - name &&
+		    !strncmp(dev_name(dev), name, level - name)) {
+			selected = i;
+			matched = true;
+		}
+
+		if (!*end)
+			break;
+		entry = end + 1;
+	}
+
+	if (matched)
+		*policy = selected;
+	return matched;
+}
+EXPORT_SYMBOL_IF_KUNIT(device_trust_parse_cmdline);
+
+static int __init device_trust_setup(char *str)
+{
+	if (device_trust_parse_cmdline(str, NULL, NULL) < 0) {
+		pr_warn("device_trust: ignoring invalid policy list '%s'\n", str);
+		return 1;
+	}
+
+	/* The command-line buffer survives init. */
+	device_trust_cmdline = str;
+	return 1;
+}
+__setup("device_trust=", device_trust_setup);
+
+/**
+ * device_trust_init - Apply boot policy before registration or bus policy use
+ * @dev: unregistered device with its bus, name, and default policy set
+ */
+void device_trust_init(struct device *dev)
+{
+	if (dev->p && dev->p->trust_initialized)
+		return;
+
+	if (device_trust_cmdline)
+		device_trust_parse_cmdline(device_trust_cmdline, dev,
+					   &dev->trust_policy);
+}
+EXPORT_SYMBOL_GPL(device_trust_init);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9a178e0e5f7f4..5b6960bbb35bc 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2083,6 +2083,7 @@ int pci_setup_device(struct pci_dev *dev)
 	set_pcie_cxl(dev);
 
 	set_pcie_untrusted(dev);
+	device_trust_init(&dev->dev);
 
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
diff --git a/include/linux/device/trust.h b/include/linux/device/trust.h
index dccc47c3b4960..b8f5514cacec3 100644
--- a/include/linux/device/trust.h
+++ b/include/linux/device/trust.h
@@ -37,6 +37,7 @@ enum device_trust_policy {
 	DEVICE_TRUST_POLICY_FULL,
 };
 
+void device_trust_init(struct device *dev);
 enum device_trust_level device_get_trust_level(const struct device *dev);
 bool device_is_adversarial(const struct device *dev);
 

-- 
2.56.0

