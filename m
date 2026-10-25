Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892838;
	b=HlSZWn+2rfGHl66rUDhOk5VjLVSzHGR9OuuuoGvmyNELEaY1JAjnFiVUk9obo5tL/Dqu
	 /kdwS+qr9nyjA07xs1nVr3TomOVXE9Rsil/dPph5fXuc38uiU0Vlw9oR9dV/xs0ghJfMT
	 gL/wONkZd59Xz2Wx46FmTugKC11BXDZv6LooRqCAv8yQQSdgT2QXpRllnh6c0iaUckyDi
	 g2GOSz1eVMTnQTtjkME6NRerG0B6EDovOh4B9RFjfwwFpAO/EWGwyb7l0tbdcjVitpiDJ
	 bu+7TFvsj6JgQTcsjYN6yQe3hWFwQ3lAibXaxhbqVURnOQJNnMNagO8GmXR+PDpI+ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=CqYJudaw98oP5V5GQh9JO5YSPL8zp03ev096osCYM1w=;
	b=JD+4ECaeyVQVwNn5j4GZTuY1MEXHgCRiMN6I2bCHzl2wOeImgW/Eg15TwwSBZ+oix9la
	 N4uH49FidrPvucKvH5y/a/tPkvMiPRu4L8at4ja2LvM/veA5lk0S33rMwkTmcNPEuDKOh
	 HGbJPvxRCKC3rcUljLlX/PvbrSdWCufylP6BBZzyQ0B8x5F5U53kJbRqb/o5MLTMCZVFH
	 eFtLFhQ6nCXXC237ONQ7Z2vRoZrDNLIavuiAwZgy3YVCBkXKOmDm8PUe6eGvX5yCPPUpy
	 3ZNARop9cQBnLdCwY7QaR3XA1aqwbSOt1Mqouy8KkvU+obRWAqVu8SuYtDL75UxXJ/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kVQH8sng;
	arc=none smtp.remote-ip=209.85.222.54
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484C606A31B
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 01:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2484C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kVQH8sng
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-98c6e050c5dso1021279241.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 18:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792892837; x=1793497637; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CqYJudaw98oP5V5GQh9JO5YSPL8zp03ev096osCYM1w=;
        b=kVQH8sngGFnZZ1Bc5R7rbJdN6VYoGrSMGNFiosVK4G+fn8WngJ6SgKv7yU/0684/1h
         flfOLQt7GuwgC6AVxfKk8H2+Ny7UKCQG0H4dypBxlfKSyS+9qbXYOaTF2PIf5VJuar74
         VnH7sUdPUmGXHskIMcVYkGh4rLB+5KleTUlvnhtao3THO9H3PgVSBGihOf66/3btVRtq
         agqBignUyIn9qLC56lCqz+BU1C+kBD8d5rKZOXhRbnb7wEnqDS953OOk8W+Y/RzI7B5h
         BndZ4q/ufJQ5WvIHNdhoJ3LPA/iDgFM8bz44sBBa1hOp8VYlpZBKtqwJuGBE0ffhTitJ
         l0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892837; x=1793497637;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CqYJudaw98oP5V5GQh9JO5YSPL8zp03ev096osCYM1w=;
        b=yjX8P+dF2ZevW6Nm/Wxjr23CaMe1DNhFWTOsH/gFhffD1j8tT3X0+uech/hFjgMPh2
         3rvAHB4Zf66anplJoBUjfUediGy962sxM4bbnG98l5A236Ejw3QEZ0JQbfuSVUH+4ARH
         4Z3Qzu18RryaffHzEHcIz6XxbI1869nNWqsFb1vapUAZYmsdmCPcA19b8FcuOCU3Do73
         W5A9h2dou6LJocZmcTyZePcBuzM/dBUNg2zvlPsVBqKVfW5FQaOaEil+SfCmb7YaPyAP
         lRow9oOJH90uKOoAeY2TkOMTWIroc1Kt99EBap7C2zJ/uMma/URuWtKDodehwDPULZIF
         V3Hw==
X-Forwarded-Encrypted: i=1; AKwUvBw53K0r7o1ea6MPVq1aflP3EAQzgzN51WbgCuCRetkUsKof8ThRmmgRniKHUKEwQIQMnDlnfNkAHS4lpAYC0Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYI6gOY0pDTdPrIWIvY3CA8BDktJOd93lbZQlBRMGLgOkzgVR2kK
	UoRAI4Evb7eALM3GFS1ubw2AI1pX3+bm5LYHL141bBnN9BPYcUlmkkGu/jrMJde5t8QFcyog
