Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197376;
	b=dRp8EyUnle4/sajC/yB2bQDG8xcYCyvYr5K59gQJGZ8jPCDXoOyPcg6ivHmfIB3fUIXl
	 4dguGF1C26/NSYlKUoVLXAzGFcv0aPh1OseteLccIKcNOcipabJoAPl8b08XoxK8TPLNl
	 cs80XlGRVFAtWHRvNCQO4/oCoI9xzqCLbD2I7WXARhg6vVR5ReP1+5c68n7xsYdCWKJbt
	 W/1fXLpZdGT4ME0lUwdMadX2R3+EA58IYQsPrOjsW1ohof7KHn/LdqOqDs7/1Nv7RQOEv
	 Cz9O0FFVkurVEwaQorqJGgzjeK6urhJcfDcRUZpDR4mGo5rjHwVevkTSi22nxhm0rZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R3r/3ZU1ASS4zexAo6qBQYoR9NBo3ie0E+cmGO2ebcE=;
	b=wHy/NUgiShoAzBU0QOJlPoPkvGDoz7Mi1og5z0qrw888py1Tr/3xBRfXUCEjbdOu+kzO
	 i1qynsw5WofCMWqn2Sdw6a/cMXs3rzP0LxrCU9+gvsSPlfy9325cC63m/0lfIsMQBEFP5
	 yU0+6/0E5P3lqA8phsohGgt68P6fcdGSAf0Q4H4/wq2syps8oSsLeHpIBj9LqK87Icoux
	 A0ZRIVRrh77c+4Ur/SQ5p8wIoRJTLZmxMeo/QnL3bB+N+aBq8ibWC+1F47Le9FXy5LQma
	 yxnLSGAx/9bdUH3dXy/hh6i/o/WOD+tQlzWeauUdx3eelsxS0V6xWNmUfatE8kd22IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gjcfw3PA;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC25606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 14:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CC25606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gjcfw3PA
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a089dfee18so1333827b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 07:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793197376; x=1793802176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R3r/3ZU1ASS4zexAo6qBQYoR9NBo3ie0E+cmGO2ebcE=;
        b=gjcfw3PA9hInUgM1/7h/j9oC2YHnkcn9OVoO3vBpXmAhWqvMOplncuF0jZhVSA64lq
         muwaNSN3eWHCy32PpAxV3l2LD2znF8xz+HN/+FtZ5bKJ7oPTnyG3ferbD2yWEjpbHGJT
         fOrz592h6KkbIurx7vayadNEk7tXXcpkJRvKyQdp2UlDP4pFA1F9YeBewcquw1QQfrVu
         rwfPTPXl6eU2/IlRBzqWIzNdiq7zWfFcf2ivaMpGCz/sAD/Ph15Le9V9y+dkbeZDtYOO
         9C+Q8v/HReRAVMIXPQ3PGfDakfNqRAISnC9nLoe1FkjFg0BaIc5QgtBw/z6d0HjYfwns
         m3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197376; x=1793802176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R3r/3ZU1ASS4zexAo6qBQYoR9NBo3ie0E+cmGO2ebcE=;
        b=0M3JdbVuVamavYy59NNFRAnKTlzv3xIoKmit07wO0dn0CGxq+5vpGQP0zRYthelsQY
         HXD62h49+obaUlR6PuLMlePqjYk4lZmw3flL8yn2v1myrpNNofIp/XV2NQWS7Uci86VG
         nxTaU2RNhBhj0AOot78hmLs1GgYO3bDRZxWIydxpjUXgqBi59J63tqz6n9IrqEBesazJ
         tUAk60cxKw4vKNYFo8rcZm2yCbPTyvDjEFRD/VjeHWGdBV206liPKRESmVO4ikTFOAtV
         VvBSg0Oycn/zuVcZn3Kn5Xw4A2zcjcH0wtPYLZD/2f877qcZkRA5bORirNBIuc8aL3xE
         j56g==
X-Forwarded-Encrypted: i=1; AKwUvByNun5VWXDWrNNCeHJuEBIAODzLkxUvEK+cfVm+frXx2YuMhfXNBknvP8+RSe6KQhPWWVukNwuUEkcjhckSmw==@vger.kernel.org
X-Gm-Message-State: AFq9FYL9c+8bMTjq77eNhX7HL8/leUnTwFQ29BDDpkjzSIMj4fuRkM9g
	msfwYgI72ncfgas3lx2xvZmsPXAefI3qiXdEhFiVqUfG4jaVkV2l4IzJ
X-Gm-Gg: AYBFou2ucsxfhkZSeStyFZkYgmCQ/dI67pKZw5rRZRYiuM83j++yfcJ5hF4qxLFhBco
	q+1BT/+MzY412PdYK8EIRYgqU1BnFPnBJ2qnJCwHASma9ulKBiUbl3z4FAVpwNjNj3WxHm8G2GY
	kB+caeGM/GWS71EOhmdydOFN6LD4hYgVYjxunZXDInHLP/ZNHw0KlA1DuYbUXPFTVhfJG8DCukz
	jB9wQb5jOEj8ena6KwgOUjKX/X4RdaHYj/GhREWHJAcY9DyrozoEr1CJmBM7PrN3m/2p2Y1YY2t
	1SeHg4CDcL+sStRmZSrzf7RugyjcBCORnE66Byku1v+/aQYBfyitD5BA5vnF1A0XztN4prHwQZ1
	PIryXmx2GPzfXct9CR6CCYAAmaRLNM4ckFZGKiZXnwGeILPVB5eZf1YeGKt713iIkAepplZKW/i
	pKZnImRuR+90GUhmwZe1QdrQo6rem8K7UGwNxT/tdIupJCU0ZTm/BL0odQneHuHI5176TiWcCOZ
	jfPvvSepWpeNPuUdagBYXjaQB8TqcNQNjdOtI6RwCqwusqyIqQS6UVmtcfhJ5ECjqW0WiXo+mPr
	JacbEOZGE+nJbY/3WpYn3ufLE6L8PzSDJ/vwTEPbpn+O61I9jJLloj0Az0LgasTUR8yg
X-Received: by 2002:a05:6a21:b8c:b0:3e1:2c06:3a51 with SMTP id adf61e73a8af0-3e908011755mr790326637.2.1793197375307;
        Wed, 28 Oct 2026 07:22:55 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a662ba00sm1245181b3a.23.2026.10.28.07.22.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 07:22:54 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: mac80211: enforce IBSS station allocation limits
Date: Wed, 28 Oct 2026 22:22:33 +0800
Message-ID: <20261028142235.15428-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 prevents the worker from installing more than 128 stations.
Patch 2 bounds pending station allocations to 128 per interface. The
patches are ordered: the insertion recheck must precede the
pending-allocation bound.
LLM assistance was used to review this series.

Zhao Li (2):
  wifi: mac80211: recheck the IBSS station limit before insertion
  wifi: mac80211: bound pending IBSS station allocations

 net/mac80211/ibss.c        | 21 ++++++++++++++++++---
 net/mac80211/ieee80211_i.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)


base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.56.0

