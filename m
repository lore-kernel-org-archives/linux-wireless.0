Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878962;
	b=wT/XadydeQeBuFy7DsD0UiYk3ADtVruFucXZiTw6VfhKGJQc4b8RhxTetjPod8inJKx3
	 NWljKmjdq4aAIuog0RcsVVb9fyaX6/kJha+rNFZ58j6Tz+vfT6dZ27JlGkqhHltY2cCRa
	 KHV0hc+vsIJ/brgRIRZXV49BxwXbwZvtpt7uY+oWRy9X5oXG+IF1rRoSXn27F5h79gyhm
	 oBPpv2tHMv/65ZtR04lyf6sBubcpBhs0LiXLhmHDxSkvIkFCL5L9RRKN82aOpIR0OXSo3
	 Z4YJDbmp8CaP8RZB3RY6JXsYeTZi4epCLA5pj1cKswX0j3NNnYPVunio6Qg7S5o1hDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=q/Qxk6NeWhoD49CZMGNhUQK3Ye1Uhy5tudrbI2veMqg=;
	b=yb/G7HuF7PCveQrq8XpHxXMQP5cLmcZM+Q3BnW7nJRmA4zqX5m4dcTxPMTlQGlU5HYSV
	 es5zV4yyq74IaL2xbFJQVFQf4xKMsJk/npuFmFjXyd3006lSFBvWe+ciKblzLJdK1UUC3
	 XX9SXL01B0jHXHIHUuOrfTjD9xMo+q6Cvui1fLaho2K/WXV53sbCz/1Yi3vrm3v2liPVC
	 bReLypLFxz+79BjztdX1ur4Tn8diBK5c2OqVvgf0VoSekFbGoZGYr13I5kkmEJ/pduYoZ
	 dAoEZqGM9qHjdvY6ov+eMRzezNgpryq0lw/aSbD9b4b6AN+TD8wQKFBdkbNWwE4WMtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UW7yjrIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D1E606A337;
	Thu,  5 Nov 2026 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UW7yjrIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E152E1F000C1;
	Thu,  5 Nov 2026 11:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878961;
	bh=q/Qxk6NeWhoD49CZMGNhUQK3Ye1Uhy5tudrbI2veMqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UW7yjrIxoMuhKqJCMOf168PwSNa9h/+jej36Fcd/LWKz5NuA9QtRSYRCMSNZd7xvT
	 jjcrXib9VxfxHay7RdARYM8NeU7zB0bpwGwwYgzD0CvNPnXv/GLWtp2jAQT48bHD7c
	 tyeFBzdliTt5BAw3wlKkrQR+vugiNfVUR38D88DQyDcjJfsvxOt8nVfm/MhstM8+TS
	 AK53IyoMUg23I94IuY9b8bE+ecVbmF/PCb3YYyz3iMsn0TvN96HrYZhD0ZXbDQn4U8
	 ZQ+r3uBNwMmpMzz06/7ItmYDusnSaVPAiPDlo7jBWoXZuaJurDJCWMhQghPLntFzVc
	 IF5WqejG+eXSg==
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
Subject: [PATCH 02/17] Input: serio - attach manual drivers through the driver core
Date: Thu,  5 Nov 2026 13:42:15 +0200
Message-ID: <20261105-device-trust-core-v1-2-1e536825b4eb@nvidia.com>
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

Manual serio binding connects a driver before driver core can admit the
device. A rejected binding therefore arrives after functional setup.

Keep the port ID check and use device_driver_attach() for the existing bus
probe path. Driver core then serializes admission and handles probe failure
before publishing the binding.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/input/serio/serio.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 54dd26249b027..604440244c1ca 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -81,28 +81,10 @@ static int serio_match_port(const struct serio_device_id *ids, struct serio *ser
 
 static int serio_bind_driver(struct serio *serio, struct serio_driver *drv)
 {
-	int error;
-
-	if (serio_match_port(drv->id_table, serio)) {
-
-		serio->dev.driver = &drv->driver;
-		if (serio_connect_driver(serio, drv)) {
-			serio->dev.driver = NULL;
-			return -ENODEV;
-		}
+	if (!serio_match_port(drv->id_table, serio))
+		return 0;
 
-		error = device_bind_driver(&serio->dev);
-		if (error) {
-			dev_warn(&serio->dev,
-				 "device_bind_driver() failed for %s (%s) and %s, error: %d\n",
-				 serio->phys, serio->name,
-				 drv->description, error);
-			serio_disconnect_driver(serio);
-			serio->dev.driver = NULL;
-			return error;
-		}
-	}
-	return 0;
+	return device_driver_attach(&drv->driver, &serio->dev);
 }
 
 static void serio_find_driver(struct serio *serio)

-- 
2.56.0

