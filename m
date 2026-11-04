Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755695;
	b=5qa4/wksi5I/a1iLu5xbndZT8l2wZu/8/7KO23D5xzhsR+O/lYei/J1r5/STSrJp7M5t
	 Gi2VOASAkpdUQ9g2er/mSGtYkNFUwVZ22mePz1udHDzcI2950m0NPFte58CQeRvnBshIc
	 SM4cPLR+H4i9StQ/ZscMumDbLKw/3INhs0jZTVghJHyARBqO5Vp4RzLUdK3OHmvITuZaf
	 S8C8QIa9rkXeGiXHO3Htw2unWm1WeboBko+Ku4WCoOeL0zZlo++OHVg33Fbkn0M35xz6y
	 2LMa3xxbvzcUbhLcNP5o9zh3R8wKHpSExfeOyFGX+wr8sq/Plyfg9PKjdBLsulKbRFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755695;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tu7JNDGi5iw89BTtRDC1OGkscf8qRs9hJIzv+IbdBVc=;
	b=gxHvVQuUqoidXlFhlHyc49f7l8ZVBSv/45hPVNPBaVw68AeV52eSNe9sOBG+K5R7f2PU
	 ReTJF617xJthSnMYzj9KChIQMXAuyz1WWC04t6WaCNTtqXQW7KCEU1Cjfl3MJFSleWvOV
	 CxY4dM7hMPjIGpo09/lWNKB14H/Jt0eAf8OF80wsSEfsX0aV49vroSV217KY7rjK/uKm1
	 Ub2IHWfOS4T3EKCF4vi/xek70pFqyCACUk4MpoKiQsU5Qnxo30anDbM6B4WGAUke71p/p
	 eYqKXaCUGedMMItCoIFk5mWCs2fo1SKvt3qU2osQph5D7T9c+yEqjyp1fWjgJMp9p+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tLWrXpWc;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B2606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 113B2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tLWrXpWc
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a9f9473029so174958b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755694; x=1794360494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tu7JNDGi5iw89BTtRDC1OGkscf8qRs9hJIzv+IbdBVc=;
        b=tLWrXpWcouMlfsYv+T6RakaKHvV4QVuLCRFU2Yz83zgTHWa12KDYsexa/NfLXuJkSA
         07n1A5m+VpxZxFk4wm+4amyfFfzDV+NfttHXcbi9C1MwwjvjvhR6uOC3Bx1B9wuJn5Hj
         hxHwhRBqCDSAXRRuBxFcwvDMs059rKrUUZimqay7KLOPFRWjTkPXjbYoBGo5fcO5HPOn
         RPjpoxR3vUH21OgbZwYSqTzUgYCbrljSg4BFcm0+1/FE6ZTm8mGLJJVbKy0DLbrAL7Wr
         orKlTS8CiAzM7c4tulRaqGyCGLjhQMtMMkjRAa44HH7KMM/JTANnR3EXNSdpHKIJ82gn
         MMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755694; x=1794360494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tu7JNDGi5iw89BTtRDC1OGkscf8qRs9hJIzv+IbdBVc=;
        b=woGxgOMhWVft4i64c89q0u3e3sJnZX7aLcUZ3os5o6+pyedhtS2LNsQG6NidQSUs7a
         /iv3zROV+Alft2VpTZkS93UrWafV7sS/hEME/s/WPkHYZaavVy7aWubPrfXbX5fZOWrN
         U2mweZY4Hp7Di71BKhZp61WWxUf2gCaFAd+z0PrPdnYgpgO3pXjreB2HHMwi+2YBwC4i
         oiETX+ETl6Uh+QMe5ZQ6r425kdqoi5ouC4PSs9WQisYjCQL9pFAcbe6TbFXAXTVJOH/a
         aa7xSa+vVaf4rhpOfKAdKEbto7vPOVDjTHvAjUC00B/bOf+w3dBrBcJ3RyMINCov+SuE
         PNmw==
X-Forwarded-Encrypted: i=1; AKwUvBwG5Rn57HSNY5kxJL/Bbu82EAsLmlyYWZxI55knthgAixvnQ5qxvP5IcAXKpzNwDiamzSpPQCeHD4XG1qu09A==@vger.kernel.org
X-Gm-Message-State: APuU4Z8RNt5ULObcIP3EoVGw8dWhp5O1gmrRNOSN+l4vuOpNjyrSmV0n
	CJmtAS+HpmM2L4ZN3RzNYGVjLPECH8C6EM9g+LmNGyIQeTZ1JNe0cAPCdF6PNXjeirI=
