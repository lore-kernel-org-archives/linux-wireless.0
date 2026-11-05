Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878987;
	b=PulCxKGcx06rbOKWXUlvqVJ0Ezz43pIa+4H1AMNndyQusr3P8IJyoADh7eEK6oFjW5ow
	 5vkOwrrnj8MNP7ifh695j/nJ031gvuYBkoayKG5731UtOWKuzcoESgSBTOG+V+pEr7dsj
	 VUt/sI48kVH8k5S3R6LEz1zxTlr0kmKsdujV48J5xqWxKEe5jRXFEEL7rtgNyH8PcOHvU
	 AWHAeR0PuMdmEaDxkYmVb19LQbuahg6FG9hm6hJW7elRpxQuQ25FeY7evGKMAm7tHeGzD
	 cyb6iV8ACiBp2jTrq1CjMCKX4pRpEjEQApNSIO9kUfIv7vLQDAMqIUIDNjtcYxnhEDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=gj2TPocW8iMdx225PJmPOgombQ0i0K+1FaOyl1CeeGQ=;
	b=w7+aBM5fNOdguTG4K8qpevDM0UcLs8ONFk89AgE5qfnlJbrfiijUyq+iTnWXxwh8gOgc
	 DGFTse/mlUcqVsu8CJ6ewHvPwg9e8Ll4pHxLqlchaACcVMoHcGjLpfHh65+fCNeBz2TSR
	 o8dW34uWZEOOwt+6S1XJ9xsg9XfiCRI10IzPyc7N4qz8byLkfjR5btoQMSgLWwLi0Q3+2
	 T/OcZ21TOs12ySPHmy0AnNCQKH43NLeeMexkvx5cf0tCkj/qa/IKh5cD+Ds2nlq46spQw
	 AFp9+IFWtJSc7XWuHtD4WhbbsTfHvexBGd0XanZ9hnPUITeFivCPh+4pnZGV+UZ8KQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Da2lW5OC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ECA606EE8E;
	Thu,  5 Nov 2026 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Da2lW5OC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F34C1F00A15;
	Thu,  5 Nov 2026 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878987;
	bh=gj2TPocW8iMdx225PJmPOgombQ0i0K+1FaOyl1CeeGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da2lW5OCzzjSmUxqFaLJraS9AFQ+vtPDdYUk50TVA4qmPiTnNOpNR4PVmkHr4tSQ8
	 buGHCNaQzY9BHJD/pMIt3Zcis0biO0voLiAradJHqkxdseAo35JNgg53q8JpRcZWrd
	 2Tpcyw/4hV2TmXzs2uR8Y0vqbe/ivRFOirdxhRyxGuIMCWfB8r6fJ0ufZ4guTnufls
	 aeSDwGnC7jrY3rHKqvTNH+yMsH2p/CcxKxderhTOvYhs74qbXGJhb+FGdYWxoPjrU3
	 voKjf+anTDRfzJdRxpW2Q1ppEKWqBmKuNdfIbIwfppP9LmTWNRDdjOXdJubCR0MSZ/
	 Nt9BloSFM9EqQ==
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
Subject: [PATCH 09/17] driver core: Introduce a generic device trust level
Date: Thu,  5 Nov 2026 13:42:22 +0200
Message-ID: <20261105-device-trust-core-v1-9-1e536825b4eb@nvidia.com>
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

For a long time now there has been a PCI concept of 'untrusted' that
is set for things like Thunderbolt devices. The way the kernel uses
'untrusted' means the device should be assumed 'adversarial' (credit
to DJW for the name), that it could attack the kernel through its
operations.

This makes sense in a Thunderbolt context where you could just plug in
some PCIe device and get up to trouble. Currently the kernel responds
to this by forcing the iommu to strict mode, but we can also imagine
further defenses.

Take this general idea and promote it to a first class citizen in the
driver core so all busses can use it consistently, including the uAPI
that comes along with it.

A device has an active trust level DISABLED, ADVERSARY, and FULL. FULL
represents what Linux usually does today. ADVERSARY is close to PCI
untrusted, while DISABLED prevents a driver from binding.

A user configurable policy level sets the target trust level when the
device gets bound to a device, including DEFAULT meaning the bus gets
to choose the level. The active trust level is static while a driver
is bound, so userspace can only change the policy before binding the
driver.

Typically the kernel will boot with all devices set to a DEFAULT
policy. This will usually select a FULL trust level, except for PCI
Thunderbolt/etc which chooses ADVERSARY.

