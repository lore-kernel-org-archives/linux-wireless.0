Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878999;
	b=vettFASexpqkh2p5hI02thL0sG4w4N91R3MNJ3baiXdpJcR9W5bTA9DuKaThX2IlYBcF
	 3Z9tbmWBN7zsufE38pjSz7AUY2ljNriJWndAP+YugmbfUIe7ejbfNpE+QFeyriaPTfTqS
	 NTgP7htPubu0kCyBKw96YLt1IEIw31J/ayFQzXxUZiFV8GNraCYBb/jIwj8FMP+dIOOK7
	 s/lH+0V2E/1MbO2WjpjL26FHfEliIwTOC9ig7zJAVCRFPRYguKnqhoVK6PqzU3bGbV2NQ
	 Uo01ygB13rqN6nFGtwRE9PrhKpAG9oT6m5RjncA9rWc66Hsyuo3WlFd5TfxMfECH6JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=/as9IdUAdpPoCkqkMuIQz0gQ0/jte3WMkR6h2mQdsOU=;
	b=Dl+fIPrFK8Cq8YpXwdKNNajQg38fgR8H0MMJoZ7lTVVQrHpzVmDz4gpDulPXjiEWEiJ+
	 lxz8af5LjDnA8zevKXWw+E0FvINFyf3mV1wuUiqR+9ITUPb7xGeZrrKMqGyoI4OCMpeJ6
	 sEgrx/ot/47i611QvpHWf0Cc4vBoG/RhxxD/20zD16eBVVzIfUs/1nlhe5yKJ/t91RacK
	 60EstvLsQIHXr5gc4mO/6Ow3EXu0j4ptd73qap4I4IxNThOC6hW8rR8d4Sdg2hHgYZ/ag
	 593PU81qGwm2hFcsGIV5gwdZyheRvkqg4zIlvWIgwn9dAUx9E2Q1hZGZwUWv0V5+DXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=etnmcbs2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0B460A6F45;
	Thu,  5 Nov 2026 11:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=etnmcbs2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C5D1F000C1;
	Thu,  5 Nov 2026 11:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878998;
	bh=/as9IdUAdpPoCkqkMuIQz0gQ0/jte3WMkR6h2mQdsOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etnmcbs2Bn+VzmMK/YrvNxXzrxhzPLvgHbXNqNC40YPrfaYWf1ZQUeo9rPXUIjqzr
	 wRHJEAWuH4+uvWTV4qsvwQakJ0/qO8s8S0wImDYtMNq0bbmqwNWElxDEM1fzKRxr8K
	 x/wwEOPyjYk1cXFUI+4zGzgR1Q5/8bCHEvD0UppNDSvhdJaElqmWGeFpcdOe6RqGmX
	 nSa5jL7TKEflkWgGQIKP9h690CZtyn5UJcX4L4ADbQX98FQTdmFguNllwxsYKNCzKZ
	 3+NKcXoyy0hnjzQkcEOuB9HSldrvsxLhZ10cOZ2eoNDbzwWKCale1HzecnExBONTUr
	 HE4I46vfD5d4g==
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
Subject: [PATCH 12/17] driver core: Accept device trust policy by driver name
Date: Thu,  5 Nov 2026 13:42:25 +0200
Message-ID: <20261105-device-trust-core-v1-12-1e536825b4eb@nvidia.com>
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

Device addresses can change between boots and cannot conveniently name
every device handled by a driver, including devices discovered later.
Userspace arrives too late to choose the initial policy for built-in
drivers.

Administrators need a driver-wide boot default without weakening an
explicit device policy, userspace authorization, or a device's lifetime
trust commitment.

A driver may claim a USB interface before it is registered, which skips
admission. Let USB refuse such a claim early when the interface's own
policy is disabled, and leave driver rules to admission at registration.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-devices-trust   |   5 +
 Documentation/admin-guide/kernel-parameters.txt |  22 +++++
 drivers/base/base.h                             |   9 ++
 drivers/base/trust.c                            | 124 +++++++++++++++++++++---
 drivers/usb/core/driver.c                       |   5 +
 drivers/usb/core/message.c                      |   2 +
 include/linux/device/trust.h                    |   3 +
 7 files changed, 157 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-trust b/Documentation/ABI/testing/sysfs-devices-trust
index 87d3410f6bd90..c0ce905b625d0 100644
--- a/Documentation/ABI/testing/sysfs-devices-trust
+++ b/Documentation/ABI/testing/sysfs-devices-trust
@@ -19,6 +19,11 @@ Description:
 		to an active trust level before the device is probed.
 		A matching device_trust= kernel command-line entry overrides
 		the initial requested policy before registration.
