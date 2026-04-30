Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477973FE354;
	Thu, 30 Apr 2026 08:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777538034; cv=none; b=poD459k8mnEu+YgiF/qN8s6I6sIlImUYqheWtsz6EGnC8pfwSufl5eyVfd7BvzAGJHJPSliOOvsKW47Xdl8+xHrhuHGue+U9guflXZ5dSye355ylPSnx9LNyY0Qc7Rx7vxjhbEWqVBbxOUDtsB0sCRtKmD6s0oZpgfJXd2ADO+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777538034; c=relaxed/simple;
	bh=JCt6tWeOBXoxgLUmoQyal2hT8O3E6cJwSDW9MnTpiqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrCrdTyUrUHrhwvIEfKzBC8SsjH8rzpf322NqYqy/FdgGdxLagGVorBi448oKav+cRS6VATKUQ2ktwfqNMsDJtn050RBANm/SIkFmG1wDgQ9/l0PpUXybGpzuP8n5i2fwDIJWxVOeSretoccO7UWGwhwIqiXuLNszTMRsvr5jCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EubHyBUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EubHyBUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E42C2BCC7;
	Thu, 30 Apr 2026 08:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777538033;
	bh=JCt6tWeOBXoxgLUmoQyal2hT8O3E6cJwSDW9MnTpiqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EubHyBUCQggaxhwStKQb2aj2yoDp5sa+R3y63rWzbrbiZGRLjFSFn6u44Vzfqyulz
	 71jthDqzU6zIECne1eoG9VPFAW6dzKHdYO90CbocmjGvduXF+szcd5saqxapKX7v47
	 k5SCPP6dyvtrQ6+laqCByU/jOklpx+OjmH/oQxxcdQjjaZd9gN3qrS2JlEBcLfcSDA
	 eZSvMIANbZ3mx9xDaiUlMJTc+E5N2Ml6/PUCRlNsZ28H4MLqGANOA0xDbMf55ABaKV
	 SIwWQB0PLjMvFy7gu8RO4zLs15rvVC4+yJf4lSaPdObSpFkKslhLlynOenccsasUig
	 9otq6D9SBEWlQ==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1wIMqF-00000000u0E-1qgX;
	Thu, 30 Apr 2026 10:33:51 +0200
From: Johan Hovold <johan@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 RESEND 3/5] wifi: mt76x2u: drop redundant device reference
Date: Thu, 30 Apr 2026 10:33:33 +0200
Message-ID: <20260430083335.215239-4-johan@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260430083335.215239-1-johan@kernel.org>
References: <20260430083335.215239-1-johan@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 01cb3b2830f3..8af360bca643 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -57,7 +57,6 @@ static int mt76x2u_probe(struct usb_interface *intf,
 
 	dev = container_of(mdev, struct mt76x02_dev, mt76);
 
-	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
 	usb_set_intfdata(intf, dev);
@@ -84,14 +83,12 @@ static int mt76x2u_probe(struct usb_interface *intf,
 	mt76u_queues_deinit(&dev->mt76);
 	mt76_free_device(&dev->mt76);
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(udev);
 
 	return err;
 }
 
 static void mt76x2u_disconnect(struct usb_interface *intf)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
 	struct mt76x02_dev *dev = usb_get_intfdata(intf);
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
@@ -100,7 +97,6 @@ static void mt76x2u_disconnect(struct usb_interface *intf)
 	mt76x2u_cleanup(dev);
 	mt76_free_device(&dev->mt76);
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(udev);
 }
 
 static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
-- 
2.53.0

