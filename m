Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878965;
	b=E23y5Dh0LvlTYSlflk1cfaRgsrBPIv9+AZEhejhMvfnKAfqAoVAyvRIgGErSxFWx/vkj
	 +st3i3PxPs4XEkTfiFD/cxKdufe3nIpF64fmUAyY63sMm147/0TLp4kyVsvQcDNv8zN64
	 kyu9v0JRfm3v0SjBOA3LLzYAo2E8JGiulJSUcGW3CS5izJj8K2ZQpH1Ql5RjwVr/zLBKX
	 gvmTAcGmhh35JdBtKWhja5EhjWs8b9G+olBA6nW8JcwIgkPqPg5dp9/6/WiLWl4S++Hp1
	 6gVWmn8wXwb+y3SpCMeoSnZ3w9MUE3WAnnmipYpAJfIUJkIYRdCWmRsNWVcsRpIuzYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=Uf1oZV9pQvGrEUvi8XtIeuSa56tR9ySw+fDX7XP+CMk=;
	b=mjBxzr0IRfTuHjOkaAF+dqa4VF6+2oTOm7oWlTM4Cnp/PBIG+aHEsTieoRVjaPPzLszR
	 pD51WD6LFjcNcZVy2owVjEEK//i1cuhxkOK8EHOK0Oi/FMbOJsWOROo+oyu6S3MUUZWVy
	 w4iaH6xwp21r4bFdttQpmYj2PgcYvMwYIhDqqriKEs5WlG5D1mwOKHNNC87sbXyzhD5qr
	 VZMExZaVcs75Xy4GWV1Y+8ugUc2Pa9hxMjxQ4JE/45waLL0dhouX0s+DjWI4TQ+8kNODg
	 GRH1N+ZzyDaYRECYWrTl90Hxzx7UM00k99yKVBhZf7oqXp/0O36sjn9qnkEND5wIcLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnInfvfx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CA9606D809;
	Thu,  5 Nov 2026 11:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RnInfvfx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A431F000C1;
	Thu,  5 Nov 2026 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878965;
	bh=Uf1oZV9pQvGrEUvi8XtIeuSa56tR9ySw+fDX7XP+CMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnInfvfxHXtvO4dD2rpgLRRjDe8FtQGLLRwQ8XylHDziicCqsNVQ5WQrmbaLGX6vY
	 zCXyGQq/kPlFlMojAMi9XImf5AAA8FMsyc8xKVMxzmLW5CKJzFa+SCHdWImWnC50wO
	 twOGlGdhGEOOmy8M7brqom2qCMFDApBMHYhcTP1rns8FA7AtPo3HgR+JWHD36IHylV
	 VfgZjUiISKYbQeQTkbTweQ3xkeHCT/DWFVYl5hFXfmVJ0XG1MAvJbjghyIEDJsZXMF
	 ekz3UjPPpd4mHzRAGT6qzsEjrEhh0pw6QnVTjASyaukekBZzUdAF0/whpYf2ASVRmf
	 xp4H1OKTG4jkQ==
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
Subject: [PATCH 03/17] net: phy: Attach generic PHY drivers through the driver core
Date: Thu,  5 Nov 2026 13:42:16 +0200
Message-ID: <20261105-device-trust-core-v1-3-1e536825b4eb@nvidia.com>
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

The generic PHY fallback probes directly before publishing its binding,
bypassing driver-core admission and supplier checks.

Attach through the driver core so admission precedes functional setup.
Callers hold RTNL, which a concurrent bind of a specific driver may wait
for with the device lock held, so for this flow let's add
device_driver_try_attach() so the attachment never waits for that lock.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/base/dd.c            | 65 +++++++++++++++++++++++++++++++++++++-------
 drivers/net/phy/phy_device.c | 39 +++++++++++++++++---------
 include/linux/device.h       |  2 ++
 3 files changed, 83 insertions(+), 23 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 52123251965de..01026e02de92e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1046,6 +1046,25 @@ static void __device_driver_lock(struct device *dev, struct device *parent)
 	device_lock(dev);
 }
 
+/*
+ * __device_driver_trylock - __device_driver_lock() without sleeping
+ *
+ * Returns true if the locks were taken.
+ */
+static bool __device_driver_trylock(struct device *dev, struct device *parent)
+{
+	if (dev->type && dev->type->need_parent_lock && parent) {
+		if (!device_trylock(parent))
+			return false;
+		if (!device_trylock(dev)) {
+			device_unlock(parent);
+			return false;
+		}
+		return true;
+	}
+	return device_trylock(dev);
+}
+
 /*
  * __device_driver_unlock - release locks needed to manipulate dev->drv
  * @dev: Device we will update driver info for
@@ -1195,19 +1214,17 @@ void device_initial_probe(struct device *dev)
 	subsys_put(sp);
 }
 
-/**
- * device_driver_attach - attach a specific driver to a specific device
- * @drv: Driver to attach
- * @dev: Device to attach it to
- *
- * Manually attach driver to a device. Will acquire both @dev lock and
- * @dev->parent lock if needed. Returns 0 on success, -ERR on failure.
- */
-int device_driver_attach(const struct device_driver *drv, struct device *dev)
+static int __device_driver_attach(const struct device_driver *drv,
+				  struct device *dev, bool trylock)
 {
 	int ret;
 
-	__device_driver_lock(dev, dev->parent);
+	if (trylock) {
+		if (!__device_driver_trylock(dev, dev->parent))
+			return -EBUSY;
+	} else {
+		__device_driver_lock(dev, dev->parent);
+	}
 	ret = __driver_probe_device(drv, dev);
 	__device_driver_unlock(dev, dev->parent);
 
@@ -1218,8 +1235,36 @@ int device_driver_attach(const struct device_driver *drv, struct device *dev)
 		return -EAGAIN;
 	return ret;
 }