Aside from allowing userspace to arbitrarily select the ADVERSARY
mode, this is also the basic mechanism to allow userspace to inject
policy into the driver probing path. Later patches will allow the
kernel to enter the initrd with the policy set to DISABLED. In this
case a flow similar to commit b8c5cec23d5c ("Driver core: udev
triggered device-<>driver binding") allows userspace to inspect the
device, apply a policy, set the trust level, set other options like
PCIe link encryption, and then progress to allow the driver to bind.

Report an admission failure like a probe error, so that a driver
scan moves on to the next candidate. Export the getters to modules,
as drivers are expected to call them.

Keep the active level in struct device, so lockless readers do not
depend on the lifetime of device_private.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/base/Makefile        |   2 +-
 drivers/base/base.h          |  19 +++++++
 drivers/base/core.c          |   2 +
 drivers/base/dd.c            |  23 +++++++-
 drivers/base/trust.c         | 124 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h       |   6 +++
 include/linux/device/bus.h   |  10 ++++
 include/linux/device/trust.h |  43 +++++++++++++++
 8 files changed, 226 insertions(+), 3 deletions(-)

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 435710f643a5c..cb3bd5fa2287a 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -3,7 +3,7 @@
 
 obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
-			   cpu.o firmware.o init.o map.o devres.o \
+			   cpu.o firmware.o init.o map.o devres.o trust.o \
 			   attribute_container.o transport_class.o \
 			   topology.o container.o property.o cacheinfo.o \
 			   swnode.o faux.o
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 866b2beb6baa2..4683b9c2a8d83 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -10,6 +10,7 @@
  * shared outside of the drivers/base/ directory.
  *
  */
+#include <linux/device/trust.h>
 #include <linux/notifier.h>
 
 /**
@@ -88,6 +89,13 @@ struct driver_private {
 };
 #define to_driver(obj) container_of(obj, struct driver_private, kobj)
 
+enum device_trust_state {
+	DEVICE_TRUST_SELECTABLE,
+	DEVICE_TRUST_WAITING,
+	DEVICE_TRUST_AUTHORIZED,
+	DEVICE_TRUST_COMMITTED,
+};
+
 /**
  * struct device_private - structure to hold the private to the driver core
  *			   portions of the device structure.
@@ -105,6 +113,9 @@ struct driver_private {
  *			   dev_err_probe() for later retrieval via debugfs
  * @device: pointer back to the struct device that this structure is
  *	    associated with.
+ * @trust_committed_level: operating level retained across bind transactions
+ * @trust_state: policy admission state
+ * @trust_initialized: bus and boot policy have initialized admission state
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
@@ -121,6 +132,9 @@ struct device_private {
 	const struct device_driver *async_driver;
 	char *deferred_probe_reason;
 	struct device *device;
+	enum device_trust_level trust_committed_level;
+	enum device_trust_state trust_state;
+	u8 trust_initialized:1;
 	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
@@ -166,6 +180,11 @@ void bus_remove_driver(struct device_driver *drv);
 void device_release_driver_internal(struct device *dev, const struct device_driver *drv,
 				    struct device *parent);
 
+/* All active trust level transitions are serialized by the device lock. */
+void device_trust_init_state(struct device *dev);
+int device_trust_prepare(struct device *dev, const struct device_driver *drv);
+void device_trust_clear(struct device *dev);
+
 void driver_detach(const struct device_driver *drv);
 void driver_deferred_probe_del(struct device *dev);
 void device_set_deferred_probe_reason(const struct device *dev, struct va_format *vaf);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index cbe05197d4a0b..a0ffe74993677 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3681,6 +3681,8 @@ int device_add(struct device *dev)
 	if (error)
 		goto name_error;
 
+	device_trust_init_state(dev);
+
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
 
 	parent = get_device(dev->parent);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 01026e02de92e..0d83f62195f69 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -545,13 +545,21 @@ int device_bind_driver(struct device *dev)
 {
 	int ret;
 
+	if (dev->bus && dev->bus->trust_resolve)
+		return -EOPNOTSUPP;
+
+	ret = device_trust_prepare(dev, dev->driver);
+	if (ret)
+		return ret;
+
 	ret = driver_sysfs_add(dev);
 	if (!ret) {
 		device_links_force_bind(dev);
 		driver_bound(dev);
-	}
-	else
+	} else {
 		bus_notify(dev, BUS_NOTIFY_DRIVER_NOT_BOUND);
+		device_trust_clear(dev);
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(device_bind_driver);
@@ -679,6 +687,14 @@ static int really_probe(struct device *dev, const struct device_driver *drv)
 	}
 
 re_probe:
+	ret = device_trust_prepare(dev, drv);
+	if (ret) {
+		device_links_no_driver(dev);
+		/* Report it like a probe error so a scan tries the next driver. */
+		ret = -ret;
+		goto done;
+	}
+
 	device_set_driver(dev, drv);
 
 	/* If using pinctrl, bind pins now before probing */
@@ -745,6 +761,7 @@ static int really_probe(struct device *dev, const struct device_driver *drv)
 		if (dev->bus && dev->bus->dma_cleanup)
 			dev->bus->dma_cleanup(dev);
 		device_unbind_cleanup(dev);
+		device_trust_clear(dev);
 
 		goto re_probe;
 	}