+		Otherwise, device_trust.driver= can initialize policy on the
+		first binding attempt with a matching driver rule. A successful
+		policy write, including the existing value, suppresses this
+		deferred initialization. Driver rules do not change an existing
+		authorization or commitment and apply at most once per device.
 
 		The values are "default", "disabled", "adversary", and
 		"full". "default" lets the bus select the active trust level.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ed307427a5ca4..b1d6999a5befa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1269,6 +1269,7 @@ Kernel parameters
 			Policies are default, disabled, adversary, and full.
 			Entries override bus-initialized requested policy;
 			unlisted devices retain their existing policy.
+			Per-device entries take precedence over device_trust.driver.
 			The last entry for a device wins. If specified more than
 			once, the last valid list replaces all earlier lists.
 			Malformed lists are warned about and ignored in full.
@@ -1284,6 +1285,27 @@ Kernel parameters
 			device_trust=pci:0000:01:00.0=adversary,pci:0000:02:00.0=disabled
 			See Documentation/driver-api/driver-model/device-trust.rst.
 
+	device_trust.driver=
+			[KNL] Set initial device trust policy by driver name,
+			including for drivers built into the kernel.
+			Format: <bus>:<driver>=<policy>[,...]
+			Names match exactly as in /sys/bus/<bus>/drivers/<driver>.
+			Policies are default, disabled, adversary, and full.
+			The name restrictions and repeated-list rules are the same
+			as device_trust=. Module aliases and wildcards are not
+			expanded. Rules remain available for hotplug and modules.
+			The first binding attempt with a matching rule applies it
+			once, before trust resolution and driver or DMA setup.
+			A per-device device_trust= entry or any successful write
+			to trust_policy, even of its current value, takes precedence.
+			Rules never replace an existing authorization or commitment.
+			A rejected disabled attempt leaves the device disabled until
+			userspace authorizes it, including across driver changes.
+			Driver rules apply after bus discovery and do not reconfigure
+			IOMMU domains. Adversary operation needs suitable existing
+			DMA configuration; see the device trust documentation.
+			Example: device_trust.driver=pci:e1000=disabled,pci:nvme=full
+
 	dfltcc=		[HW,S390]
 			Format: { on | off | def_only | inf_only | always }
 			on:       s390 zlib hardware support for compression on
