Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228FE38330E
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252525; cv=none; b=SoJ6PiQ2OR8quu5nAD0x5n6jmP2zN+PAyt50t6u11OLQRsUSxgYFbXiVFD3DFrtAA3+ZsDAsp2IFz9rBcqx2wmn2GBfoSrdycRLGotD+HKCo0w2FtxapnPSGtqXhbCSbsCMC7fueRPrBt0RvZbIrOFivvV7Ya+zuqTHDX6HoB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252525; c=relaxed/simple;
	bh=dSNCESu5+dm5e6z1LWQbgytixk/aVHVZlXJ92PA6rW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ryYc1wlid8Px/kP43G0W1bpr0EKjz84QsrAKKadMisAEGys+fhHO/hxY3GuXvX4dpfrRZ4Du54QFYW6WxygaSyThvyAyiz2VqunT+s9V561t2TaMNWQnf1He5OUfw1kSaURKUSrc35JONVNvay7oYSwE4IS5oAKSttPEwvId0dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PamsQ6Hs; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PamsQ6Hs"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4956869750eso5234125e9.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792252518; x=1792857318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vG9pmLwap9/s2Xp+YiqlcSlpjYirU8JCd4qCN2FEQus=;
        b=PamsQ6HsGOgvLfeAREdyzChu1qNibLUxldMbamORo8ju2Q5f/YanqbsGjGSnPAGfkb
         jIrKML3VwW4qvhYcLF7bAOuZHag4YdE7RLRbsfXGplIYzdj1qGsRzvNtVBGFzhGxoFlN
         e21CQl5j80LaBVQGjT2cbcqDJ0W2Xblpfm7ZABaEQtE3IDlGAt4k5e1nNkz00WS0VMF7
         5QzFZdNb5EQjrToBjId7y/2K8gnYjc5TsL1vUQUS6HD/CqvaPug09XuOBLAI7GpC52kO
         30Xbqsk6+YACKeCqKDnULbaSzAbiP8mmKFXj5oJMdgEjT1NJtSeqIGBN/eNUaXjUJ2VQ
         BscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792252518; x=1792857318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vG9pmLwap9/s2Xp+YiqlcSlpjYirU8JCd4qCN2FEQus=;
        b=r0Gsj7K4tqg3vOV2KChrsdUb56BtLMSbnpSUmF6F30axGdV3a8FE3MqLQvGHTxXd55
         pXxiGevARQnZ1eV7em0JFYvTs0ZL+ntKZZgI+JILZYhbEkr3jAcZE76csvGdQQk9spiM
         J5ScAgP+S+/YtfaIZTBwk0KjybsVru/TAHwsM7Vu8+gSERwHjhmybLi2tGyb5R55dD/k
         /uoHrf2MeiqKleZONnxBoD6MDuhg1VuxIQWwn3Sa7CUTw1MKxUfVjIt3B1IHIm3ZA+zX
         jCllO1cIjWrwHppbB1fNRZqYU24zSQsDZ3jMz5oTYdllAsy2l+0uedYDuzR2uui6nxp0
         jhcw==
X-Gm-Message-State: AFq9FYJ9JeP/4OKAvn3PMbznohCYRgQpGnwWkNmR8Kwrprq7iTKQCbUU
	r10p4rodfGt3xsGEqfUv80jpC7StEsNtY8oisPss2TnUHzK5yU2YTTHo
X-Gm-Gg: AYBFou0eo7fB8Ky1Tfyq/79Ugo7otdyaTE8Eup7pwQ0UcdI2f3HiXF9MVv3eTpDVlha
	4/V34559h+p4pu4IULoq/zbzsP23PBhaCw29SdLLgW7HqQFyLkt9pUS05ng1wqJ2F8Sui1xg6MA
	PNd7fSGpQR+304sPUtGq5EeeigTGUEdZT2X+79rOJsqXlEsXHR+VXgcU8HwX+1MUyXT+I1T3iYB
	4VHwkMfCVyWaMotZ6k2tNR5KYdh9pywWoVCQtB8QFwhqZ+njTVB4seybxaNqA6u3kgWbpyQ29nC
	Qm/RXdjLJg9Sc4cnmKQY7F/PPx/FpcvjyQyUgImqCCX8svNL//uUy1m05LkzZu3w7JQzhXf1faO
	+OV0tikQAlrMgYW2aGfWXMTWFATYtauXGisJFWg7CN65r5G7ky18rbU+d2/RhxLn3LtM8p2zw0C
	651Oe00Pq6yPznzCeX4nlKHjXH3qE3G2zBpkc5OKpouAPuSBHvEEF+3a4zckouSpTF+8RWs5e2x
	/V7zOVCjLCQgKcDEno=
X-Received: by 2002:a05:600c:4f94:b0:4a1:a2c0:7b73 with SMTP id 5b1f17b1804b1-4a1d76086damr55314085e9.30.1792252518028;
        Sat, 17 Oct 2026 08:55:18 -0700 (PDT)
Received: from potato ([31.176.162.244])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1dea678cdsm42335505e9.1.2026.10.17.08.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:55:17 -0700 (PDT)
From: Omer El Idrissi <omer.e.idrissi@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Omer El Idrissi <omer.e.idrissi@gmail.com>
Subject: [PATCH 0/2] mac80211: hide tracepoint definition
Date: Sat, 17 Oct 2026 17:55:07 +0200
Message-ID: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series does the following:
- Move static function that uses tracepoint from header file
  net/mac80211/driver-ops.h to net/mac80211/debugfs.c where it's called
- hides tracepoint definition flagged by UT=1 behind
  CONFIG_MAC80211_DEBUGFS

Omer El Idrissi (2):
  mac80211: move static function from header to referenced file
  mac80211: hide drv_get_stats tracepoint with ifdef guard

 net/mac80211/debugfs.c    | 15 +++++++++++++++
 net/mac80211/driver-ops.h | 15 ---------------
 net/mac80211/trace.h      |  4 ++++
 3 files changed, 19 insertions(+), 15 deletions(-)

-- 
2.53.0

