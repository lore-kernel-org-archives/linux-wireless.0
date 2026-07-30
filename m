Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750438DC40
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427474; cv=none; b=UrlIJg4p+++0mzEtqsRhQ3z1+Yw3FSpPUmTSDHPGox0v45i4xO0Xe9fWiPEf3CS1GlTCLallkgF6Q4pB0E0/AsqHotqh1FPCRlxlc4btIi1GljQWl4QE0pJkRUxZG3K6D6hrOWHVYrZPPQsheWMrinmYnyKHYVmntOB8dk5+nMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427474; c=relaxed/simple;
	bh=OspfEu0PH4En6DDNaG81nLBxGMAEqO3gsvGoIDdgcn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U18ut8mu5cpYHxJo9OXFPk+t2YxYEra5D0i6yEjbZcxWca3/DpmjGZfa+UMHcOj5y2DOJQZbAKsMjqyzZ2yuOPoeF09r6Tzd2sNM10wUL8m9u57d72dBeDRLviqgvS2guSQwDC2A2nMoYoppC6RtO6/iTIDKxnaE8utsD4Cmzl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pURGoqGt; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pURGoqGt"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3856d4015e0so4112a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427472; x=1786032272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqASPZFtaBlHPhl3fozdspmc8s9/23tVm7H9FNuYtZU=;
        b=pURGoqGtaeWOfT36mr4kQaLia5U7uUQnFWGU5eaq3vOWzr/IDD3fHdWViIBrHPU49P
         eTpX4VlY/2WQJAMdKWeDkq+rg0mco75y46dA0StHpc2srBfB3sQw5348St1nmCsS+hiN
         OCAi8pOjggRbh5B1MLzQWjxRvR1IuoJPxsFjp+31qwLZNuoChcdv5aQLoDu5ymOFUtcK
         Dk/Ci2AEgEjZSqLe3Sz6Vh92k5FNAASjOV8wuDAFhSPeIGx0ECGo7qOrwPm5CXWvtRSu
         aEk9KvgvuJLmA5d5u1WmwWI+om5W6nivpgQAYS1YVpBNditsqyYkOoy1aClfu1Pj1Ygb
         3irQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427472; x=1786032272;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hqASPZFtaBlHPhl3fozdspmc8s9/23tVm7H9FNuYtZU=;
        b=e3fx2sKZhOUxRiSXGfMi4j88UbzTE0M0boPYHTsnCG8zjVhJ3mn285uoTluks6Ya3e
         hibKsA5nu5D/Mp8p8zfkd1E6b2DxNbGsY7aV4Qr4dx+Sov7nQ6YzZJh/l0heJdcdp64B
         YxUVqJGz3CHSuHhNdN0xy6enFGsvwgugfApmncOawlOdWjykeBg6J8EFdXIy9KRSYUm2
         4tOLaQu5u5mY7x0XBFeWcjMnzfz1TeMvegG2eV/ku6S+YQ7C+vT32JNf18S8F8bNvOXq
         BOAEmM9oR+rsbq6CHMe4vS7uTCTl+Cr7xBdjl9LHDHtqfDJaRNAcGHjubf9774VaWbhg
         vVZA==
X-Gm-Message-State: AOJu0YzLoru9cafTj5zoBrhqk9jzWYQs9sdeQaZQKNitDgvSbVOjiDmJ
	2Q3rUzGdySCfKM2x3IHTjR/MEBLpaKRpFuRVJUPC7q7fWUeEcYkfsq9l
