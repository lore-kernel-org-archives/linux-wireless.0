Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755704;
	b=WAYWyHAiMgKtbkQCeN5wCEKGtNCbFK56fnyCDU7WZucniEb7q9ShR7MbFKY6lTTV+x9z
	 bV31BxymlabFdAToDv4ypah2/vuM+VZLw2Osmdq5Q8rO3BPTe2snzrwPUmuyX6krFfvXJ
	 4XHZx+sQpYOoARTVvCcalV6019bgRA9tER4tvuNkZnKRg1qMCBMO/PSuW14DpN6vSa0eh
	 X+eybT0I2wDWaMzDkcvTl5eb8SYxZ7LBiNZ7q6vl+JG5iq1xMnYSdpwjFi4xNcH7yYfCs
	 ae/OCCSOk4NvFfeVyxOgoinUmHmKO6mShWoebyAPf4e0UDEgD/zmlVJoqkIE5eap7uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755704;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQqdjkJhp/eG4FeKb92HMXECBcgkqjYmnYQd0OcpF38=;
	b=iMlNVCQr7DeLlWGd6a2OwyEoy4gRNqZ5J5WiNY0T8gCnE+XNsPISz28A3kqT7eJ1J3Nu
	 Rf2uNwnRg8iDOKE03b0/kqO4G3715kWi3LuD2fRr5UYv+OD0R4h75MrgyJQqnlMTVhqlP
	 ulkOxinQuVXlv/hJd3WQpvI8Ni5Jpbol0UGGeLNNIvPFy8Jxyy2aRt8pO7X8c1LBaf9kk
	 cNze0TR9W7X2oWS6iQVRu4suhd8GooYQDbKIB/zLfSNBGMVkQ7b3NB7ArtLSI/zb+ld7L
	 /6TU7MLtUygbT8ZWb7FZI/L+XPJYq7bNnFN0x5Yr2YzLrOwbErdQ/SFAkMblpZgIp/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=UJmpLgJv;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DC8606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10DC8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=UJmpLgJv
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a089dfee18so695291b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793755703; x=1794360503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AQqdjkJhp/eG4FeKb92HMXECBcgkqjYmnYQd0OcpF38=;
        b=UJmpLgJvO7G3XXfgB5OWscPcfAk686TxnQxf0hjbbLXBsXUlMTxe0RFTKHPYOgWow6
         R3r2Y5UPYSnSJzvvv0dZ8fvSewh0WTzuKlZifxPNlyczW8auBlUYXb77SB4hoY8mFK9t
         ZOeDNsbwpyR0hHkC3YavINsl5AsyHKhXqvKarf9D0MSYX6rwtXI9D3vyQ/7AU6gp3WFl
         d6St8MOBtn1ORjiAds0ie+FgsfsFu1hIQwEwoRx34CJS67JqnY6zngWxt3Jy+ecFMzRb
         V1o+GsdkcNTKtt2GFoukjEL46sAsUFRZwFvYz9YUdisr5gp8S5+21IpZ9HgOYyMLfiaN
         v4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793755703; x=1794360503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AQqdjkJhp/eG4FeKb92HMXECBcgkqjYmnYQd0OcpF38=;
        b=Xp4xhqNJKCvuwOvXYq14Jochkd8+aWKZXdXrKq7EqDDcCHVCHr43LWZ2+k0RGk1FMu
         OFY5cpyOlv2aSiVVc6uacW6bMppYErfJWrKspF3QS0+dxuFXruPgtqhIah5RTe0vCs1d
         yRk6jxHVmXu6BPRxEH5Ep7RITAsXBMXip17hOEtCosJffHCyK13cGsySvj/wjY5BGweT
         Fge/j8d2iBoBRCvvMKiQ1/A0WvY38ArMrwB2sl+F6GYrqlEX4SJzEc9aJsAHlfAO5RmK
         3WsFrs8BUF2q1VlC13ApfQg7ipKP9yictzaKzKIe4/AhvtLKlK30acl12tt0LsziKmda
         fg3Q==
X-Forwarded-Encrypted: i=1; AKwUvBy8kNMUcWMLUyHY4SZPaZZPbecDfQd1XyeFXhhf8WnDJJ06v/Z8XVFfb1t45bYCBSp/dM71DBSstQYDCsyfPQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z96YDxTziZg6V2IrYtyUQurPWozWNkClXZmpXqkVz02GWAgMs//
	MnrXg0dNLGTArWPSYS5A4RmTY/4UBL273vEoIHT2rmzm+ZUhod1QjOCIqtlA+cqN+TY=
