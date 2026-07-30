Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784037F8AF
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428504; cv=none; b=M8op2+ICWIM+vl90o26idnBRHFJTHzmRquvhC5LpF6vHuGJqytLCjkfPMfUIe8KT8FiZ75kK3OWIeZi9iQl+wVcacaH6Xf6Vog2S10/9y40VhuxYgUhEuHfmKD7lrP1CipEtAYXSS8MtPFGJsHvUoI694SyE26Quok8sBYFgGoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428504; c=relaxed/simple;
	bh=bq4PN7BDO0yFKVQsaXHpuXUbJYEn7r0/aMV4I2Qy7bk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WfvuP8oydRRkU5oYBEYN1ELY52ww0vBe1Vj7IiglxrW9/flqpXzMjkK2Dc+O9s+F8b/KKZFTxwH5mtdu6tlQuqAje3omyz0tcN6RFTHQwELNsjSphRT//s3j1dYR3aoeGhvhzXloROaYhTqSrCQmeaxLUWUn3WFtRFc3w+RcxbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YwJTVbTH; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YwJTVbTH"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3856d4015e0so8734a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428502; x=1786033302; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fDjKwH/pLgq11MmSt15oZfyeN0eo31ydS4Xhih3a270=;
        b=YwJTVbTH3OwlH2fzjPC0psGgu/OM5Aq+gdoWAHozus57de90mYgiH/5A5w/Zc2NbZP
         VigIF3GmoDC+5bau5FO8HE0VlBnEf4+MNgV1+HFtlmOoSOQZjvkyXY2v9RcOdO/l4Eb9
         RTi5a40DBrLWYItoFrMLSuXfViHSQaaAm5Mn5XbCr3+0Dxs/YmA4st6bA9rEbDZgEZ65
         pIlTHk3QpwPuALoRu+CrHneg0XBDS2TCAkGNx79bFQCZnKx5+Sm68Dys1oTMSOCW43cb
         5tnH3H10G4uIlpqgHtN7SNmUWFLDZsfa4h7UdaZ0rHzyFywVu1uJftOowlp7FCDWUamT
         c6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428502; x=1786033302;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fDjKwH/pLgq11MmSt15oZfyeN0eo31ydS4Xhih3a270=;
        b=m5oyAr2xogsMIyYZ99yBWvL4929HfTnK2zkzQEDwmwjm8pt/fI8qI7uJfZymuGKCyZ
         RyqfRqeiw54+Nldg3gxbBOW6NqNlcGpDDhicZpHehnZyZ7w0Mcnf084Ne5DFX3ktDGja
         RV5APthZB0Wh1LfLcznOQVfnZ0Xv8LJCn9eb+zEWc0lPnNw2ku8IGTGQKHHd61f1LRvM
         PKDTJTBGTFeaELX6H8n4rSMgmsCZfgxTelMaZg0T0YlM7UtZorYjHqRQmviPWxH9x9rY
         CFXs1ziqlzzKVXXFbngff+emXy2HzR4CSXz2sKDgr89a8faZiB97PeaIDmcY5FRoBYEB
         hahg==
X-Gm-Message-State: AOJu0Yx2cdFyJwS4c7jr1Rni0CiepC2ZXCavIDzK4fVc69l4W/LFYnl1
	H35WVG6p3/dhs+GUTB043K0sS9FxP4l8U9xV17XWsNw6lGavtYHNJuNc
X-Gm-Gg: AR+sD10AWyuIdZppmgBJYgXwLLot2kpAsL75n6Now91QrnoNpCsuLeWZm3pDT3TS1Ec
	IfmAItDLjEGk/HmAKaTaTRAHXSUt5XFAE+J+jQor0amgglHQIXxtdIFlbX790KuzmoZlbDnfSjq
	XWDxjqeWXOA7mJkkFmhmqoZr6vXwGU3qAtnTPx1WnEhc8LWSaGlxsArRxlJu97smE2NnIrnXyJ5
	Je92kVz4ICtLDL0MZ4BBekVAZ1ieYnEFQwIb/WqsRPPQNWHlenPL2QMMhcv8ICPo3xkZM9wmIU8
	cl2TqeY6UTJCLBWow5fdcvg3mLKtWk7l638dnxl+7DgQWG+FZ5+d+NwpK6dMvGwFQMWvxAKinSK
	ReRx0MYHGa0R7dSPP70f0ZXLrSqMNhQRDKDCfafh3w2ZEUz9w665wewHn1rUgRlUJWl/vWsFydJ
	c/ULfAwS4qKV3EEJ8BG5D6YmUub2yuxGOzBOMnEkeCxjLKxhCPkmz7ecvP5xgGCvRHtioE9ANqu
	54=
X-Received: by 2002:a17:90b:4487:b0:38e:ab3f:2c99 with SMTP id 98e67ed59e1d1-38fa8094a00mr759768a91.2.1785428501521;
        Thu, 30 Jul 2026 09:21:41 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:21:41 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 1/8] wifi: brcmfmac: flowring: replace O(N) loop with atomic counter
Date: Thu, 30 Jul 2026 16:21:04 +0000
Message-ID: <20260730162135.12278-1-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Optimizes flowring deletion by tracking counter updates with a flag
instead of an O(N) spinlock walk, fixing a teardown leak.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
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

