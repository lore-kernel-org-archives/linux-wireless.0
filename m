Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC42223D7FF;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787135; cv=none; b=Y8L/tyGpMWwBQ0DzEW9jO33pYGSHMmqgZhVZyxKog48HDV3OuNkYeIieodUjPEAYnO81OD0Y/PXbUWZKGSkdxyQSbQ+s2bmgwS/W5j037O8HZZnegE1+jRbCca5hQht45EBmQQpiDG+pu9VgfbmXkzPe/ugIbDu7LgoXo11gNws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787135; c=relaxed/simple;
	bh=kaq0JBNHyQqQlidhi1/aPYh1/H5njyrGvo0l9Tfow5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgOkb5JcHKBy94Wf76ogFQUOZosq+W5wgVkHmF4AiaSV7L+1nxtSe8Y9/wYs8pw+sZK3HI0MD5KzCDDyJ4q/jMazb8rNM1jBbupa/Fs96lmiVpG8i9pt9J1YitGyfS+KvB7d2wGg9phME0BUWK1OIf8klIZ17iwu/sW9VCvvrBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezpeRrkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezpeRrkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7055CC4CEF7;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772787135;
	bh=kaq0JBNHyQqQlidhi1/aPYh1/H5njyrGvo0l9Tfow5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezpeRrktOFKOzNVq65yGXnie5Ezdwl7U//BjLWxRPul4V5XZ2Wxd3quESPYHJR5xP
	 309PaUP2Yt6zPfEYXna3tH+VKzCrmYAYpTSX0QYCAy00W6w0dCBt/VBf/Tk5RBsZT2
	 SiMnMDkzBwkmB2cTH++4tUx/ainTE28zXAei2CNWf9RIyXS0mSvID8reru+33lCRnJ
	 JZASEcaOEQiL6g2ZBDDYnCIUxp73XeA73j9HTYcW3GMFjZzZahCLV1oBsMI7K+nhF9
	 dJCuF+ZbNn8V02mrERYpSHCxk0zaF5xS6Fq2bW99vKVOZwlJz3F5b+DcSMZVeWHOw6
	 m7YzmLzmCfqXg==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyQuq-000000003AX-3g6H;
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
Subject: [PATCH v2 07/18] wifi: libertas: drop redundant device reference
Date: Fri,  6 Mar 2026 09:51:33 +0100
Message-ID: <20260306085144.12064-8-johan@kernel.org>
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
 drivers/net/wireless/marvell/libertas/if_usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 8a6bf1365cfa..05fcf9cc28fa 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -276,7 +276,6 @@ static int if_usb_probe(struct usb_interface *intf,
 
 	cardp->boot2_version = udev->descriptor.bcdDevice;
 
-	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
 
 	r = lbs_get_firmware_async(priv, &udev->dev, cardp->model,
@@ -287,7 +286,6 @@ static int if_usb_probe(struct usb_interface *intf,
 	return 0;
 
 err_get_fw:
-	usb_put_dev(udev);
 	lbs_remove_card(priv);
 err_add_card:
 	if_usb_reset_device(cardp);
@@ -321,7 +319,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	kfree(cardp);
 
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(interface_to_usbdev(intf));
 }
 
 /**
-- 
2.52.0

