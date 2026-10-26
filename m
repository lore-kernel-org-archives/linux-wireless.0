Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041845;
	b=dYtG+lxdF2HeADfpAwKoRAzB+5w9LgS7fB+LJq7jxsgWih366PDSNKt6Qr3s+w8Ojsw+
	 ADQsqqcBFzIn+EjHIgN2YPkLPqOfiy2FZPfGi1CPKOSFVWaHT4mb0sbxdvVlUU9cq2/j1
	 n33SLJ81Vvn0j7Fme/cA8u3YigrCrP9qY/mGvGstzpzhPZGhaD2qw76mU5FGDamSoP2/j
	 JYO4hr0pn0/K+M7akw3lP+fr1Wo+6ERLpSoqz44f32iQ3pndTohmBC+8Zq9fjw1/iVBGB
	 auu2h4MAZdR/mSRk1zflj3BvmUma+54fKvr6yMBavgIeZuDfTnYlfsbMYG1epTJ4o6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041845;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=618ppnTTAMIe+DoCnrNMfZTILgIDF8MyT0GWuzKsSm0=;
	b=R5tBgYs/Yyz5SYE7hMDIE2JLjWyRYfU9APc1ngNA9X+6xbe7GO2dFVbKZrJpJWTFVVqI
	 6gMSe9ploDod1gFCirwNpFLxkZ73MF9f+IU8++wywAm4Cf9A22xSqPUfONXfYU9L+K5g+
	 GweOSUYAN4CjBijFZi3bEDekew2rylcJ4i4PXW5anJKJr8kRArP21hwQQxL5U765EviUr
	 vs/D+YEwFLh8gjR9KN0PTq1YoL2zek3hPrecwWqY94KlwElkx00+cE4sjKR+E5Pw0I920
	 8P3bFKtgxWF/eJIQOCk62sv5iSTqwlVASWqQhsndIEs1L/76LtuU8E9ao6pYMOFuDlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GEf0g2kO;
	arc=none smtp.remote-ip=74.125.231.198