X-Gm-Gg: AYBFou3rn8obMtYuY3FoA3tg9cCWu90KkfAYfoxhpQqqYAbjpbNy1nv9sqQjSrvIvgb
	GUSDr/9befovinhuqCpYCihperf+Ui1BgyH2hiYZgrgFS1LAFSBaiTPWzgTUjeTzWPJN8DCdGel
	znlbe3F8RlZlvPiRuTfNQNbBdKfM7tXmYF3i8kQ5maDanB2hmUk7XMVxHTyHS6Um9kw9dENA/Ym
	TaVadV6r/H3DN9tNN2+8s91b0wsJrsM0Hbh40plHXZ1tWMg5PwfJT/Oq3s1osOc+OdADkwFYehb
	E23of/QfVjQct8ujt7iTnasqL31ciIcqcEdRWiqoOdV00FbLMqU+yMj82vzciU1OKOv0na9igkl
	ACLFE3JZCr5QxTBSNKx6sZnxtaSdOfkVLs0RgwpY9Sy6pkKDAvDAqYrzYkX22ktAS/BmoqpVqGF
	iWatDjS/2cYXTFWaUyXQZ5wWEBQDMzKvSpXVeSyESdlNFdtHNvs/ksFn9Bl6aS8JLLRTXA1ZdXk
	R2dHxGLUEfxCA131Xo5ChDg2oqR/Ee16W+MmGn1eBTrgxp6ljwW13vF0VHs5DLSJiDYjwifxyZK
	FdGjydRyEUtjoemAXnlTwYRkRQ6u7zCshVl+sJP/0+3+RyXohhiYHyIYsPxFUIxOzHWVCRJdmT+
	2GmD/tF40Vts7Hfn0+KBar2XfDl/4TsF5hn8xNF4TVGcV3ODC
X-Received: by 2002:a05:6a20:918f:b0:3e8:b7fd:6286 with SMTP id adf61e73a8af0-3e92898ebb7mr13348708637.34.1793755694464;
        Tue, 03 Nov 2026 17:28:14 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:14 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Sam Chapman <sam.chapman@morsemicro.com>
Subject: [PATCH wireless-next 2/7] wifi: mm81x: mmrc: don't credit failed frames as successes
Date: Wed,  4 Nov 2026 12:27:51 +1100
Message-ID: <20261104012756.510424-3-lachlan.hodges@morsemicro.com>
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

From: Sam Chapman <sam.chapman@morsemicro.com>

mmrc_feedback() walks the returned retry chain using the total attempt
count and unconditionally credits one success to the rate the walk ends
on. A frame that exhausted the whole chain without being acknowledged is
therefore recorded as a success on its final rate, inflating the success
probability of fallback rates and leads to misinformed future
rate selections.

To fix, make sure we only count a success if the frame was acked to
prevent failing rates from being picked when they shouldn't be.