X-Gm-Gg: AYBFou07DDHu21sflJIWzJyKL8JJrBOtaV31himsS01PB3X0lLvKPX3WACNdyvU9AhA
	glBMKr/IMHZmbzdeXSzNmv40bEFNBhURqBsaBkloY+lFLCeRUVxl4ht66gaxi1Ou5KQGtC29QgK
	wyUvxupsEsfsX9ukjqn9n+RYr6NCSOxiMvoAqdrWg20mFiOs4ZGeDQ4R9N4DSCF8ejw57z3wdZ9
	t7cuyAw4iU9/65CYN2erEfPI5D13modeNoAzksEGusJ1wbBKKf3bsXhI1UOdWNWeDK38mZwLxA3
	v+k/kg0VkKIrm32XOX8Df5T+9Iq06DZM4YQgJhwVLnagLdLuHwaj3PvIhYJPPmg/gJ5jARSxzOG
	ScbQ9xJ9BvgQ8BQuEehZAfyj5YeBneBvtN97ix7cZgs6NXmvbzam2vu9CsTNLp8BPnrK8sGHO5e
	gNdeJ9HF395whwiyq5lqacmPtJYCCAFdAxkywaUwHCuxpqpNBJfvr5ulguioGpqbD9mIPYsUm2Y
	qJ4yOGFqVZe/tWSaM/QxUNWhmCV3dreqiuKRCBUFdsr0VNh9kaRbHfYoXVQ/8ioL5u8edb5y7Cm
	XTamZxlSYI8oHRyrTOb2pS3URk6W2dWJJal8lpslpWyMirVExa8VuLvr964K5slcGkgR6zddBMX
	IStb/U6SBTfunhsEdqU+HPAhTXTRyDhEI2o08CyGBbRYu99Q=
X-Received: by 2002:a05:6a21:328c:b0:3e2:2b6c:2e7 with SMTP id adf61e73a8af0-3e913bbc026mr14318956637.28.1793755703399;
        Tue, 03 Nov 2026 17:28:23 -0800 (PST)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb469814b4sm300794a12.26.2026.11.03.17.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:28:22 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org,
	Nev Young <neville.young@morsemicro.com>
Subject: [PATCH wireless-next 5/7] wifi: mm81x: mmrc: precompute lookaround candidates once per cycle
Date: Wed,  4 Nov 2026 12:27:54 +1100
Message-ID: <20261104012756.510424-6-lachlan.hodges@morsemicro.com>
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

Choosing a lookaround rate is very inefficient. For every packet that
can use a sample rate, a random rate table index is picked and checked
for whether that rate can be sampled. The same index can be picked
repeatedly, so this sometimes takes hundreds of iterations even though
there are at most about 66 different rates.

Instead, scan all possible rates once per rate cycle (not per packet)
and build a list of up to 10 candidate lookaround rates. Then, when it
comes time to use a sample rate, use a random index to select one of
the candidate rates.

Signed-off-by: Nev Young <neville.young@morsemicro.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.c | 163 +++++++++----------
 drivers/net/wireless/morsemicro/mm81x/mmrc.h |   7 +
 2 files changed, 80 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.c b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
index bad4fec03d86..410b3368f05e 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (c) 2017-2026 Morse Micro
  */
+#include <linux/array_size.h>
 #include <linux/bitops.h>
 
 #include "mmrc.h"
@@ -45,13 +46,6 @@
  */
 #define LOOKAROUND_RATE_ATTEMPTS 4
 
-/*
- * Limit the number of times we try to pick a theoretically better rate to
- * sample. Necessary so we don't stall the CPU, due to constantly picking worse
- * rates.
- */
-#define LOOKAROUND_FAIL_MAX 200
-
 /*
  * Initial and reset probability per rate in the table
  * Changing this value will have a severe implication on the current heuristic
@@ -434,7 +428,9 @@ static u32 calculate_throughput(struct mmrc_table *tb, u8 index)
 	 * precision as the throughput is already multiplied by 1000 in
 	 * mmrc_calculate_theoretical_throughput (returned as bits/sec)
 	 */
