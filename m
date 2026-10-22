Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.236
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659078;
	b=FDuhD5J53h0y48FzYp3a1YvqZk4mpRrKl6MQ1IapCaoZEiJhoH8q7uzA/Qbmwu0Azv0R
	 yb8dejvTCWzZstmUXYIsGd0WF3rByxNBAP1/Q55T54J4zaqLy/s9vVu5WU3iiLGHvPOSe
	 avOrCdr+Fn0tGg4NZPi8IX51dLvZRECNV384B/KdIOX4ZOqrzDqkTVP0jpn18Lc73gHBo
	 yRRoF0sjFzasvN6W9J4wmx4XTqX+LkByussEAUTF8RrkWdChF5Jz5znuz7YUbwbxlzf+F
	 8WL3FFHg94TzYLtKnnZ8X7xJbGN/16Cupz4Z9rBCRbNKx9BG1KX36m3Jkhnx1AVE8ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659078;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=x3LnsTRS1dnrRM4yNtWpemXuIEJdYAT0PtyCG1QfkdQ=;
	b=sax0yhrxa0RcY/zQucZUCjMZPjHoMM+LZQcce5EGcHZrvHMifwY+vVBkpOcokt3YlXZ6
	 nvkJXFgTQwxp4FubrNvqjokbGB/FrHTWy1guaL9BQHRhocoDJBViMjWMTEr/RkQHlxTpy
	 kPSFLjihhq5FLu9c8MU6UJ0IQ46fph3WoqWJpoClMc9YbON0dE/bJqcpkYdvyBVUGCuXw
	 GvG2VnnlvP8YhJoygxYVVAPeqnAB5jE7g8gc2pYjtA2WQYQuns23kzYaFWeJfXhwKa/E1
	 kwdsnyb3jfc/bpsOtwTMOHu+g6iAx1fPj3Axb1JfzY8bNP2ffRf12M57CHKI1XkSH8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LCstpISX;
	arc=none smtp.remote-ip=95.215.58.236
Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33370606A31E
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 08:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33370606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LCstpISX
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2f8PtKyL+H9I/dXyzzOyuH2jrH5LoCjaCgKtz8un7Pk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792659075; v=1; x=1793263875;
 b=LCstpISX/qKcFrStc7RUSvzSRZTQSA8jxyys/kekD/Be0ki4pJj2cpEcfQLTNISbiPVRBb9k
 GbtsKBCWtQBuz+UDzaWvkjI7XJaot5ZOB/Ol4FcbIa4EwIEILzmeubOoiu//afMpoy1DCJNeU9F
 XrM8jEhuiuzuqiao6ixWApVw=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 7d77fb6879c93d29;
	Thu, 22 Oct 2026 08:51:14 +0000
X-Mizu-Trace-ID: 7d77fb6879c93d29
X-Migadu-Flow: FLOW_OUT
From: Yi Cong <cong.yi@linux.dev>
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	mingyen.hsieh@mediatek.com,
	emery.hsin@mediatek.com,
	Yi Cong <yicong@kylinos.cn>
Subject: [PATCH] wifi: mt76: mt7925: do not report resume failure after reset recovery
Date: Thu, 22 Oct 2026 16:51:00 +0800
Message-Id: <20261022085100.132368-1-cong.yi@linux.dev>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Cong <yicong@kylinos.cn>

When the firmware loses its state over suspend-to-RAM, e.g. on
platforms that cut PCIe auxiliary power, the HIF resume handshake on
the resume path always times out. The mt792x_reset() fallback already
recovers the device with a full reinitialization, just like the
hibernate restore path:

commit d54424fbc53b4 ("wifi: mt76: mt7925: add pci restore for hibernate")

Yet the callback still returns -ETIMEDOUT, so the PM core reports a
resume failure for an already recovered device on every resume:

mt7925e 0000:12:00.0: PM: dpm_run_callback(): pci_pm_resume returns -110
mt7925e 0000:12:00.0: PM: failed to resume async: error -110

Report success instead once the reset fallback is scheduled, and skip
the follow-up commands that the reloaded firmware cannot answer.
Platforms whose firmware survives suspend are unaffected.

Signed-off-by: Yi Cong <yicong@kylinos.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 0d477dc1086c..82ee58eca78c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -886,6 +886,7 @@ static int _mt7925_pci_resume(struct device *device, bool restore)
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 	struct mt76_connac_pm *pm = &dev->pm;
 	int i, err, ret;
+	bool hif_timeout = false;
 
 	dev->hif_idle = false;
 	err = mt792x_mcu_drv_pmctrl(dev);
@@ -927,7 +928,9 @@ static int _mt7925_pci_resume(struct device *device, bool restore)
 	ret = wait_event_timeout(dev->wait,
 				 dev->hif_resumed, 3 * HZ);
 	if (!ret) {
-		err = -ETIMEDOUT;
+		hif_timeout = true;
+		dev_info(mdev->dev,
+			 "HIF resume handshake timed out, recovering through reset\n");
 		goto failed;
 	}
 
@@ -939,7 +942,7 @@ static int _mt7925_pci_resume(struct device *device, bool restore)
 failed:
 	pm->suspended = false;
 
-	if (err < 0 || restore)
+	if (err < 0 || restore || hif_timeout)
 		mt792x_reset(&dev->mt76);
 
 	return err;
-- 
2.25.1

