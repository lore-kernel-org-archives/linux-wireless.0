Received: from mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31DB388E4D
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789064716; cv=none; b=Pvj/mWvxHUU1fbKL0dxXh9KyMDIznnetXZ8DFTS9zCViqE0tP08rorDeBsw1a7VU3H8SRkgxELRaYfmk6HcjawHpWoVJMbM00dCxeYTKMThclwbJ3b5GB2+cElI0Rprrl9Pt8JDfbZ6voGPJLHM1n7bm8PPRo09n21CbthSKj5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789064716; c=relaxed/simple;
	bh=Unzddf307mAvMOURKnhmf+KWoikvjT9ZPBPAxTwAQAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V6GVHVI67dZ+INmb6PQUjhQSxnGsbd3dgrxlyrzr3Hcr2ml8hpq4EyXroLMYgU/ZyxmV9nUDU3FTlzgs3VgOOPlSvF7h4hsszn49K4TTHwdOG1G1uz9W/S5/bvoa3GXh4e4KozwyL+szzmv3wJV66a3oLbzkI3guYkSRX5mNxXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=JmpqVa2P; arc=none smtp.client-ip=91.218.175.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="JmpqVa2P"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Unzddf307mAvMOURKnhmf+KWoikvjT9ZPBPAxTwAQAE=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789064709; v=1; x=1789669509;
 b=JmpqVa2PZ4+Qp/nd4bxw0YWMj2QpHvMinnwo6iVSWfGk3oUkATLTEhNdyD492m4peGEVD7V3
 9fh7GMmpK53ghysOEcifvmT4Gq4kLej7hvX5GWerFuIIwwK/lzZpq6gzEQtDLOwFrgozKtrJWKd
 6XDbpJPr8fDThELdkkSaRtxEt3PQbsnbeJ+84ndhv5v7zMMX+W3y7lT5tKCafJ/xx5pGff/ZWfh
 S9DlObe5gu/PCgVIYgWCMC+0lO0vy7lrDSvlP66vO9WhLcrtz8cWS8F6Se1NC4UhfqxRBuUDKAc
 ZJMyesP85PIQlk+17cRyOjSzb5fdYcJ6ypfzVnHP6BSPw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 424bc7d2cbc17b05;
	Thu, 10 Sep 2026 18:24:59 +0000
X-Mizu-Trace-ID: 424bc7d2cbc17b05
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path
Date: Thu, 10 Sep 2026 11:24:57 -0700
Message-ID: <20260910182457.35209-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

81faf578320d added the cancel to mt7925_ops, but it never reaches USB.
mt7925u_probe() takes its own copy of the ops and points .stop back at the
shared mt792x handler, which cancels mac_work, ps_work, wake_work and
reset_work and knows nothing about mlo_pm_work. So the work still outlives
teardown there. The last line of that commit message says it covers both
buses. That's mine and it's a boo-boo.

Give the USB path its own stop that cancels the work first.

Two-link MLO on a Netgear A9000, work armed with a power-save change, then
the interface brought down:

                   stock    patched
    stop ran        3/3      3/3
    work still ran  3/3      0/3

Skipping the stop leaves both builds running the work, so the zero is the
cancel and not a setup that failed.

Fixes: 276a56883257 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index 1757023..db6fd01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -147,6 +147,15 @@ out:
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