diff --git a/drivers/base/base.h b/drivers/base/base.h
index a286f48a69747..b4441242496f7 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -116,6 +116,7 @@ enum device_trust_state {
  * @trust_committed_level: operating level retained across bind transactions
  * @trust_state: policy admission state
  * @trust_initialized: bus and boot policy have initialized admission state
+ * @trust_policy_override: explicit policy prevents deferred driver boot policy
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
@@ -135,6 +136,7 @@ struct device_private {
 	enum device_trust_level trust_committed_level;
 	enum device_trust_state trust_state;
 	u8 trust_initialized:1;
+	u8 trust_policy_override:1;
 	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
@@ -186,6 +188,13 @@ extern const struct attribute_group device_trust_attr_group;
 int device_trust_set_policy(struct device *dev, enum device_trust_policy policy);
 int device_trust_parse_cmdline(const char *options, const struct device *dev,
 			       enum device_trust_policy *policy);
+void device_trust_apply_driver_policy(struct device *dev,
+				      const struct device_driver *drv,
+				      const char *options);
+bool device_trust_claim_allowed(const struct device *dev,
+				const struct device_driver *drv,
+				const char *device_options,
+				const char *driver_options);
 #endif
 
 /* All active trust level transitions are serialized by the device lock. */
diff --git a/drivers/base/trust.c b/drivers/base/trust.c
index 246d2516fb3af..b38f69e440eae 100644
--- a/drivers/base/trust.c
+++ b/drivers/base/trust.c
@@ -11,6 +11,9 @@
 
 #include "base.h"
 
+static void device_trust_init_driver_policy(struct device *dev,
+					   const struct device_driver *drv);
+
 void device_trust_init_state(struct device *dev)
 {
 	if (dev->p->trust_initialized)
@@ -64,10 +67,11 @@ int device_trust_prepare(struct device *dev, const struct device_driver *drv)
 	int ret;
 
 	device_lock_assert(dev);
-	policy = dev->trust_policy;
 
 	if (WARN_ON_ONCE(READ_ONCE(dev->trust_level) != DEVICE_TRUST_DISABLED))
 		return -EBUSY;
+	device_trust_init_driver_policy(dev, drv);
+	policy = dev->trust_policy;
 	if (policy == DEVICE_TRUST_POLICY_DISABLED)
 		return -EPERM;
 	if (dev->bus && dev->bus->trust_resolve)
@@ -170,7 +174,7 @@ VISIBLE_IF_KUNIT int device_trust_set_policy(struct device *dev,
 		goto unlock;
 	}
 	if (policy == dev->trust_policy)
-		goto unlock;
+		goto set_policy;
 
 	/* A driver that claimed the device before registration was not admitted. */
 	if (READ_ONCE(dev->driver)) {
@@ -195,7 +199,9 @@ VISIBLE_IF_KUNIT int device_trust_set_policy(struct device *dev,
 		ret = -EBUSY;
 		goto unlock;
 	}
+set_policy:
 	WRITE_ONCE(dev->trust_policy, policy);
+	dev->p->trust_policy_override = true;
 unlock:
 	device_unlock(dev);
 	return ret;
@@ -229,10 +235,11 @@ const struct attribute_group device_trust_attr_group = {
 };
 
 static const char *device_trust_cmdline __ro_after_init;
+static const char *device_trust_driver_cmdline __ro_after_init;
 
-VISIBLE_IF_KUNIT int device_trust_parse_cmdline(const char *options,
-						const struct device *dev,
-						enum device_trust_policy *policy)
+static int device_trust_parse_policy(const char *options, const char *target_bus,
+				     const char *target_name,
+				     enum device_trust_policy *policy)
 {
 	enum device_trust_policy selected = DEVICE_TRUST_POLICY_DEFAULT;
 	const char *entry = options;
@@ -267,11 +274,11 @@ VISIBLE_IF_KUNIT int device_trust_parse_cmdline(const char *options,
 		if (i == ARRAY_SIZE(device_trust_policy_names))
 			return -EINVAL;
 
-		if (dev && dev->bus && dev_name(dev) &&
-		    strlen(dev->bus->name) == bus_end - entry &&
-		    !strncmp(dev->bus->name, entry, bus_end - entry) &&
-		    strlen(dev_name(dev)) == level - name &&
-		    !strncmp(dev_name(dev), name, level - name)) {
+		if (target_bus && target_name &&
+		    strlen(target_bus) == bus_end - entry &&
+		    !strncmp(target_bus, entry, bus_end - entry) &&
+		    strlen(target_name) == level - name &&
+		    !strncmp(target_name, name, level - name)) {
 			selected = i;
 			matched = true;
 		}
@@ -285,8 +292,86 @@ VISIBLE_IF_KUNIT int device_trust_parse_cmdline(const char *options,
 		*policy = selected;
 	return matched;
 }
+
+VISIBLE_IF_KUNIT int device_trust_parse_cmdline(const char *options,
+						const struct device *dev,
+						enum device_trust_policy *policy)
+{
+	return device_trust_parse_policy(options, dev && dev->bus ? dev->bus->name : NULL,
+					 dev ? dev_name(dev) : NULL, policy);
+}
 EXPORT_SYMBOL_IF_KUNIT(device_trust_parse_cmdline);
 
+VISIBLE_IF_KUNIT void device_trust_apply_driver_policy(struct device *dev,
+						     const struct device_driver *drv,
+						     const char *options)
+{
+	enum device_trust_policy policy;
+
+	device_lock_assert(dev);
+	if (!options || !drv || dev->p->trust_policy_override ||
+	    (dev->p->trust_state != DEVICE_TRUST_SELECTABLE &&
+	     dev->p->trust_state != DEVICE_TRUST_WAITING))
+		return;
+
+	if (device_trust_parse_policy(options, drv->bus ? drv->bus->name : NULL,
+				      drv->name, &policy) <= 0)
+		return;
+
+	WRITE_ONCE(dev->trust_policy, policy);
+	dev->p->trust_state = policy == DEVICE_TRUST_POLICY_DISABLED ?
+		DEVICE_TRUST_WAITING : DEVICE_TRUST_SELECTABLE;
+	dev->p->trust_policy_override = true;
+}
+EXPORT_SYMBOL_IF_KUNIT(device_trust_apply_driver_policy);
+
+static void device_trust_init_driver_policy(struct device *dev,
+					   const struct device_driver *drv)
+{
+	device_trust_apply_driver_policy(dev, drv, device_trust_driver_cmdline);
+}
+
+/*
+ * A matching driver rule is applied, together with its admission state, when
+ * the device is registered, so only the device's own policy rejects a claim.
+ */
+VISIBLE_IF_KUNIT bool device_trust_claim_allowed(const struct device *dev,
+						 const struct device_driver *drv,
+						 const char *device_options,
+						 const char *driver_options)
+{
+	enum device_trust_policy policy = READ_ONCE(dev->trust_policy);
+	bool device_rule = device_options &&
+		device_trust_parse_cmdline(device_options, dev, &policy) > 0;
+
+	if (!device_rule && driver_options && drv &&
+	    device_trust_parse_policy(driver_options,
+				      drv->bus ? drv->bus->name : NULL,
+				      drv->name, &policy) > 0)
+		return true;
+
+	return policy != DEVICE_TRUST_POLICY_DISABLED;
+}
+EXPORT_SYMBOL_IF_KUNIT(device_trust_claim_allowed);
+
+/**
+ * device_trust_may_claim - Test whether a driver may claim an unregistered device
+ * @dev: device with its bus, name, and boot policy set
+ * @drv: driver that claims the device
+ *
+ * A driver can claim a device before it is registered, which skips the bind
+ * attempt that admits it. Reject a claim that the device's own policy forbids.
+ *
+ * Return: False if the policy of @dev rejects the claim.
+ */
+bool device_trust_may_claim(const struct device *dev,
+			    const struct device_driver *drv)
+{
+	return device_trust_claim_allowed(dev, drv, device_trust_cmdline,
+					  device_trust_driver_cmdline);
+}
+EXPORT_SYMBOL_GPL(device_trust_may_claim);
+
 static int __init device_trust_setup(char *str)
 {
 	if (device_trust_parse_cmdline(str, NULL, NULL) < 0) {
@@ -300,6 +385,18 @@ static int __init device_trust_setup(char *str)
 }
 __setup("device_trust=", device_trust_setup);
 
+static int __init device_trust_driver_setup(char *str)
+{
+	if (device_trust_parse_policy(str, NULL, NULL, NULL) < 0) {
+		pr_warn("device_trust: ignoring invalid driver policy list '%s'\n", str);
+		return 1;
+	}
+
+	device_trust_driver_cmdline = str;
+	return 1;
+}
+__setup("device_trust.driver=", device_trust_driver_setup);
+
 /**
  * device_trust_init - Apply boot policy before registration or bus policy use
  * @dev: unregistered device with its bus, name, and default policy set
@@ -309,8 +406,9 @@ void device_trust_init(struct device *dev)
 	if (dev->p && dev->p->trust_initialized)
 		return;
 
-	if (device_trust_cmdline)
-		device_trust_parse_cmdline(device_trust_cmdline, dev,
-					   &dev->trust_policy);
+	if (device_trust_cmdline &&
+	    device_trust_parse_cmdline(device_trust_cmdline, dev,
+				       &dev->trust_policy) > 0 && dev->p)
+		dev->p->trust_policy_override = true;
 }
 EXPORT_SYMBOL_GPL(device_trust_init);
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 262502642ca98..4620667a11832 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -563,6 +563,11 @@ int usb_driver_claim_interface(struct usb_driver *driver,
 	if (!iface->authorized)
 		return -ENODEV;
 
+	/* an unregistered interface is admitted later, so refuse what would fail */
+	if (!device_is_registered(dev) &&
+	    !device_trust_may_claim(dev, &driver->driver))
+		return -EPERM;
+
 	dev->driver = &driver->driver;
 	usb_set_intfdata(iface, data);
 	iface->needs_binding = 0;
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index d35a7710c8ef4..2d75b85b2d139 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2209,6 +2209,8 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
 		pm_runtime_no_callbacks(&intf->dev);
 		dev_set_name(&intf->dev, "%d-%s:%d.%d", dev->bus->busnum,
 				dev->devpath, configuration, ifnum);
+		/* A sibling may claim the interface before it is registered */
+		device_trust_init(&intf->dev);
 		/*
 		 * Make sure the interface does not outlive its parent (e.g.
 		 * as needed for usb_queue_reset_device() and
diff --git a/include/linux/device/trust.h b/include/linux/device/trust.h
index b8f5514cacec3..552af3e73d4fc 100644
--- a/include/linux/device/trust.h
+++ b/include/linux/device/trust.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 
 struct device;
+struct device_driver;
 
 /**
  * enum device_trust_level - active trust level for a device
@@ -38,6 +39,8 @@ enum device_trust_policy {
 };
 
 void device_trust_init(struct device *dev);
+bool device_trust_may_claim(const struct device *dev,
+			    const struct device_driver *drv);
 enum device_trust_level device_get_trust_level(const struct device *dev);
 bool device_is_adversarial(const struct device *dev);
 

-- 
2.56.0

