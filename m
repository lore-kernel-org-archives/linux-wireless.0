Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657735;
	b=EfiiTqrh3c0zUZzkf/vXPCiep9bwh26LmTbLStjoYxYVhA+mcl0hmXftt3Hp6Hciac81
	 uaY7cC2kGZg8CVmn7qf7eaTGkMSuUQiZYbjFRn6ikt++vpnwgL7gdQMA9zhNvmmJHOZWA
	 A5CjOYjLZBBMFtMN9vPiUtS6vtdqUt70dyCZLAUmcueU0kOsG5PRwks8DTkkxw+MaM8pR
	 gYCI2+/O0aZd4EB/N9EyGpkamTFnBjOajjj56ZVjeq6NK22rAoxG/yUdz8RGbEJV75JfW
	 hwtecozXRtIWtIlkPwA43D7YWyoEE2Gxjlnz09Ja/6gsbvBZ9ueeDZP8N2uECA34bPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzAycytcomj7YtaQRGxKObOzpf4opDuIErlVoBcZTss=;
	b=4cL6ROndism9ooB7XK6NJDwvGzw4kGUWUpkU3RkBgYSZkWX2bDKM11+Le+a2DzQ00hX7
	 gz1ZexlzbANO+zehMz0pOiyw3StzR1utqU/fJNIKLv88AzmhD7i/UOVr9e51COR6YyF5I
	 K06aUCu+DxloHEWzZ0p6I02eNgXcSl7wQ0DK9U8e+iEuuotai5KtgVzsMbz4xSnzUmTyu
	 q5lvswR7BydKOKbnBvUJ4Y40Ui+MLwd/0BVMHAUaUwKwcjV45CG9IXxZe4onMXfQbb3ic
	 lDkHdi+3oQppteYXuvDydupQ0DLbnesOkLRM8vwXsJidyygwuta+yqYcVo29O/k5i/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GGzavak3;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A1606A336
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 352A1606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GGzavak3
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso3138940f8f.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 14:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793657734; x=1794262534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QzAycytcomj7YtaQRGxKObOzpf4opDuIErlVoBcZTss=;
        b=GGzavak3e0tA7DrLmdafsU9MiTNFGXwVcuNo3wc33/hneDtK5/ziKFuxm2xZUq9+sx
         7h9D6opsLVutH4YG38lhjZEJTB4QciVNBUdN8o2+++QXDq5c/Al40ZYrt2XJt8KHfBXN
         nfoKkzp9m/fsJ+V8wdO1YsCGD4tWKPadxIfzNSfBoC8pRusOvtp/POf04BU8TRyLSrve
         t2JQS2NlbB+eSegEqjlxUSPPwi+pCkaN11FOU/itEAVIu27HAHqW1Oh3wvGigsSp7u2A
         FP/eb9r5ai4NEme3Gb5seyYGK0gnwNY3U0FnkhHf9WkZE1bmvx/YLZXJvnTarb+lX1M/
         FCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793657734; x=1794262534;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QzAycytcomj7YtaQRGxKObOzpf4opDuIErlVoBcZTss=;
        b=zZyWKSQv8GAYhcMaWL6FHrz+td8Sdjzn/zVATUL93T+akZijYSV4IGq6Wg8hNYGQKM
         N+wZXTtT+MSvVWSXwTdwLwom6i+maKWxzgKkr87L/fijuww5k21RVh6Z60Cl0qLsqf89
         dwllQAB9jy6UOKpve3g4dZCXqPEyee/KHVRfdDa0daj4RGgE6yb8cptbtT3KmUMGzkIj
         nOQOLBKci/8CWqzhQzcCFAsXx4jmKBvuEAHdgyV/5vOLodDMmpQEjLFrGig0maKCLUGC
         ACnMp+J8D1IC5gBqQJxBRes/LaXP7Ww+Fff4iKwwIEenV0iGH9N0RYjTtvvMym7vmVSh
         eAOw==
X-Forwarded-Encrypted: i=1; AKwUvBz9/X642uB19x8XlaUqo3vX8Z3wF7ujVQgH4rwkhb5AfthsLA68J9UB+O+qzskLDMIFJvgH1OKtLNVB+/PQzQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9c/c9Zt3kFWWOsqmv3LDeppvdrEYZcHoAkufb6RgdHiUw8/nwy
	+OD8pfqPyBunXIIoLGG9MJmZcN8ZFyoeBAY5I7OU7Kscn7Ja/S9oCiI=
X-Gm-Gg: AYBFou1aXpf5yn9ZvSS2kR4zs2cxkGn9GmVCetyFvDwkoB1IkCwbvLio3ybjAd1+wVf
	Iwt4rz/wpfoAsswWOV8DOOd+SenAhRH/szyJg1XhWhN+07XgyOaDIEk5YoE5PAzszaCHxyAuITW
	qoAOTXHX9h0E0+25yWipucbxhcSsIb9ZoVtNjPrxkaHQ5KN9zxFR2qGfjkpdLVyT5AX34ZbtTCN
	P6ZNWezLY1j8cWMnxa2Uvd0ls74qKBh2yG1S2Kry3lPL/Lhh5S968zL/LV5osFElaHeXEFeFuC/
	00b5Hzi0tz89YdQZUgqlGv67Nu38+EG2nD2XOvl9kKdOAJM6GRikhQLZKzTlYR6wQQYJHtYK4xV
	r0RjomSi0et1ynzt5K2obZDdjgyVHK4JHImI7+Sj3MfgndGPM4qOvVc8DO3q/5YQhEBfOF1U70G
	nvzIJxuaTDUpbBZzcfmqJajPikdquh2fgaSwNbM6P3XU1wRQNs5Qk8Kx6RIS/a05ikwghPZmg9/
	Xv4pgyduHI0RuRNTgZ/D/jNnCty5W34VwdAE2avHDw6vsuNgYo9uPYjyss4sPn2nN3k7nvXryfX
	f2t+fXAvOZE=
X-Received: by 2002:a05:6000:2611:b0:48e:4e00:b72f with SMTP id ffacd0b85a97d-48e6e50c8ecmr24326939f8f.32.1793657733478;
        Mon, 02 Nov 2026 14:15:33 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b725a2sm20662549f8f.13.2026.11.02.14.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:15:31 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless] wifi: mwifiex: zero-pad SDIO TX buffer to block-aligned transfer length
Date: Mon,  2 Nov 2026 22:15:30 +0000
Message-ID: <20261102221530.3469388-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

mwifiex_sdio_host_to_card() rounds up the packet length to
MWIFIEX_SDIO_BLOCK_SIZE (256 bytes) for SDIO block-mode transfers.
When the original skb data is shorter than the rounded-up length, the
SDIO controller reads past the valid payload into uninitialized skb
tailroom, transmitting stale data to the wireless device firmware.

Extend the skb to the block-aligned transfer length and zero the
padding when sufficient tailroom is available, preventing the data
leak.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index f039d6f19183a..c46a048cc961a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2386,6 +2386,9 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	/* Transfer data to card */
 	pkt_len = buf_block_len * blk_size;
 
+	if (pkt_len > skb->len && skb_tailroom(skb) >= pkt_len - skb->len)
+		memset(skb_put(skb, pkt_len - skb->len), 0, pkt_len - skb->len);
+
 	if (tx_param)
 		ret = mwifiex_host_to_card_mp_aggr(adapter, payload, pkt_len,
 						   port, tx_param->next_pkt_len
-- 
2.47.3

