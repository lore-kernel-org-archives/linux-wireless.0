Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879014;
	b=YFdpshcpMDbzcpJmUsa0VS4BtT2y0gZUH4soKwtgvsFWAXBjd0Pa1x4071TctDKRF91v
	 pkzGobdRU801lAj0NHqzzigeqboUcgE6l+gEBokCJTApHgjNyX2L/e4NX783/uviWPPLn
	 5cuiBDy4Gj4I5AUw03/v3K54QOp0kIxdudaGoWHtEyOsyCekkRM337nMn57lTgCoa6kMg
	 W/TVr3Gf+93m7mDd17Xms/4yHbYLCeibkYWG8ucLNvwqRqeu62lXYcpiqyp5Sw1ZmHxJy
	 hTAH0vMbM+R7jfHNNAilMn5DSzSwiPDD+aSJHu2KGr4AvcNz/7RNkV0SfGbcEF8GWZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=HVj6l3UydzXkgX5b5Nv8SsmCm86UwO2uKscetvhcHxs=;
	b=TVLMJYwmwKE6XigbuRMGrKT4V6CjTdVpLpnjc92YrbRz3heq+//LOcardWfaME06DEEA
	 VmI0wrJkZXnNfzCHZvu7H+KfBvNTqSZlGByovpfVgIyKjTJgGgcbL7dIkazPyjVxsvYuB
	 ZZeIQAm2ImzfyZdMURS5WsKr5mGqusV0xr4xWup6cQ4JAf3BYi5L9Ms6ze+mGga46tGTU
	 Z1y2cjKkUWJvulcnBIFEs4feMEIdOuvtyyE93uSAitZUccWlti3InBkg8Bx+YVPIT8IrS
	 kiRGPN01Mv8L0A6aYrLKsQe6OAi7Q9io+TbmyGc4r7b3yC61YMW2uLIMlo+YbOy31Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OlF/vFbM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82F1606CEAB;
	Thu,  5 Nov 2026 11:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OlF/vFbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7734A1F00A16;
	Thu,  5 Nov 2026 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879013;
	bh=HVj6l3UydzXkgX5b5Nv8SsmCm86UwO2uKscetvhcHxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlF/vFbMqHhOlnVgXEDiOnXUZv2d23YcbiXuuNoglNRKpbkPITpWwaZyCfFCmNQ4i
	 N+o9NvmyJd4ylmXFA2w7KGEWqqLCjnG+/+Fzzyu18PMCzWeCTjd1pOD4eRc17fBkdh
	 luPVTzBrvG/LuZcGJRIMpAr4e4/fAHPffn1LaJA666p/vR2b2kNR9qpfK1VdDOg18d
	 AxCnhkzdE9+uNJ8LLOgkjQPC8v4USZVu4YdVjIpRlMILr0+q4yp770BttPPkBakBDf
	 kNFA81zQ3AMB7iMqMBzVNpLwe2AduH8RVW3DDi48/XTxkpGXFYLmBXsOkt2bL2UoFM
	 fdD3k0Ie6rlPw==
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
Subject: [PATCH 13/17] driver core: Preserve trust commitment beyond driver binding
Date: Thu,  5 Nov 2026 13:42:26 +0200
Message-ID: <20261105-device-trust-core-v1-13-1e536825b4eb@nvidia.com>
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

IOMMU state can outlive a functional driver, including after failed setup
and unbind. The active trust level becomes disabled in those states, so
it cannot describe the authorization governing persistent translation
state. Infrastructure needs the immutable commitment to avoid treating
an unbound, previously authorized device as newly untrusted.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/base/base.h          |  2 --
 drivers/base/trust.c         | 17 +++++++++++++++--
 include/linux/device.h       |  3 +++
 include/linux/device/trust.h |  1 +
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index b4441242496f7..dd78857abf74f 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -113,7 +113,6 @@ enum device_trust_state {
  *			   dev_err_probe() for later retrieval via debugfs
  * @device: pointer back to the struct device that this structure is
  *	    associated with.
- * @trust_committed_level: operating level retained across bind transactions
  * @trust_state: policy admission state
  * @trust_initialized: bus and boot policy have initialized admission state
  * @trust_policy_override: explicit policy prevents deferred driver boot policy
@@ -133,7 +132,6 @@ struct device_private {
 	const struct device_driver *async_driver;
 	char *deferred_probe_reason;
 	struct device *device;
-	enum device_trust_level trust_committed_level;
 	enum device_trust_state trust_state;
 	u8 trust_initialized:1;
 	u8 trust_policy_override:1;
diff --git a/drivers/base/trust.c b/drivers/base/trust.c
index b38f69e440eae..4bcda888591a5 100644
--- a/drivers/base/trust.c
+++ b/drivers/base/trust.c
@@ -88,10 +88,10 @@ int device_trust_prepare(struct device *dev, const struct device_driver *drv)
 	if (level != DEVICE_TRUST_ADVERSARY && level != DEVICE_TRUST_FULL)
 		return -EINVAL;
 	if (dev->p->trust_state == DEVICE_TRUST_COMMITTED &&
-	    dev->p->trust_committed_level != level)
+	    dev->trust_committed_level != level)
 		return -EINVAL;
 
-	dev->p->trust_committed_level = level;
+	WRITE_ONCE(dev->trust_committed_level, level);
 	dev->p->trust_state = DEVICE_TRUST_COMMITTED;
 	WRITE_ONCE(dev->trust_level, level);
 	return 0;
@@ -119,6 +119,19 @@ enum device_trust_level device_get_trust_level(const struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_get_trust_level);
 
+/**
+ * device_get_committed_trust_level - Return the lifetime trust commitment
+ * @dev: device to inspect
+ *
+ * Return: %DEVICE_TRUST_DISABLED before admission, otherwise the level fixed
+ * before driver setup. The commitment survives setup failure and unbind.
+ */
+enum device_trust_level device_get_committed_trust_level(const struct device *dev)
+{
+	return READ_ONCE(dev->trust_committed_level);
+}
+EXPORT_SYMBOL_GPL(device_get_committed_trust_level);
+
 /**
  * device_is_adversarial - Test whether a device is operated as an adversary
  * @dev: device to inspect
diff --git a/include/linux/device.h b/include/linux/device.h
index 5bd0cee874731..65ea07c9ac35b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -699,6 +699,8 @@ enum struct_device_flags {
  * @trust_policy: Requested operating policy, resolved before driver probe.
  * @trust_level: Active trust level while a driver is bound, see
  *		device_get_trust_level().
+ * @trust_committed_level: Operating level retained across bind transactions,
+ *		see device_get_committed_trust_level().
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -804,6 +806,7 @@ struct device {
 	enum device_removable	removable;
 	enum device_trust_policy trust_policy;
 	enum device_trust_level trust_level;
+	enum device_trust_level trust_committed_level;
 
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
diff --git a/include/linux/device/trust.h b/include/linux/device/trust.h
index 552af3e73d4fc..19052e3301729 100644
--- a/include/linux/device/trust.h
+++ b/include/linux/device/trust.h
@@ -42,6 +42,7 @@ void device_trust_init(struct device *dev);
 bool device_trust_may_claim(const struct device *dev,
 			    const struct device_driver *drv);
 enum device_trust_level device_get_trust_level(const struct device *dev);
+enum device_trust_level device_get_committed_trust_level(const struct device *dev);
 bool device_is_adversarial(const struct device *dev);
 
 #endif /* _DEVICE_TRUST_H_ */

-- 
2.56.0

