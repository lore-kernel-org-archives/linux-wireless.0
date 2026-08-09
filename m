Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0778B1C2AA
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786279794; cv=none; b=N/uJGDxOe/w249fyIrjdczbQ0XJptRXLscgwS270zLrNImdQBl/MBPsO0NhMpV3RA4W89uNV1epTy/FbWRY7RiNnL0vif7CzZZe6uhZwKVXamlbXe3nbkTUb517GlqXBIO89xSxTs+fCz+Whk75bDAyelh4lHJ1w4psoVYwlct8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786279794; c=relaxed/simple;
	bh=OzbdYbL+gUvdMTuZNQsfLo3ZKlrCPm1lBLn5Zm/LECQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=crxBNMoVgdOdfpGz5y74QJeMlmn+L8bwrnGd6NuUZijifmiLu4f/RORqbzF60xJA3NMKHjmoVw9t9TrRhzokHg6x7nWy6i7pKJ1sFWEFDGWy9Ip+fpgDBSWDmMNERLWxhcGhpZgoti+a++7QVoSw3Fvl49xJGSGQ7T1vjjOA1zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+FYeqZp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+FYeqZp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ccf2360620so7938825ad.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 05:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786279791; x=1786884591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ju2ymnAxFp+A32fedWTUymUkCqeeJhrljRjaYcY60bw=;
        b=a+FYeqZp0O10oKR/pwI7Y0KZj6HlICxhXVGXKzNG0CTN66LXmXx4+0NiAdOV3+wvSq
         7IjsKgKJKrpmeCTksM/944dU4G0WCheO2/11oYZAn4DLmfQQRtRxqrcc+Ft6S5RZW2We
         ffFBi/H2zXrtgd+f5IZjNndVMaCZ0fbz8y6DTNkAJGqXxKUa8vCaUCnNzkpuTZgVODf6
         d8moVK5RkefLtIVD+7T8LnKFH31vMIkxQljT8fXJ8jK98iGnhsEgDT4UO+cPt/NIeAH8
         LCI0QP9ptq4jkROicxxPaPfU/T9Bb5MzsvbZaxOILWYWDj89lqvwddOlL9210c+pyxYE
         8GLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786279791; x=1786884591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ju2ymnAxFp+A32fedWTUymUkCqeeJhrljRjaYcY60bw=;
        b=f8OwgtqmxS/usAMGn4U4Xm/dXWegEbQIV38WJw2nz2mL1IX6J8Sy8yrQ+s1hGkzw9q
         s6O9W3rXsLksrjcLpCd1YWUouUtGqcYcIJjdEhVlJbFqx0Rq4aRQgQZ6Xf+QBf0O7LiO
         nJx3JboclYC115ZpNNZxSdSErJ/Yp40qFR5YASG+3LpI6FfUDAVq1yjLswZOxSHB3jbk
         K7/OjCGXx2Emc14xMRsWMI1MultjesLEvaTS0pXGKkkiDNDmhlFWEEm/8a2brlod87Fs
         cLfN3YI979tQZwKgjPRXTQRwmBcvjRDSvnqSsvP2GAm55YSSHNV9CV7w2GnKmkXr4kvv
         K4Mg==
X-Gm-Message-State: AOJu0YxWKUqXATT0cW6VgePmwJluHlNrhhtexZ1MDY2P9gfCZIFLXmVh
	ZlMGJZkcXXCfaQresmMdKlYx15P+CMcd88fuEFiG5MhdrhNkuYqFDqRn
X-Gm-Gg: AR+sD13Zv2yQOTup2W9sBsHw+efKE8SNHN1DSqMCSTgRS46K5Q2OVWtDJQHy75G5U4A
	ENdVid6YbPwaZbfJINiEWMK2QDfS/62K2ND40yfI3j3RrAlJEL8wl/kPYca8RNCRPcLErqu3ZHn
	KM5vFp1319uqlUhhaOyulYiUTUHL7CTQKLubCH+UYR3ODA5wOJ1hAB82lsTFQ7a1VO30Xjr4jcJ
	nXRpu8hnrKGIAXlYwxFHy0XnzGW2EwmjGjjR3a6RMhVTLOk3nwGjyAaebFPzEMvk9EqihaTQr0j
	jyRAjLp5jDwKvjW3V+6cs0CpK3zgh6pZfhK/B7XgrshhjSLen7CosGF7Egnl5CSq+dB7TtnAm11
	i+MBJMCsQurTxt8kUizOeadwd7UXuT0zGIQZiyypiGx27r1AzTCNbcWMsJCym5iHHpLUn+6ddj7
	u742KLf+lfuSrFC1MITyt5KysJbP8wzsyxID5Da5ti3KiK5ZOQcutWCVLSK6kulqfvFpip6PjUv
	yc=
X-Received: by 2002:a17:903:8c5:b0:2c9:e2c1:4fb5 with SMTP id d9443c01a7336-2d106e99159mr281206385ad.22.1786279791012;
        Sun, 09 Aug 2026 05:49:51 -0700 (PDT)
Received: from fedora.fibertel.com.ar ([200.55.79.212])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebde2e6sm29510770eec.21.2026.08.09.05.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 05:49:50 -0700 (PDT)
Sender: Mariano Baragiola <mariano.ignacio.baragiola@gmail.com>
From: Mariano Baragiola <mbaragiola@linux.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mariano Baragiola <mbaragiola@linux.com>
Subject: [PATCH] wifi: virt_wifi: free skb when disconnected
Date: Sun,  9 Aug 2026 09:49:47 -0300
Message-ID: <20260809124947.3590270-1-mbaragiola@linux.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the simulated link is disconnected, virt_wifi_start_xmit() returns
NET_XMIT_DROP without freeing the skb. dev_hard_start_xmit() treats this
return value as consumed, so every packet sent while disconnected leaks its
skb.

Free the skb before returning the drop status.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>

diff --git a/drivers/net/wireless/virtual/virt_wifi.c b/drivers/net/wireless/virtual/virt_wifi.c
index 2335e45db8b8..b69a4650fba8 100644
--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -434,6 +434,7 @@ static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
 	priv->tx_packets++;
 	if (!priv->is_connected) {
 		priv->tx_failed++;
+		dev_kfree_skb_any(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.55.0

