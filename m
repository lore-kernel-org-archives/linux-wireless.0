Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052233;
	b=3kL//N+kexJncBtwbRxAAJ3r7P4funzb1okQQsKWpGa5+wIKPzZ1ilvGC1MTQ5fgA0TV
	 laruljk1QoSwJwcblni3btOkFuIJDOXTNyIt//ak98iVECeQb585xAyp0J11hGTFi5oay
	 rWfldGQvb/lF0a4DI4NcIjEAv0QEWAPVZ1cHU3V/A824R2TCn0bsZ+0M4iSleO5ZaTjuN
	 e6sioFq5W1w5/pBjHxQyrA7/4FtXm8V/zWvDUCs01ShdDI30ypbKa993IAcHh3zTfjKIf
	 72VQafMYRHzFDkQmzW1cE2P5C4B/aVvd8eA6caaYj1WDfeOL5A8a5QJufvhI5GHEsoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052233;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ibD08606yEFUxTJGU5K0RlgFEJpEu1WZ7fdVr6ZErf8=;
	b=MBwmHlfvvGoP4EVAZ7zlqpltLOI/eHeecZbsmR+MvXJaPxd4XjVy/+cOKSCq1EYnEeTD
	 aWteZDIRUlfPHRrpfVYIwiz0AByaxYRUdPy8UDCI2eXFark1ZiijdU5Aux5W8eHy0KADi
	 +D5kz9Eb7K2iO+ZSTPVwFQWZNdBe5QbkxNCaiInIqMkHkE6+/jxidpjAIVIWGkfsEFH7h
	 d/MS5FZH7iaDSHkdbudme5nyYFC1QjOlgRcjE5GrBsZGh4onUWNFqtqJ5MqFWJe/kcHqT
	 Yy3KXS61UBhs4wTk2SWMrK5CC1f1mRGVUYKzOrEiCeFihd6m5HBjStIQbVRAVSY3MIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=frI4I1AT;
	arc=none smtp.remote-ip=95.215.58.10
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1466D606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1466D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=frI4I1AT
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jh+Q1NPj1U0mthfgFZ04CAfxglcvSphNXg64QZcFOik=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793052230; v=1; x=1793657030;
 b=frI4I1ATEmh1cT7dDgpYt0tW2TtZHvgZ5VjhDk/QS1ImIHUqSHPnR7kz5tK8VdVPF8CWTLnx
 Ep5Y2VMxX0tMOCP/+8zSvzoYvvNySfqmXS2NWG360chBXjjHibiq/g90YRoNMXe+EWwD3nm8phf
 MJ0+eEN0SxrWL5bNqwR3fumM5e5eofz46iVzl+3imv8pbYwXFzT85Yej5sHYepDnvV0vH8Z4h1n
 yMw8yP7Y9EYKo3ttYGIOA55GDxjc+XS9tucnYYOw9kAl4oZe997qlnXDCUl0ujAq/GyIXWypHTp
 QYIxJeLwp3Ug3CbxcxNf4WUDDxdEALAANScrw/4ShBisw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 475ee133ccb2599b;
	Mon, 26 Oct 2026 22:03:49 +0000
X-Mizu-Trace-ID: 475ee133ccb2599b
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: mt7921: let monitors see other stations' unicast
Date: Mon, 26 Oct 2026 15:03:46 -0700
Message-ID: <20261026220346.601314-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
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

After an mt7921 has scanned or connected, its firmware drops unicast
frames meant for other stations even with the sniffer on. A monitor
then gets the AP's beacons but none of the unicast between the AP and
its clients, so it never catches a handshake.

Clear that filter whenever the sniffer is enabled.

Fixes: cbaa0a404f8d ("mt76: mt7921: fix up the monitor mode")
Link: https://github.com/WLAN-Pi/wlanpi-core/pull/364
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Tested on wireless-next with an MT7921AU and an MT7922, the monitor
on channel 6 while clients joined a WPA2 AP:

	handshakes caught, of 3      before   after
	fresh driver load               3        3
	after a scan                    0        3
	after connecting                0        3
	scan while capturing            0        3
	connected while capturing       0        3

Same on 7.2.6 and on 5 GHz. Left up for a few hours with a scan every
few minutes, the monitor didn't miss a handshake. 6.18 also needs
a7d35545c2ce for the scan while capturing.

Once the monitor is gone the radio connects as normal, and the firmware
turns the filter back on by itself.

Doing this from the filter callback instead was only enough for default
monitors. A monitor created with only the fcsfail flag never asks for
other-BSS frames, so it still went blind after a scan.

An A9000 (mt7925) doesn't need it. Its firmware clears the filter by
itself when a monitor comes up, even after a scan.

 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index a0caa77339ee..7ef870b2a37b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1207,9 +1207,15 @@ int mt7921_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 			.enable = enable,
 		},
 	};
+	int err;
 
-	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req),
-				 true);
+	err = mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req),
+				true);
+	if (err || !enable)
+		return err;
+
+	return mt7921_mcu_set_rxfilter(dev, 0, MT7921_FIF_BIT_CLR,
+				       MT_WF_RFCR_DROP_OTHER_UC);
 }
 
 int mt7921_mcu_config_sniffer(struct mt792x_vif *vif,
-- 
2.56.0

