Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7063337E2F8;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=Es51Oh2KrfjIraiNsFCVJJbek5QWuUL7otWU8sTQJDrpwy0xJrXt6sAhpNYzpdOI4iuhwo2gi7B8w9f1dgowq4d6ihYK7EsKbY0a1pkcqLWJ4/69BsauP/e9i9NBGWz4BlJSpg7cWMz6WUoCeKcORKMugKBJG7M4aP3mFbms0Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=+n2gwwI5ICbPV5XOVnFHvtm0RnUfCoQpce3aU1BVfTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6x+Vcnh/+S3Vj4ThVXUyDMqIQULTv6ZyDyNnJyIhsDaEoduDpu8ELyJmEQdQnstdLfepAIGsLl1WF6+X4mKTWVlmYrbJj+r5t4mIYNDZf0VyKjkWy5rfqlnQ/NPYUxnhICt+GxrUo1dEHKzycvjpN2y8j0jHnqjstQgI/ePHLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ti6jcZMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ti6jcZMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EA5C2BCB2;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=+n2gwwI5ICbPV5XOVnFHvtm0RnUfCoQpce3aU1BVfTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti6jcZMg9hkzFNNuRJZ8J6p+Wm6FJte19bySeGHUcqN32ZseL0DVoC3ezybWDPCk3
	 AKhklBKc76YrcTQyj5xsbxy9PMiBq4WwyfShK8QYKuWBMkg312U3hR14U2pvz8euSX
	 kxUi2xQcQR+Dy6YoKSd714v8Xq+O00ptptd9i8/FWUlbiTQvLxJZzJKhHGYqZhJTDF
	 lwdCTRijWIScDb4CIKRSvi0YAHqFIPxf8+jiBJlVQpE9tx0IPK5vccwym1Kj6upeyd
	 xTpB2Uq7cJEQDp7RHQJfwJdOR6LFBLBTEHXDh80PXT66yBJE97QZUL212kfNIZZY/h
	 uz41RyHJAwWKQ==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004ct-2YsO;
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
Subject: [PATCH 04/13] wifi: mwifiex: drop redundant device reference
Date: Thu,  5 Mar 2026 12:07:04 +0100
Message-ID: <20260305110713.17725-5-johan@kernel.org>
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
 drivers/net/wireless/marvell/mwifiex/usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 947ecb0a7b40..f4b94a1054f6 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -520,8 +520,6 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 		return ret;
 	}
 
-	usb_get_dev(udev);
-
 	return 0;
 }
 
@@ -666,8 +664,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	mwifiex_dbg(adapter, FATAL,
 		    "%s: removing card\n", __func__);
 	mwifiex_remove_card(adapter);
-
-	usb_put_dev(interface_to_usbdev(intf));
 }
 
 static void mwifiex_usb_coredump(struct device *dev)
-- 
2.52.0

