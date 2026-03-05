Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69C63845BD;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=bDnESGJyvLyzojYP2jDSdj0DmfXf+3qAVikZEFFXrO0ZLTj3nA81MuRM9sJiiZTcNBFbZc0JvUusKILI+8hCLZcWkE3ObPdIunv6xICVjIud6GrprTAxcGSjC350849tSYid+nsVNIIPI5Cmt8m4gxzCZKhPrSPRKGlty9uwF6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=TeJWcibhwqPsG9lU0UCk3JLuhDg4KJLJiyLETuN7pPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okzTfkRa8CAiq6u83HR0GDIHn2VgemGgAHj10kCM7t1mzsJaGNc0PabrOPN+petNDATbfIZhWrm3a7LT+a3EzxIV92xSQPFjc9jynCWHPcTG5a7xIATPkSkT/bDcZK+w4OC0iUctwBp0fynBPYrfAKc+rKw44k91BWMgTuyl1B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1ioO3Bm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1ioO3Bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF76C2BCF5;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=TeJWcibhwqPsG9lU0UCk3JLuhDg4KJLJiyLETuN7pPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1ioO3BmOPmPhVlgkhgzoQVN7eTyL5mPNRi+z+5js5bCedyqA34Cbu6zti/L4H7cD
	 F3fFlhYPNUM+U+rQ076+Qx6OBhwuzXZfiJZ7489gQxhhZwus0M82KEK71/Qzhrsk/C
	 +bIrdG9M47KWblZRGgE2gWngO2tCqkqbnf3HB1c5tyBXM4TastYOFxc5pslcK0Bf6f
	 xAonKFixr680xnia1K298O+Q/WXyb2ww3BdjliRpPrWpc2HuZQFC/FSglI9kXHoTyT
	 jhRqfI02F2CKFOYCP+zTbwx41rguhpXcNijfQ8aVDH8IL7J3tc4RWiaOMqGproLem9
	 YkZEWNzDjoB+A==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004d3-2msp;
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
Subject: [PATCH 09/13] wifi: mt7601u: drop redundant device reference
Date: Thu,  5 Mar 2026 12:07:09 +0100
Message-ID: <20260305110713.17725-10-johan@kernel.org>
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
 drivers/net/wireless/mediatek/mt7601u/usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index c41ae251cb95..9306870cbc91 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -274,7 +274,6 @@ static int mt7601u_probe(struct usb_interface *usb_intf,
 	if (!dev)
 		return -ENOMEM;
 
-	usb_dev = usb_get_dev(usb_dev);
 	usb_reset_device(usb_dev);
 
 	usb_set_intfdata(usb_intf, dev);
@@ -319,7 +318,6 @@ static int mt7601u_probe(struct usb_interface *usb_intf,
 	mt7601u_cleanup(dev);
 err:
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	destroy_workqueue(dev->stat_wq);
 	ieee80211_free_hw(dev->hw);
@@ -334,7 +332,6 @@ static void mt7601u_disconnect(struct usb_interface *usb_intf)
 	mt7601u_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	destroy_workqueue(dev->stat_wq);
 	ieee80211_free_hw(dev->hw);
-- 
2.52.0

