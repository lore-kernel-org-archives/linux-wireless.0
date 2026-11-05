Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878991;
	b=bCSWsjZg5SOlWcGujDsl+y4pIYnADJW4Koe1mbxB7xq6dPC3N8QzjwYDi3uO5gGcMM3A
	 IMtGv2xCmJpQQsMKQ0JiTvrfGLVt56C8Q3WPrZoX4y3TTQUJ3IcB0dYWC4T2+nPFm8/oJ
	 q8huYXOc0AGsktH6x0UQrqfX8GyK53LbZekKoirP1urUH2icVliIhE10+yHC4nuEvj6Rd
	 gl3okf+kLsWQSXUxPd2gwH9lRnyxREXoiuzGrQ1tkkWSiU5gCrXWB2OOntYEO6ADVNWeN
	 xM4XkIf932juBzMuyLlxjLYbXxUzmcZZLxYbOW9TrzHY7ciz+JLIFXX9AiZigZk+dvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=To1pchWJNq8O58SS1SPMwu0h1sZmzD6KnBh+BH7g+b8=;
	b=MvIcgBaURN8D/PhJkpo1YbdiY8t8Bf+vcW4EqPsKuUJX6miaOeD0TQ6NBIBeeEoxhnv0
	 AR2c+SEvtBsrlonPcsTbpSUQOaQqvRruMmyVcrN5FxbhZ/GNcm9yTnepHJWSsO08FtK0z
	 HHbfBrwPV7v9GUq00YwRhBYAYq6nNA8vysiRGSahkgUVqjBjdt5ALJm8Q6CPlOLyF7V3r
	 UujouEohOvYH4pN06leeyzoRIwmC4PfiCkGBbWxmRhFtcRxQzSuhUKv62zsjVMMORjG90
	 LjoKIPH5acC/wvRetaXztjcjy/z9ssLDUDTub/hQVfV3/PXFDWdWnANLCB/vER8La2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PYJ0DDWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AD660A2630;
	Thu,  5 Nov 2026 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PYJ0DDWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA9A1F000C1;
	Thu,  5 Nov 2026 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878991;
	bh=To1pchWJNq8O58SS1SPMwu0h1sZmzD6KnBh+BH7g+b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYJ0DDWicQT5hXAFcIfiX/QnAroRb6yU1aQNeVFnaiUwm0lU2m0vwts4DphsnsxBh
	 oQ50LpLcoIa8LeO9Bt7JHPIWz3Gt0A5agsosplf/v3xDDnG1tmZb0B3zg6Z/NyhYFA
	 /wWFAGdL38tmhOsqIauGcW3fwlS6rMaT5OlHJR5j3Xfbujkpg2ZxBBxb0x8aHiDFjj
	 7m9OY9ZpYfvOBEYCnhQ9lPg90teUbhVvpP/tPkKbI6xfN9ZqI/+kjmOgGe4ZbKC9tM
	 acekT8pcraLHM4BSD2eYyns4AxrPr1AU74fwLyfn0B1JuvKq5z0NnXNs1F5gFOAEk+
	 bcoLd8Zd0g4xw==
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
Subject: [PATCH 10/17] driver core: Expose device trust authorization through sysfs
Date: Thu,  5 Nov 2026 13:42:23 +0200
Message-ID: <20261105-device-trust-core-v1-10-1e536825b4eb@nvidia.com>
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

An initrd must authorize a disabled device after attestation even if a
built-in driver already attempted to probe it.

Expose requested trust_policy and read-only active trust. Allow explicit
disabled policy to advance once to adversary or full, fixing that decision
immediately. Reject later policy changes, including for a device claimed
before registration, while allowing same-value writes on live devices.
Keep initial unrestricted selection separate from explicit authorization
and bind-time commitment. Serialize writes with probing under the device
lock. Include the attributes in device ownership changes.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-devices-trust |  51 +++++++++++++
 MAINTAINERS                                   |   1 +
 drivers/base/base.h                           |   6 ++
 drivers/base/core.c                           |  15 +++-
 drivers/base/trust.c                          | 102 ++++++++++++++++++++++++++
 5 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
