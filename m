Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755708;
	b=puDuXkVWC0O8DoIdOKQ8URQs8lg5iCc4BKBxI8sjqJRuJo1IrzU8XsAD4IhDP4QlHr7W
	 zOdobtik1hopvPBNRmVVeHos9mIb9p0HA5oQ5/nWuynrnBQW4C/9tUpcrIxxi8r0ef32t
	 jyFoH3/Uiviv2/CyAaTmk5jBbOKljkZIMtIT9XHbiaEVObxLiid3SNYRFYUfM1C3kq5PO
	 t7Ku3bWmq8fD9Yr5Lbo99XNV25wP85SAT/ojvu7LjixhFacuzKGVBwBWkoYD4ScqKgVj6
	 Wj8XjDsf4WiFGrKC55JxmLJ9fTfjCXFtBRWCnGl2d+tJkCdMdfmmXf1FDEygRB0LuDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lsZWUBpvhePl1wIov0jyedf8Obc/7EwRbPKy1mGFvZ0=;
	b=2LLWmMnojDClHPSVm/NMWx1f9mUJeOGabbrYkGmoLFjsEKOdMIQ9B68qBRu8XEmsBdvn
	 ShoB4e6i0XQDOj2enwrpzAJVr7fFtE+4wVII8C9XiKS+xz/FgzmzHJ8J1Nhx9OUfxFMdt
	 urfNLTOOYNYQN3oGvw1GdEZdT0IBRbR2ixOSyKvrU0dp43zWWs42SNH+WLlfpt+7b/62y
	 QE/p9nJqmIZE89yHvBYLOGQ+gRlfwTbHFF0WSkpOoVHIs+at5PLjgXpIwgDEtD3TfgJWk
	 gpo5vHIajvVNuhr/nc6G7Ro27k369AAXtO+et3U3C5ymdOq/pI1G6IDJyoYfuJFBXeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=I4R9GRSq;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38B606A337
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF38B606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=I4R9GRSq
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc758830601so134792a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755707; x=1794360507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lsZWUBpvhePl1wIov0jyedf8Obc/7EwRbPKy1mGFvZ0=;
        b=I4R9GRSqqR9rdVI7+cRvCYjAZ2U/H9ZsVyavASHp4WFde/R+s7MtLIcNSzW+OaTDKr
         3oMvFQLBNmcXz0ThJjDDN3hTnjNjX4XoL6T1BzPDckeNj98ZNhrnEDlPJVXFC3RC2dTg
         XVphtdnJj5VgcZV/evwWR9swRQYd0Ttm7+s4G3rHZCW7eTIGpyCpxbdXRo+gM3PvkE4o
         0CmWgNGbetfJm+NR6olgSeOMBpZHydD8pEj2pR7bLMWTZnmhovYsxy0UGesscj6nVmjR
         lCE1TqoTEfoa9rx9bV/H39xQTx2Ey2bdnzZgtA4gWwIcCyjj9llvdHzV98A1GsyCllZE
         +wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755707; x=1794360507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lsZWUBpvhePl1wIov0jyedf8Obc/7EwRbPKy1mGFvZ0=;
        b=HBVVRRhYbiOFgv1nLn86lmSTzCUEBSh4xEEgjRHvJGsnumeoXaW6/+pv3yDyc+wcIM
         ROq2f/kTeikKr6C/VdG5NZFhxg8wIF+T3jW83a2zfofKO22xpz4yhxEtnDbWC851qQFE
         bWoYSpCpsEiC1t+rmzGWEI6ZTm0HuENLenv7i2SNuokvCtLrHJ8V9WWiWfsNdCKPX5Kb
         RKUld5KzmiLqECaCpRGBItoB4wUheV4LdHvM2iQfEiaR6rog5VtjKK+t+wxb9eJvYcg1
         dCqWAeJKIy4wVNCFjnQNRRtBtvKlVm7xqF0fM0EeC6fwJJg97DF7+APxB5wx5jwjChPg
         L94A==
X-Forwarded-Encrypted: i=1; AKwUvBxiFuTKmgyLiBeEQKQnwmhcyXum3mjF50+J/gvkLzcZdAv1depff0bBQojEc04CtPWxS7c+OCrTmg5h2DZ0HQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/wexhDfZVIJQVvlFZsSL4t7/ZPCiEi1nvAI6lXrdp3fydWfXSf
	GKByXrgUN302a6ZUrs7tZiv9IxC1TutrInpl/FX3DXtAaVI6Z/TXEu/iFXqpYXwQD8o=
