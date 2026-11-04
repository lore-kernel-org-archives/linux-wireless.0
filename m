Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755710;
	b=nu36eQ5AEtPC2ZkBV83R35IlAV0G27LvE1qFR2durZYNx4miMUuZcOySkkrA/c1e1rgd
	 h+iI1ECKxG6J6mYFxHcqzLak8TbLvb/yjUFab3DClSaTK+q7tYYGmYjulCYPxJmzC6ZsW
	 SFDFqJv7DPZPm9gIz8wlCVp+W6F4NGRjZcWr6Bz+qiZMYgX+9qkbw88lBNgv8OOLER+qA
	 pLBMHoCcf8jFfCm2GQ5gF2IazoCcNS1RYHmsS8sfgBYA2oUoZmVjnX34MGPr/neiUEQpU
	 swVzLLKWwsVBSnAMYSIebngWaOHXFEQGv/+yr5nAMHJV01tGWQxXxAUm9e3gdoVUMDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KCVgDvaZXHa08ljqzUcaj2GuBC47j28XlCNU2sxllkg=;
	b=L4KAgpfCc3BptDF3BCmzRYifMnv0JDXjd45QgGZEiJ3zz4IHlvGbE9dQ2hKikYSbTSJP
	 bLIyieauBM9T905fao6NANgNXka+uwmjdztdFOH1Uy7vXOic9XHqht/i9HHIYIRVmyai6
	 IiXxMW+T3M4g4vje04xUKvIFOMqRy/6/88aBou1iianhf2+OHcflyJxmQ0jo2S5rubBnY
	 Yvq2WZjGaMSq0GMVcyGyMqBWcK5bbVZ5hMark2iJAVcSgZKd5gqvg21uXTdGZ9tPobxM6
	 I1pm1T3aEPZMWDorTJdSPMqNdiIk7IUhF2HF5JENidlKdK2GsohrmvZQ0Mp0lVhXgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="ArQcn/dH";
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D996C606A330
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D996C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ArQcn/dH
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8ac1f2ff78dso641649b3a.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755709; x=1794360509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KCVgDvaZXHa08ljqzUcaj2GuBC47j28XlCNU2sxllkg=;
        b=ArQcn/dHA4gv5EmqI5TVDaPKtlVeWisjQgFL5kYXe6tFW1RTslqd6qOwP4ny/wNJB3
         vmi3QTS6vBpVeQg1xFomry2nDPMy5/nToLEb44gWTuR+PrCE36Ks39e/u+J4J5CArwpA
         ODN+PYiz/jhUg6b4BdEt0mXxgZ5mPCB0yf/BEMwEznIIOZOC97ZJF+zsN1iSSr5hUUSo
         abNBQubz5NCddiTp12M9yKkjTJ65RPCXpY2gYEBRIGwqEFzr/lLq/h+a8oeWazS1yeve
         wM+C4nmgP+MxAn7EWEJCkQxsDh6wGc1FEpL+dj6sMhvxVO0p8bsAEbkpwoFUfbVLOV8Q
         olFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755709; x=1794360509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KCVgDvaZXHa08ljqzUcaj2GuBC47j28XlCNU2sxllkg=;
        b=mEtDvpMgAzNeJ/l5QzKRRMx9tRAUl6Jx1VM0b5wFjJ1aryE0piXLXDc9bs3x/WMKE9
         BL7ED30ncD9bTO5jEcpPZP+axq6dlBbSIKgKqbjd0KgF0MBbVYXNqiZ+ef/FRWroBvr4
         G25kEvBOBcQYQNUjaQLfhFLiwXJc8tdPCgcwLIry1P7n7V0AoBIYbcjIhZRkNx+P/cUK
         DV/K7B6cfIXb5YJTUWCBzQiDXoRUBeYJObEY3M3m86Ne1X5NvCWyjbCkfSrQd3pM0z4D
         7wDq2tJyq1BZUxfdbHC5rlACUM9rAR5NCX+iCCmU1Q9MhTXB0qFflrf4+L1ivkOspIsL
         X0Eg==
X-Forwarded-Encrypted: i=1; AKwUvBxZSWVLecPX5WMn/qNavR7KL/ssZwljrgz6L47uAvTXELIw3L/OfK7g9sFG2Iwi91j5GhO9lkGZJ4tt9yILoA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+LQGrnO0LB6F3SXcIA2XOlZN/15CdEdnE/ajaqdkuhkgu0lMPp
	E6uU/WAe1OybvrSgKpDFnThY0McD3BR7P34gYJFDtnruVaNf2DME4DeWM/ZUabdeGe0=
