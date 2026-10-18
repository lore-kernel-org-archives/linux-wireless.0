Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5922E62B7
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345752; cv=none; b=YinXaz3PMnyhkL5wQ2d3uh4JJmJr1j81/qq7a9a76kLKymBmIUF4tT6yawHgTwwoE/oAyjy1OsHIbQxFgM6OuJ9Hsssfe/6gX5nQSF73afuI8nsWrYT9+p5o4woB0qfGy3yQEW5p+QubPBdERm07laY6QhkK/qgyIZ/DbahCeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345752; c=relaxed/simple;
	bh=HMtSkZz2ZwPqcJHkY55gc25r+vpWT37SCT4ZLZaqegg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmMPspyws0uGcridTnWVSDXGlBK/b6Y9vMhukCw3PmwP+ufn0YBieaYgrJScx9c3r8Dk0SvlAkAIMF7dwA2XrWbo5xq1BLKyQZhKJ/DGFR+mSwinUxFWjVZEowkO5QkSDi6ToMqGiLm2eOfBdNfGLnc9tfbekObySWZCps8dmd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Zx4LyFYD; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Zx4LyFYD"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c411e139259so132911666b.2
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345750; x=1792950550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RlOGk4B2S+sC0KxKSWrB/2y4+wcPHldmFXjF9XSW5C4=;
        b=Zx4LyFYDckopX/YcxPxV/0BsTb9SZQKfEAjfjvek+PRDdmQXAEHPx25ZfReUJAOgha
         ES9kttdgJucuwVlaLPxiNtC1WpkMZUwNaYFVl7lQEkaHdX/XhA9CTxm68rPSl+65+Xtj
         9iLifZWX78B2opf/aHV8rOeqwL5COnOhrctPPfejjV7+iOp33Q+S3AsBz4HWFi0pRDv2
         6a3kZ8h0GSGkrer89XZqwHZ6k7h9jZSi65z+Jpgc9PW8C+R0edlTTcrqrTj11OejeWSC
         /lN3/btM5etsk7yP061usYCp0uBFFhAK8LDY9KrOe8Mg15Q+tMHz+g6twzSxKekBlXMG
         X9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345750; x=1792950550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RlOGk4B2S+sC0KxKSWrB/2y4+wcPHldmFXjF9XSW5C4=;
        b=eD6iLObrzQdCc8FF39g43w3M22uyCbR42/OaGDmXmF4bhP0HoNL/GWNBCkCTyBI8Ox
         IZ4u8CyG4dXB9i5MkCGI8c+IzWw1TLiwOuSOgAkoMmqretWUUqa6aT9amWV7z+UxMaOp
         3nKNMXTeJz4ofOTDSr851VNRfTFrJcL7pmPUJOkV1lioZoCz9BCccKTMp0fM6pzhOBXz
         CZkIOZzBjqVQ8QtNV8rvgXqSx9Hu5OFJsOiCGYFz4elNfjYcFar5+sTEfg+1+TQlC3y/
         Amug6mjxxeUfGbzutQN2+uDG/M9UXeFgq2BYv5bayxeKyK95N+gxoTumY4axqu3If949
         +rTw==
X-Gm-Message-State: AFq9FYLUWcEDY/hM8258vRVMjRXnOmTY7xLw92UUnpd3rOs74pOV/jS4
	5Vf4QTnBcDb8tdyFBgbGLntJWWseJShF7LTiraf2ZkctOofy4H6DBi3SHTcG6v44Rw==
X-Gm-Gg: AYBFou2LaljB9EEtTibOz7JrKjz+7QhJ9UIlKlittAJvb1l38gwIC7sWbT4ump9aC4z
	gu3Sbs3RuFPpnz6SxXcw7DBkSpY+EUNk/RqTOnyQWgBGakxkuiznJmvedfyt/XvwqymRLEnOqNZ
	5vyhPC67fOd/7IF5Py7DHNmhcZ3CDQKaOL+6KlSTHxirXQZ5qGS1Ui0SoxlFunrC3Ll787EySZX
	00Exax2iuyrZ8oNuTjUAr8pGpQAth7kRUa8IqA6wF20ACPUTkxi+yMY7diWI8VdDdin/4XqyOXR
	qZhylEDnwujMzs2gMdqLIQOrtB9tbj7KYs0LxpDRmu93TpHUbBtWI4cygT1+BXHmN7t5PlZMtW2
	ttkmwymcaQyJK9enfdNCkZhVihc1tIxtsISmEj/JGCabYk+Vv4L9+uzzEowuZWIRdnj8PLrlIp9
	urKxBibfKmoTIfUpf3Lh5HiQOTD312hhAW2UHyYofdcP6OsaArnONaJv11LX5D7SDTAXfuun8y7
	Dppt+9E/Xu/CKU0+UC6heYWo6izUJZNpRdMbR0ZhECl5USECKBXqL/QEpuSnOsr8yjqxWyzy7/E
	msdLot5vB1C1QSsyI42NS3JsBLkb6djUYrIPMGJ9XIeVEoVFaHYSdsazdpD85NsSKvq4NE3c0Kr
	zcdTMid1mYsgvNIiLGE+n4TqG8kwONOVNwm91xIsuDFwBG4EELpsPb2CU1fiH0vaPqqtgTOSxJi
	dBYo7MGjMn
X-Received: by 2002:a17:906:ba89:b0:c31:6a37:f284 with SMTP id a640c23a62f3a-c419a05c3d2mr331429866b.1.1792345749860;
        Sun, 18 Oct 2026 10:49:09 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:09 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tamizh.raja@oss.qualcomm.com,
	jtornosm@redhat.com,
	baochen.qiang@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	sriram.ramachandran@oss.qualcomm.com,
	yaojiale02@163.com,
	quic_pradeepc@quicinc.com,
	kvalo@kernel.org,
	sven@narfation.org,
	john@phrozen.org,
	toke@toke.dk
Subject: [PATCH ath-next v5 1/9] wifi: ath11k: free tx skbs through ieee80211_free_txskb()
Date: Sun, 18 Oct 2026 19:48:56 +0200
Message-ID: <20261018174904.1757161-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018174904.1757161-1-julius@bairaktaris.de>
References: <20261018174904.1757161-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_dp_tx_free_txbuf(), reached for the HTT REINJ and INSPECT
statuses, frees the frame with dev_kfree_skb_any(), unlike every other
tx completion path in dp_tx.c. This leaks the tx status clone and idr
entry mac80211 keeps for a frame whose socket asked for status, as
commit 29d15589f084 ("wifi: ath11k: Cleanup mac80211 references on
failure during tx_complete") fixed on three sibling paths. With
NL80211_EXT_FEATURE_AQL, set by the next patch, it also keeps the
frame's airtime charge, and an access category at its limit is never
scheduled again.

Free the frame with ieee80211_free_txskb(). Neither status occurred on
the hardware below; the change is by inspection.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 083aca8ff355b..f7d3cf0ff0358 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -305,9 +305,10 @@ static void ath11k_dp_tx_free_txbuf(struct ath11k_base *ab, u8 mac_id,
 	skb_cb = ATH11K_SKB_CB(msdu);
 
 	dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-	dev_kfree_skb_any(msdu);
 
 	ar = ab->pdevs[mac_id].ar;
+	ieee80211_free_txskb(ar->hw, msdu);
+
 	if (atomic_dec_and_test(&ar->dp.num_tx_pending))
 		wake_up(&ar->dp.tx_empty_waitq);
 }
-- 
2.53.0

