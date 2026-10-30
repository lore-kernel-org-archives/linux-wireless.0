Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793397592;
	b=3gQ7ohESjlZhLfNv56lTDmMXGfS5gY9pkwYm3InBRRLUL4T7zYznCvFqD6u/1CtRo+51
	 5on/WlQNGuRjZNqCbh/hIiNP4/zeYdilcQXJGuhZS2yNOWeVExFKWJS/5KPFF7EILKvHY
	 c+79/mQrHqv76GD9JcJzQ/n2pZ7PnAdJMrcNRawdywL+A8MnnMB2CIemLNFrgq4n7aC7e
	 Q71xBxxxJVPEoVPvVWALsS6PKnX02hH9KPpHRILawtm1goDDHeqw/GyDSUVFnw1/s9hSP
	 83/vQbARmgjHqzr0/V4dhkuR//SOZ1yLs741eLqovNu4OpVOV8puOStEc02cwwE+Yag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793397592;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HnOFnygv5yOSl1HLMfs9WsIC+5M5o8+ReDWT9KOBRGU=;
	b=zIZPopYjFkI2O+Xy9W9MFADf1dcBSS+i9HojCbk9nFC3Ru71q06olTsuK5ClsRSqN+35
	 qk75C8c36EKxbHNOXgsqOknnX+Okh/W9CFjjv6bVW0EZhDU66TvImkG0P/f0P3ELzxkmS
	 bOncSO/rSdCiqbsmC4P3IzPuBms3V2aM9zWV8k5OM5n2/l3BPKO/yrw27JDcZ8k89BJnV
	 lFRtSpv5Sx7Im8vyH4R2QrJeiseki2HH1iPNsccrkEtWfPqPfZiQC1hJ4kSMXOJkuPAzn
	 3KaHiOtQcphCRye8w0rA2fh+7DIe1Ov71rhRaI/9rM0jdMhXjNizEw9j46QrpxSFhaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qYRHSMZ4;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC42E606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:59:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC42E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qYRHSMZ4
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso9393535e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793397590; x=1794002390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HnOFnygv5yOSl1HLMfs9WsIC+5M5o8+ReDWT9KOBRGU=;
        b=qYRHSMZ4SpGnsNf/EFABndKTuiuilCxUPc07JXhHkXGsEbUYR9SrKPr9v4FLiXHnbg
         7XiM9tjvj2C1gRqON5p1+yIJBsULQsV154tlv4V06nmGkCAet9mnls4M8+GhceGIbyH2
         T0f0VDgAEnX85hhsdQ1k5K2MViDPc0wbvM74oZH3Al65ZfxKksYDNLMGwJgRlHyN33vV
         gJa/v2HulmiCLkK/UhCvmE1SAfLe2rid4y89DRaiNutLlWBADi9Ly00AssaCuelbsauG
         aEFH53WQzGvt9Hq2ubnDzdaeNS/97Bwvl94EQpmV5mg1pp3g+7DHGa6rsl8V3uYD5RPu
         luKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793397590; x=1794002390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HnOFnygv5yOSl1HLMfs9WsIC+5M5o8+ReDWT9KOBRGU=;
        b=lValbhAzAQ/E8QzzT8jQ1irLyuRS8+UYlKx0lWafrtGVsqWD4vsgYTDdprgPd3VD+8
         MkCzQ+Bj31OSTt/ICaPmGP5wfMWYp1CZeChYye9tudw1U33q6QQzy316lm7/FZ9HzHVU
         bRCK63EeMbu20tRNtdokPamEmWcOKSZwJmyvFJj9Cg9SOSlTu7t1ET3JECplcInRsq7y
         rYyDxy4KFIUF5hOosZoAlaNf9fejA/0uDMj1cvGP4uaDXwCZ+8fgk3wLC9qa71TRRQF2
         F/I74AEHgT/9zWZONJRBO9X85KZ1Z6CsOk/hbYskcRcbO4+mxDaYEoZlKCk/8MMfHn9k
         Mh9g==
