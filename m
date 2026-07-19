Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEA243F0BE
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498307; cv=none; b=dpPj3Z8MibVpDDnwNM1M3PmvuYauOaNi5Qqe/QMofFH0E6SRFcGFjO/3c29xYStDMriPXKLBFCEnK13rBt/p0ThmB1Ila3poWq95lhTsHjiB5Mt/kYyGODaYgR2Ei3D6cU1wsI9lfsqrGjW4WKQORRnxVjGAzPgO/sP1J51B3g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498307; c=relaxed/simple;
	bh=6gmd0pPqch6iW9yOzexZBXmNV/rXNPLlqlMxc6znOAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NKzctQ6AM/Mb2c8CsvfelrO6WYrSPjV76Ddn3plk3oA2sur3J0hrU8clkEnyXRfynTpnDb6+s8iJZaIy0G+wSkYBpK3yjftWON3lGLXnm4+3lUCblIWX/Nil18D5itWyekf+bdYmMVGut1naF16kLwBbKyJjg7WbyWCVUccvWxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y7HiUCit; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7HiUCit"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15c42a45adso494022266b.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 14:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784498304; x=1785103104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+b/LWj/hLmWJErzZT/ZoMVshAClUgZMmHRGkesS9h0M=;
        b=Y7HiUCithsT+F4hvO5WVTl3p9GoprxlzOdX3scKqbS5iYPmV1F5QpJDG/qX/Bjk3gl
         JcfpPjI7qAGwyMtezdfD+mraC3S6GEljKwgG4vgZR9o1RLVglvCBUfVH0icnFLlo2Qyg
         fD36ccVYwjzX6QZsLMSLTh+bOz9juoP/PKbgyzdmfun7mmd54QNOIW/CoKpWob3WWuEd
         ZT3FOjqpHMClt3RyyZWncgcXeRLxLWpZFLsb00QJr9NIsUANxWGR15Y6dgBwntOu22Ty
         9h5OGzug9YyZoVFr/LEqg/uOUj8yE+gY2QDbitKXmAwzoXYV8CVrAtWHdrMiW1oUVWxc
         EmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498304; x=1785103104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+b/LWj/hLmWJErzZT/ZoMVshAClUgZMmHRGkesS9h0M=;
        b=LdjHQqt7w9Tfb59ggjqSJo+fnvdI9NBf1uSLYMOWYQwmx4wUq5nXc6xr1458MS8Pyb
         ArIoaMy5LXL7ximO1pgV4SLzwuTUU/vljn6Co0v4hLOZkMthiwQpJIKUfFYl6QgwDcDB
         3tcteFWn3aNjm+iiyB/onTcKpOigPu4dl4B3Dkn0k33hGfh6EjWbVzSB0BbGzDOUeA0W
         svEw7uo/Kfr30uN11K4tT/iPGdWeyMGc1qiA4e9CgfrWUECZG83ruoJK07tCsO7mhNxx
         7OXxxpTKA6tgH/49wypdAya3/gzZZzC6vBEFCpMjJzZy0GabPMl3PepRd1R+HiyjccTK
         qcnw==
X-Gm-Message-State: AOJu0YzuXsHjAWGZCxGqs9iKpRR+lqj8MLKlGjXzljMjqaY9SebEYGLE
	7sYQSadaA4YhKWjBlRR2MGCGlMQsr0EozgbM5aoI3Ua2c2hx/uG7v2VM4L+jbjLm
X-Gm-Gg: AfdE7clqDNI9/3wVApnb8K0GbncTi2SPoDxFvoyEZJI6pBMYXAb6FbNYsSyAUp7+D8E
	ZuwLgpWyr2nAteJqV4I5/GYWGoXNn9cH/nY+ohJJY/uzNOXP+Z0FWtgeLiyJNRP6l+2U2Qjy2yW
	V5bprCsSn+kanct9ht3FtaQK+ymls0M6KEWhLfxR5l+hvZw2I0dtG1JzgxWJyfBN+RcXZ/JhBLb
	iPoVDJk5rooF+8b5AuQOfAmzNzUTd5ZgBOIC2mZ/OsikZLx1URKESHewC5lc4M/YT7lEdUNwAhk
	vuvk6yohpeWtXDjE2gQHtVEA6xp0PwBmkowcNZ0xUxcnSNfKMwlpK9C2mLf45HQq9pftPT/ZwXG
	rjNzv5I5ZnJbUrbBXuiuXHcoZDjUPu/RXRBVPzWCG8b0RWZ1gTTUcf0FBknMIB7kgleILF51baf
	VDdWGLdNxb5ib1QQ==
X-Received: by 2002:a17:907:3e93:b0:c12:b68f:1a72 with SMTP id a640c23a62f3a-c169240e51fmr720302766b.24.1784498304106;
        Sun, 19 Jul 2026 14:58:24 -0700 (PDT)
Received: from nv-msd-x1c.mtdk.labs.mlnx ([212.60.125.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c16eb80bbf8sm379116766b.0.2026.07.19.14.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:58:22 -0700 (PDT)
From: Mark Ruvald Pedersen <wabsie@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org
Subject: [RFC PATCH 0/3] wifi: ath11k: isolate RXDMA page-frag lifetimes
Date: Sun, 19 Jul 2026 23:58:14 +0200
Message-ID: <20260719215817.2468580-1-wabsie@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k fills RXDMA rings with skb heads allocated by dev_alloc_skb().
Those allocations use shared per-CPU page-frag caches, so unrelated RXDMA
rings and other network users can place fragments with different
lifetimes on the same backing page.

On an IPQ8074-based Linksys MX4200, repeater/AP traffic made available
memory fall at roughly 12-16 MiB/min until OOM. Ring and IDR ownership
remained bounded while page-frag backing accumulated. Two ownership
captures found fragments from multiple allocation origins on 86-87% of
the final tracker-visible backing pages.

This RFC:

  1. fixes an existing no-op alignment attempt on empty RX skbs;
  2. makes sequential external IRQ/NAPI lifecycle transitions idempotent;
  3. quiesces non-reset crash recovery before DP teardown, gives each
     RXDMA ring a private page-frag cache, and drains it after the ring's
     DMA mappings and skbs have been released.

No RX buffer or ring sizes are changed, and the existing per-buffer DMA
map/unmap lifecycle is unchanged.

page_pool should also be viable, but it is not a mechanical allocator
substitution here. These skb heads need about 2.5 KiB of backing, so an
order-0 pool uses one 4 KiB page per buffer. An order-1 fragmented pool
restores packing density but lacks page_frag_cache's lower-order fallback
under fragmentation. page_pool also adds fallible setup/unwind and
requires every skb return path to become pool-aware. This RFC keeps those
behaviors unchanged; I can prototype page_pool if that is the preferred
ath11k direction.

The AHB version was built as an OpenWrt backport and remained bounded in
natural-load, resident, and high-packet-rate pressure runs. PCI has not
been runtime-tested. The non-reset firmware-recovery path has not been
validated in isolation, so feedback on patches 2 and 3 is especially
welcome. The IRQ state guards make repeated sequential calls safe; they
do not add synchronization between concurrent lifecycle callers.

OpenWrt discussion:
https://github.com/openwrt/openwrt/pull/24254

Mark Ruvald Pedersen (3):
  wifi: ath11k: reserve headroom when aligning RX buffers
  wifi: ath11k: make external IRQ control idempotent
  wifi: ath11k: use private page-frag caches for RXDMA rings

---
base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
