Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5822F366057;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=PNHON7IHQJsov86v3OP39iPH0Gcr/Y4t0jC9e9S1t+n/6h0mkPaOH1B+7JLlARV43RP86FX1SIfT0pRHsUQsJl12vWA2iXgVmPvy2X6Z4bZ4lJhalIDI10tknNr8HDdwi9TtY7cUn4lcFg+XLTjNowS6LyRkcWFpYfJpnOrm/VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=Wg9PdiYnvFewTYn81qDhfXqKVkfZq7jAfwyGUQeiiBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTp3R2sWzlSAFEq414d6/fx4Isg43c8f4KqPOuRCqwL4Kr9DTRPT+MwCEF5H0cWwi02oeUCqe6Sz1xSzyeJVNfD0pjdIcVOCjEowDuSncOkDoSJJ8NNQrglrlt5p9rnhIy5hLicnhPkjCwu3JE+iSN/sWhUAiMcs+W0qsr5odG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F77uYfDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F77uYfDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1B6C2BCB1;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=Wg9PdiYnvFewTYn81qDhfXqKVkfZq7jAfwyGUQeiiBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F77uYfDEj7n+JLq8mRyTJYYoPdW+1ubYpGZn2PgSatGjS20qFwh6GygQDhfNNK83E
	 1Zyo1blaT7IrNbibzw43jtpyeXJ+1kuIxxSFjonXgvkIgmNnKkJ3yU4S2Jykmcyk0a
	 CEr6EESUottHfqGHLbUeD6W+NgkcCp6rfyE1m1e/kwtBtxohwQIXik2L05lKj7C4yH
	 reX/Y4hnetBvUZG7WxunqgitL7ubLmE8NwBgZohsxuCxx/eJCuP6mq6XEL9eP8sh55
	 sKAILbFy8FbVN6Mn8UwmsIGbpUl/ZYgAchQIQm2kgIvMOUgeXlXFgdElZD+mGN4LaO
	 lczoS4ryWxz0g==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004cr-2VxD;
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
Subject: [PATCH 03/13] wifi: libertas_tf: drop redundant device reference
Date: Thu,  5 Mar 2026 12:07:03 +0100
Message-ID: <20260305110713.17725-4-johan@kernel.org>
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
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index f49151c18b79..07b38f2b8f58 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -223,7 +223,6 @@ static int if_usb_probe(struct usb_interface *intf,
 	if (!priv)
 		goto dealloc;
 
-	usb_get_dev(udev);
 	usb_set_intfdata(intf, cardp);
 
 	return 0;
@@ -258,7 +257,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
 	kfree(cardp);
 
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(interface_to_usbdev(intf));
 
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
-- 
2.52.0