+
+/**
+ * device_driver_attach - attach a specific driver to a specific device
+ * @drv: Driver to attach
+ * @dev: Device to attach it to
+ *
+ * Manually attach driver to a device. Will acquire both @dev lock and
+ * @dev->parent lock if needed. Returns 0 on success, -ERR on failure.
+ */
+int device_driver_attach(const struct device_driver *drv, struct device *dev)
+{
+	return __device_driver_attach(drv, dev, false);
+}
 EXPORT_SYMBOL_GPL(device_driver_attach);
 
+/**
+ * device_driver_try_attach - attach a specific driver without waiting for locks
+ * @drv: Driver to attach
+ * @dev: Device to attach it to
+ *
+ * Like device_driver_attach(), for callers that hold a lock which the holder
+ * of the @dev or @dev->parent lock may wait for. Returns -EBUSY, before any
+ * probing, if one of those locks is contended.
+ */
+int device_driver_try_attach(const struct device_driver *drv, struct device *dev)
+{
+	return __device_driver_attach(drv, dev, true);
+}
+EXPORT_SYMBOL_GPL(device_driver_try_attach);
+
 static void __driver_attach_async_helper(void *_dev, async_cookie_t cookie)
 {
 	struct device *dev = _dev;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5d4508bcfbe99..8cc0de755bd08 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1912,7 +1912,9 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	struct device *d = &phydev->mdio.dev;
 	struct module *ndev_owner = NULL;
 	struct module *drv_owner;
+	struct device_driver *drv;
 	int irq = phydev->irq;
+	bool bind_genphy;
 	int err;
 
 	/* For Ethernet device drivers that register their own MDIO bus, we
@@ -1939,16 +1941,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	/* Assume that if there is no driver, that it doesn't
 	 * exist, and we should use the genphy driver.
 	 */
-	if (!d->driver) {
+	drv = d->driver;
+	bind_genphy = !drv;
+	if (bind_genphy) {
 		if (phydev->is_c45)
-			d->driver = &genphy_c45_driver.mdiodrv.driver;
+			drv = &genphy_c45_driver.mdiodrv.driver;
 		else
-			d->driver = &genphy_driver.mdiodrv.driver;
-
-		phydev->is_genphy_driven = 1;
+			drv = &genphy_driver.mdiodrv.driver;
 	}
 
-	drv_owner = d->driver->owner;
+	drv_owner = drv->owner;
 	if (!try_module_get(drv_owner)) {
 		phydev_err(phydev, "failed to get the device driver module\n");
 		err = -EIO;
@@ -1956,11 +1958,20 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	}
 	phydev->drv_owner = drv_owner;
 
-	if (phydev->is_genphy_driven) {
-		err = d->driver->probe(d);
-		if (err >= 0)
-			err = device_bind_driver(d);
-
+	if (bind_genphy) {
+		/*
+		 * RTNL is held, and a concurrent bind of a specific driver may
+		 * wait for it with the device lock held. Never wait for that
+		 * lock, and let the caller retry.
+		 */
+		err = device_driver_try_attach(drv, d);
+		if (err == -EBUSY) {
+			/* Another bind owns the PHY, so nothing was probed here. */
+			irq = phydev->irq;
+			err = -EPROBE_DEFER;
+		} else if (err == -EAGAIN) {
+			err = -EPROBE_DEFER;
+		}
 		if (err)
 			goto error_module_put;
 	}
@@ -2071,8 +2082,6 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	module_put(phydev->drv_owner);
 	phydev->drv_owner = NULL;
 	phydev->irq = irq;
-	phydev->is_genphy_driven = 0;
-	d->driver = NULL;
 error_put_device:
 	put_device(d);
 	if (ndev_owner != bus->owner)
@@ -3813,6 +3822,8 @@ static int phy_probe(struct device *dev)
 	int err = 0;
 
 	phydev->drv = phydrv;
+	phydev->is_genphy_driven = phydrv == &genphy_driver ||
+				 phydrv == &genphy_c45_driver;
 
 	/* Disable the interrupt if the PHY doesn't support it
 	 * but the interrupt is still a valid one
@@ -3949,6 +3960,7 @@ static int phy_probe(struct device *dev)
 out_reset:
 	/* Re-assert the reset signal on error */
 	phy_device_reset(phydev, 1);
+	phydev->is_genphy_driven = 0;
 
 	return err;
 }
@@ -3977,6 +3989,7 @@ static int phy_remove(struct device *dev)
 	phy_device_reset(phydev, 1);
 
 	phydev->drv = NULL;
+	phydev->is_genphy_driven = 0;
 
 	return 0;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 429e39f647cf9..4cf62d69eac4f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1314,6 +1314,8 @@ static inline void *dev_get_platdata(const struct device *dev)
  */
 int __must_check device_driver_attach(const struct device_driver *drv,
 				      struct device *dev);
+int __must_check device_driver_try_attach(const struct device_driver *drv,
+					  struct device *dev);
 int __must_check device_bind_driver(struct device *dev);
 void device_release_driver(struct device *dev);
 int  __must_check device_attach(struct device *dev);

-- 
2.56.0

