Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09296352020
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 23:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791071392; cv=none; b=Cz2eTKTa27EudrGruDU92W2kJbn3AA3p+r8uboHZq3Mmtbqf0+ewyqXRjJuuwuygrZrR7nlfOnQFGdh65GQLHaoxXAZthbWqnzkd+OGKFfRCgWdV/Bz0GVN89B/0uwjcSQmJhd1rqCgOc2cbnzx0N/TMUl6EqAECgfINHZ9x1n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791071392; c=relaxed/simple;
	bh=xl4GPcatPDKKUjDT7CDuYUyfau6OOsS9xvgfmbROSqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HGQiY/QTrr24FDr6uXFMjDV5NU77ry9BCZKd1/r1+P75r0/lAF6WtaHbYx+/PodZvk/AKiNAhlI2U+Q5gQj98QbPG8wSjKa9i9P/f32/nTvvE+IIJCPTeSzrkV06CfnrYn7eCOYVPtxO+MpZ4S1z/JW1xaPsCUQBbqE6FwD9C1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=sPQ7gGb6; arc=none smtp.client-ip=95.215.58.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="sPQ7gGb6"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xl4GPcatPDKKUjDT7CDuYUyfau6OOsS9xvgfmbROSqc=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791071387; v=1; x=1791676187;
 b=sPQ7gGb6BAfQmWRqMNl8fj4Rsq/LpO113aTNzxZzfJEdJbwwfCmdxje/59JhsXTMbbt2DXgJ
 A+31lDT/+ckb/pH7/KVy/I78ezw7Zh95IrW7f66NzdzG+TPii+KApOgxCqSYBc1ypY9WOIP1k07
 AejzTZ8r8OfUOXaufH2pIooCmBKBpSX/a9Dd7+5gNq5rV1WF58c3tXWLldeNIH1T7nmhYleGPdx
 pTOLjoQMl+PUlQzGKOGVIvReReZj5rmGiLibHPPqnYJpzKfy+6qdJvJcofpPA68FekgMaMPGqWI
 w2tGLoySjzTlHeZa8EvkA0mFClasLmEkdvXShTL3zVpGA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b4c22351e5f5a4a7;
	Sat, 03 Oct 2026 23:49:47 +0000
X-Mizu-Trace-ID: b4c22351e5f5a4a7
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org
Subject: [PATCH RESEND wireless] wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path
Date: Sat,  3 Oct 2026 16:49:44 -0700
Message-ID: <20261003234944.96066-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every other teardown path cancels this work, PCIe unbind included. USB
unbind does not: PCIe has its own unregister hook for it, while USB
shares a generic one and the stop callback that would have covered it is
replaced in probe.

That cancel came in commit 81faf578320d ("wifi: mt76: mt7925: cancel
mlo_pm_work on stop"), whose last line says it covers both buses. That's
mine and it's a boo-boo.

Give the USB path its own stop that cancels the work first.

Two-link MLO on a Netgear A9000, work armed then the interface down:

                   stock    patched
    stop ran        3/3      3/3
    work still ran  3/3      0/3

Skipping the stop entirely leaves both builds running it, so the zero is
the cancel.

Fixes: 276a56883257 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index 1757023ea70d..db6fd014447b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -147,6 +147,15 @@ static int mt7925u_mac_reset(struct mt792x_dev *dev)
 	return err;
 }
 
+static void mt7925u_stop(struct ieee80211_hw *hw, bool suspend)
+{
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
+
+	mt792xu_stop(hw, suspend);
+}
+
 static int mt7925u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
@@ -193,7 +202,7 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 	if (!ops)
 		return -ENOMEM;
 
-	ops->stop = mt792xu_stop;
+	ops->stop = mt7925u_stop;
 
 	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), ops, &drv_ops);
 	if (!mdev)
-- 
2.55.0

