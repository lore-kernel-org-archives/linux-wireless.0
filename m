Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878977;
	b=u01Ky0WJrd7RieMb1IgZk+dAPmqPUStOtLerhuK2qwwpm0Uhnqe9uuQIvbKaswqUSYh+
	 25JrEn1m2an9xf51FytUGwrrGrPWyORLC8L1FZTeB1ADKvt0TaU0+ikCE/WB2HZDGpukq
	 ok1A9DAkyzaCNvRl3HMUTmYV/SAUGv+EUVukpECqKGurPyfHiIwkG2gUxJUvhO1Z/vCmg
	 9pDmZO/Dh8ukHEJoc7S1BpqLfcSglyJ2OEVRHPSpXJVuyjPgSfIFzsRviVSw9oXBmTTDv
	 JDL65CbawsNzwFSbtw9X/heZT0vhmDojl5a6CiPX5bBp0Qk8eIilK4k4ZdmIVCVbeJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=Y/diz28OtqaYX4DdZb+JhCSN/xAyOePemSvH2IVI+oI=;
	b=dGyOQHr94Mdi2Qm7LFsvZhDEtuNo98cH4R00nA3PzCzEfgFEUIfNgYuARY8Im4fp/ToH
	 QheJKeMOA0IDLk/lXG9U+e0DaumMIChA4M2jTVymDVIFjIzNKlR9ez8CC1UISq3QT8hb0
	 21DQauUUz00cVvVbuzFPZTIs4C41h5wD0pBn80UrGKG8sl3m+8oTnIrNYjeIrY4RNaW5u
	 TFxj0IzfrKpnihV0uWW7v2xFQ5f6I2kzQYM1xDsi3wpaB8O3AW8Do7xyyMFcRIonFWpwa
	 3GlU3j8HDvasRYrbyODMlm925Qg2+ak8qJak60fkDk1D0UM7HQF4TLkFFXaHt2j4FJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WbL5QjYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A884C606D830;
	Thu,  5 Nov 2026 11:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WbL5QjYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425D71F00A15;
	Thu,  5 Nov 2026 11:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878976;
	bh=Y/diz28OtqaYX4DdZb+JhCSN/xAyOePemSvH2IVI+oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbL5QjYsFkg65r1u2G3TgevctJY75JgPBr4BQeGQMD/7QzqtkIWrbIB8hZGRT0mfw
	 /kfVAiYZJu8K/qqQnLel87sKZgqwTFBI5uhJnqJsg9HJGz2xXyCHHqsy5pMzCyYUOA
	 nXRvT8P29UgyOeBEE0eY6Km0xdBtugwoUUqc1uyUwYj3cCGJwZYddOkcTeqNb6ZzV9
	 748SmpPnmX+lnfiPSSwGHW6o11kAwCvZmoBqacXlE0V8Fms7gCltsiTTiyrfi4tIEh
	 fF/Q8HZs6P/tuorrRu9e7N/eT7XRGR92gPVL1D6yFrgwtW2RGnfWcWaNT4pU7Pwsd9
	 LqiLwc4CO4n9g==
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
Subject: [PATCH 06/17] PNP: Attach card devices through the driver core
Date: Thu,  5 Nov 2026 13:42:19 +0200
Message-ID: <20261105-device-trust-core-v1-6-1e536825b4eb@nvidia.com>
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

Card device requests probe the selected link driver before driver core can
perform admission and setup.

Use device_driver_attach() for the normal binding transaction. Keep the
card link owned by the enclosing card probe until the device is bound, so
probe cleanup and debug removal cannot free a link still in use by that
transaction.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pnp/card.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index df5e3d3cbf6c0..9aaaa03d5ffa9 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -52,13 +52,17 @@ static const struct pnp_card_device_id *match_card(struct pnp_card_driver *drv,
 
 static void card_remove(struct pnp_dev *dev)
 {
-	dev->card_link = NULL;
+	if (device_is_bound(&dev->dev))
+		dev->card_link = NULL;
 }
 
 static void card_remove_first(struct pnp_dev *dev)
 {
 	struct pnp_card_driver *drv = to_pnp_card_driver(dev->driver);
 
+	/* The card probe still owns its link until this device is bound. */
+	if (!device_is_bound(&dev->dev))
+		return;
 	if (!dev->card || !drv)
 		return;
 	if (drv->remove)
@@ -331,16 +335,12 @@ struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
 
 found:
 	dev->card_link = clink;
-	dev->dev.driver = &drv->link.driver;
-	if (pnp_bus_type.probe(&dev->dev))
-		goto err_out;
-	if (device_bind_driver(&dev->dev))
+	if (device_driver_attach(&drv->link.driver, &dev->dev))
 		goto err_out;
 
 	return dev;
 
 err_out:
-	dev->dev.driver = NULL;
 	dev->card_link = NULL;
 	return NULL;
 }

-- 
2.56.0

