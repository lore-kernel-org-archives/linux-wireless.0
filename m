Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5D81F427C
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310367; cv=none; b=dsvki6N9Uhz2ZpX+33REmyfq8RudEibwz/KNJwvPtKD/sBwLC92D1siRaa7ytWJ/N1MK96ocFj8Ggk7Bo7/ztaYDqLOire5GyB7gPOynG6FD4SPW9HITN0YD8ID1IJcGVfTRoZPXX8LKT7F3xa6K4Vy2HKSDFCTGDDHIJkBgvYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310367; c=relaxed/simple;
	bh=LeEW41K4SKvs+/+9B7bLQV6ubT/3fp/nR1aZcNwVzO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+YgjIv20QX9sRBztBUD/Udn3WLG0w/gbTybhcW8XgIfATf9jBUxTxRLfmTFmW988BpKFlNXAMaOLCpJI5PzRlaZvFQLPP1wMLfhXVNQsubDzvbr7q6NkLxV+N7z7FJDY1Si0KjgQSEhH5vXOe4fL/ZIL4U3ueOEWnvYUEBqkQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ZGubtdSH; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ZGubtdSH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1781310363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0pKq1nYaCIzJpCv86fW/jDXG5bRjNJmWJ90iIFq7Pg=;
	b=ZGubtdSHRmzNTKD5xmaYvQWAS7PUBRkIZ5LlSFtBpIEx/fDGDu65ZdKb+3cs6cjmW1fb6r
	uSK0ysTrgyIfSVH2Kj+d9g35V2YAgJZr2Z2IF4zo9MBQG4jHzdbojXx7pOlLKOlIzRUDli
	X29IWO/U/z76/ysdn4WWH4yfBdKX7vcOgoqjVKhbtw7GSiJ5vOAFrwA6QLhdgnycVsmctT
	8uMg1MYQgl5mzej8+WGoUFPuadmcr7mDVmj1XLh5SMk8sc9JrsfTdzRN5DsucBZhBDjDvG
	wStZwE7zpn45DQQB/9K8nSEtipwjkZgSStPiBUZNY94sXY5Q7tquERF06GoD8Q==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	0072a70 <90307219+0072a70@users.noreply.github.com>
Subject: [PATCH 2/2] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Fri, 12 Jun 2026 17:25:44 -0700
Message-ID: <20260613002544.27750-3-lucid_duck@justthetip.ca>
In-Reply-To: <20260613002544.27750-1-lucid_duck@justthetip.ca>
References: <20260613002544.27750-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When the fcsfail filter is enabled the hardware passes frames with a bad
FCS up to the driver, but mt76x02_mac_process_rx() never checks
MT_RXINFO_CRCERR and hands them to mac80211 without
RX_FLAG_FAILED_FCS_CRC. In monitor mode the radiotap flags byte then
never gets IEEE80211_RADIOTAP_F_BADFCS set and corrupted frames cannot be
told apart from clean ones.

Set RX_FLAG_FAILED_FCS_CRC from the descriptor CRC error bit, matching
mt7603, mt7615, mt7915, mt7921, mt7925 and mt7996.

Reported-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Closes: https://github.com/morrownr/mt76/issues/38
Tested-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index aa525adb6743..21f8b1e64101 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -792,6 +792,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	if (rxinfo & MT_RXINFO_L2PAD)
 		pad_len += 2;
 
+	if (rxinfo & MT_RXINFO_CRCERR)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	if (rxinfo & MT_RXINFO_DECRYPT) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_MMIC_STRIPPED;
-- 
2.54.0