X-Gm-Gg: AYBFou1vUlabquKw+vumAywLgcdPQofwISEqphPzn277jyS07BurbHR+sXD0J2/NrP+
	qJJl8Ed6kdVxqT8SJeFrHvAvLTzouaqjYLzkIyU1DH5PEkKUZkpHKaDy2aOaXYcQQ//eE19omZ5
	sFS9vZ0SpHM1Zlkrxl3HTItErTpGck4wB7ea+LrI8NuHm/G1/6NbSjktUg0MbgQ52h6s5J5VWNc
	YCPjoBlHakTeJ1ABNXAAGHJhshxPbSxdr2/A74Ya+9vJPYsoCg6kgxGSq9bT/KgOnN9CUf9n3xK
	Bb01m8LU1m13wD8Y1Az00C0vgeocXuUJ05IIr8Tt//RQPCSgNqbnxlPMkGl39wXsW0Dv+kL1WDu
	BNF8bdNUUMQnZikmowKdGigy8aBCkmD60R/ckURYIY/nm/lZnm1Ch2cv9Upd7fD1AdPfePiGLKh
	tsgdo9UzJnAas8Ln59w2I5pXcDC/3/KLp2CEZ72jx1Pv0RU+QX1SqhbYUdgASdj5LLx9Wknep0G
	Xi0f2eBnA93XOAxBJwtDdABX6C7AnpO2aZ+fqzNOUy3ZOP59XcOC6Ow+0agVlv15J2cR3QWa2q1
	b9+WaljG8qUb5T5VhzxpsaQvNTJtFH0P7ng5HvXdKY1tDL2ZlOY=
X-Received: by 2002:a05:6102:b04:b0:7cc:2cef:b330 with SMTP id ada2fe7eead31-7ce5ccbfbe8mr1103295137.12.1792892837018;
        Sat, 24 Oct 2026 18:47:17 -0700 (PDT)
Received: from 1.0.0.127.in-addr.arpa ([2804:7f0:b101:277b:8118:1af6:d493:fe05])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910e6cfb52sm4120593241.2.2026.10.24.18.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:47:16 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: reload eth header after mesh fast
 forward fallback
Date: Sat, 24 Oct 2026 22:47:11 -0300
Message-ID: <179289283170.50420.14882678961393805746@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

ieee80211_rx_mesh_data() sets eth = skb->data and, for unicast frames
that are not for us, first tries ieee80211_rx_mesh_fast_forward().  If
that returns false, the slow path builds the forwarding header from
eth->h_dest and eth->h_source.

ieee80211_rx_mesh_fast_forward() calls skb_linearize() before it looks
at the next hop's TX BA session, and returns false when tid_tx exists
but is not HT_AGG_STATE_OPERATIONAL yet (an ADDBA to the next hop is
still pending).  For a non-linear skb, skb_linearize() goes through
__pskb_pull_tail(), which calls pskb_expand_head() when the paged data
does not fit in the tailroom.  That allocates a new head and frees the
old one, so eth then points into freed memory.

The skb can be non-linear here, for example, for A-MSDU subframes:
ieee80211_amsdu_to_8023s() sets reuse_frag when the driver passes up
head_frag skbs, and __ieee80211_amsdu_copy() then copies only the first
32 + mesh header bytes into a small new head and attaches the rest of
the subframe as page fragments.

The stale eth is then read by ieee80211_fill_mesh_addresses(), which
copies 12 bytes from the freed head into addr3/addr4 of the forwarded
frame.  hdr.addr3 is also passed to mesh_path_error_tx() when no next
hop is found.

Reload eth from skb->data when the fast path declines the frame.  The
slow path already deals with non-linear skbs on its own (skb_cow_head()
and skb_linearize() on fwd_skb, after the addresses have been copied).

Fixes: 8b0f5cb6bc7c ("wifi: mac80211: use mesh header cache to speed up mesh forwarding")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
---
Found by code inspection, compile-tested only (W=1 with
CONFIG_MAC80211_MESH=y).  I have not reproduced it at runtime:
mac80211_hwsim hands up linear skbs without head_frag, so reuse_frag
is never set there and skb_linearize() is a no-op on this path.
Hitting it needs a driver that passes up head_frag or paged skbs and a
next hop whose TX BA session for the TID is still being set up.

 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ecee9348c7..fb49f3974f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3047,6 +3047,9 @@ ieee80211_rx_mesh_data(struct ieee80211_sub_if_data *sdata, struct sta_info *sta
 	    ieee80211_rx_mesh_fast_forward(sdata, skb, mesh_hdrlen))
 		return RX_QUEUED;
 
+	/* the fast path may have linearized the skb and reallocated its head */
+	eth = (struct ethhdr *)skb->data;
+
 	ieee80211_fill_mesh_addresses(&hdr, &hdr.frame_control,
 				      eth->h_dest, eth->h_source);
 	hdrlen = ieee80211_hdrlen(hdr.frame_control);