-	if (tb->table[rate.index].prob < 10)
+	if (tb->table[rate.index].evidence == 0)
+		return mmrc_calculate_theoretical_throughput(rate);
+	else if (tb->table[rate.index].prob < 10)
 		return 0;
 	else if (rate.index == tb->best_tp.index && tb->interference_likely)
 		/*
@@ -542,6 +538,46 @@ static void mmrc_fill_retry_rates(struct mmrc_table *tb)
 	}
 }
 
+/*
+ * Fills out the array of candidate lookaround rates for the next rate period
+ */
+static void generate_lookaround_candidates(struct mmrc_table *tb, u32 best_tp)
+{
+	struct mmrc_rate rate;
+	u32 rate_tp;
+	u16 i;
+
+	tb->num_lookaround_candidates = 0;
+
+	for (i = 0; i < rows_from_sta_caps(&tb->caps); i++) {
+		rate = get_rate_row(tb, i);
+		if (!validate_rate(tb, &rate))
+			continue;
+
+		/*
+		 * Sample rates that are no more than one MCS or one bandwidth
+		 * level higher and don't increase both at once. It will avoid
+		 * sampling rates which have very low success. In case of
+		 * better environment conditions MMRC will collect enough
+		 * statistics to climb up the rates one by one.
+		 */
+		if (rate.rate > tb->best_tp.rate + 1 ||
+		    rate.bw > tb->best_tp.bw + 1 ||
+		    (rate.rate > tb->best_tp.rate && rate.bw > tb->best_tp.bw))
+			continue;
+
+		rate_tp = calculate_throughput(tb, rate.index);
+		if (rate_tp <= best_tp)
+			continue;
+
+		tb->lookaround_candidates[tb->num_lookaround_candidates++] =
+			rate;
+		if (tb->num_lookaround_candidates >=
+		    ARRAY_SIZE(tb->lookaround_candidates))
+			break;
+	}
+}
+
 /*
  * Updates the mmrc_table with the appropriate rate priority based on the
  * latest update statistics
@@ -606,16 +642,22 @@ static void generate_table_priority(struct mmrc_table *tb, u32 new_stats)
 			last_nonzero_prob = tmp.index;
 	}
 
+	/* The best rate needs to be updated before selecting lookaround rates */
+	if (new_stats) {
+		tb->best_tp = get_rate_row(tb, best_row);
+		if (best_tp == 0 && tb->best_tp.rate > MMRC_MCS0) {
+			/* Drop one rate, as the best throughput is zero */
+			tb->best_tp.rate--;
+			rate_update_index(tb, &tb->best_tp);
+		}
+	}
+
+	generate_lookaround_candidates(tb, best_tp);
+
 	/* Only update rates and stability when there are new statistics */
 	if (!new_stats)
 		return;
 
-	tb->best_tp = get_rate_row(tb, best_row);
-	if (best_tp == 0 && tb->best_tp.rate > MMRC_MCS0) {
-		/* Drop one rate, as the best throughput is zero */
-		tb->best_tp.rate--;
-		rate_update_index(tb, &tb->best_tp);
-	}
 	tb->second_tp = get_rate_row(tb, second_best_row);
 	mmrc_fill_retry_rates(tb);
 
