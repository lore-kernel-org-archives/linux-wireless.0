Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878EA384248;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=cZcLfqlqBSRBAkq7/VZawgC4FCcgLwy/dgkFeu7TwU15pzWYgl0v2kU0GpozwfZYlOEbPAbaXj5LKy76g8EXT5wlNz1UCRRFPPww2+26hmbSgBGW1vJztdu5vVhsdhOp5Jf3A+2CpHkOJDganNscyUg1IYA+HTxMhRzgRBvLtw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=0v5Gv1OSiBL9CUheGKWW1u2VaL5UzKQuFEiUKbDcGSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0hq5RLJwN9LFWH0K+4qkfNgd4YoRG3tIPevU4b2tQz3bdbpUFQNIK6O186Nhf7ARqpFOwxaVuuQd9jzDRK5yeOM4Xaw3An3Qg/l19H9XVOr7RHAn2ZNE/njpWt/zl9cwjD31l5G2zJLRAGQK07TRQ+L1acJ/N0XYEyQxxSZ8vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cyt6zAWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyt6zAWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EA1C2BCB0;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=0v5Gv1OSiBL9CUheGKWW1u2VaL5UzKQuFEiUKbDcGSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyt6zAWEj4Dm3PbmDphHAqJwpQ4aWYhhKzfb+3g32/GfqwUFnriSBDgFHwP1v6GKW
	 te8tuwG5oXNr14Ql6U+Q3c9G9MfKXuhkVRE3PCUhB1GmronhDzKFvHB2VGWvyR/Amm
	 qwQgYE2u1OjsmTQGj9t0gNBYYOWbjG42nG+L/NGSewxg+mDmoteiKTrsZZOOGvgL9A
	 QG8uyEc0joXnb2pDXg4oM0wt/zxNX0r3lzJIefaTH+ZXq52wn0rKsyrSqaVWDyUxfR
	 hRJdNfBryDwGDapQ9NYrZuP/b//WHc3bihhP70Shl7SJJy3w5DZa1gpEdZ6ui0iAPr
	 KUGtoH2D6H1mg==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004cx-2eMR;
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
Subject: [PATCH 06/13] wifi: mt76x0u: drop redundant device reference
Date: Thu,  5 Mar 2026 12:07:06 +0100
Message-ID: <20260305110713.17725-7-johan@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 90e5666c0857..2acce121fb14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -245,7 +245,6 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	if (id->driver_info)
 		dev->no_2ghz = true;
 
-	usb_dev = usb_get_dev(usb_dev);
 	usb_reset_device(usb_dev);
 
 	usb_set_intfdata(usb_intf, dev);
@@ -284,7 +283,6 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 
 err:
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 	mt76u_queues_deinit(&dev->mt76);
 	mt76_free_device(&dev->mt76);
 
@@ -303,7 +301,6 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 	mt76x0u_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	mt76_free_device(&dev->mt76);
 }
-- 
2.52.0

