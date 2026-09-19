Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD942DA749
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 19:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789845766; cv=none; b=oUqkk/KyahLnfLTqn4322n9yBj7IEwHsvVTunIS8ZHPNkNiWq5Dtq5n9dQLMaF5KGnQlztuqOoRuR5spQ3o5elD951L1TIBdkzsBY/QUlEMmKU4OlTYzrMZ6WBQzzdkgwsvJ+yiXUK/RISh9uVPdzoPHZjoTtNsGDDR3Or/0Zrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789845766; c=relaxed/simple;
	bh=KdA7cGRwAxWoJkmRE6AukygfZZOpTRPrEMpn/8/qM9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ufc94bA6wM4XUEsCtdm2dUvcy5WUEAMfNq2rYiFaA1ML/F9Emlfz7hCCNC2A+8Nlr1ZLq9po0MmhAP+Wp63TXZ5ARj3gbV7iy0mR87wd/1lb0SNc+K5WoTbCgRPy5E+rbiWPIDDTU7CNfMkLXk1CuYvQE8cbc1tVatUn7FM5Do0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnyVGNTy; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnyVGNTy"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350faaso901828f8f.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 12:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789845762; x=1790450562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=y8bMzTcIlQ0jv0JIoHF33vifWOPJhpDzKzOKxwrvPdU=;
        b=cnyVGNTyiduz6XnswPmc9M88d2tAhhnhjZAojqny6aarMyE5r3gTbIXPtJ3WqVm4/e
         FkqFxWbr63y3vANQqbL+6sFXsmJJw8b6M7j+uFuxDf/QbfdtdoPhK64CU3IychXN8SUs
         xGeCIv6TayotW2wNeUxpBwPlSwdhKvk3NeLcFfXBraWqcnstGz7hxZEGPAmeqEyhKac1
         rAGeV3mdtixCHUcF3pBv446/qqBD/kRDUSThgNJXFKQ2Oq/kLGeHPDjIygKMSXAGyR/O
         sweYVAKwOCQOeMI5T7SOcNNkZLBZyjAaBJzvIr4yBDDpQ2Vp74oRNkyEGkC6YuM/ZNiF
         GWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789845762; x=1790450562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y8bMzTcIlQ0jv0JIoHF33vifWOPJhpDzKzOKxwrvPdU=;
        b=Yi5C1BoueVo2C3CrokNUFclGNBrPzSFOyqyTYkiMUKOpAzrFRhvFlGMzcHvf92AMo1
         OeuoYF+Y2OEXD2DLXqnPK/leW6RvC9BbgbiMG9Bf8fnSaNv/d3Z4Aj7QJVysiCaIvh1I
         NMSCQeSpr/w7uqaxyXofCbbE0tsgQyMQGaST7K7fkS2Q7wpSUeygHBn7/bv1n4oZOUpB
         pk7dHIXN4TFlZSG3Fjry8Rt2CZgpAdCVZ91lpmgv5TnXvzYsVAkQQqzmeHxARqcT/eXK
         yBGxpoT4C1d5ePYDqkajJkxOR+G1vbUbvmtj6A9/+AFLM5osnk9TRaHQdGbMPWOu8c9I
         Z1Ww==
X-Forwarded-Encrypted: i=1; AKwUvByI3LCGPRhukqGAq3bzBHTrlZT/9WntgH2vivN5yw/HHOoFvgKFZtKBNZwL0pux4kVIZTs9QCS2AjZsuJ76CQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mYj5fGI6hqEt+txqeTezmXvNgm45ub7ZrrKUzbIUUVP0XC5fuK
	W5S6KK7lX4qgVGcs2kxell9wGmeLxHyeKdoj5jN6WCbd7pQiST7z59PR
X-Gm-Gg: AYBFou2zW69HDYG0sf40mxJ0vym4L5J1p3rY+NtMXosEmtACTSKQNMGXZk51IAUP4SS
	BYZeyzFDiXMFOdc1sbvRSMDbRB9lt3A8PFEsD6y5JsLlY2KqdPP0uuwVNVfqwTOo6a7qF7Z6AMv
	8d4w1qzfioUs/1TFvxMaiczocpJXAp2Ymds7RWL1fscbh5MNA05r8+plZZEQkt7Cy6f4h1uK7ZW
	BsdpBGzTX7oQVaVmBcotsIYS9xBHccstmbnDqh40W1KdCddmU2u6hYnlbVaubNgYDnsuHmM12+u
	m5EyeKonNf3Mt7A0YMHaP1lTB7/mUzosasSWRGPaJTAOsFX12/FFCUNoslfUavnyIC5DsFpRngP
	fC2aC8wZZ84QYLhISps7r1QwWnw/fb6OF/TS9sQlPxpS9YH/NzbWWiJtsdfA2HV5QoNgA3qyUPv
	maUR1hMKnDP0NXcXYhhsJ3K4EYzV+M7+KzXSCT9Pd21qzR8BPnaF5ssZhcC4GNI+dlR2tUYlhkH
	p8hX6T4a7AOn77AUkkmO/ainLns5vTsIM7BuVUrPKVR7J+4o6w=
X-Received: by 2002:a05:6000:27db:10b0:487:218b:bbb0 with SMTP id ffacd0b85a97d-487218bbf19mr4960876f8f.42.1789845761595;
        Sat, 19 Sep 2026 12:22:41 -0700 (PDT)
Received: from fedora ([202.47.63.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724460753sm9471875f8f.10.2026.09.19.12.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 12:22:41 -0700 (PDT)
From: Muhammad Bilal <meatuni001@gmail.com>
To: lachlan.hodges@morsemicro.com
Cc: dan.callaghan@morsemicro.com,
	arien.judge@morsemicro.com,
	johannes@sipsolutions.net,
	ayman.grais@morsemicro.com,
	andrew.pope@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH] wifi: mm81x: check bytes_remaining before reading delimiter
Date: Sun, 20 Sep 2026 00:22:31 +0500
Message-ID: <20260919192231.272078-1-meatuni001@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mm81x_yaps_hw_read_pkts() reads a full 4-byte delimiter and then
subtracts sizeof(delim) from bytes_remaining on every loop iteration,
guarded only by "bytes_remaining > 0". If 1-3 bytes are left in the
window, this reads past the end of the valid data and then subtracts
4 from a value smaller than 4, driving bytes_remaining negative.

A negative bytes_remaining then reaches the total_len > bytes_remaining
branch, where "bytes_remaining" is passed to memcpy() as the copy
length. Implicitly converted to size_t, a negative int becomes a
huge value, turning that memcpy() into a massive out-of-bounds copy.

Bail out of the split loop once fewer than sizeof(delim) bytes remain,
the same way the existing "end of stream" check bails on a zero
delimiter.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
---
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
index 3d641d23c35b..e1102b8fb802 100644
--- a/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
@@ -486,6 +486,9 @@ static int mm81x_yaps_hw_read_pkts(struct mm81x_yaps *yaps,
 		int total_len;
 		int pkt_size;
 
+		if (bytes_remaining < (int)sizeof(delim))
+			break;
+
 		delim = le32_to_cpu(*((__le32 *)read_ptr));
 		read_ptr += sizeof(delim);
 		bytes_remaining -= sizeof(delim);
-- 
2.55.0