X-Forwarded-Encrypted: i=1; AKwUvBxsLzzIZ8BbUMm6oG2Am7+GIaSeGIgoSiTqvtPuut2Rgkc6D7AeQpNyx4Jn2bo4ojXiKvpWqlymhNkDin5z8Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLghdQuNN7XH6iLPzdXxYIxSH60PaJwKCqROL4/MKH+nL+Je1Xy
	5EvgIYEZfiPbQo86VDEU3f5bmSuuAjsEVaq9xmqtEFS6AqV9mlT5mvg1
X-Gm-Gg: AYBFou30MjlR4689lzwFIJKQpNP99OXpwtEc5HAz2DFZ6f38slmBL9esYGNJGx5XNA2
	TqiQ6EDzdP0Rwl5BvUYXcym9aTak5aphdoTxU/U6oMTI5qMxJk+jhPPd6nbcx2BSb3Vxr/AsY3F
	gCCZ2E7/95csD0eXTeY8IKrh1P/l6rk+XazWhBjC0ophtubHzPVbhNHKJSpWVQwcS8x31eYXdff
	P5ZebQmAERJWxeQXiThdTsnyiiLZDB/D5nNxMS51CJ6HE2K1O/+pD/SFDZaerNciLGMojxcxmoR
	m/Mkzndg7w9Cf/4bsVjQ0bnL6EnRiqBx0h3E0/yLHQ2HHVkt8GtDjbsqoGEMKWCV+g0lG40VseX
	Ohj0XTo61UHlH3ggFEwl4yx2DQ/it27oUrlxn2+YtWUJdhHNxbDvLwR2wzd0Sjg6NANBFzslhwr
	x20FbJNnj2C5ZRoYBQtLugCkQKvieNpvvocKVpGJNJyPWI+GEkm1E06U5CXpQkcX3XWq4huPRm2
	AOHtiVdDvGWuFc0tm0dsruJyMtjPis6VGrdIeVH4vWyFJsCG/nPgzRfp14D2i0Urij0la/osbJS
	caltbfDi5G2i20J6rRNLU78drTJuGKDaIzb45kKiGPyRBw==
X-Received: by 2002:a05:600c:83c5:b0:4a1:88de:9e8b with SMTP id 5b1f17b1804b1-4ac17191074mr71942865e9.5.1793397590225;
        Fri, 30 Oct 2026 14:59:50 -0700 (PDT)
Received: from linux-virtualbox ([176.123.27.73])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf723b5dcsm87207155e9.14.2026.10.30.14.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:59:49 -0700 (PDT)
From: Salah Ahmed <haddad2inc@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: mac80211: make the phy tpt LED indicate real traffic
Date: Sat, 31 Oct 2026 00:59:35 +0300
Message-ID: <20261030215937.18103-1-haddad2inc@gmail.com>
X-Mailer: git-send-email 2.53.0
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

An access point's phy throughput LED currently counts frames that are never
delivered to any local interface, and keeps blinking on the broadcast an idle AP
bridges, so it cannot answer the only question a user asks of it: is anything
actually being transferred?

Patch 1 counts the trigger from delivered data only, moving the RX accounting
past BSS/interface matching in the rx path. Patch 2 keeps the LED resting in its
baseline state below a small idle threshold, so the residual broadcast of a
zero-client AP no longer produces the slowest blink step forever.

Both were exercised on ath9k (QCA9563) and ath10k (QCA9888) access points,
including a zero-client idle-solid battery and a link-flap battery over several
weeks of production uptime.

Salah Ahmed (2):
  wifi: mac80211: count the tpt LED trigger from delivered data only
  wifi: mac80211: keep the tpt LED solid below an idle threshold

 net/mac80211/led.c | 16 ++++++++++++++++
 net/mac80211/rx.c  |  7 ++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.53.0