@@ -771,6 +788,7 @@ static int really_probe(struct device *dev, const struct device_driver *drv)
 pinctrl_bind_failed:
 	device_links_no_driver(dev);
 	device_unbind_cleanup(dev);
+	device_trust_clear(dev);
 done:
 	return ret;
 }
@@ -1405,6 +1423,7 @@ static void __device_release_driver(struct device *dev, struct device *parent)
 			dev->bus->dma_cleanup(dev);
 
 		device_unbind_cleanup(dev);
+		device_trust_clear(dev);
 		device_links_driver_cleanup(dev);
 
 		klist_remove(&dev->p->knode_driver);
diff --git a/drivers/base/trust.c b/drivers/base/trust.c
new file mode 100644
index 0000000000000..10a135b8bf399
--- /dev/null
+++ b/drivers/base/trust.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <kunit/visibility.h>
+
+#include "base.h"
+
+void device_trust_init_state(struct device *dev)
+{
+	if (dev->p->trust_initialized)
+		return;
+
+	dev->p->trust_state = dev->trust_policy == DEVICE_TRUST_POLICY_DISABLED ?
+		DEVICE_TRUST_WAITING : DEVICE_TRUST_SELECTABLE;
+	dev->p->trust_initialized = true;
+}
+
+static bool device_trust_policy_matches(enum device_trust_policy policy,
+					enum device_trust_level level)
+{
+	switch (policy) {
+	case DEVICE_TRUST_POLICY_DEFAULT:
+		return true;
+	case DEVICE_TRUST_POLICY_DISABLED:
+		return level == DEVICE_TRUST_DISABLED;
+	case DEVICE_TRUST_POLICY_ADVERSARY:
+		return level == DEVICE_TRUST_ADVERSARY;
+	case DEVICE_TRUST_POLICY_FULL:
+		return level == DEVICE_TRUST_FULL;
+	default:
+		return false;
+	}
+}
+
+static int device_trust_resolve_default(enum device_trust_policy policy,
+					enum device_trust_level *level)
+{
+	switch (policy) {
+	case DEVICE_TRUST_POLICY_DEFAULT:
+	case DEVICE_TRUST_POLICY_FULL:
+		*level = DEVICE_TRUST_FULL;
+		return 0;
+	case DEVICE_TRUST_POLICY_DISABLED:
+		*level = DEVICE_TRUST_DISABLED;
+		return 0;
+	case DEVICE_TRUST_POLICY_ADVERSARY:
+		*level = DEVICE_TRUST_ADVERSARY;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+int device_trust_prepare(struct device *dev, const struct device_driver *drv)
+{
+	enum device_trust_policy policy;
+	enum device_trust_level level = DEVICE_TRUST_DISABLED;
+	int ret;
+
+	device_lock_assert(dev);
+	policy = dev->trust_policy;
+
+	if (WARN_ON_ONCE(READ_ONCE(dev->trust_level) != DEVICE_TRUST_DISABLED))
+		return -EBUSY;
+	if (policy == DEVICE_TRUST_POLICY_DISABLED)
+		return -EPERM;
+	if (dev->bus && dev->bus->trust_resolve)
+		ret = dev->bus->trust_resolve(dev, drv, policy, &level);
+	else
+		ret = device_trust_resolve_default(policy, &level);
+	if (ret)
+		return ret;
+
+	if (!device_trust_policy_matches(policy, level))
+		return -EINVAL;
+	if (level == DEVICE_TRUST_DISABLED)
+		return -EPERM;
+	if (level != DEVICE_TRUST_ADVERSARY && level != DEVICE_TRUST_FULL)
+		return -EINVAL;
+	if (dev->p->trust_state == DEVICE_TRUST_COMMITTED &&
+	    dev->p->trust_committed_level != level)
+		return -EINVAL;
+
+	dev->p->trust_committed_level = level;
+	dev->p->trust_state = DEVICE_TRUST_COMMITTED;
+	WRITE_ONCE(dev->trust_level, level);
+	return 0;
+}
+
+void device_trust_clear(struct device *dev)
+{
+	device_lock_assert(dev);
+	WRITE_ONCE(dev->trust_level, DEVICE_TRUST_DISABLED);
+}
+
+/**
+ * device_get_trust_level - Return a device's active trust level
+ * @dev: device to inspect
+ *
+ * The value is stable from the start of DMA configuration through the end of
+ * DMA cleanup. An unbound device has %DEVICE_TRUST_DISABLED as its active
+ * trust level.
+ *
+ * Return: The active trust level for the current bind transaction.
+ */
+enum device_trust_level device_get_trust_level(const struct device *dev)
+{
+	return READ_ONCE(dev->trust_level);
+}
+EXPORT_SYMBOL_GPL(device_get_trust_level);
+
+/**
+ * device_is_adversarial - Test whether a device is operated as an adversary
+ * @dev: device to inspect
+ *
+ * Return: True when the active trust level is %DEVICE_TRUST_ADVERSARY.
+ */
+bool device_is_adversarial(const struct device *dev)
+{
+	return device_get_trust_level(dev) == DEVICE_TRUST_ADVERSARY;
+}
+EXPORT_SYMBOL_GPL(device_is_adversarial);
diff --git a/include/linux/device.h b/include/linux/device.h
index 4cf62d69eac4f..5bd0cee874731 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -30,6 +30,7 @@
 #include <linux/device/class.h>
 #include <linux/device/devres.h>
 #include <linux/device/driver.h>
+#include <linux/device/trust.h>
 #include <linux/cleanup.h>
 #include <asm/device.h>
 
@@ -695,6 +696,9 @@ enum struct_device_flags {
  * @removable:  Whether the device can be removed from the system. This
  *              should be set by the subsystem / bus driver that discovered
  *              the device.
+ * @trust_policy: Requested operating policy, resolved before driver probe.
+ * @trust_level: Active trust level while a driver is bound, see
+ *		device_get_trust_level().
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -798,6 +802,8 @@ struct device {
 	struct device_physical_location *physical_location;
 
 	enum device_removable	removable;
+	enum device_trust_policy trust_policy;
+	enum device_trust_level trust_level;
 
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index 9ef7538a9a7f2..ba2b5743a47cd 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -17,6 +17,7 @@
 #include <linux/kobject.h>
 #include <linux/klist.h>
 #include <linux/pm.h>
+#include <linux/device/trust.h>
 
 struct device_driver;
 struct fwnode_handle;
@@ -59,6 +60,11 @@ struct fwnode_handle;
  * @resume:	Called to bring a device on this bus out of sleep mode.
  * @num_vf:	Called to find out how many virtual functions a device on this
  *		bus supports.
+ * @trust_resolve: Resolve a requested trust policy to an active trust level
+ *		immediately before driver probe. The device lock is held and
+ *		@drv is the candidate driver, which dev->driver does not name
+ *		yet. Return 0 on success or a negative errno. This callback
+ *		must not enable the device.
  * @dma_configure:	Called to setup DMA configuration on a device on
  *			this bus.
  * @dma_cleanup:	Called to cleanup DMA configuration on a device on
@@ -102,6 +108,10 @@ struct bus_type {
 
 	int (*num_vf)(struct device *dev);
 
+	int (*trust_resolve)(struct device *dev,
+			     const struct device_driver *drv,
+			     enum device_trust_policy policy,
+			     enum device_trust_level *level);
 	int (*dma_configure)(struct device *dev);
 	void (*dma_cleanup)(struct device *dev);
 
diff --git a/include/linux/device/trust.h b/include/linux/device/trust.h
new file mode 100644
index 0000000000000..dccc47c3b4960
--- /dev/null
+++ b/include/linux/device/trust.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _DEVICE_TRUST_H_
+#define _DEVICE_TRUST_H_
+
+#include <linux/types.h>
+
+struct device;
+
+/**
+ * enum device_trust_level - active trust level for a device
+ * @DEVICE_TRUST_DISABLED: The device cannot be operated by a driver
+ * @DEVICE_TRUST_ADVERSARY: Operate the device with adversarial restrictions
+ * @DEVICE_TRUST_FULL: Operate the device with the usual kernel privileges
+ *
+ * Active trust levels are discrete states, not an ordered privilege scale.
+ */
+enum device_trust_level {
+	DEVICE_TRUST_DISABLED,
+	DEVICE_TRUST_ADVERSARY,
+	DEVICE_TRUST_FULL,
+};
+
+/**
+ * enum device_trust_policy - requested device trust policy
+ * @DEVICE_TRUST_POLICY_DEFAULT: Let the bus select the active trust level
+ * @DEVICE_TRUST_POLICY_DISABLED: Request that the device remain disabled
+ * @DEVICE_TRUST_POLICY_ADVERSARY: Request adversarial operation
+ * @DEVICE_TRUST_POLICY_FULL: Request normal operation
+ *
+ * A requested policy is resolved to an active trust level before a driver is
+ * probed.
+ */
+enum device_trust_policy {
+	DEVICE_TRUST_POLICY_DEFAULT,
+	DEVICE_TRUST_POLICY_DISABLED,
+	DEVICE_TRUST_POLICY_ADVERSARY,
+	DEVICE_TRUST_POLICY_FULL,
+};
+
+enum device_trust_level device_get_trust_level(const struct device *dev);
+bool device_is_adversarial(const struct device *dev);
+
+#endif /* _DEVICE_TRUST_H_ */

-- 
2.56.0