@@ -784,17 +826,13 @@ void mmrc_get_rates(struct mmrc_table *tb, struct mmrc_rate_table *out,
 		    size_t size)
 {
 	u8 i;
-	u16 random_index;
 	struct mmrc_rate random;
 	struct mmrc_rate lookaround0 = tb->best_tp;
 	struct mmrc_rate lookaround1 = tb->second_tp;
 	bool is_lookaround;
 	int lookaround_index = -1;
-	int best_index = 0;
-	int random_tp = 0;
-	int best_tp;
-	int lookaround_fail_count;
-	bool try_current_lookaround = false;
+	u16 best_index = 0;
+	u32 candidate_index;
 
 	s32 rem_time = RATE_WINDOW_MICROSECONDS;
 
@@ -810,10 +848,6 @@ void mmrc_get_rates(struct mmrc_table *tb, struct mmrc_rate_table *out,
 			 ((tb->last_lookaround_cycle +
 			   LOOKAROUND_MAX_RC_CYCLES) <= tb->cycle_cnt));
 
-	/* Also skip sampling if we don't yet have data for our best rate */
-	if (tb->table[tb->best_tp.index].evidence == 0)
-		is_lookaround = false;
-
 	if (tb->lookaround_wrap != LOOKAROUND_RATE_STABLE) {
 		if (tb->stability_cnt >= tb->stability_cnt_threshold) {
 			tb->lookaround_wrap = LOOKAROUND_RATE_STABLE;
@@ -829,80 +863,24 @@ void mmrc_get_rates(struct mmrc_table *tb, struct mmrc_rate_table *out,
 	}
 
 	/* Look around only when the fixed rate is not set */
-	if (is_lookaround) {
+	if (is_lookaround && tb->num_lookaround_candidates > 0) {
 		tb->total_lookaround++;
 		tb->forced_lookaround =
 			(tb->forced_lookaround + 1) % LOOKAROUND_RATE_NORMAL;
 		tb->last_lookaround_cycle = tb->cycle_cnt;
 
 		if (tb->current_lookaround_rate_attempts <
-		    LOOKAROUND_RATE_ATTEMPTS)
-			try_current_lookaround = true;
-
-		best_tp = calculate_throughput(tb, tb->best_tp.index);
-
-		for (lookaround_fail_count = 0;
-		     lookaround_fail_count < LOOKAROUND_FAIL_MAX;
-		     lookaround_fail_count++) {
-			if (try_current_lookaround) {
-				random_index =
-					tb->current_lookaround_rate_index;
-				try_current_lookaround = false;
-			} else {
-				random_index = get_random_u32_below(
-					rows_from_sta_caps(&tb->caps));
-			}
-			random = get_rate_row(tb, random_index);
-
-			if (!validate_rate(tb, &random))
-				continue;
-
-			if (random.rate == MMRC_MCS10)
-				continue;
-
-			if (tb->table[random_index].evidence > 0)
-				random_tp =
-					calculate_throughput(tb, random_index);
-			else
-				random_tp =
-					mmrc_calculate_theoretical_throughput(
-						random);
-
-			/*
-			 * Skip rates that can only be worse than the current
-			 * best
-			 */
-			if (random_tp <= best_tp)
-				continue;
-
-			/*
-			 * Force looking up the rate no more that one MCS.
-			 * It will avoid looking for rates with very low
-			 * success rate. In case of better environment
-			 * conditions MMRC will collect enough statistics to
-			 * climb up the rates one by one.
-			 */
-			if (random.rate > tb->best_tp.rate + 1 ||
-			    random.bw > tb->best_tp.bw + 1 ||
-			    (random.rate > tb->best_tp.rate &&
-			     random.bw > tb->best_tp.bw))
-				continue;
-
-			if (tb->current_lookaround_rate_index == random_index) {
-				tb->current_lookaround_rate_attempts++;
-			} else {
-				tb->current_lookaround_rate_attempts = 0;
-				tb->current_lookaround_rate_index =
-					random_index;
-			}
-
-			break;
+		    LOOKAROUND_RATE_ATTEMPTS) {
+			random = get_rate_row(tb,
+					      tb->current_lookaround_rate_index);
+		} else {
+			candidate_index = get_random_u32_below(
+				tb->num_lookaround_candidates);
+			random = tb->lookaround_candidates[candidate_index];
+			tb->current_lookaround_rate_index = random.index;
 		}
 
-		if (lookaround_fail_count >= LOOKAROUND_FAIL_MAX) {
-			is_lookaround = false;
-			tb->current_lookaround_rate_index = tb->best_tp.index;
-		} else {
+		if (validate_rate(tb, &random)) {
 			lookaround0 = random;
 			lookaround1 = tb->best_tp;
 			lookaround_index = 0;
@@ -910,6 +888,10 @@ void mmrc_get_rates(struct mmrc_table *tb, struct mmrc_rate_table *out,
 		}
 	}
 
+	/* No usable lookaround rate, send the normal rate table */
+	if (lookaround_index < 0)
+		is_lookaround = false;
+
 	if (tb->caps.max_rates == 1) {
 		out->rates[0] = (is_lookaround) ? lookaround0 : tb->best_tp;
 		out->rates[1].rate = MMRC_MCS_UNUSED;
@@ -1315,6 +1297,7 @@ void mmrc_sta_init(struct mmrc_table *tb, struct mmrc_sta_capabilities *caps,
 	tb->last_lookaround_cycle = 0;
 	tb->lookaround_cnt = 0;
 	tb->lookaround_wrap = LOOKAROUND_RATE_INIT;
+	tb->num_lookaround_candidates = 0;
 	tb->unconverged = true;
 	tb->newly_unconverged = true;
 	tb->stability_cnt_threshold = STABILITY_CNT_THRESHOLD_INIT;
diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.h b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
index f6106384b1ea..75b151196990 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mmrc.h
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
@@ -25,6 +25,9 @@
 /* The frequency of MMRC stat table updates */
 #define MMRC_UPDATE_FREQUENCY_MS 100
 
+/* The maximum number of lookaround candidates */
+#define MMRC_MAX_LOOKAROUND_CANDIDATES 10
+
 enum mmrc_flags {
 	MMRC_FLAGS_CTS_RTS,
 };
@@ -171,6 +174,10 @@ struct mmrc_table {
 	 */
 	s32 best_rate_cycle_count;
 
+	/* Candidate lookaround rates, regenerated every update cycle */
+	struct mmrc_rate lookaround_candidates[MMRC_MAX_LOOKAROUND_CANDIDATES];
+	u32 num_lookaround_candidates;
+
 	/*
 	 * The probability table for the STA. This MUST always be the last
 	 * element in the struct.
-- 
2.43.0

