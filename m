Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FA3DB97A
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787417540; cv=none; b=lY0mLQzAcb0A48AgIvPuwkP1PdFllLX+HMKPRZL7gWdpM6cE9DDfbz6ZnMXAitnh2fDd1lSGAsfNIhtZfqv2ORpSslIQIcg487ZwP2Oa3lmYuK/2L3TYbCR6AQ6vqfJm7Jqr46EI/CQknseDB9ixuGEVeRDbLi7UzH/aMYX+No8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787417540; c=relaxed/simple;
	bh=DByPZRUvyVcEdHD1jpRTlxqduptfCBNbhR048Af42tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jue+6JPEpwtvVVFhOa6Q6uJDmCsN2S/RH+0wIMpnk6n+p1L8/29IwwHwRjB74puLAhQxcxTexHeymaa+n9o7aUKkcOsoLan3S7Tq8S9EtHNfPRQHVCuJ5PhsKXZeYRLRrtusC4NFPzW1eHNvkrUVPJsQNEi6JhDpspTOZE0vQ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kabsSs8m; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kabsSs8m"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c2cce930cso20712181cf.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787417537; x=1788022337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tzs5YoNsBThnaikyqAQZp9SOqHfVyefiIDTKcmb/YvU=;
        b=kabsSs8mBV6ioyMIFKy7cbWcVD1130DI5qnGcxAeTaBz/b9G1a0sBeFsgMGYQxEEQp
         ExvuQkMlWvC5vLEaCJOzcdjETRSDlw78SRi7zoCOt/j+vYA9X18sYRuUyTyQG0RrSXcX
         BtqptQEG0YYnCIgwwmMJIFLKiuLwMH14jtewZ637MN+9tWDTsdmpkYeb7DrMiZHhdJqh
         4DZDJniIaEhyIyFmClyDM8Jo4P2Bt5WcYRH7CztEEPKWaea8BSCDd48A9XYSFexolugN
         AyLuhY5aGca1tYIBTCYBqUV7ZqnZ0DgC2k5gPruwFD5UgDAeJ5hgzhCnXGu+tbaDJ/OV
         Plfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787417537; x=1788022337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tzs5YoNsBThnaikyqAQZp9SOqHfVyefiIDTKcmb/YvU=;
        b=GKx65sXAXjT43NdRZNy354Oi9QL+S+XLuoXJKatsiYUWhFoe/kXDaFOsYSi1LnVI8P
         MPO9PbfsRiYCwl6RDKhKNIi5dggrsbxJ2XT3Tkv1huXX1MKW1p0VhOdxItyzDtkkyHX4
         NuaNTkQV/4VqqPNngcGpkOwAiffUL5G38ZHgEchLQ1gItGVOMVldiL24/Y1SdxwzGVQP
         9bs5FodbmJV2KnAt0WfmKmJDr7JVaAf/r8EY7hXhzBRVEFdUcWjpVdoYbjq57eKXyUuF
         3fhnNQL2FnLpsDD6MkgFNCN4g5/jgDWNL182/PDyEQPnAEGg9L5tzp+dEGDkGQYs3UG2
         DH5Q==
X-Gm-Message-State: AFuF++m8VJXsAI4KccC5t+oGa08hWE0zOSFO+1x7fYne/V162dd6Zbef
	E8y3Y9J+DSGhq8gRSfkCjDJ7DCBO2EI1ZhxfMMdy2AJ9uBN/yGfK+V+L
X-Gm-Gg: AR+sD11u29S/zNt0qV+HCLT6aAMpjbBzrDo2Nd5DJH8cNYLC/MV++Ix6pGFYIDAY+5I
	Cd+Bvji2efhrMJDD3cUJeuA4Y5oGAkVB8bAjVxOHhfj/3kpgqdzIVc5A6BzhbZEeYWuT9gEqwEV
	yP2zahAJjkZUzOGaOy+DI0KK8T/K1bU6q0R5lVXxHkhi7ulG3qbZBfsNo0RuwWpfPig2ZLZCPdb
	7M0BhFczjlwgg4vExLtKgEMEBq9gMLbmrILrJNe0CzLgTHs88M1sDQLozrhDhiZ5QY6beg9QTId
	HIKfaJRo7sgWucFvFCeDD+WqWjAsvsacg0kna/3Qlrip6cLWq2LICdAykZvcXGVxILZX+JmHtU2
	IOwjCD/cOC5/7Z3cBoBPfJYfd9j7btz38u0tG1/m6RGkiGu8eWf5QY2FAf1EbLyDuUC41XuVzC+
	JW73g6YwSf04Smr10ad2nqLaPVxE3VMT7SQ/1ZuCXX5FVTBDZTOpm7DymMDWBf38fMv10t9N7HM
	6tQbvuWdKdCAkEc+CnQOyfJErCIag==
