Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185421A5B8A
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809822; cv=none; b=fyuVbop8wCasEmaieQ/+3MFoUMoyjyqC+7OB6tMyU9fc+PFbYsm2h3i/XW6vhgh7GOkxAFnlRQX0o6oJvH66kB8tNaHgOYLFJSKhJPSy7WrWZgydMu7SvKLa7aGxvUnvmMK73b4AsYGAeAL0mzUienyV+FPhOgO0ymBWqbGFyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809822; c=relaxed/simple;
	bh=glo7ODYClZcjNMDxZa93dsuZVgLLjoaNbtXFfPESXHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yg6BcOBKS72qfXtpXzAD6v2jdbQJPPLtdKrj99EwkfbvpWQGK81mP6x8dLIDgmehvcT+s0CDFdIt0Qfus6g7TG1r4HjOEm+xvCaTj7fjwcz5Cxp9gWoP46XOsUKHgty2YvjmtmKf1nmfQNp8knAKoVwB9/j3jnCieAxtUymc6kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=JDcRDgLd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="JDcRDgLd"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso226975b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809820; x=1788414620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YjEtESSJVXYg+8nTWINYoD/xP4gt7h+ZV0dapPP//fw=;
        b=JDcRDgLdWkKI4y+DtYWfgYle+d/WAQS0gpyYLA7QsyZxxOnQsfwHAvUHA5fmmunn5Z
         M03xSdYPF6Y6APYcNOgJVnOMZXtW+/lv/9MasRdjzS/RYfcR2aHtxNyi8oXLX77luuo4
         IZouy9TWlA5tVVb/KWLFitQjyO/f9Y7DnhT5LCPVe1KIgmPUh94ZvIyOq/rPU0LKZqHx
         JDQyEW+rZ9kq1zd+5GfRBzEjwlHlcJBLX0+kl9c0aCspMrvOMvcYdJsAn7nB3RJty9Nq
         +Y7J/e0wK0cvw0qi0BVvcMDNRQ2ylQwmnTJboK/fwj/Hqsm+Pbym8DTDT7Opnsn2fMug
         oFjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809820; x=1788414620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YjEtESSJVXYg+8nTWINYoD/xP4gt7h+ZV0dapPP//fw=;
        b=rKyYPhir6kIpJ3GBPRVuXs5e1Egn+9spIhwJaTvMecWwBI/VdugxwswVd16pZfir7V
         BjLo2Cw9i8iFK6Ap7QHs1Y/ZzPdsPOkwIga+yUV6DxiJcUgI/8jwJ/vF3pwu1u80tKEw
         GN8C5qCG6qcAorXZKON1t6Em+BKS6osEPe8u6XeXLnF0SVl0yZcC6Nz2zH2pL3tHf4bE
         iXx84FSCrraut8umoj/2wzHtBxPuxYdSP3zc0cZ7OcqENLcHgkpmZtIRmTUnvJzEWP+K
         a83fT+E/D2Rcf0dVVbKVUpOUeYc3umJQG2rKwEMxVtEtJdwxlEfPtQnkPvdh0ANcvBgY
         Lncg==
X-Gm-Message-State: AFuF++l82Bzr7K4xbdNfOEa8wqmbuQBOgRt9+b9eijCq9pO45kHIshYM
	ZDranK9S/dBP1H0RBvTlolUgMLcxLp2H5QSfWGWgeeKsBwY4zF04aVkHEeBatNuXsIU=
X-Gm-Gg: AR+sD13I04sr1aSov3FwzETt1DyfESXoklgDv5O93BMobvQNcOnbgO0SReIC5C8E+v5
	ErJ9mDEG0rXoVVe3W4gclFFSp1zq3HhbpiXlniRY6nUmBLASzsQ7mWISbrsaRXe1gz1GuJl8w6i
	5jakpIDKJXeVfeFLSEaNSKorq5FxY9a4pqYbt3hgWl0Wovbr8IT4WRMmX8KeyFPT1fO1Sl91KOY
	M06MEpqmU3NHLZYOOwSM5OWh+WsAubVpoJVEgm6ptiokSq5qS05w7l+MpJGQPXKIi9R9j+VO7hZ
	9u67FzoUMTfk1Pu2jysmqGiCpf0YmFEb1yYBMlAL/iPNDdF0K68KZGZ0ORHYsRfQ9JMz0n4dMC7
	DCjwVgDyaWRxrbmd2+7zt+irfIpA3r9kTKOk7jKBc3nqb2ncV0qQN14vN/zlpbJTXB4Ua6dcZxN
	rNhAp9GHHyjP0D1L+v7DSLQ5EUcZmJZPlhT9kHslHI04oAOFYac2eE/LLU3c3YiZ71cTnYXb32C
	eQ5mov8llhfspegAd6RrlxGCBTNZ+kUYGBo/x6Npx6SoFGC0lCnuZ94BCn2CdZCxgFHM3ttnONN
	rQL+5HsjHR0=
X-Received: by 2002:a05:6a21:4596:b0:3d0:cc29:ff63 with SMTP id adf61e73a8af0-3d0cc2a04a0mr13928450637.12.1787809820498;
        Wed, 26 Aug 2026 22:50:20 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:20 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 4/8] wifi: mm81x: implement .tx_frames_pending() mac op
Date: Thu, 27 Aug 2026 15:49:13 +1000
Message-ID: <20260827054917.255584-5-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
References: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement .tx_frames_pending() to assist mac80211 when deciding whether
we should enter powersave such that we don't enter when there are
pending tx frames.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index 0bbedcdd0b3d..5bae7c6251df 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -2035,6 +2035,13 @@ static void mm81x_mac_ops_flush(struct ieee80211_hw *hw,
 		mm81x_mac_wait_queues(mors);
 }
 
+static bool mm81x_mac_ops_tx_frames_pending(struct ieee80211_hw *hw)
+{
+	struct mm81x *mors = hw->priv;
+
+	return mm81x_mac_has_tx_pending(mors);
+}
+
 static int mm81x_mac_ops_set_rts_threshold(struct ieee80211_hw *hw,
 					   int radio_idx, u32 value)
 {
@@ -2260,6 +2267,7 @@ static const struct ieee80211_ops mm81x_ops = {
 	.configure_filter = mm81x_mac_ops_configure_filter,
 	.sta_state = mm81x_mac_ops_sta_state,
 	.flush = mm81x_mac_ops_flush,
+	.tx_frames_pending = mm81x_mac_ops_tx_frames_pending,
 	.set_frag_threshold = mm81x_mac_set_frag_threshold,
 	.set_rts_threshold = mm81x_mac_ops_set_rts_threshold,
 	.sta_statistics = mm81x_mac_ops_sta_statistics,
-- 
2.43.0

