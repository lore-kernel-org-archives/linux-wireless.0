Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041850;
	b=dYWFRgA5uT1QOmtuc/GBaTjqkVODZRsO8NAuAeCPhbqqOtkgbQIswnwRG73Lxo17XGIC
	 9RjS3d3Zaii0GCttONOk1t8QeBNTe55/sc+5w4oDkc8a3MJwwIKisQLrzGXDysOt7we/v
	 s2TazDYvTWg4WjVtJEpEJhBqP6eXX329H6pZLigg1gPJosmHHUl+oT5P8eDOENPjdp1+V
	 b21ns8t9AiKzaqXZ6Hjp7ANVojCGLHBY+/DZVBFSz+ev80JEMFNki0pqQzlQd0InSPZhx
	 cO6lH8s7NL42XB6u3YHkRewPjyyIgeVw+QqdRwK47rA3TxoncXYQo0D9q6LgOWCynSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=hslISBXc3XOFlG6x7S2yz4ikb3NBWFkUfj2BOwtECQw=;
	b=JLgVApb/BRGUahyBhTtBExwlUyFDHyVFflykI7mMjxNXT5PgzLhGK8VKS0TauYupye/b
	 JrWyG+pzXlte6uZ5xL5QUKpPe9wBGzYbDlkG4LorX707yIXzDVDurdqLpLHYzm4Gp+IIF
	 jZfxRnHfZtij/80LrNaSMnRY8XKTt77aWYYthvPdaRZleL+UCPlfFs9R5SVxAOgr3XlPI
	 iCsLtpY4F891sebcLlSpmRw41T4eKLyWY9wcPQ5kESuU54SAekg4iAmkAHV7R5GbviKgM
	 pN26wBL+VpCr3oqKiU3PxkKsW2NcvriKbW0nHTYJEcHLPDSzfjwhbUIfdUw0WoJynug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cTBAgOOM;
	arc=none smtp.remote-ip=74.125.231.199