X-Gm-Gg: AYBFou2ytCCut9m90kRc7f0LYFgpp4x4nd1jjSZLvBhcvtK61IaoQmjpO1UZsFxegSN
	AkXO1HQRbmOXuVq2pHmLxZOw7ugMzdaPfsiBATdxNHbklpk8eOcNP8mYXPsJfE4tY/RyRlEbMPp
	giWr/ZiBqmFIfb53XOwqSkuIQNUEqCreKvNixQZl8OzUODWiHrLV7nPWIpdJ6B1ceoDlKfHir2O
	LGr9fdjmJswqW7QeelyObkFfTxzS9AjSZ5kIvGYeqqE7u3WXh09qaJpNu4Hvt4gl22PlslLtyoX
	N0xdqzxBH5OE+1njTSVu/tfb3KwApcFhMFAtSCmJ+jy7ToVSrPa7lUf5mRTogIB0WDuGL9bYdMv
	qxowbipRW9TBLT4gOQCoF9wXOAXH8pasi292Od/YnnDnh+7M3sctTgDwLEmqkL9vVWjave7i+Oh
	wQ4k9V3gr+e4CR3nmkA9aDi8fJoRVcBAmjKRpw7CAOsDfU3u5l+a0KAxcjlRrLOPiQ37YewDOHB
	AdWR74ntyDYADV3Nd7LXK0OdrOWq01BUayViwVZT+GU1oc3yY+O2Voqi+/dHGZYlKSZ8r+m/1xW
	BKw+y8O06zc2XTHD+0WW6iGt5u/owrwVopoOyfRLnHqCp8iVkr0L2/7aakHncjm/mAxdRjAkjW0
	zmP7g4FkiaxXkxxG9VA97RQrNKd8lzww4gtnAWA8/fggm5mk=
X-Received: by 2002:a17:90b:4c81:b0:3ab:188b:c5bf with SMTP id 98e67ed59e1d1-3ae897c85e6mr12227260a91.18.1793755706932;
        Tue, 03 Nov 2026 17:28:26 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:26 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Nev Young <neville.young@morsemicro.com>
Subject: [PATCH wireless-next 6/7] wifi: mm81x: mmrc: cap the third retry rate at MCS4
Date: Wed,  4 Nov 2026 12:27:55 +1100
Message-ID: <20261104012756.510424-7-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012756.510424-1-lachlan.hodges@morsemicro.com>
References: <20261104012756.510424-1-lachlan.hodges@morsemicro.com>
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

From: Nev Young <neville.young@morsemicro.com>

In converged mode the retry chain is best, best-1, best-2, MCS0, so at
high rates the first three entries are clustered together (e.g. MCS
9/8/7/0) and a frame that fails at the best rate is likely to fail at
the next two as well before dropping straight to MCS0. Cap the third
rate at MCS4 to give a better spread (e.g. MCS 9/8/4/0), matching the
cap already applied to the second rate in unconverged mode.

Signed-off-by: Nev Young <neville.young@morsemicro.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.c b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
index 410b3368f05e..2f0a424b1117 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
@@ -500,9 +500,10 @@ static u16 find_baseline_index(struct mmrc_table *tb)
 
 /*
  * Fill out the remaining rates to be used once the best rate is selected.
- * Normally the retry rates are one MCS lower than the previous, however in
- * unconverged mode we limit the 3 respective retry rates to MCS 4, 2 and 0
- * respectively. The last retry rate is always MCS 0
+ * Normally the second rate is one MCS lower than the best rate and the third
+ * rate is one MCS lower again, capped at MCS 4. In unconverged mode the second
+ * and third rates are limited to MCS 4 and 2 respectively. The last retry
+ * rate is always MCS 0
  */
 static void mmrc_fill_retry_rates(struct mmrc_table *tb)
 {
@@ -522,6 +523,8 @@ static void mmrc_fill_retry_rates(struct mmrc_table *tb)
 		tb->best_prob.rate--;
 		if (tb->unconverged && tb->best_prob.rate > MMRC_MCS2)
 			tb->best_prob.rate = MMRC_MCS2;
+		else if (tb->best_prob.rate > MMRC_MCS4)
+			tb->best_prob.rate = MMRC_MCS4;
 		rate_update_index(tb, &tb->best_prob);
 	} else if (tb->best_prob.bw > MMRC_BW_1MHZ) {
 		tb->best_prob.bw--;
-- 
2.43.0

