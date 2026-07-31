Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0CB446070
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514017; cv=none; b=nTLHbNRJpSL4KhMzG5dHV4wbsEzcI+0soQ6tTN/AeRi2ojOx0tsA3eBAjEp9VaSsg4bknB2qCGLtPaWlTZSoFW4NgxDnFhelIatSmewnsuLWlKJd03nJVmd0tGzSSEcGHsD7gseOgC0L2bWG0xzITZ7j5npJFhGC7eN8Xy4RZfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514017; c=relaxed/simple;
	bh=YJBvBZWvNxs18TqfUfA1hwadJeuDBfwNuagruUWmko0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GhhFGr9b1Nw0xi8mmlEcEu9HiHQIaG1DFcyOUr4qFD96f9/gysI+lRvzrILf5ntUKG5i1V8O4zUNJusBc8rdJYkIkeMDHr2wsu2OUIVPshcwXvq4ExdnvpZjgtzHe+Rp1zA4oOVlabt69Cp45EaV7xvtscj3DrcfHG8Rb/20DWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKmEUAN7; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKmEUAN7"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-383fff6e8b6so43625a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514015; x=1786118815; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V+7zRa7zBwj/Mp97JNRaCsdKi8S7AHJm5zHHTJ/ZjEk=;
        b=LKmEUAN7WM2pOPs0/S9s2K6fX1k1hDzorSiPG/YYGoI3fwUAUxz/XaRHSRbpD9uFye
         A723mjHIUrRd5BoBaw7E2qKB7WFGV0IsswW7JJbzogxmD62eXeo1AVEj4481MywMyySW
         XaH2RoL2AhGcruek92M6oAgMq+urZ1J/uYZqkpXq8bnbgl94OMY2HlnkQ7akCX4vezYN
         ajl5eUYqI1b+UlqwqVThx51jIyX2Yrji7gwa7FGpIl0S/tghqDK1N9WlF7v7uFz+1fbJ
         hqJLOWE/3Ni5B5gYBeiWV6p4QKctm8Pt7ezUBM96dHQ2uAFGbPFLFebww/J2Bprq1ndw
         8/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514015; x=1786118815;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V+7zRa7zBwj/Mp97JNRaCsdKi8S7AHJm5zHHTJ/ZjEk=;
        b=nqJLqcnG4mCT+8gjcW+VeXVLY+zbP0Yjpnbom01S9EMi681v8Qg5UPdn1iO8tz0abb
         z9sFxghnuL62YxL5WRG29pFfeUUcWOrbVfqDTlXIlx/NKJ6QKErluR02/BeGoIIJzgQe
         PXJfW+Ka/EYTLZUw4/edAw3sHv+hzUZHPJp+mT7yNvJqQSowRw3Qt4Qgu7SKRwMlRsu/
         m/vx7RY/WDBYOrA/h7r2cYy2ZtFlDVOelHa3pcLeMhktFlecRk5m9ZrHOzFWHEIHYEQX
         AJRXDFgx8nYI1wnaPDdE9PEZXhzut6hyBguctcwFFOsfjVgTaveuR0OFkwWAn5F5LZpM
         wYmg==
X-Gm-Message-State: AOJu0YwmTGVb2w2PHFXzKBPMmRQN/D2Duu0p7hZWVa+VTq2bQiIRNT6Y
	ycDOy0ZKtLUvqk6xEmg7q7eQArtwuwPDFKo0Awltd8V+dkAR8HjymkWs
X-Gm-Gg: AR+sD12KQT4FrNOCAhG0r/Bb9JjbETJFzOcDIT8pznkB+o3IdfcL84kwExe8Xc3rAzn
	rILTedOjuESzaFR77HqIfBSm3mee4YjU+CrTL3+uoT8z4nk8yfBQfRdKR3NwOIBbBiaLyYpUl5z
	fhAIbBKoFJtFn/bNS/utKxw/OiwJtTVut3gkUHciVHFdUAYl1jCzw1LIZiGFKyOJngcaG59UUNt
	iKdquhCKT6xDR4R40w48DxesgFoTmh7BYqhKxDy27uEfPRRmmBTPXpPpUYip7jusdmhjLURp7SZ
	8srkFxiqZsc704OVd1JW9xoqr/hmGzjQ7OSILiflXYV5L/AvHOiqEPJwuekA8mynDIERCsWf6U3
	YnYMnp05X813BfozmdDAfX2Zn6SUnGqaRI9LQ6jpdtF9qTIov9mH4f1SvJot7XGONMlgB6ghSMS
	s+I0sNl1Sbu+ufu3jdyaxrYLH1378aebUtl9HrWhRJYxH2oJiP6pomoqgNwDmWnsQMM6MP4uwcp
	9vMHmFe
X-Received: by 2002:a17:90b:5408:b0:38e:c140:2a0b with SMTP id 98e67ed59e1d1-38fbc4c8183mr624796a91.3.1785514014834;
        Fri, 31 Jul 2026 09:06:54 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:06:54 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 1/8] wifi: brcmfmac: flowring: replace O(N) blocked-ring scan with atomic counter
Date: Fri, 31 Jul 2026 16:06:18 +0000
Message-ID: <20260731160646.3812-2-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

brcmf_flowring_block() previously determined whether any sibling ring
was already blocked by walking all nrofrings entries under block_lock.
This O(N) scan is both slow and incomplete: a ring that transitions
from RING_OPEN to RING_CLOSING while blocked causes the unblock path
to skip the decrement (because ring->status is no longer RING_OPEN),
leaking the implicit "someone is blocked" state and permanently
stopping the netif queue for that interface.

Replace the per-call O(N) walk with a per-interface atomic counter
if_blocked_cnt[BRCMF_MAX_IFS]. Introduce a per-ring boolean
counted_in_blocked that records whether the ring has been added to
the counter, so the matching decrement is always applied regardless
of the ring status at unblock time.

The decision to stop or wake the netif queue is now a simple
atomic_read() check, still performed under block_lock to prevent
races between concurrent brcmf_flowring_block() callers.

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

