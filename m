Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4382B1F099C
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 00:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310364; cv=none; b=QYIXPQGE6CSKeMYSbM+EcTQt1OuAxPPfryG1WwPdcn+zYyUpdnFMT/Dj7036BAC5+H49ZMJXvyuLsUdfy7bAx02+2el10NTEgIUX/TQzH0Dvlr9KSCYk+J+9onrjqVio/NIpMV/8/jKid1MDzykdefGJmDatYhcsXLadtA5zITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310364; c=relaxed/simple;
	bh=b3n2wBngbN9hgc+B6kVK23AReiEcWXLaZOsdJerp7Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJoEs37pbIANKqzD8Ps4tYsZAFZxoOBiBhYR7eYJbIflw3hZJBanEr+dbFa7IDbKqgx2uP1Rc7hmq4+KeiuEeH5or9cCFP2JDgwk3/xb/Gon0BBm3iXMaUJDeRq21ZC1ASV5fe3lPvJNxhUhqxDHeqouAUBothV57763nMyTpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=cxNym+ta; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="cxNym+ta"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1781310360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I7McMK7YeTZmE/zNitIska6dFjdBthhR5cB1rkIf9nA=;
	b=cxNym+ta5uyxQ1Mb8IHYFiQx39+7nxl1AJS5sAe8YX3IdWDr/gMAPF45NOk0NjSnS4NXII
	4Exbkm0/LRPzt2gMqyO0CXNG77p1/GSiLd0r+AGdl1kmVJAxERp9UcPqVp2/0+ZoO5fgYH
	dxTMQzeUxeiso0DCK62wWrGH0d7pSlvVAFgyLwY8T9/erWVC11U6wBKkznyfvaWEXTSczO
	riDkpXHosydE83uT+FjAFoNCD85Y6zGYmYdfP9kLXXDxmHRQpApvU+TCse9tX8H3Oc+4gz
	AJVF+4DtfKNJMHGGTx7qZP7VHGAfwZo4wFFYCBwHTlRePPeXlXH4xf90LQWUdw==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH 1/2] wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
Date: Fri, 12 Jun 2026 17:25:43 -0700
Message-ID: <20260613002544.27750-2-lucid_duck@justthetip.ca>
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

The MPDU length in the rx descriptor comes from the hardware. In
monitor mode with the fcsfail filter enabled, the hardware passes up
corrupted frames, and a corrupted frame can report a length larger
than the received buffer. The bounds check correctly discards such
frames, but its WARN_ON_ONCE wrapper means any over-the-air garbage
frame taints the kernel, and panics it on the first such frame when
panic_on_warn is set.

Drop the WARN and discard the frame silently, matching what
commit c2d4c8723dbf ("mt76x2: remove some harmless WARN_ONs in tx
status and rx path") did for the neighboring rx and tx status paths.

Observed immediately on rx with an MT7612U in fcsfail monitor mode
on a busy channel.

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 14ee5b3b94d3..aa525adb6743 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -848,7 +848,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
-	if (WARN_ON_ONCE(len > skb->len))
+	if (len > skb->len)
 		return -EINVAL;
 
 	if (pskb_trim(skb, len))
-- 
2.54.0