X-Gm-Gg: AR+sD13VW6izZzDg9qxJ04aYhjxN1D/47HZ5tu8StbGT4yzv5Bm5+lzdQIbF1LL2xLq
	2RfbMIv06ZwPXSKVpkj+xz+UP0/O0TOjRs10kEBG72xhz+JXt/vWqmBFl4bz9MRCiknhmJzCEUv
	vkLWBFkKgUxWGarXXtxmcfeUKWV8d0iuWRUEXQdYrdjB5cnwM1klREG5PYTVtMoH4Mxf0+gcogO
	ZdP6exRyliEwnyD+GjoLdyNWq04s2vjQVFGDxSzZqmPOTrZpouYwX5dDWQEeKz06lK5WbNIDRQB
	S5xbkTGDmDBoG990+sAsDmEUa+tffRAQ7ZHsmHDRRDoU2Tgn3Q8A0dJO0SCMN+OkaDStiMSJjLK
	J6GXh78cguKbNTtkLBwpAB8Y+mQt5f0Yr83ePkwnjbKCwB2q8fqMgrU8KKX/OcA86fcweKjGaRZ
	rtb1RiLQeymCpPPJ7X90T4PbWVBbVUpZl2LKbAVWC99Kcbb6dNHmRktQFyJQkELzCYpfuQlMn1w
	C4=
X-Received: by 2002:a17:90b:4487:b0:38e:ab3f:2c99 with SMTP id 98e67ed59e1d1-38fa8094a00mr688435a91.2.1785427471539;
        Thu, 30 Jul 2026 09:04:31 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:31 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 1/8] wifi: brcmfmac: flowring: replace O(N) loop with atomic counter
Date: Thu, 30 Jul 2026 16:03:49 +0000
Message-ID: <20260730160425.11933-1-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Optimizes flowring deletion by tracking counter updates with a flag
instead of an O(N) spinlock walk, fixing a teardown leak.

Signed-off-by: Shivesh <shivesh@example.com>
---
 .../broadcom/brcm80211/brcmfmac/flowring.c    | 65 ++++++++++++++-----
 .../broadcom/brcm80211/brcmfmac/flowring.h    | 18 +++++
 2 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index 35cbcea0abc9..b9c518939f50 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -182,10 +182,8 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
 	struct brcmf_bus *bus_if;
 	struct brcmf_pub *drvr;
 	struct brcmf_if *ifp;
-	bool currently_blocked;
-	int i;
-	u8 ifidx;
 	unsigned long flags;
+	u8 ifidx;
 
 	spin_lock_irqsave(&flow->block_lock, flags);
 
@@ -194,23 +192,54 @@ static void brcmf_flowring_block(struct brcmf_flowring *flow, u16 flowid,
 		spin_unlock_irqrestore(&flow->block_lock, flags);
 		return;
 	}
-	ifidx = brcmf_flowring_ifidx_get(flow, flowid);
 
