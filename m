Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878969;
	b=arqXehG9kuumvEuSWkssmManquAdOgdbHdCbUSr7SeSNqaU2giyeJfo3IFqqaIkuAU5l
	 2/uQemHYSTC1JguxWz5N71RRUUcnwfHUIJwzzBQD9rIOOQASqcLIn42xGzQAIrFmjpBX9
	 z/Zp4TBlH2MrjFTIc/zGaKkF6e1wHq8SVFC4QotzYMFNmDLe4pxE/tctlYn3xgQ4w2wh5
	 hITyBp82eMhsZgZcjZXIq0IYs52WBXglPBrrfl+VzmHR8TqTnipTmBm1wHOCqOZFJ6aib
	 /IS7uMFHpyMFH8sFIaONgLEhNnZlE0Ic3b94FhWwq6kU8iHiLc7+l7P6qLlQncwGvoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=cqZgEa3fWaSRKdNA/kRQddW5Yao1N6EqxQ4vC2mu8po=;
	b=HeEu33g7EA9z56S4GtKarhnEDlHlBVebn2CQYGD4MzpFpk071/jCKVJUxFqlzY6ApIT1
	 RucpZ3NYlKOOwfTs4ynjI2h3qX4oscIsmAXZrwwEKSVCg3hqQWQLlEi4aJc9eQNhrXulO
	 iWUdzqwV8sGOK3fhYuEXMOO60NZeDDNsJfvEFfCvwUxsHE8d+weTmo8kDHX83O+Zqnv9Q
	 8WncXsxNNCbGpfHKK/yEX/qFJmtCSq6Zzg9fgpC2JiQD35CtM59ehtTRYnYALu6zOa0XX
	 thE6Lz1qel5t2tKz6Kl2Cb+2yuYmElXTMMWUnakf++g6pSXVd4mxVG0Wa7Ltk5uwgPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZxrngzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A454606A331;
	Thu,  5 Nov 2026 11:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZxrngzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0391C1F000C1;
	Thu,  5 Nov 2026 11:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878969;
	bh=cqZgEa3fWaSRKdNA/kRQddW5Yao1N6EqxQ4vC2mu8po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZxrngzB1E1pJVoVqirsVSVSCKIBFFy5KNVKCWITnqq9FWXxij3jNeO5+uBfw04Mi
	 XeFZuHTEbef0o4Uok2oqxq3VqybwlxxV0Q1WM7fIH9tOgso7ZseC1MRPoyc3Es6ars
	 z9NVUJrMxvQqp9oK2LkUU97NMQgBne6M/R3uz/jyOgkI8vV6fUBAHINw5MKBlbJny6
	 b+uIaiiQ/RjxORFhnIK+Oeu0Mh/IZNzd+Qm9Unntu/37ijV+fxI88ANdeBs0rKPw5C
	 CDK6EOWnkt3tOsGxST/ud/ZCkwsblZBNYkYvVnT4TV2G+io4BNGfEm6huWIAp6Jg4m
	 cI/+WIoTE/sew==
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
Subject: [PATCH 01/17] Input: gameport - attach manual drivers through the driver core
Date: Thu,  5 Nov 2026 13:42:14 +0200
Message-ID: <20261105-device-trust-core-v1-1-1e536825b4eb@nvidia.com>
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

Manual gameport binding calls connect before publishing the binding, so
driver-core admission cannot reject a device before functional setup.

Use device_driver_attach() to run the existing bus probe and removal
callbacks under the device lock. This gives manual attachment the same
admission, setup and failure cleanup as automatic probing.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/input/gameport/gameport.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 9707b155bc947..c9efec2dc55da 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -214,26 +214,7 @@ static void gameport_run_poll_handler(struct timer_list *t)
 
 static int gameport_bind_driver(struct gameport *gameport, struct gameport_driver *drv)
 {
-	int error;
-
-	gameport->dev.driver = &drv->driver;
-	if (drv->connect(gameport, drv)) {
-		gameport->dev.driver = NULL;
-		return -ENODEV;
-	}
-
-	error = device_bind_driver(&gameport->dev);
-	if (error) {
-		dev_warn(&gameport->dev,
-			 "device_bind_driver() failed for %s (%s) and %s, error: %d\n",
-			gameport->phys, gameport->name,
-			drv->description, error);
-		drv->disconnect(gameport);
-		gameport->dev.driver = NULL;
-		return error;
-	}
-
-	return 0;
+	return device_driver_attach(&drv->driver, &gameport->dev);
 }
 
 static void gameport_find_driver(struct gameport *gameport)

-- 
2.56.0