X-Received: by 2002:ac8:58c9:0:b0:52d:796d:4563 with SMTP id d75a77b69052e-52df585c299mr147209511cf.26.1787417536703;
        Sat, 22 Aug 2026 09:52:16 -0700 (PDT)
Received: from reolab.localdomain ([146.70.168.136])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c935e63e3sm17779056d6.5.2026.08.22.09.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 09:52:16 -0700 (PDT)
From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Subject: [PATCH] mac80211: mesh: Fix missing bounds checks in prepare_for_gate()
Date: Sat, 22 Aug 2026 20:21:17 +0330
Message-ID: <20260822165117.34396-1-a.jahangirzad@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When moving or copying frames to a gate mpath, prepare_for_gate()
processes incoming packets by reading the MAC header and modifying
the packet to add Address Extension (AE) fields if necessary.

However, the function lacked proper bounds checking on the incoming
skb, exposing the code to potential crashes and out-of-bounds reads.
Specifically, the function calculates `hdrlen` from the frame control
field and then directly accesses the mesh header at `skb->data + hdrlen`
without checking if `skb->len` is actually large enough to hold this
data. If a truncated packet is processed, this can result in an
out-of-bounds read.

Furthermore, when the packet does not have the Address Extension flags,
the function calls `skb_push(skb, 2 * ETH_ALEN)`. It performs this push
without verifying if the `skb` actually has enough headroom available.
If a packet exhausts the available headroom, this will trigger a BUG()
in `skb_push` and cause a kernel crash.

This patch fixes these issues by validating `skb->len` before reading
any headers and checking `skb_headroom()` before modifying the packet.
`prepare_for_gate()` is modified to return an `int` (-EINVAL on
failure), and its caller is updated to gracefully drop malformed
packets instead of queueing them.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
---
 net/mac80211/mesh_pathtbl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 03171cf00855..b344f305a85f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -131,22 +131,32 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
 }
 
-static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
-			     struct mesh_path *gate_mpath)
+static int prepare_for_gate(struct sk_buff *skb, char *dst_addr,
+			    struct mesh_path *gate_mpath)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211s_hdr *mshdr;
 	int mesh_hdrlen, hdrlen;
 	char *next_hop;
 
+	if (skb->len < sizeof(struct ieee80211_hdr))
+		return -EINVAL;
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
+	if (skb->len < hdrlen + 6)
+		return -EINVAL;
+
 	mshdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
 
 	if (!(mshdr->flags & MESH_FLAGS_AE)) {
 		/* size of the fixed part of the mesh header */
 		mesh_hdrlen = 6;
 
+		if (skb_headroom(skb) < 2 * ETH_ALEN)
+			return -EINVAL;
+
 		/* make room for the two extended addresses */
 		skb_push(skb, 2 * ETH_ALEN);
 		memmove(skb->data, hdr, hdrlen + mesh_hdrlen);
@@ -169,6 +179,7 @@ static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
 	rcu_read_unlock();
 	memcpy(hdr->addr2, gate_mpath->sdata->vif.addr, ETH_ALEN);
 	memcpy(hdr->addr3, dst_addr, ETH_ALEN);
+	return 0;
 }
 
 /**
@@ -218,8 +229,10 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 		if (WARN_ON(!skb))
 			break;
 
-		prepare_for_gate(skb, gate_mpath->dst, gate_mpath);
-		skb_queue_tail(&gate_mpath->frame_queue, skb);
+		if (prepare_for_gate(skb, gate_mpath->dst, gate_mpath) == 0)
+			skb_queue_tail(&gate_mpath->frame_queue, skb);
+		else
+			kfree_skb(skb);
 
 		if (copy)
 			continue;
-- 
2.55.0

