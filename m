Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E3331A7B;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787136; cv=none; b=VdLA7Zjt3kIvAhXsvTEAIQnM+3gzey9gFHMGxZ63Nd7RO6CBsu2lkCrbKUvYumFwPB2AXKm/iO2pS/04CshCxKd+3HUOZWuEDey+GwM+ogg/RkI5k+YIdr40DAiDVfcc2MmE20ReKobWo4Sqj+1RRnXC0usXFDC+W7OBQ7+AOyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787136; c=relaxed/simple;
	bh=0v5Gv1OSiBL9CUheGKWW1u2VaL5UzKQuFEiUKbDcGSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iu7SJ9F5s5TqJOE93Jin3hDiFJz+/JfLNNO7ABE8tMlp7w4Zdp1pTet4r2d0vJR1DrSUogQdd00mcctWN6j1csNCE2AfBSCvDnkpLFPgM4eh2atdejZSjoC6/EHsmf/WPUSoQcy+zxQg8d7Faro+UbgReuoB32wOsGMQ4uXzO1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b23fHuz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b23fHuz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91352C2BCAF;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772787135;
	bh=0v5Gv1OSiBL9CUheGKWW1u2VaL5UzKQuFEiUKbDcGSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b23fHuz8rrHVyIuJwvRkrLPMyxr5r7rqL7HeSGX+K3Z4LxJZYwPCbus0qFNjXvNry
	 kXm1mUmc1MEN5jqZ2yi31+67b7T3bRNzF4uQIPOD3iknccilxukCf597Tk3ri9m34n
	 ynhz3xkoMQ1edC5/afzZuthxYsvCBtUKOanRCeeI+MVmHi6ZYhYmww8tVeAi48dEBg
	 8tfOcHWghrcHv4CUu19Osj24G1muf1kAUAR0RCAE4OGM1VA0LCPLx4VxHGFtumVAdM
	 w1zMVBU65xZHhDlcaWfQ/+D4yVA4DXHWTkqKxVHUByRy6FFPijaNyXAu1iYeVBk2Bl
	 VR7vHvm3rI2KA==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyQuq-000000003Af-3ruV;
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
Subject: [PATCH v2 11/18] wifi: mt76x0u: drop redundant device reference
Date: Fri,  6 Mar 2026 09:51:37 +0100
Message-ID: <20260306085144.12064-12-johan@kernel.org>
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

