Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF1F3AA9EF
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788939103; cv=none; b=j0PtQofgVEUyQaVMqQJ85ocl6eiMYNVxMHWvcexk4azWiOcMMyEy5GhOvF+EdHGLfpD3mibVX8KFIbPloh/oPJo7SSfk3XzYS8giHOLZ6rrZu+UF5EYkmdB9NANBN8Y+iQ0BlH5WUhkDzJCvR8AzVJZgE4+65rKtNMQQ0MfEO14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788939103; c=relaxed/simple;
	bh=Vk0dgqm3pJ0clBYZ0cTT7Lcs6abLw7gUXU8l0AjBxzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAZylmywxfw+Tst7xCNoO8ZKGFdhbLi919EeUAxBgBjKn8169reesXa+KA97K3yYcgz3xtDmXi5FGlOgw0b+UTwP4snzd4ovyKwOEk4yxgYO+X3k4MVvys9sZiL+sOg3fejBjrWoFrp4FuO5XsV8eWcSNZOHOS+X4dnNhoKewp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=papDljJF; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="papDljJF"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so4248332a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 00:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788939101; x=1789543901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r51GNvtVwRR51Qq/5au5KCaM9QHirsPfOx9FsHjs7+8=;
        b=papDljJFVtoPHED5tjeDkob7Uvqrxj6419PNVx+vcZ8mXzf9z4GyVPOzzvxeSlfErc
         EurV6Sj2RuhxihzLHHppZjYfDa37oD9+c0cw6ZxklyTTxN6S79qYHVOefJ9oJ+8AuK3j
         3CotghqXHMi73YHYOhwYogc8XyHW8JJLsCp7LIZeHpls3zmFBwZ64T1tEf+06UKXCAdG
         cZ9pgZq3bqJg2ajmgK0AeQKF+fxXSepSw9lH880GoZUYvg9qVU2inJIJdPYQbEId7jRQ
         xQjd0uXkSFPhBjKV6Z2999UgFRbWxLjNWmGmN+eWlPr7+LAmyPsUwNnwINPsXAQ2uygH
         xkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788939101; x=1789543901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r51GNvtVwRR51Qq/5au5KCaM9QHirsPfOx9FsHjs7+8=;
        b=K+Ks2P3tKn3kT8UjW1GTRSz9kZTLZNYqvbac+o98R9SBJ8/1yuWzt5GLwt8YHEe88Y
         WcDVN0ZaFDlEvF/ITMAVYFsVB/ED2NSTOes+XrI6nKR1j5QzXfueFFHr2Bmwt7iwem9u
         CeGyT8RuSAkUcsA7IUZWOgTQSCAH5eI4CWatdY+3hbrkMA/VERSAw4hSK09Bq4CWFoQE
         CBI1YsJ1Qwtx4lqIvkx1yIZldGZswsjp6JVX19iEFlpHVjaPM+176Z8l71DhrSbrL3jP
         cTQFJyrA/Q7JgEvonrxi26qJ+gIqg+e7foxCR7ZR/mw0fxfcCEbswcDXEOhTFDk90ahH
         6cYA==
X-Gm-Message-State: AFuF++mW8xhToeRsVwYtMpH9SNstmCmmCxsT1z5iTcqLgy6Ze4imo+va
	ajiqshpbJsTFrqTULn1c+AN5sdKmeZ7H5zHRx3nv+6DYr6R6Zh1cCycmPaFla2WhGF4=
X-Gm-Gg: AYBFou0XYzB10vdQuOIFikNYS4ARAC6r0OFvz7ZktwFkfdkDdnaY71vS4QrGw8rkBLP
	6Qt2HQkVABTsIF9sp4eEVNEz6vSvmx2RuiuZnGdU/7wV6GF86RFJ6k8QyOGY/TTYBvoGkr67f/T
	UAGOp2sPylnHvEjVkoyQk7uOmV0UEoRMNk+YXlsZAWroaDvZjATEXlTaAdAM8aqnVyBjPDA5FVw
	HP0Pp0PYz9WFJ4Ormms1SlS9LiSqhz4NKbgEhizYiBdrt61ptaNdAfK7I8qElsKKexN2popi9zK
	Gyft6irdsaTLtKISv4Tja7YIq9ITgkjyKSgyZZwYUB8F1sCP30HSGxSNb7lCcDk7mEC1VTUNqt1
	AbTOr48qucGaUGaEi6KZV/uT6RP9cM84Ze2ZMJN0SkpxB/tOQhAOgY4r8I1AdeFakCyKx3d8Z8i
	iiDB2zxRNg0rAv+kIh1wpdo+A2R7aEOS7PYcBZIeXQMAsmSJzIOYGhGp2ICT78dLe3ZU9g/y1c+
	37YZ3kgtxB1FnW5QAC8mkIulRQOCbncjWACTBepw3T9RVZDX6JkBZ4zx6gauqsE1xX6Gu3s6rgr
	8BI=
X-Received: by 2002:a17:90b:1c8b:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39b26214502mr46925124a91.19.1788939101258;
        Wed, 09 Sep 2026 00:31:41 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2615039asm30891776a91.15.2026.09.09.00.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:31:37 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: report 900MHz channel for S1G band radiotap header
Date: Wed,  9 Sep 2026 17:30:14 +1000
Message-ID: <20260909073014.53344-3-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>
References: <20260909073014.53344-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently S1G frames are reported as 2GHz spectrum, use the 900MHz
channel flag instead.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e26be8e27d8..edb53e5b4462 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -452,6 +452,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->band == NL80211_BAND_5GHZ ||
 	    status->band == NL80211_BAND_6GHZ)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
+	else if (status->band == NL80211_BAND_S1GHZ)
+		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_900MHZ;
 	else if (status->encoding != RX_ENC_LEGACY)
 		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
 	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
-- 
2.43.0