Signed-off-by: Sam Chapman <sam.chapman@morsemicro.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 47 ++++++++++----------
 drivers/net/wireless/morsemicro/mm81x/mmrc.h |  2 +-
 drivers/net/wireless/morsemicro/mm81x/rc.c   | 14 +++---
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.c b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
index 6bedcdbcb61f..3f87b50ce391 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
@@ -1212,37 +1212,38 @@ void mmrc_update(struct mmrc_table *tb)
 }
 
 void mmrc_feedback(struct mmrc_table *tb, struct mmrc_rate_table *rates,
-		   s32 retry_count, bool was_aggregated)
+		   bool was_aggregated, bool was_acked)
 {
-	s32 ind = retry_count;
+	s32 last_index = -1;
 	u32 i;
 
+	/*
+	 * Every attempt reported by the firmware is accounted as sent. Only
+	 * the final attempt of an acknowledged frame counts as a success; a
+	 * frame that exhausted its retry chain must not credit the last rate.
+	 */
 	for (i = 0; i < MMRC_MAX_CHAIN_LENGTH; i++) {
+		if (!rates->rates[i].attempts)
+			break;
+
 		rate_update_index(tb, &rates->rates[i]);
 		tb->table[rates->rates[i].index].have_sent_ampdus |=
 			was_aggregated;
-
-		if ((s32)rates->rates[i].attempts < ind) {
-			ind = ind - rates->rates[i].attempts;
-			tb->table[rates->rates[i].index].sent +=
+		tb->table[rates->rates[i].index].sent +=
+			rates->rates[i].attempts;
+		if (was_aggregated)
+			tb->table[rates->rates[i].index].back_mpdu_failure +=
 				rates->rates[i].attempts;
-			if (was_aggregated) {
-				tb->table[rates->rates[i].index]
-					.back_mpdu_failure +=
-					rates->rates[i].attempts;
-			}
-		} else {
-			tb->table[rates->rates[i].index].sent += ind;
-			tb->table[rates->rates[i].index].sent_success += 1;
-			if (was_aggregated) {
-				tb->table[rates->rates[i].index]
-					.back_mpdu_success += 1;
-				tb->table[rates->rates[i].index]
-					.back_mpdu_failure +=
-					ind > 1 ? ind - 1 : 0;
-			}
-			return;
-		}
+		last_index = i;
+	}
+
+	if (last_index < 0 || !was_acked)
+		return;
+
+	tb->table[rates->rates[last_index].index].sent_success += 1;
+	if (was_aggregated) {
+		tb->table[rates->rates[last_index].index].back_mpdu_success += 1;
+		tb->table[rates->rates[last_index].index].back_mpdu_failure -= 1;
 	}
 }
 
diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.h b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
index a4c7d941ad55..f4a90a50e4bf 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.h
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
@@ -184,7 +184,7 @@ size_t mmrc_memory_required_for_caps(struct mmrc_sta_capabilities *caps);
 void mmrc_get_rates(struct mmrc_table *tb, struct mmrc_rate_table *out,
 		    size_t size);
 void mmrc_feedback(struct mmrc_table *tb, struct mmrc_rate_table *rates,
-		   s32 retry_count, bool was_aggregated);
+		   bool was_aggregated, bool was_acked);
 void mmrc_update(struct mmrc_table *tb);
 bool mmrc_set_fixed_rate(struct mmrc_table *tb, struct mmrc_rate fixed_rate);
 u32 mmrc_calculate_theoretical_throughput(struct mmrc_rate rate);
diff --git a/drivers/net/wireless/morsemicro/mm81x/rc.c b/drivers/net/wireless/morsemicro/mm81x/rc.c
index 28dd293df966..c1a334f7846c 100644
--- a/drivers/net/wireless/morsemicro/mm81x/rc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/rc.c
@@ -341,8 +341,8 @@ void mm81x_rc_sta_fill_tx_rates(struct mm81x *mors,
 }
 
 static void mm81x_rc_sta_set_rates(struct mm81x *mors, struct mm81x_sta *msta,
-				   struct mmrc_rate_table *rates, int attempts,
-				   bool was_aggregated)
+				   struct mmrc_rate_table *rates,
+				   bool was_aggregated, bool was_acked)
 {
 	struct list_head *pos;
 
@@ -352,8 +352,8 @@ static void mm81x_rc_sta_set_rates(struct mm81x *mors, struct mm81x_sta *msta,
 			list_entry(pos, struct mm81x_rc_sta, list);
 
 		if (&msta->rc == mrc_sta) {
-			mmrc_feedback(msta->rc.tb, rates, attempts,
-				      was_aggregated);
+			mmrc_feedback(msta->rc.tb, rates, was_aggregated,
+				      was_acked);
 			break;
 		}
 	}
@@ -410,9 +410,11 @@ void mm81x_rc_sta_feedback_rates(struct mm81x *mors, struct sk_buff *skb,
 		msta->last_sta_tx_rate.guard = rates.rates[0].guard;
 	}
 
-	mm81x_rc_sta_set_rates(mors, msta, &rates, attempts,
+	mm81x_rc_sta_set_rates(mors, msta, &rates,
 			       !!(le32_to_cpu(tx_sts->flags) &
-				  MM81X_TX_STATUS_WAS_AGGREGATED));
+				  MM81X_TX_STATUS_WAS_AGGREGATED),
+			       !(le32_to_cpu(tx_sts->flags) &
+				 MM81X_TX_STATUS_FLAGS_NO_ACK));
 
 	ieee80211_sta_register_airtime(sta, tx_sts->tid, tx_airtime, 0);
 
-- 
2.43.0