new file mode 100644
index 0000000000000..97e07a174769c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-trust
@@ -0,0 +1,51 @@
+What:		/sys/devices/.../trust
+Date:		September 2026
+Contact:	driver-core@lists.linux.dev
+Description:
+		(RO) The active trust level for the device. The values are
+		"disabled", "adversary", and "full". Driver core resolves
+		the level before DMA configuration and probe, and retains it
+		through removal and DMA cleanup. Outside a bind transaction
+		the level is "disabled". This does not imply that policy is
+		writable or that the device has never operated.
+
+What:		/sys/devices/.../trust_policy
+Date:		September 2026
+Contact:	driver-core@lists.linux.dev
+Description:
+		(RW) The requested trust policy for the device. The initial
+		value may be selected by the bus before the device is
+		registered; otherwise it is "default". The policy is resolved
+		to an active trust level before the device is probed.
+
+		The values are "default", "disabled", "adversary", and
+		"full". "default" lets the bus select the active trust level.
+		"disabled" prevents a functional driver from binding.
+		"adversary" requests operation with the restrictions that the
+		bus and DMA layers can enforce for a potentially malicious
+		device; it does not isolate DMA by itself. "full" requests
+		normal operation.
+
+		Before an operating level is committed, policy may change
+		freely until "disabled" is selected. Explicit "disabled"
+		blocks binding while allowing a later write of "adversary" or
+		"full". Repeated rejected probes preserve this opportunity.
+		Authorization immediately fixes the requested policy.
+		Returning to "default" or "disabled", or selecting another
+		mode, fails.
+
+		Successful resolution to an allowed level commits policy
+		and operating level before driver or DMA setup. Both remain
+		fixed for the device object's lifetime, including through
+		failed or deferred probes, unbind, reset, and driver reload.
+		Later binds must resolve to the same level, including when
+		the policy is "default". A resolver error or disabled result
+		before commitment leaves the policy's writability unchanged.
+
+		For a live device, writing the existing value succeeds
+		without changing state. Other forbidden writes fail with
+		EBUSY; invalid strings fail with EINVAL. Removed devices
+		reject writes with ENODEV. Writes do not trigger probing or
+		attestation.
+		Queued probes may proceed immediately after authorization,
+		so userspace must complete verification before granting it.
diff --git a/MAINTAINERS b/MAINTAINERS
index b726344362b41..a145aaaca2ef3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8150,6 +8150,7 @@ L:	driver-core@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
 F:	Documentation/ABI/testing/sysfs-bus-drivers-probe
+F:	Documentation/ABI/testing/sysfs-devices-trust
 F:	Documentation/core-api/kobject.rst
 F:	Documentation/driver-api/driver-model/
 F:	drivers/base/
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 4683b9c2a8d83..c88b3302969f2 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -180,6 +180,12 @@ void bus_remove_driver(struct device_driver *drv);
 void device_release_driver_internal(struct device *dev, const struct device_driver *drv,
 				    struct device *parent);
 
+extern const struct attribute_group device_trust_attr_group;
+
+#if IS_ENABLED(CONFIG_KUNIT)
+int device_trust_set_policy(struct device *dev, enum device_trust_policy policy);
+#endif
+
 /* All active trust level transitions are serialized by the device lock. */
 void device_trust_init_state(struct device *dev);
 int device_trust_prepare(struct device *dev, const struct device_driver *drv);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index a0ffe74993677..dca0179714c82 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2989,10 +2989,14 @@ static int device_add_attrs(struct device *dev)
 	if (error)
 		goto err_remove_type_groups;
 