-	currently_blocked = false;
-	for (i = 0; i < flow->nrofrings; i++) {
-		if ((flow->rings[i]) && (i != flowid)) {
-			ring = flow->rings[i];
-			if ((ring->status == RING_OPEN) &&
-			    (brcmf_flowring_ifidx_get(flow, i) == ifidx)) {
-				if (ring->blocked) {
-					currently_blocked = true;
-					break;
-				}
-			}
+	ifidx = brcmf_flowring_ifidx_get(flow, flowid);
+	ring->blocked = blocked;
+
+	/*
+	 * Maintain the per-interface blocked-ring counter.
+	 *
+	 * We use ring->counted_in_blocked rather than checking
+	 * ring->status here.  A ring that became blocked while
+	 * RING_OPEN has already been counted (counted_in_blocked=true).
+	 * By the time we unblock it during teardown its status may have
+	 * advanced to RING_CLOSING, so testing RING_OPEN would wrongly
+	 * skip the atomic_dec and permanently leak the counter, leaving
+	 * the netif queue stopped forever.
+	 *
+	 * Rule:
+	 *   block transition  (unblocked→blocked): count only if RING_OPEN,
+	 *                                          set counted_in_blocked.
+	 *   unblock transition (blocked→unblocked): decrement only if we
+	 *                                          previously counted it,
+	 *                                          clear counted_in_blocked.
+	 */
+	if (blocked) {
+		if (ring->status == RING_OPEN) {
+			atomic_inc(&flow->if_blocked_cnt[ifidx]);
+			ring->counted_in_blocked = true;
 		}
+	} else {
+		if (ring->counted_in_blocked) {
+			atomic_dec(&flow->if_blocked_cnt[ifidx]);
+			ring->counted_in_blocked = false;
+		}
+	}
+
+	/*
+	 * Only propagate a netif queue-stop/wake when the interface
+	 * transitions between fully-clear and at-least-one-blocked.
+	 * Reading the atomic is safe here: we hold block_lock, so no
+	 * concurrent brcmf_flowring_block() call can race the update
+	 * we just made above.
+	 */
+	if (blocked && atomic_read(&flow->if_blocked_cnt[ifidx]) != 1) {
+		/* Another ring was already blocked; no new queue-stop needed. */
+		spin_unlock_irqrestore(&flow->block_lock, flags);
+		return;
 	}
-	flow->rings[flowid]->blocked = blocked;
-	if (currently_blocked) {
+	if (!blocked && atomic_read(&flow->if_blocked_cnt[ifidx]) != 0) {
+		/* More rings still blocked; do not wake the queue yet. */
 		spin_unlock_irqrestore(&flow->block_lock, flags);
 		return;
 	}
@@ -367,6 +396,8 @@ struct brcmf_flowring *brcmf_flowring_attach(struct device *dev, u16 nrofrings)
 		spin_lock_init(&flow->block_lock);
 		for (i = 0; i < ARRAY_SIZE(flow->addr_mode); i++)
 			flow->addr_mode[i] = ADDR_INDIRECT;
+		for (i = 0; i < ARRAY_SIZE(flow->if_blocked_cnt); i++)
+			atomic_set(&flow->if_blocked_cnt[i], 0);
 		for (i = 0; i < ARRAY_SIZE(flow->hash); i++)
 			flow->hash[i].ifidx = BRCMF_FLOWRING_INVALID_IFIDX;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
index f3d511f9a3c9..afdea8b3f8aa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.h
@@ -5,6 +5,8 @@
 #ifndef BRCMFMAC_FLOWRING_H
 #define BRCMFMAC_FLOWRING_H
 
+#include <linux/atomic.h>
+
 
 #define BRCMF_FLOWRING_HASHSIZE		512		/* has to be 2^x */
 #define BRCMF_FLOWRING_INVALID_ID	0xFFFFFFFF
@@ -26,6 +28,16 @@ enum ring_status {
 struct brcmf_flowring_ring {
 	u16 hash_id;
 	bool blocked;
+	/*
+	 * True when this ring has been counted in the per-interface
+	 * if_blocked_cnt[].  Set to true whenever the ring transitions
+	 * unblocked→blocked while RING_OPEN; cleared on the matching
+	 * blocked→unblocked transition.  Needed so that a ring that
+	 * becomes blocked while RING_OPEN and is later moved to
+	 * RING_CLOSING still correctly decrements the counter at
+	 * teardown, even though its status is no longer RING_OPEN.
+	 */
+	bool counted_in_blocked;
 	enum ring_status status;
 	struct sk_buff_head skblist;
 };
@@ -40,6 +52,12 @@ struct brcmf_flowring {
 	struct brcmf_flowring_hash hash[BRCMF_FLOWRING_HASHSIZE];
 	spinlock_t block_lock;
 	enum proto_addr_mode addr_mode[BRCMF_MAX_IFS];
+	/* Per-interface count of currently blocked open rings.
+	 * Maintained atomically so brcmf_flowring_block() can check
+	 * whether any sibling ring is already blocked in O(1) without
+	 * holding block_lock across an O(nrofrings) walk.
+	 */
+	atomic_t if_blocked_cnt[BRCMF_MAX_IFS];
 	u16 nrofrings;
 	bool tdls_active;
 	struct brcmf_flowring_tdls_entry *tdls_entry;
-- 
2.53.0

