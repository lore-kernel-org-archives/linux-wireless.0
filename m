Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879002;
	b=mbR+uNdt7wxdn61RTT2vbrkShxcysLBesM1G7pvaqgCnsLIW73Smtp9NiIyKmE3MJ26x
	 N8FW6IuQpNJAuEHl45f8tT/+zpGr9wOdtgd9Rq65FnXJnAz2suoK84mBuzmDDrn9lvE5v
	 PxjkVgHpw/ipRrahpWOF8V//BgUFDSfJ58O6By6v/Zg2YPsAgJN1rHLx+GUblAjAaLZMe
	 vuW6WxZcUqQpTz1pnlLqCdX25SU6vLTvQtUEfD6/2A4ZTclM777iIokKDabCRq+HEwakK
	 UlTVl5AmkfN0si3cdaoxw6+PGy2wcuNcIxkkqv21DpUfxBXC66s0maizHGAXdUgdKUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=Kya3esT+ja5CoFsJojA0B+sdCKA8A1pbdw4lgiA8vnE=;
	b=qMzfbiIGBysfGSonX5+pgkS3yZWD4OnEnM1ujY2vrTIMpBH2HAPREIX0Fh5TMaQC97/d
	 GTbFlucqLpxWBg52FV213QEet+7DliFD4W9PiUV7zACd1P+/zYC484GTPCS+SPkq7RYfW
	 Xfum1EU9pkWq7JIgrNuv8Xdx0CzeoTyNxv4TNteS+U5O2SC2HeJPvyh+DMS9mNBpGctom
	 LcmC9Nj8T4gjkFMbw3CtM+VIRQQlM4kw7pDgCMFcgYQdhtOuuglC/JEVaMHvGNrDZdCby
	 wI6rJqWi5ha/E75J11dbrQ78u+A/tkDEVfBZ7OJQ1r44OT7iaDbtAUs0bNRyD9ZauXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqNb1Wne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ACC606A927;
	Thu,  5 Nov 2026 11:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqNb1Wne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC0B1F0093A;
	Thu,  5 Nov 2026 11:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879001;
	bh=Kya3esT+ja5CoFsJojA0B+sdCKA8A1pbdw4lgiA8vnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqNb1WneZNPbHxf4k7WsDFngZ6BOP7gcl9wUZ464/qJHWz7uxNhiTKlzCzYy6yKGf
	 ssc7CpnrgxYN3lgXedAnuf+DrTVWvNurDczkpqqd+kr9KyXsBHeEy6AymFhZsEhxO4
	 L7ElhgOGMxNsUHFkrq9nsmJRUlao2FbFpCcPLFh7xq/WfoxcM2KOlb8d04i0P64ujY
	 jbRwLMs6xYhfH4N5gGZssLCYJaSH9XEkUZRc1Fol1YUztvfoRUga2w0VJThMMX04Ku
	 cuOlQbDssvAzzGLr41KaX0wiuUx2sc2yxEPXzYXxKl85BAQILPI1ZCZhcjWZZ0CKJH
	 HcKsJdKYGed1g==
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
Subject: [PATCH 08/17] driver core: Allow userspace to detect EPROBE_DEFER when using sysfs drivers_probe
Date: Thu,  5 Nov 2026 13:42:21 +0200
Message-ID: <20261105-device-trust-core-v1-8-1e536825b4eb@nvidia.com>
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

commit b8c5cec23d5c ("Driver core: udev triggered device-<>driver
binding") introduced the concept of "Systems who want to control the
driver binding with udev" can use the drivers_probe sysfs to trigger a
driver bind based on the kernel's match list.

If attaching the driver is deferred before its probe callback runs,
userspace sees EINVAL and cannot tell it should try again, maybe after
loading other drivers.

Map that deferral to EAGAIN and add missed documentation for the
drivers_probe sysfs. A deferral requested by the probe callback itself
is still not reported.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/ABI/testing/sysfs-bus-drivers-probe | 13 +++++++++++++
 MAINTAINERS                                       |  1 +
 drivers/base/bus.c                                |  9 +++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-drivers-probe b/Documentation/ABI/testing/sysfs-bus-drivers-probe
new file mode 100644
index 0000000000000..851c65b9331ae
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-drivers-probe
@@ -0,0 +1,13 @@
+What:		/sys/bus/.../drivers_probe
+Date:		February 2007
+Contact:	driver-core@lists.linux.dev
+Description:
+		(WO) Writing a device name requests driver attachment on this
+		bus, even when drivers_autoprobe is disabled. A successful
+		write does not guarantee that a driver bound. The device's
+		driver link reports the result.
+
+		EAGAIN means attachment was deferred before the driver's probe
+		callback, for example while a supplier or the device itself
+		is not ready. ENODEV means the device was not found. Other
+		attachment errors return EINVAL.
diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065d..b726344362b41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8149,6 +8149,7 @@ M:	Johan Hovold <johan@kernel.org>
 L:	driver-core@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core.git
+F:	Documentation/ABI/testing/sysfs-bus-drivers-probe
 F:	Documentation/core-api/kobject.rst
 F:	Documentation/driver-api/driver-model/
 F:	drivers/base/
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 396097fdb3162..ecff32c3704b5 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -310,13 +310,18 @@ static ssize_t drivers_probe_store(const struct bus_type *bus,
 				   const char *buf, size_t count)
 {
 	struct device *dev;
-	int err = -EINVAL;
+	int err;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (!dev)
 		return -ENODEV;
-	if (bus_rescan_devices_helper(dev, NULL) == 0)
+	err = bus_rescan_devices_helper(dev, NULL);
+	if (!err)
 		err = count;
+	else if (err == -EPROBE_DEFER)
+		err = -EAGAIN;
+	else
+		err = -EINVAL;
 	put_device(dev);
 	return err;
 }

-- 
2.56.0