Received: from mail-oi2-f6.google.com (mail-oi2-f6.google.com [74.125.231.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33CA606A323
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 19:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C33CA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GEf0g2kO
Received: by mail-oi2-f6.google.com with SMTP id 5614622812f47-545a4fb8d5dso410128b6e.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793041844; x=1793646644; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=618ppnTTAMIe+DoCnrNMfZTILgIDF8MyT0GWuzKsSm0=;
        b=GEf0g2kOp+3P7dWWSNiQJ7BcKpjD+/HmM2WdKR4ppwelkhCkkP2KI3jYvMw+iX4ALk
         z+PPgRd891GJqxS3DrxwdyWCud9lN8uth+9Af1u5ZK10decCdrxFOD1YTf0GVy8qRoNq
         p9i73cc60vLnqKlM1CECcdvHgGohQt4LNK0DQ/XTViWADdoD5sBokVHEUFE3zDqqILwa
         WSkZBa32qxhpZdQhDfIzEPw4A15GgnoR3oPSWmCYGQOc0O56x8/AxWFadZY5YTzJyOVq
         9kzRK8gHGUu5mKtwWqja+H5cex8OwGwdibBgJo0jhCuTcLhfCh8uZQlVQ9wjlp4L3LcO
         Pa/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041844; x=1793646644;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=618ppnTTAMIe+DoCnrNMfZTILgIDF8MyT0GWuzKsSm0=;
        b=FbuSFjtYoQ7EpnOtpWMDOA5Ph3j4S0yWRQ6yh/21wGyq0YVABbeeK42SrSLWk3uKF/
         Fs0eNMgbxZf0YQY9P0lPofis1RbnOif17eCK/OorIPxpkbkr8GAVTBJyLX3cMfWIWzij
         /mkdrp7+mQPVmNeANsSRtbNbWpXld5IOQH43yaXFx9uMowpoGeHL7ejv0DwMKfAki/AH
         wP8P7/1o4svZ2x5r/OONOIq2Vh5Iqxe87NDPFuAqRDQvgZ0sxRup7DbSGDQSFZfQO1wJ
         NZRXVz2yfcRgzkbnWANBhVnfZhAc6NZKwv0HvvUEpUKdI/SzjF78SFNNMNwWO2hDPCL0
         gBzA==
X-Gm-Message-State: AFq9FYJuDpWFk162ddjAeT2dq/X2/eHEtvBAQ5ZibtHqgtcln4ezUkD5
	ODi7VOXibT9dIoIbiOVZvWxjcvYRXqdI/kewPyAG9sNxt+x4o1anR8Dl
X-Gm-Gg: AYBFou2OlMqJVO1BiXl5UvJCMGHlhf1GtBvWPWRUCqyIDLl1csGiSxrLKWuSWVQZUMq
	7SGlDxWHMPXqED4lwR33nJ8y4cb9DTWMyd9Kcysv9A6e2HQSlQc/pk9pupsm+r832RstCHCCsWz
	cUk4PKsNinNcACx0GvKEz+/7WlwnKcmxqMT9r/A6NXEnwvuAqdLQ0BslZn08nOwZz7WzJLDOim2
	ElFY5+0DPIiJeSQbspujNrQCmcOmpCpgZodKJSs4oxD7CW10g1aGENXOvxPi2tZ6LkcHFFI06Cj
	Twjpvnmi1NTnYdUQnd/hWnhUKZegTTSkZ2ksfcgh/bB2tUj7WSaHqqf4VXp4EJUJApFlcfiSrZ9
	46vTyDiqjaYeMOvrtXU1wYMehRob8HVF6UI+nphfICpQDpLS5iTs1BDKoENYkjdAt3GtPk/SXEE
	uR6gAwJy8sQJD6AxzTJ1OHM/KDim0yK2F9GMi0DGifbqNCOWEus0iZaHXfnMATz03YPu09I+pDj
	Hq/vNZXeKBqYQ1Egq0uFx7mUpThaxTrrflyHzKb+ShDyYs1gBhHobIF0aPDXvYFIx8NIXoIp9Jo
	5K9FOVsgc6Dj07g2zMZ/W/roP0RIK5AM2TRn/W4xk5iUrFQqbRkm1Un7rc3tr0gL1EM=
X-Received: by 2002:a05:6808:1209:b0:4d6:90f3:74a3 with SMTP id 5614622812f47-55c003118bemr5492504b6e.46.1793041843805;
        Mon, 26 Oct 2026 12:10:43 -0700 (PDT)
Received: from [10.10.18.223] (wsip-64-207-253-118.tu.ok.cox.net. [64.207.253.118])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c03dc3524sm5740834b6e.0.2026.10.26.12.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:10:42 -0700 (PDT)
From: Ryan Brue <ryanbrue.dev@gmail.com>
Date: Mon, 26 Oct 2026 14:10:36 -0500
Subject: [PATCH 1/4] wifi: mt76: mt7663s: don't advertise random MAC
 address scans
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-1-944b1f7e63a8@gmail.com>
References: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
In-Reply-To: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-0-944b1f7e63a8@gmail.com>
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
 Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 Ryan Brue <ryanbrue.dev@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793041838; l=1887;
 i=ryanbrue.dev@gmail.com; s=20260906; h=from:subject:message-id;
 bh=ZxzBWCMIVzBy2zHcQbyAGCsHpmwqwCbczZ1Y+dIdAUw=;
 b=JQfaph5OJQ4fE5sflHyc3YV9ljMuTh+tTrOIW1IgQQ0aFKTtqLSEtsrcaemUK4HFew0sfFGir
 3w4+xgm3WyyBDexS52kgyrjuzRFqDFkswzrbmOnDeL9cZqTcguX/7yc
X-Developer-Key: i=ryanbrue.dev@gmail.com; a=ed25519;
 pk=KsUvVaP//v/2q+ZBuacc7cLbsyEYn+AD71Sn28oZWKo=

With the MT7663 offload firmware (N9 3.1.1, build 20200604161656) on
SDIO, a hw scan with NL80211_SCAN_FLAG_RANDOM_ADDR completes in about
50 ms with no results, while the same scan without the flag takes about
5 s and finds every BSS in range:

  iw dev wlan0 scan flush            -> 17-23 BSSes in 5 s
  iw dev wlan0 scan flush randomise  -> 0 BSSes in 0.05 s

NetworkManager randomizes the scan address by default, so on an
mt7663s it lists no networks, or only the few whose beacons happen to
arrive during a scan, and it can't find the network it is configured
for.

Stop advertising NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR on SDIO, so user
space falls back to the device address. Scheduled scans have their own
MT7663 request layout and are left alone. Only the SDIO variant was
tested; the PCIe and USB ones load the same firmware and may need the
same treatment.

Fixes: a66cbdd6573d ("mt76: mt7615: introduce mt7663s support")
Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 665b0f1e939f..e6685c51fa6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -200,6 +200,12 @@ mt7615_check_offload_capability(struct mt7615_dev *dev)
 				   WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 				   NL80211_FEATURE_P2P_GO_CTWIN |
 				   NL80211_FEATURE_P2P_GO_OPPPS;
+		/*
+		 * On SDIO the firmware ends a hw scan with a random source
+		 * address at once, with no results.
+		 */
+		if (mt76_is_sdio(&dev->mt76))
+			wiphy->features &= ~NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 	} else {
 		dev->ops->hw_scan = NULL;
 		dev->ops->cancel_hw_scan = NULL;

-- 
2.55.0