X-Gm-Gg: AYBFou04gceE4X1JuS+4q2qZD2pHxOIMovwYaE4j3Q+HNPyB5G2JyCigPjOQXWAG8E2
	HYVMRrKmoj1/+hERzzbciEjAEjR4Y5OkpYeTr34FLazgmqfwSCCHfFB49UKMazw3PGvsUN7dTKJ
	4xQhq2/PG3403RVIuSvcvKYB9ogXN4oJM25X+Q7F10WeI48nsVrBpHFIyCm/SQV7Glo98lltsci
	QeKHdy3HiSIqIQPimoVmrSMQJe64gNifiM6jPy4uKCLLwFhz0j4TG9F6TxmLXsb79WVrhY2BDmB
	Lipz3YtPWYVY4GgfLXjNWhHI65WV8Yxal2XxPUuXCFzCTKkJnuh3r8inbJkKYp2ErfNT0tqAYIY
	az/VKsJCrH0C0ve7TB1ol6pZR3ksUOn5BafbC/Rh8IEYU9Fg5LpZ2TSjToNVoAe2dkxX6QNjz7k
	+GJJSSMcN9TFeIn2oxVTq/lHbo4LR3RgpGWmx46AFv7ViF054o0znLSDHCRuE4aGv1UefEYUgie
	2tkWpjjrzH6WUPPzRRTXXSlW6UoOX9mNU/rfKmu6v9Zlz6bLtPBUeQLfkeEAjnJKBxpzVncgjhz
	T+SEjTUTQG8RQP1/ox4QkLxMGbJq7DqBnOy8RbiIj45x699Hnui56QCHl7YE/WGgRwuLRB6Kuqj
	/KE07QZMLiwveAh1r6AcYeLgwkjprko5dBYF/2LxXWfKVmAk=
X-Received: by 2002:a05:6a20:918a:b0:3e2:58f2:7557 with SMTP id adf61e73a8af0-3e913b5b07amr12874646637.18.1793755709212;
        Tue, 03 Nov 2026 17:28:29 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:28 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 7/7] wifi: mm81x: use the default mac80211 TCP pacing shift
Date: Wed,  4 Nov 2026 12:27:56 +1100
Message-ID: <20261104012756.510424-8-lachlan.hodges@morsemicro.com>
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

We currently override tx_sk_pacing_shift to 3 and while in theory
that would make sense given the much longer transmission times of
S1G, our driver wrongly has large intermediate SW queues that are
invisible to CoDel.

A lower pacing shift allows more frames to be queued locally. At low
bandwidths and rates (e.g. 2 MHz MCS2) these fill the driver's internal
SW queues, so the driver stops pulling from mac80211 and frames wait in
the TXQ longer than the 20 ms CoDel target. CoDel then drops them,
causing retransmits and throughput dips.

While reverting to the mac80211 default does not fix this problem
entirely (as fundamentally we should not have such large queues in
SW that CoDel is unaware of), it significantly increases reliability
at lower bandwidths and MCS values.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 6df06b535319..d6ef7fee67e9 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -48,9 +48,6 @@
 /* Max rate attempts */
 #define MM81X_HW_MAX_RATE_TRIES (1)
 
-/* Max sk pacing shift */
-#define MM81X_HW_TX_SK_PACING_SHIFT (3)
-
 /* NSS/MCS map values */
 #define MM81X_NSS_MCS_BYTE_0 0xfe /* 1SS */
 #define MM81X_NSS_MCS_BYTE_1 0x00
@@ -2394,7 +2391,6 @@ static void mm81x_mac_config_hw(struct mm81x *mors)
 	hw->max_rates = MM81X_HW_MAX_RATES;
 	hw->max_report_rates = MM81X_HW_MAX_REPORT_RATES;
 	hw->max_rate_tries = MM81X_HW_MAX_RATE_TRIES;
-	hw->tx_sk_pacing_shift = MM81X_HW_TX_SK_PACING_SHIFT;
 	hw->vif_data_size = sizeof(struct mm81x_vif);
 	hw->sta_data_size = sizeof(struct mm81x_sta);
 	hw->extra_tx_headroom =
-- 
2.43.0