Received: from mail-oi2-f7.google.com (mail-oi2-f7.google.com [74.125.231.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4CD606A31F
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 19:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE4CD606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cTBAgOOM
Received: by mail-oi2-f7.google.com with SMTP id 5614622812f47-4b39374fab5so1426140b6e.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 12:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793041848; x=1793646648; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hslISBXc3XOFlG6x7S2yz4ikb3NBWFkUfj2BOwtECQw=;
        b=cTBAgOOMT/JaAVdk+8VK3Ol13F3yJNNR4A9lb2ukhnCmvChU6gN3u0vGkPXngPadzu
         78SlP2CS6eck9TOLZ8uX11Nb8nD3HBVKsSfUMz0pd1yPg8ZQDhQzaRZvVrU+laTB97ad
         YRO28GBXEiYR9BK+l0SgLtNzzMOcS7gK5vqtIje8e9KFyWLijApLaBx4OBMj6vXyocsD
         I+3ofZILIstKPIj1n4Lji/yjnVMZdptVbIFo7R191AGgnIdO0vP0zqmwKMHNQLu8VJw0
         eDJiWvHT80Z8WXVhi4w9vWYkd2hw9XQ7IwPJs+wGFjdKH1KoY2IWtgfd5EPQJyTk+SXQ
         5GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041848; x=1793646648;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hslISBXc3XOFlG6x7S2yz4ikb3NBWFkUfj2BOwtECQw=;
        b=l6HTP5DHJ14p5Iyj/b4MOzSkd+Dk5Natb0CNvoWF9dto8H4WVYdgup9bBS5A1Vi3yz
         74mOKu9NIoG+gUCgUcLyDZ7pEY0a72LxZHz/vRNKcIWIw/rBTz/Az4Ag+s5uIE0oDR5O
         PBLUd3UzayiKN8MivgGip5OlkV8zLLyV3pmAq1Fo16ABq6L3jD5l/R2+kWoQNWVzu8sw
         pmceP4SqebvIunYNFv652L4ugX3iM+7m2rxID8Nma3AFZ7U8VO5Dn1/M4LFrc/qkYxsv
         uSAKq7+B6ZkA0aPOlsQpmxbc2sphMNX053VdNQ7nhR2DjbqVuuR789VZCvM+dAYCw5DW
         bfxA==
X-Gm-Message-State: AFq9FYINErKIY9GPOOCpqimpK3238oI/1UWl282UqZXsdunPdKBqmEBZ
	yr/9G9Y+iEgppnU+CaRKcP/j+jx5rrTACo6uNPPhvgKbx7CPDZCbx+OA
X-Gm-Gg: AYBFou38xf6FGS97SrYIdphi0vSzTsrLFd1Otc7AD2WAXOr1h26f+tZOtZ0Copdi6Ic
	WEmkOViqHR1T8kq3sz+xuRxxyPSxiDxIiiD2NjOOP4MCV7VHqOyaxTOZ9L11XrOVuDEoHZXNCNW
	GG6GV/ksKRWTi3rGB+fZY0IgqSF1ovpFYKrNBYb9Q6p2QI1J1IGIB4iqoSpzO8yoneUIlf+0/MQ
	1MhevtwceE4NLKIrqB7WlLk1cvn4fj0epGzBo1ivXwK8EaaP9jRtXvFS/shJMk4yuFNYG8rDKD+
	yvF0WcTUVQd/niAxQ+P7KhZ1c347B1pjIfjU4HWPAdX+8aa2Ax02VvMtjkrqG/RpE8Lwsya6OiZ
	Cb9Gtn8RHbTWBPdkAMlsJe/DFYtDIjlCajkfiS0Tpq0CGyiu2pzG8aOXUiV96reuR0j84h3Fqn3
	vITZ07MIK7TBwxh/1VlRUhidQhgSXNa1vgOgVR8p1+U3Fr4kqcpPWtlF3/aDX+a+yey83JWzT+F
	LHq68Un9sWtv8Hv2ilNV8Zti3cXRq7D+aPJ8hL4BnJVajE3fVZZbghSGb5E9TFwbZH3nuwPfkR/
	sxHPdunpAYH7/Y1t8R2bOzCFXCHO/NlKOXynTMTv0KC3vQ==
X-Received: by 2002:a05:6808:30a6:b0:4cb:f21c:a794 with SMTP id 5614622812f47-55c00261d33mr4881021b6e.28.1793041848572;
        Mon, 26 Oct 2026 12:10:48 -0700 (PDT)
Received: from [10.10.18.223] (wsip-64-207-253-118.tu.ok.cox.net. [64.207.253.118])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-55c03dc3524sm5740834b6e.0.2026.10.26.12.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:10:47 -0700 (PDT)
From: Ryan Brue <ryanbrue.dev@gmail.com>
Date: Mon, 26 Oct 2026 14:10:38 -0500
Subject: [PATCH 3/4] wifi: mt76: sdio: use CMD52 to mask and unmask the
 interrupt
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
Message-Id: <20261026-rbrue-sheldon-upstreaming-mt7663s-v1-3-944b1f7e63a8@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793041838; l=1910;
 i=ryanbrue.dev@gmail.com; s=20260906; h=from:subject:message-id;
 bh=9KbBbuhojfi8oGqXT5PidIszoMscEC5hDq/fupskgeI=;
 b=GzThTvCATPI/ee8BIDVBMnOGZfI02Dm40DZnZKhDEynwCCp6k9M/V6+94HfyPX0T6bmxTpVzO
 4ZYw0j+17aTB3Y/o9OUS/sxyVi3rCA6VeyIZ/kuxBLRQX4KxMFuEwNT
X-Developer-Key: i=ryanbrue.dev@gmail.com; a=ed25519;
 pk=KsUvVaP//v/2q+ZBuacc7cLbsyEYn+AD71Sn28oZWKo=

WHLPCR_INT_EN_SET and WHLPCR_INT_EN_CLR live in the low byte of WHLPCR.
Writing them with sdio_writel() costs a 4-byte CMD53 with a data phase,
three times per pass of the txrx worker. A byte write is a CMD52, as
MediaTek's own driver uses for the same register.

On an MT7663 SDIO module (mt7663s, MSDC2 at SDR50) the writes take about
17 us instead of about 40 us each.
The worker is shared with mt7921s, which has the same WHLPCR layout;
only the MT7663 was tested.

Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
index 3f314e8e1e69..311c31e87ee5 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio_txrx.c
@@ -319,7 +319,7 @@ void mt76s_txrx_worker(struct mt76_sdio *sdio)
 
 	/* disable interrupt */
 	sdio_claim_host(sdio->func);
-	sdio_writel(sdio->func, WHLPCR_INT_EN_CLR, MCR_WHLPCR, NULL);
+	sdio_writeb(sdio->func, WHLPCR_INT_EN_CLR, MCR_WHLPCR, NULL);
 	sdio_release_host(sdio->func);
 
 	do {
@@ -351,7 +351,7 @@ void mt76s_txrx_worker(struct mt76_sdio *sdio)
 
 	/* enable interrupt */
 	sdio_claim_host(sdio->func);
-	sdio_writel(sdio->func, WHLPCR_INT_EN_SET, MCR_WHLPCR, NULL);
+	sdio_writeb(sdio->func, WHLPCR_INT_EN_SET, MCR_WHLPCR, NULL);
 	sdio_release_host(sdio->func);
 }
 EXPORT_SYMBOL_GPL(mt76s_txrx_worker);
@@ -365,7 +365,7 @@ void mt76s_sdio_irq(struct sdio_func *func)
 	    test_bit(MT76_MCU_RESET, &dev->phy.state))
 		return;
 
-	sdio_writel(sdio->func, WHLPCR_INT_EN_CLR, MCR_WHLPCR, NULL);
+	sdio_writeb(sdio->func, WHLPCR_INT_EN_CLR, MCR_WHLPCR, NULL);
 	mt76_worker_schedule(&sdio->txrx_worker);
 }
 EXPORT_SYMBOL_GPL(mt76s_sdio_irq);

-- 
2.55.0