+	error = device_add_group(dev, &device_trust_attr_group);
+	if (error)
+		goto err_remove_dev_groups;
+
 	if (device_supports_offline(dev) && !dev_offline_disabled(dev)) {
 		error = device_create_file(dev, &dev_attr_online);
 		if (error)
-			goto err_remove_dev_groups;
+			goto err_remove_dev_trust_group;
 	}
 
 	if (fw_devlink_flags && !fw_devlink_is_permissive() && dev->fwnode) {
@@ -3022,6 +3026,8 @@ static int device_add_attrs(struct device *dev)
 	device_remove_file(dev, &dev_attr_waiting_for_supplier);
  err_remove_dev_online:
 	device_remove_file(dev, &dev_attr_online);
+ err_remove_dev_trust_group:
+	device_remove_group(dev, &device_trust_attr_group);
  err_remove_dev_groups:
 	device_remove_groups(dev, dev->groups);
  err_remove_type_groups:
@@ -3047,6 +3053,7 @@ static void device_remove_attrs(struct device *dev)
 	device_remove_file(dev, &dev_attr_removable);
 	device_remove_file(dev, &dev_attr_waiting_for_supplier);
 	device_remove_file(dev, &dev_attr_online);
+	device_remove_group(dev, &device_trust_attr_group);
 	device_remove_groups(dev, dev->groups);
 
 	if (type)
@@ -4790,6 +4797,12 @@ static int device_attrs_change_owner(struct device *dev, kuid_t kuid,
 	if (error)
 		return error;
 
+	/* Change the trust attributes of @dev to @kuid/@kgid. */
+	error = sysfs_group_change_owner(kobj, &device_trust_attr_group, kuid,
+					 kgid);
+	if (error)
+		return error;
+
 	if (device_supports_offline(dev) && !dev_offline_disabled(dev)) {
 		/* Change online device attributes of @dev to @kuid/@kgid. */
 		error = sysfs_file_change_owner(kobj, dev_attr_online.attr.name,
diff --git a/drivers/base/trust.c b/drivers/base/trust.c
index 10a135b8bf399..884e7c2dfbbb6 100644
--- a/drivers/base/trust.c
+++ b/drivers/base/trust.c
@@ -3,6 +3,7 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/export.h>
+#include <linux/sysfs.h>
 #include <kunit/visibility.h>
 
 #include "base.h"
@@ -122,3 +123,104 @@ bool device_is_adversarial(const struct device *dev)
 	return device_get_trust_level(dev) == DEVICE_TRUST_ADVERSARY;
 }
 EXPORT_SYMBOL_GPL(device_is_adversarial);
+
+static const char * const device_trust_policy_names[] = {
+	[DEVICE_TRUST_POLICY_DEFAULT] = "default",
+	[DEVICE_TRUST_POLICY_DISABLED] = "disabled",
+	[DEVICE_TRUST_POLICY_ADVERSARY] = "adversary",
+	[DEVICE_TRUST_POLICY_FULL] = "full",
+};
+
+static const char * const device_trust_level_names[] = {
+	[DEVICE_TRUST_DISABLED] = "disabled",
+	[DEVICE_TRUST_ADVERSARY] = "adversary",
+	[DEVICE_TRUST_FULL] = "full",
+};
+
+static ssize_t trust_show(struct device *dev,
+			  const struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+			  device_trust_level_names[device_get_trust_level(dev)]);
+}
+static DEVICE_ATTR_RO(trust);
+
+static ssize_t trust_policy_show(struct device *dev,
+				 const struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+			  device_trust_policy_names[READ_ONCE(dev->trust_policy)]);
+}
+
+VISIBLE_IF_KUNIT int device_trust_set_policy(struct device *dev,
+					   enum device_trust_policy policy)
+{
+	int ret = 0;
+
+	if (policy < DEVICE_TRUST_POLICY_DEFAULT ||
+	    policy > DEVICE_TRUST_POLICY_FULL)
+		return -EINVAL;
+
+	device_lock(dev);
+	if (dev->p->dead) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+	if (policy == dev->trust_policy)
+		goto unlock;
+
+	/* A driver that claimed the device before registration was not admitted. */
+	if (READ_ONCE(dev->driver)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	switch (dev->p->trust_state) {
+	case DEVICE_TRUST_SELECTABLE:
+		if (policy == DEVICE_TRUST_POLICY_DISABLED)
+			dev->p->trust_state = DEVICE_TRUST_WAITING;
+		break;
+	case DEVICE_TRUST_WAITING:
+		if (policy != DEVICE_TRUST_POLICY_ADVERSARY &&
+		    policy != DEVICE_TRUST_POLICY_FULL) {
+			ret = -EBUSY;
+			goto unlock;
+		}
+		dev->p->trust_state = DEVICE_TRUST_AUTHORIZED;
+		break;
+	default:
+		ret = -EBUSY;
+		goto unlock;
+	}
+	WRITE_ONCE(dev->trust_policy, policy);
+unlock:
+	device_unlock(dev);
+	return ret;
+}
+EXPORT_SYMBOL_IF_KUNIT(device_trust_set_policy);
+
+static ssize_t trust_policy_store(struct device *dev,
+				  const struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int policy, ret;
+
+	policy = sysfs_match_string(device_trust_policy_names, buf);
+	if (policy < 0)
+		return policy;
+
+	ret = device_trust_set_policy(dev, policy);
+
+	return ret ? ret : count;
+}
+static DEVICE_ATTR_RW(trust_policy);
+
+static struct attribute *device_trust_attrs[] = {
+	&dev_attr_trust.attr,
+	&dev_attr_trust_policy.attr,
+	NULL,
+};
+
+const struct attribute_group device_trust_attr_group = {
+	.attrs = device_trust_attrs,
+};

-- 
2.56.0

