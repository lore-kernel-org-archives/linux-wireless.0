Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133553E5EDA
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 21:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788557141; cv=none; b=ed8hT93P/Ldg0oiy1W+tufRi0fpPdBuG6bfxfNY0nMla8YLExeRvGC3nVUCbXEzkzxkTTbtJbjx/8ETNGW2UB4UXEdWEfygipqWCT9k18W98qdaYFYs87OnzypD+EYNILEE6tZrX1RG2iTOAFroAynJ73vOqv3E5Q7etz5TZcgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788557141; c=relaxed/simple;
	bh=Wslx/l7V3evJ7hILTLC32m3ayC5+HML9tyYibTpzgtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fL6S82NViApTVTVycTT4lJVgot27Aq405P5xZu9vAZ14gp6NQLgTIe2Rp1f8CDpSMXmXkFEJncXfYtiJxvxnuSYrSYooMWG8quKIo3o2qnfGof8Uv2ppL4To82qv2LiSh99gZXXjuxiJoWpLfzvz08JACJX+bxwnEWXkQYIWpFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ffC1fWsZ; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ffC1fWsZ"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so1855253a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 14:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788557139; x=1789161939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fVOfg9PgU/mfeubCPPMqd+U1k0Vvj2HlWQCTwM0265E=;
        b=ffC1fWsZDD35bHGKoy/oS6GbCaL8VxWaoqxJhg3biwCtUyjsgN+fMruJIZNfpojnhG
         PPuCtZmzaRrq67MyiXbQBVExWjDPeGjS4Jibc4WkZybqZAGXzwsa1jquh2UQYgletU44
         2tgDYQiq4UirH/B7Et9htOhVyv7bpJOmI44kvYCvKA2RwSTyLSgt7TVJl7j+bKzf7F7r
         Z+HyFkRbbvvoCCzF/lOIvp2dS/lUl4xqae+z21yIFepkYYoATIXn0AQf5doQkkEzOwk7
         uqnZU8EO6dxUgK+4XYEIycKp+8sLBYZwJVYzlDHLmvoFj3SEs+D9GHPlv0AMqW6gMi+H
         lKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788557139; x=1789161939;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fVOfg9PgU/mfeubCPPMqd+U1k0Vvj2HlWQCTwM0265E=;
        b=C6+JOOFdCDPTLYoWZ3NgjqpvxOWpkSgLVN8yNYdqBmpjbKi5TLCgrX0nymQRkm0PdM
         vUj2f61v5t8DhBdQ8FJn/kGjhNUEcglvWH6YiKEhq9B3ysxWV0C+bk/7xfpQ7OKQy0Kc
         sk5vnxCoQVLteMU4mpBEa/rJwt2QRh4PEND1rUn5xFiZPTx9Z21sSioCBzhePQkl2dgQ
         iv1z+C5u8s8MMLiwqHQwNQrVo3dAv3N5fjZb9K9dSz8ds7PYgOnQeTTcnD8NCwVOyBsl
         gcFvuPBWfQaBaWOKLLqt9e2BkPB5vhV92gOXvu9mfMR5cal6CnxBvv15QY9z1WO2f2+L
         4ssQ==
X-Gm-Message-State: AFuF++n3FcqVHLKudZ0zYw0eIcNEPCX3DqDb5X9i8hP7kpyCm82X8xiR
	gdZPcutuTVwhFUx+1hhfu2dC+5CCMKgQwXH+uH81Ssbr6FCxL2JPE0eVaT7uKA==
X-Gm-Gg: AYBFou3f/PGQ3ZKW7x/8ZATG/+Fjv3/BeZVl/tNh/AQXGnxUa5KcB7gbWPDQBc6zjwt
	FmsmonV6MC91rC09LuZ40EfVRl2GPMmj4Ceffd/PTENrr4thK4D9NJrJARTStJ1v5zYnq0T+GaE
	bpLIyaRVDmZGbMs89A1nUY3n8I0AcmdtLfC/B8PCvijPYYt0wqbRgvWy+Xmf7oTdUJhdcG0ksNn
	l9KSR0caOHU2aAWGf2Gq5HPlbun2e89uHkdI+qw7h039FY2UJxrRwjAAj39dSxO5lQ09Avuszl8
	l9WhG7JZzg/TTKcROMJ13CmtAjB25cI1O5d/w21Ramrvw5DW1BwHScNBBsL1JYe8Kwn2E8Zntro
	mHwori0K7aGjyyV+jfbVK5D/ab/Yqy/pfiMjYoNsdswyYtXC3t+FygHD6MD0ED/3LIlRGu6iYcY
	+prCeNFC2TNu6/1pV+iDOQ/L/IRMquXXcK4vsqsn5UMGGMFprlmt+ZHcl4nAfx2zVbPh4LVT/EP
	gIHAWSqu1qWntvbz+PWfmdQucInoHEbtgrbONso4FKT3R2DCJGpR40pIRkTapVFKCZZnCKDYnzc
	r7of5cKk44gaf99X5uKnpo9/pQOOrIldw+YGbA==
X-Received: by 2002:a17:90b:4a48:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39b260d2d58mr13373795a91.6.1788557139119;
        Fri, 04 Sep 2026 14:25:39 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c3a526sm12261984a91.10.2026.09.04.14.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 14:25:36 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH ath-next] wifi: ath9k: unmap DMA and free skb for stale TX buffers on queue drain
Date: Fri,  4 Sep 2026 14:25:34 -0700
Message-ID: <20260904212534.86403-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When draining a TX queue (e.g. on device removal or reset), stale
ath_buf descriptors were returned directly to the free pool via
ath_tx_return_buffer without unmapping their DMA buffers or freeing
their associated skbs. This leaks both DMA API resources and socket
buffer memory.

Unmap the DMA buffer and free the skb before returning the buffer
to the pool.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 89d8b3178784..89930eaf1fd3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1884,8 +1884,17 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 		bf = list_first_entry(list, struct ath_buf, list);
 
 		if (bf->bf_state.stale) {
-			list_del(&bf->list);
+			struct sk_buff *skb = bf->bf_mpdu;
 
+			list_del(&bf->list);
+			if (bf->bf_buf_addr) {
+				dma_unmap_single(sc->dev, bf->bf_buf_addr,
+						 skb ? skb->len : 0,
+						 DMA_TO_DEVICE);
+				bf->bf_buf_addr = 0;
+			}
+			bf->bf_mpdu = NULL;
+			dev_kfree_skb_any(skb);
 			ath_tx_return_buffer(sc, bf);
 			continue;
 		}
-- 
2.55.0

