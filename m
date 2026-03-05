Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58196345CC9;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=M/NLWVGYxuBW/kLaxkb4/IZkBhRFtZoQKniLMefpNdp4t4Tf4MqbNaZPfpDFpRxUc+GtNdBWPnb0T23ZbBiICEuSdZuxPN5lMaOv8m3iIoGZy9DYHb7vbpE9kn+Zykqt8p77RDC7PbbtPRZaICYxcPbsivoGu0TTO6YTR3leJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=JAu4aGrnPPyf8CrNrqLPSHkFG5LAr0AmkxM6UI5mqdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2GvBTO58WNK7BVtoPTu+wjUJNyxIeBNdiU+NJ/HyWf9pnUPzy4JugQ6OaQOQnwVda8sa7DXBoDy8pq6zoTn5ASJXGqGwgqUo7614rkj1/Xto7oA0giXbQRy4GuFTQ1snrHiUCO5VDlCMcky+Fei3Mj/to1vPwpfH9fw3b7yp6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/MpcMgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/MpcMgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0314BC116C6;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=JAu4aGrnPPyf8CrNrqLPSHkFG5LAr0AmkxM6UI5mqdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/MpcMgwq2QvImIVCdhoVkAy+wcdlniZFR2QNnxI2PJ9URJMGIHBtQhMs3DKGEQ+3
	 Yuy/iUn3aGbS0FtdkFj9usIm+GFRCQHsQCirtgUleKOC2yZW1ywPFKTn/vQh1UGLSI
	 9ZozXQQk3SNuKeGnVb4DrahNKKh29I0vMTbWp1Fi7307+uNUm3ikwbfwxGH/1Lzlzr
	 elwUM4jNssrIBUOauGmshwgQFLT0rwSMTSALblJ06SZoD9UzZIBsAO37HnKA19SzXU
	 MabR+4YLwy3wA0rrcgmap+q8u4r2D6VaM0/8lylKDR78YLiY0bX50z36Vch0cwfmHv
	 mL1zAwBmuBTJg==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004cn-2QT7;
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
Subject: [PATCH 01/13] wifi: at76c50x: drop redundant device reference
Date: Thu,  5 Mar 2026 12:07:01 +0100
Message-ID: <20260305110713.17725-2-johan@kernel.org>
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

