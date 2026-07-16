Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560033F8ED6
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 10:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197848; cv=none; b=Dqcaa3OUPy5pYO06NglU1IWRHkz9WjPXi+6gFEm9L8oRTYx6rSq2RrA+UDibsJKgDi5qjGYNlJXOzNjlCRkvLvhuTpAh4+SZHQMNHRIG7oP5PE5PUhaifrVCXuRGSOaJieynmc2AOBHTlyjnbWDamlu65GZJP5fd1udFoRD2Tac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197848; c=relaxed/simple;
	bh=jHxMxHF6q+AqqNr4U2IcpOC6OPKostUFnRX9P65WGs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZlZGn7eYwLmUPFohxHoV0vxkRJtLtKGNhasZr6O+xwu8ynjVO+14qIkHzWX65vN4+Je4N68BXH7zZqp9Exw9w9vAGsxXTgyk1WII1TXud9eIvPcWC8tShkx6GmnhgRp7piEEuPdsRkc5TZ9iu6gh5pRpMJGkiv63VtdwZ6bOYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0sec.ai; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=ZyY5NCGG; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0sec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="ZyY5NCGG"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493c19bad03so55534665e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 03:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1784197845; x=1784802645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gWJAyUbafyywGmXpBH2PyYDaC3fadnaJ7OKPoatVSfQ=;
        b=ZyY5NCGGvLWYoPqJ1eloYg0DbLWDTV9g6Ds3lILfonOWeM8vrOi1P3hQINF7haqZ4s
         v4fj6LG4SzMEdgke3YPtwQPZhYM8w+HkKzrGh06khYp3QBsWD6Ox6EQI6R8hiH/JKOEe
         qtzLoQ3yq0qmklR3nugGvg1SOkecaxRNzdjrClY+Ui0pbxD02uIO9UG31jua4zc7WGlp
         DrIKIRwnG3j3VUZfn7+T2fq4VAFMNdHZI84KsvWXflIBU3JOP/dhHx7eXCJHV+u6rdIC
         vImB8AQioWFoAL3a6K+U8F3Ruv2m/+0pTn3HG+cpwqYc/vAXK7xNdUwTXReHomgr1HTJ
         x61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784197845; x=1784802645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gWJAyUbafyywGmXpBH2PyYDaC3fadnaJ7OKPoatVSfQ=;
        b=EwYqGzPzde4PsGnY8O6ybH7ZYHIAyhTtrtLhlokObDHHG8c7wmsiIIUH6oHnsFPiUV
         aMkKdRVUL8pAzNp7ZSFRgKVYNjLMFYczewzQ49qGUnkdCn7fk1yURUuEOHYzq+sXJvZf
         WLFsZMpv9PNlSThSqFmbz6bhZcDp78Dcn438MCKlprhHOVDuoiZRsnBak0XDyqPuN22i
         Kc37suEJI8oOdohI4zucMEjSW0KSKXHEkdLARtKZ3g5deO4JmfG/3LGyihn03p6VW9Pl
         FdZ5o5CYk0DPcPIUk4Y1arfpzueJXcBcjqD+E8jQElFpCdJp5MY8Twr3Zb1yCIwnc2bq
         LRfA==
X-Forwarded-Encrypted: i=1; AHgh+RqRilSI1Ijx6qTXn9ptui0SU5o9tRF9hVkcQ71E0qkE8c9VxtMZVXbP1b4QyETZwwi8+Mcm73OeaKgczvN95Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiTVgLjYg9mgs3gMPveC1a6bF/FE2Si/wIZXPlMo0O+6eh3SEd
	zok4u9xf5A86LCnWZSijMSh+BooUMk4X3TLSxMSxXLZx+PulJotm3Zxag8z+tBxx91iO
X-Gm-Gg: AfdE7cknLHgI+LVpPfSbvrmbdd2jIsC3BTcKGzevz79GZFfv/ZHldKXM6ecyU6WLwnj
	nbVPwgvQYNgEbz7VXyM3iWiwN7QEjG29iPoSStUPGn+iSdTAEKrcQJuZewqv6ObSChbLJgsP2Ad
	Uzfl6cpfPDGpWOMEk076jXwKc8QEgeSMxrO6P8mUQVF6NEFmOGEtpNNRW/QCtAqrsOF+gLoPuOI
	Iaw97gP9fnQVpJ+b/EY0mi5qGVOJCwtdN1wt4pN+zAImMCK+0pBOexxNEaoAaBZMnmvDQKaBYlq
	ABKjXp1e8s/v9fTzPm8AMcMySSaRbToHOV9SyiRaxdkLKKW8jDKiknQyS2Y28uN6Y9wQASae4ZP
	dutixHjSzyRgcSpKVxSvjX5m/fmvC9/zsuaGYpWGSnvxP9tUaXjNpp7+L7N8VOXwfpLeJcOsHXP
	+hC6eVkI1VmpvqOPIHHFgQ7BWnXyJZ19SVWQPdH9UMVVZ0/VzmrrbsgosrchelzOPRmiHVQIqwt
	MrHJGhZi+TNajp0cVN5DXNK
X-Received: by 2002:a05:600c:4fd3:b0:495:4593:bcb5 with SMTP id 5b1f17b1804b1-4954593bd26mr4811145e9.34.1784197845285;
        Thu, 16 Jul 2026 03:30:45 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541eb85dcsm49129325e9.12.2026.07.16.03.30.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 03:30:44 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: briannorris@chromium.org
Cc: francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper
Date: Thu, 16 Jul 2026 12:30:42 +0200
Message-ID: <20260716103042.88469-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mwifiex_tdls_add_ht_oper() gates its follow-the-AP-bandwidth path on
bss_desc->bcn_ht_cap being present, but then dereferences a different
pointer, bss_desc->bcn_ht_oper:

	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
	    bss_desc->bcn_ht_cap &&
	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))

bcn_ht_cap and bcn_ht_oper are populated independently while parsing the
associated AP's beacon in mwifiex_update_bss_desc_with_ie(): an AP that
advertises an HT Capabilities element but no HT Operation element leaves
bcn_ht_cap non-NULL and bcn_ht_oper NULL. Setting up a TDLS link to a
peer while associated to such an AP then dereferences the NULL
bcn_ht_oper and crashes the kernel. Every other bcn_ht_oper user in the
driver NULL-checks it first.

Guard on the pointer that is actually dereferenced.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 396939f94084 ("mwifiex: add HT operation IE in TDLS setup confirm")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 845f2a22e071..c71ffe8399e4 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -215,7 +215,7 @@ mwifiex_tdls_add_ht_oper(struct mwifiex_private *priv, const u8 *mac,
 
 	/* follow AP's channel bandwidth */
 	if (ISSUPP_CHANWIDTH40(priv->adapter->hw_dot_11n_dev_cap) &&
-	    bss_desc->bcn_ht_cap &&
+	    bss_desc->bcn_ht_oper &&
 	    ISALLOWED_CHANWIDTH40(bss_desc->bcn_ht_oper->ht_param))
 		ht_oper->ht_param = bss_desc->bcn_ht_oper->ht_param;
 
-- 
2.43.0

