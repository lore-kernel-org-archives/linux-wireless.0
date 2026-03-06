Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69DE32ABCA;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787135; cv=none; b=V5wKRWiRWQMdR6LRhhP7N4uiRwasrniHGlgPqdyyxz/Y+mtFqtPUUo0gfzoCdjeZEy2SKeah1GD9wgog/fDYBH+/zIcVBcaLzLtsUoV+8jDrxnpi8uuGZ1yTC6O9YZqOC6tZ0akMVrQBL/qLXbVnzfJI6MDyUi3CTNujY8eS/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787135; c=relaxed/simple;
	bh=JAu4aGrnPPyf8CrNrqLPSHkFG5LAr0AmkxM6UI5mqdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSyAls4UhM+nQgyjsQZFutPTPK50UsmVfycpknj7lGA+hxR8EWGcXQlDHXxEODK46kS1UvmWuj2XMux/h4U0Q+PeGZMU6mnJ7PXs0XBvK8PLTo3VOcYtxJd0GgDyT23UzjnyRuwnNJ56wkAKra9JbOiWzOhIJby9HklZFkd73tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBbq+bqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBbq+bqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D94C2BC9E;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772787135;
	bh=JAu4aGrnPPyf8CrNrqLPSHkFG5LAr0AmkxM6UI5mqdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBbq+bqgGOzJohI3myC/rfmWyVTrUMYfGt24Auc7rMLkPX5htugIF32oay0ULQKj3
	 M/7ztsuslvGQU2BRKlQbEpLeJb/0+4DjefPdOaaawI9lYQ/hM9smL801tOHLeo0X6i
	 5UYECwfxN8dB2bD73fqskcY3G0RZFj7rPNsncA5g4Zm66sE9WW7kH91urn5X8ESQpP
	 pDZHjlNhAA/cKob7SHkgA00ihWO38siJEvu3LpgVaaMy4LCsO6vT1U4z5Qoe1C8ata
	 kMI3IWvmffe7R3sxlQktltQxG2ER5ly37if+2BWgVjApsnSYSbcVvtJkMl6IFmfuCl
	 0wGveMa0liShw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyQuq-000000003AV-3dQg;
	Fri, 06 Mar 2026 09:52:12 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Brian Norris <briannorris@chromium.org>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 06/18] wifi: at76c50x: drop redundant device reference
Date: Fri,  6 Mar 2026 09:51:32 +0100
Message-ID: <20260306085144.12064-7-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260306085144.12064-1-johan@kernel.org>
References: <20260306085144.12064-1-johan@kernel.org>
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
 drivers/net/wireless/atmel/at76c50x-usb.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 6445332801a4..44b04ea3cc8b 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2440,13 +2440,11 @@ static int at76_probe(struct usb_interface *interface,
 	struct mib_fw_version *fwv;
 	int board_type = (int)id->driver_info;
 
-	udev = usb_get_dev(interface_to_usbdev(interface));
+	udev = interface_to_usbdev(interface);
 
 	fwv = kmalloc_obj(*fwv);
-	if (!fwv) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!fwv)
+		return -ENOMEM;
 
 	/* Load firmware into kernel memory */
 	fwe = at76_load_firmware(udev, board_type);
@@ -2534,8 +2532,7 @@ static int at76_probe(struct usb_interface *interface,
 
 exit:
 	kfree(fwv);
-	if (ret < 0)
-		usb_put_dev(udev);
+
 	return ret;
 }
 
@@ -2552,7 +2549,6 @@ static void at76_disconnect(struct usb_interface *interface)
 
 	wiphy_info(priv->hw->wiphy, "disconnecting\n");
 	at76_delete_device(priv);
-	usb_put_dev(interface_to_usbdev(interface));
 	dev_info(&interface->dev, "disconnected\n");
 }
 
-- 
2.52.0

