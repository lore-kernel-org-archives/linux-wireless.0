Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793666774;
	b=S/dWV3x0qUNfbv7+ka46oYcB3zQsWljyM2c4AIM2rxckHcGvHjKvJLeuC7D8S2AkxN93
	 KaewbRhdZI6bt0d0KVQU2ArH6EJcvIimZZDv8cakzNbpUDU5hMvmS1Z6luf2mmPgum+yt
	 LI6CG3ygjiPSsZ+7SgY90gVBQwxY9X7Aizmp3URcOvNcg445Lemu7yvu/MnRcXCb08w6r
	 vqrfUGyhoTDsN8mP9bBCQAaYZWSScIZ6Unu721fWxxN1m6SHro3Z36f5wOmWctbEMVUeD
	 VbaNvSq6FKQfqkJqE2oILRpf4rTdzO7R+FEqPHDg7LCaHta1wPimoUEytOAWPuDQYow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793666774;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=McHAtaoAopLY8VKLOPI+I31Q7QJw2mGgzISVHigw2PA=;
	b=3QVwNZIo4uwLj588BbrOjhkUMBVLJLvDuz1J+ZdYFA1HEvMWJtgZNhiVCG+AxQpUyS6w
	 hy+ZFJS6EzH/c/0iaGsbst2ZffjXsl31XX1sGkGa4AG4I0947fMyDbVqtaM9j16zW/OH1
	 d+M9X3Yk8BuBoHOtvJekDPaEtYzzU7D1bAt2gcKI3HUpp/RI2gnSGUthqXJ8PDHGGUv+G
	 4QgnBjZf4n+c/mty5nEwkA4OSnM3QnkBJv7KFusmsSggSIutI08rWnr+HXAVjpyjgbbZ9
	 ZGFx7eLcilIwLB1+ih9+8KTvPI77etfh7dnp/UjLU/4q1UAX2hRailFN2HoO0p6wg2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=david-bauer.net;
	spf=pass smtp.mailfrom=david-bauer.net;
	dkim=pass header.d=david-bauer.net header.i=@david-bauer.net header.a=rsa-sha256 header.s=uberspace header.b=SRuvU2eV;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D181606A339
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 00:46:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D181606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=david-bauer.net header.i=@david-bauer.net header.a=rsa-sha256 header.s=uberspace header.b=SRuvU2eV
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id DA1E260CEA
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:46:10 +0100 (CET)
Received: (qmail 11057 invoked by uid 988); 3 Nov 2026 00:46:10 -0000
Authentication-Results: perseus.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by perseus.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 03 Nov 2026 01:46:10 +0100
From: David Bauer <mail@david-bauer.net>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH mt76] wifi: mt76: mt76x02: only read QoS control for QoS data frames
Date: Tue,  3 Nov 2026 01:45:52 +0100
Message-ID: <20261103004553.185692-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.53.0
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
X-Rspamd-Bar: /
X-Rspamd-Report: SUSPICIOUS_RECIPS(1.5) BAYES_HAM(-2.999999) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -0.099999
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=david-bauer.net; s=uberspace;
	h=from:to:cc:subject:date;
	bh=mMof3IyROvhgq1PIWw+P3zt9Tbi9VUqagMwtUWT9DJw=;
	b=SRuvU2eVpwSAjPCeghAAjLgO6SicQeZqeD2yQHU/m3yVoq1V5m9AOZvQbrwgF2GL8nJ01UdqMd
	DpnSSkxImy288R2zGRoktpkxJKfwzYvgEZvjfLsK3wIVN7/LhqtMGXJN/Q0EVPBK4jmtxNvNh8cQ
	ryffdJcQxnfMBelL6tctXgZ68juCfZPUBS2cVkcnz/kQvM5KDg76KoND5kHcgPNNrMhfhq/XV9np
	v1a9VH7DvvXBdX8LzduWtu02+mCF+BfNc4Fygej6iWpIG7ZHP42adWs1F4d72OlYLd624HfbyOX9
	PrVvGgqRzCQm2gVZZFxstFlb5suwWLU8euP4tMovRSI9DBudq6XVcf84NQk5PuKCAdcjUoAGHnz3
	NP9qoTariJ5rf+IAvAGwqy/HwTIRxghT7ymFLe/Sy00ZRnVU8Cw4CjcgklqzcZHFPfmbnkp7ktDf
	UjZLH8Uuh06WygW0T3LT03zZ9/zmn0L5WcQnaMXFUpV53xHLcYnrZuNUXjcA+cAAm1hBhq2glxB4
	CkuXtRNfDAJ6Ir1sWMe5lme+7sUXKjn0MXDIL31K/GoJrg1sUpoxpl1ucZdtxltlydGVNc9jWpbH
	t/0XcJ3a6uDMFkMXErg8xYO9fwUPinMcfJwq/m6/TNAxIoTbpb4IlV1px9IIiSA/3t57Z73kgXb/
	4=

Only read the QoS control field for received QoS data frames.
For any other frame the pointer might refer to bytes beyond
the 802.11 header, so the read picks up payload bytes or runs
past the end of the frame.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 457767bbd8b60..3a08b57bd8de3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -897,10 +897,12 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	status->freq = dev->mphy.chandef.chan->center_freq;
 	status->band = dev->mphy.chandef.chan->band;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
-	status->qos_ctl = *ieee80211_get_qos_ctl(hdr);
 	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
 
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		status->qos_ctl = *ieee80211_get_qos_ctl(hdr);
+
 	return mt76x02_mac_process_rate(dev, status, rate);
 }
 
-- 
2.53.0

