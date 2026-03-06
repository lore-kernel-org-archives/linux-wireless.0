Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6245E379ED7;
	Fri,  6 Mar 2026 08:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787136; cv=none; b=VdaUTRmQ+lLUzVU7+TmTG0JX/1v601BbhviKrbVsnjKW3/4zsxLBFBFaBK8WQfZ3WvJj9aG40FTE9AAcg6VYT99e8iDhySfMep1wV0auK3PCNe+WaBD3ycUjpijWqHMxlSwXhL3PfrsQ0DQDghbsYig+2LfUU1N0r9LaoUO8Q50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787136; c=relaxed/simple;
	bh=j7gUhRofsdD3lZ7m1JTxHiv5hjhqUXzgfkH4RMIENgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG2wFHpYPYxOBinL1AougBJZ1zD6+LRgFgGP6L1HqgBjRRKqtfaG56ED6z+ESk2fGsu8pvI8UyxvMBiH+hYIk6dOTZF3OftM7VUVrEDHEcs43yDOE7KKV8hG63S++5NIgFSQYKTNxkraAdOb5GMTwtgiShZM8aPNJcWfqMkz32k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkUyQMXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkUyQMXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F15C2BCFC;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772787135;
	bh=j7gUhRofsdD3lZ7m1JTxHiv5hjhqUXzgfkH4RMIENgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkUyQMXw1BJFV6KsNwejWWLgx4bEIHvkYpDlIGpJKn+vAlX30qx7Wy/val7jPRkam
	 AqQIRQc886O+KJgZ02LM7ZAuRl8uemn9326u+rRLNGl/MVkFJ6kpv8SWDWHNp+XbfH
	 Wj9PyKrY3E2l9nJhIPW6LQPhQpQLdeVqF3SDrXs+JAxP/XGpuKsU6+VsfDbYYt8zVZ
	 3ZedjE66C3w/x6svNiAKm/GENTgzjBXSSmt2j5uSeyEiUAKQrSLCMRMt0cepMl+Zja
	 PrTMIT4YK4c4LD6rzM4nubEhADBNEWhu4VRUmDy7YP506Rosr/x/gCIKedqe9jcQuI
	 XEMDzuuIG3gXQ==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyQur-000000003At-03JJ;
	Fri, 06 Mar 2026 09:52:13 +0100
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
	Johan Hovold <johan@kernel.org>,
	stable@vger.kernel.org,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2 18/18] wifi: rtw88: fix device leak on probe failure
Date: Fri,  6 Mar 2026 09:51:44 +0100
Message-ID: <20260306085144.12064-19-johan@kernel.org>
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

This driver takes a reference to the USB device during probe but does
not to release it on all probe errors (e.g. when descriptor parsing
fails).

Drop the redundant device reference to fix the leak, reduce cargo
culting, make it easier to spot drivers where an extra reference is
needed, and reduce the risk of further memory leaks.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/netdev/2026022319-turbofan-darkened-206d@gregkh/
Cc: stable@vger.kernel.org	# 6.2
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 433b06c8d8a6..718940ebba31 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -1041,7 +1041,7 @@ static int rtw_usb_intf_init(struct rtw_dev *rtwdev,
 			     struct usb_interface *intf)
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
-	struct usb_device *udev = usb_get_dev(interface_to_usbdev(intf));
+	struct usb_device *udev = interface_to_usbdev(intf);
 	int ret;
 
 	rtwusb->udev = udev;
@@ -1067,7 +1067,6 @@ static void rtw_usb_intf_deinit(struct rtw_dev *rtwdev,
 {
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 
-	usb_put_dev(rtwusb->udev);
 	kfree(rtwusb->usb_data);
 	usb_set_intfdata(intf, NULL);
 }
-- 
2.52.0

