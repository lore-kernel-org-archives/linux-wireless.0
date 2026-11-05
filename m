Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878973;
	b=0Yh1WHWN41Cm8vdC1ePgGiJm0lpxhKfAYczhX+LJKL2LmdjIL0WKe3Hdc/7tJgpCAqhz
	 tRoN4VlaNNhcdGlzuTgwHJwC6m5YLwM3JuwugCOC39SdUKdShQioJI4e0Vn2aysS1WaDb
	 uy6lnVxZyjzWBjt0zDEgDr59dFg1j5bMaO/UJpZin/bwMCy3TIPGhAAblBJilkrvfns8f
	 b9qcA1L+qhVHIStXk9p86R9XKjjKdqAZiwacWw+lL7gVAXtS1lTJl/fs7FfPynxGFIXwb
	 c82QMVmpjoE/6+fkAYE2X9/wuAkG9Hj12uUlgtv5RDnOG1OKyBLOI/pdSa0dILVPK4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=FmgNjcvuogZZsh1B1AZimpAG4mxHQSWn6k+79AdsFKA=;
	b=K2IqwmfH0spNEr4/5TADm0NJbiGkAV7WzRfNy5TT3WYJ40aVdmLK6UaL5cR5yD2ep9Os
	 rC2teWUsVxcKzjzni9WD4YU1Ghj/L7PSCow2BcX6YwHwa0HV7eVIwvFmOP0x5e7JhZw27
	 ++C1NHABYOJB/McBQFI2U2lg/nOIWrGfYNL6EXOzdhRODhEjtZ/38yfhSqFwhbfr6pOxe
	 4tuYQAo+mBOYgwQmzecjYNT80EPyQNGgZ8GB+3du1DlS5XHBlV3SbJ+zYZtmEG04E/3Ci
	 gpRYi7ni6nKTvw0bUO3SNC58umDAYDEn1/NixFGJwkKPl34GH+6hwhYq2OMQ3/JMJKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k66JHzak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD97606D814;
	Thu,  5 Nov 2026 11:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k66JHzak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9521F000C1;
	Thu,  5 Nov 2026 11:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878972;
	bh=FmgNjcvuogZZsh1B1AZimpAG4mxHQSWn6k+79AdsFKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k66JHzaka3JEL357Qqofj+lqvbFQpWgUYQb0Y2e77GzOy4dWV+I2tKdy/qH44Io2+
	 GoIuWLj3t7o1YFiV6/1wWwJgYIsajiBZ1qY9a9BQnMZwpeQecL8Y3tcvIl+VWZvFnf
	 iXYd6loWezkvSrRF5RKxPkQUPUqvV6s44uc/HM4W0vrvmBIjlFwfs9sEZ8Pmn0Gqp0
	 KTk1GlM1a/kMDVXVtaE5ARKWxnAVdzP6p2uMfP7D3lyuU6KAHfMEclDhN3lz+QTF+T
	 7a7H2NFMEMi3V4ObM8WteURCLc0dv/+kV5eLks0BrEDO2L9j5aD9PN48dYVUm4nfXZ
	 8ZvQutcDpLDIw==
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
Subject: [PATCH 05/17] USB: Lock registered interfaces during manual driver binding
Date: Thu,  5 Nov 2026 13:42:18 +0200
Message-ID: <20261105-device-trust-core-v1-5-1e536825b4eb@nvidia.com>
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

Interface claims hold the USB device lock, but device_bind_driver()
requires the target interface lock. Without it, trust-policy writes can
race admission.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/bluetooth/btusb_main.c | 42 ++++++++++++++++++++++++++++++------------
 drivers/usb/core/driver.c      | 25 ++++++++++++++++++++++++-
 drivers/usb/core/message.c     |  8 ++++++++
 drivers/usb/core/usb.h         |  2 ++
 4 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/btusb_main.c b/drivers/bluetooth/btusb_main.c
index 92a78a7e60396..8fe6bd1bff906 100644
--- a/drivers/bluetooth/btusb_main.c
+++ b/drivers/bluetooth/btusb_main.c
@@ -2993,10 +2993,13 @@ static int btusb_recv_event_realtek(struct hci_dev *hdev, struct sk_buff *skb)
 	return hci_recv_frame(hdev, skb);
 }
 
+/* usb_lock_device_for_reset() gives up after one second of contention */
+#define BTUSB_MTK_ISO_LOCK_TRIES	5
+
 static void btusb_mtk_claim_iso_intf(struct btusb_data *data)
 {
 	struct btmtk_data *btmtk_data;
-	int err;
+	int err, i;
 
 	if (!data->hdev)
 		return;
@@ -3011,22 +3014,37 @@ static void btusb_mtk_claim_iso_intf(struct btusb_data *data)
 	}
 
 	/*
-	 * The function usb_driver_claim_interface() is documented to need
-	 * locks held if it's not called from a probe routine. The code here
-	 * is called from the hci_power_on workqueue, so grab the lock.
+	 * Disconnect holds the device lock while draining this setup work, so
+	 * the lock must be taken with disconnect-aware acquisition. Hold a PM
+	 * reference so the device cannot suspend first. A slow interface
+	 * registration can keep the lock past the one-second limit of a single
+	 * attempt, so retry a few times, but not without bound: a teardown
+	 * that holds the lock may be waiting for this work.
 	 */
