Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC0838424D;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=BFJcr2RvgkMrovW7JWAvJ2LDd8htCCOdXJclaBDZIfL0zQMBJ2IChb0lLn6Q5gMFEbIM4wz/DKF0sAfs6iwRJBaAjl8PZcirnSGLBPby6C3MRxMeLmurgSW5AESCBay7e5Q2Ogbr9/B2pA+pgZCe7FJZTdqUQ3MSJ2Fm9Ql+pqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=tGJ7KOHEEm7rLo+cGLabikKcGHzDBaTAEAtltw3d7rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXcNxwLrZmIySkepvMdU5mGI37VUnmBR9pB7S5gmmvmMRF+dKJsJaTEnPd1jEehXAhB7ufg66/MyVtikaqp+rV1hsvAeLt0aRzlhAHcXowzfPArocgECLehvDUAEAJlVgCNvo0k3O3SxYNhcRd8SR+oLhDt1Yf3p1oaYTxqQDU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qKXYNvzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qKXYNvzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDAFC2BCB9;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=tGJ7KOHEEm7rLo+cGLabikKcGHzDBaTAEAtltw3d7rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKXYNvzcfmfRBTY7qzjwlk8PhI0217qD9GZFz2A9cRnTyDBeRD+zMs1Mru9w5rT33
	 IcWjFgCqli6Niy9hYAOEFVD/DCt2j8zdXLTQxKxNaeFVPWR6fedMiYpOqQaeeY0pcd
	 dsPiqPUB+bpNvRHPmB9q+vgcyKpcDsYUKv4cdatNmfFuJaPTA06pwJCz7e0sYNXXTS
	 mF+fiQAl4fbkRnJjFvhtf0Kgi61UFxfNGDIEj1MmIgEJDhhozTEQjGLQXQ/1Rm6grM
	 UWPlKQVkQugKwjoNy9MJ3oqVmaU4DktwWQ9MY2aDQDz7107jd/G34kY/72Zx/seZ56
	 xwOrjHMzV3Cqg==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004d1-2k0j;
	Thu, 05 Mar 2026 12:07:34 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 08/13] wifi: mt76: mt792xu: drop redundant device reference
Date: Thu,  5 Mar 2026 12:07:08 +0100
Message-ID: <20260305110713.17725-9-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260305110713.17725-1-johan@kernel.org>
References: <20260305110713.17725-1-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

Drop the redundant device reference to reduce cargo culting, make it
easier to spot drivers where an extra reference is needed, and reduce
the risk of memory leaks when drivers fail to release it.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c | 2 --
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 2 --
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c | 1 -
 3 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 17057e68bf21..9bfc234f306f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -197,7 +197,6 @@ static int mt7921u_probe(struct usb_interface *usb_intf,
 	dev->fw_features = features;
 	dev->hif_ops = &hif_ops;
 
-	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
 	usb_set_intfdata(usb_intf, dev);
@@ -246,7 +245,6 @@ static int mt7921u_probe(struct usb_interface *usb_intf,
 	mt76u_queues_deinit(&dev->mt76);
 
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	mt76_free_device(&dev->mt76);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index d9968f03856d..84bcebbf009a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -185,7 +185,6 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 	dev->fw_features = features;
 	dev->hif_ops = &hif_ops;
 
-	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
 	usb_set_intfdata(usb_intf, dev);
@@ -234,7 +233,6 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 	mt76u_queues_deinit(&dev->mt76);
 
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	mt76_free_device(&dev->mt76);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
index 552808458138..f827e8a56a18 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_usb.c
@@ -306,7 +306,6 @@ void mt792xu_disconnect(struct usb_interface *usb_intf)
 	mt792xu_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	mt76_free_device(&dev->mt76);
 }
-- 
2.52.0