-	device_lock(&btmtk_data->isopkt_intf->dev);
-	err = usb_driver_claim_interface(&btusb_driver,
-					 btmtk_data->isopkt_intf, data);
-	device_unlock(&btmtk_data->isopkt_intf->dev);
+	err = usb_autopm_get_interface(data->intf);
+	if (!err) {
+		for (i = 0; i < BTUSB_MTK_ISO_LOCK_TRIES; i++) {
+			err = usb_lock_device_for_reset(data->udev, data->intf);
+			if (err != -EBUSY)
+				break;
+		}
+		if (!err) {
+			err = usb_driver_claim_interface(&btusb_driver,
+							 btmtk_data->isopkt_intf,
+							 data);
+			if (!err) {
+				init_usb_anchor(&btmtk_data->isopkt_anchor);
+				set_bit(BTMTK_ISOPKT_OVER_INTR,
+					&btmtk_data->flags);
+			}
+			usb_unlock_device(data->udev);
+		}
+		usb_autopm_put_interface(data->intf);
+	}
 	if (err < 0) {
 		btmtk_data->isopkt_intf = NULL;
 		bt_dev_err(data->hdev, "Failed to claim iso interface: %d", err);
-		return;
 	}
-
-	set_bit(BTMTK_ISOPKT_OVER_INTR, &btmtk_data->flags);
-	init_usb_anchor(&btmtk_data->isopkt_anchor);
 }
 
 static void btusb_mtk_release_iso_intf(struct hci_dev *hdev)
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index d3a61ebc6afb0..262502642ca98 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -584,8 +584,11 @@ int usb_driver_claim_interface(struct usb_driver *driver,
 	/* if interface was already added, bind now; else let
 	 * the future device_add() bind it, bypassing probe()
 	 */
-	if (device_is_registered(dev))
+	if (device_is_registered(dev)) {
+		device_lock(dev);
 		retval = device_bind_driver(dev);
+		device_unlock(dev);
+	}
 
 	if (retval) {
 		dev->driver = NULL;
@@ -649,6 +652,26 @@ void usb_driver_release_interface(struct usb_driver *driver,
 }
 EXPORT_SYMBOL_GPL(usb_driver_release_interface);
 
+/*
+ * The driver core refused to bind an interface that a sibling claimed before
+ * it was registered, and dropped the claim. Let the claimant release the
+ * interface instead of operating it with a bound interface but no driver.
+ */
+void usb_driver_release_refused_claim(struct usb_interface *iface,
+				      struct device_driver *claimant)
+{
+	struct device *dev = &iface->dev;
+
+	device_lock(dev);
+	if (!dev->driver && iface->condition == USB_INTERFACE_BOUND) {
+		dev->driver = claimant;
+		usb_unbind_interface(dev);
+		dev_set_drvdata(dev, NULL);
+		dev->driver = NULL;
+	}
+	device_unlock(dev);
+}
+
 /* returns 0 if no match, 1 if match */
 int usb_match_device(struct usb_device *dev, const struct usb_device_id *id)
 {
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index a738d03c23eac..d35a7710c8ef4 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2264,6 +2264,7 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
 	 */
 	for (i = 0; i < nintf; ++i) {
 		struct usb_interface *intf = cp->interface[i];
+		struct device_driver *claimant;
 
 		if (intf->dev.of_node &&
 		    !of_device_is_available(intf->dev.of_node)) {
@@ -2277,7 +2278,14 @@ int usb_set_configuration(struct usb_device *dev, int configuration)
 			dev_name(&intf->dev), configuration,
 			intf->cur_altsetting->desc.bInterfaceNumber);
 		device_enable_async_suspend(&intf->dev);
+		claimant = intf->dev.driver;
+		if (claimant && !try_module_get(claimant->owner))
+			claimant = NULL;
 		ret = device_add(&intf->dev);
+		if (!ret && claimant && !intf->dev.driver)
+			usb_driver_release_refused_claim(intf, claimant);
+		if (claimant)
+			module_put(claimant->owner);
 		if (ret != 0) {
 			dev_err(&dev->dev, "device_add(%s) --> %d\n",
 				dev_name(&intf->dev), ret);
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index a9b37aeb515be..293340a48b6c5 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -49,6 +49,8 @@ extern int usb_set_isoch_delay(struct usb_device *dev);
 extern int usb_get_bos_descriptor(struct usb_device *dev);
 extern void usb_release_bos_descriptor(struct usb_device *dev);
 extern int usb_set_configuration(struct usb_device *dev, int configuration);
+void usb_driver_release_refused_claim(struct usb_interface *iface,
+				      struct device_driver *claimant);
 extern int usb_choose_configuration(struct usb_device *udev);
 extern int usb_generic_driver_probe(struct usb_device *udev);
 extern void usb_generic_driver_disconnect(struct usb_device *udev);

-- 
2.56.0

