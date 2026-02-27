Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE976346E73
	for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2026 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772165617; cv=none; b=teJQzzmxQ6/yzI6KGACVKBWbinEzo8LteJZ9aC0/ENnT6ETY2xcs3dlDkEV04/K8SAgXh11Pui8245/Q/1Dmmwej4iV4T/Vr2JunyU7CjR4V7S/knGgjbyzAGdUh/Lgebe4y40I0xsRQhqx99cFx85/K+BIFh3YN02om94AoI4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772165617; c=relaxed/simple;
	bh=PJJU4pfTErqlN/HS7C/EsRWfJCHQXFF01zUnucBV794=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+/izQlyi8EwZ84vX+rNZ4pcFIzi+nv9Fws4Lp6yGA0LNTlGv3FLSvuBJ7CNgUj/Utp7Ty+HwmS5rJRLCrOybS3UhvffxDev0gNM5Uf0y02eap8zmjIOAC8+1kuGorZ95yag+GFg1qdpLpDt9EUbFl00KCa+a90y7HoPRg1N4P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b=gtiUBbMx; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b="gtiUBbMx"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2adcede372cso6602595ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2026 20:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20230601.gappssmtp.com; s=20230601; t=1772165615; x=1772770415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vps8/QEIPf/qcHcwOq/sK3G75sunFUbRWWjibdncsVA=;
        b=gtiUBbMxMiAO2dJCjK0HlWUOh6FrxwmdeinDC/3vxx40PSj+87ef/Enj3nKqT758Qd
         NyQv3Zj0exsJOa4xXpb96X+Z/jGrBR3rvHuGfUEjLxAZUlSDkzL61sR7Vv62kmkuA8GE
         FXzYFsbqHDgmdtEjruLrybgvWPfzpl81pNq3GAV116Nb+9qHrQCqR6M6UtDdfMsLotrP
         XvrUvAPHWvUNd7zMPXXdZkPdhbB8mOzPS1cFFc0m0ESa/2fV1VD+rtppjsdS4IxxEdom
         1mw5mhiBrM6LMLFuZBTECv9gdVACytNBM08xOC9gYkqYhlVgF6S5t+PKlz+QMSOa39vJ
         jkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772165615; x=1772770415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vps8/QEIPf/qcHcwOq/sK3G75sunFUbRWWjibdncsVA=;
        b=Z+uOvHAXOMToA6EACtoyn6EmyoRRnIBzORqfNg2XOA3NnUqt9M4wMj7rebc7JDo6q7
         OJxwKeH5azRbDqVey6g6w7bcFglr+Me5SVdbLeZKOCPCkcW8AFiyvRrJQvIUsJYqXEOy
         NM73PclffSwxZqrUkq7Ct7YLEhjIYcg1Cl+hFq8mpV6iVnpMWK7jfqbbi/FnQcW81LnU
         tLyCyAaA88emAjPADG8uwRS8lflP1m2MWg3ZK0z7/N7HHkAgvK6ey5i3Fd/34Ho6Dy5c
         +a8Kq4064D45fpnwKyCK60gJwP+NJMxgaAPOlU/1qqt6y2GovObPahfVodT0Rw7a18xH
         FkSw==
X-Forwarded-Encrypted: i=1; AJvYcCUNNtseNFjNJy75gzVOv99xCTF1v4ofOq9e9jINYasogtx/3EiKxaWf963MI/eLAJPtMahIy0IVrRfWNm5X1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKChOVF+WQ1AWRZ36iDMfDNYL+xBIZmL/Aq9sFFnkA68/SXvVN
	3Pyzz49goifbK7xKKhgqc6WM9djWIUnP90fpf1wc3o+cS4LuksbLfLXzSl+zbbbVGUY=
X-Gm-Gg: ATEYQzwX+pD+by79VTexpUkRUc5c7K721+YNl4+nFZZ1epr82IdUddc9B7iZjNeVSeZ
	7ajCTm/f2gbogkB6AQ4VdPDjthEvODA/k1ykdSz6I9xwhbZq/8k8djDcVD7cXhAfueHqdG+0wWJ
	t0C++7xA795KhW4A/diKGj0TVKSvzUsWcsgh5LUBuxA3uFdu5LiJ+rwDNnuhdS7I2RdS6NY8EyI
	Z3xuVIlR0hPhCpFjPDZQ/EFXtHCeNhmO53L43SnljD5nMmY+odnNZaqAe6IVqLsZPUbJpeNG2MI
	vby3aNDqMODo9uKXVBfOvH1nPaN0toOJYyTKhctqC4Se2cRuELV1BFU5GAU+CAaBW4go+8jPkXJ
	jpPbIE/Cd0nnFvY1UX7Uypm+GebjIEu/T4wj8ghh6W/gNwOmulunuONnBfqMA3C+fYTiEBZYzZJ
	KC/a7FYHZv0E4SaSwXKsrEuuXoFfR7QVYWiem/tlNxnsij8w2Vg7XYfZ2Wnn5g1ZV2xf3RcLjPf
	rXm/Yg70jf5ejHv/ejhAorq4sgfvxI=
X-Received: by 2002:a17:903:2341:b0:2a0:bb05:df55 with SMTP id d9443c01a7336-2ae2e269131mr12213095ad.21.1772165615040;
        Thu, 26 Feb 2026 20:13:35 -0800 (PST)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6ba5eesm41682865ad.68.2026.02.26.20.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 20:13:34 -0800 (PST)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>
Cc: ayman.grais@morsemicro.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 17/35] wifi: mm81x: add mmrc.h
Date: Fri, 27 Feb 2026 15:10:27 +1100
Message-ID: <20260227041108.66508-18-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227041108.66508-1-lachlan.hodges@morsemicro.com>
References: <20260227041108.66508-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(Patches split per file for review, see cover letter for more
information)

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mmrc.h | 198 +++++++++++++++++++
 1 file changed, 198 insertions(+)
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/mmrc.h

diff --git a/drivers/net/wireless/morsemicro/mm81x/mmrc.h b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
new file mode 100644
index 000000000000..36b4a9cf551e
--- /dev/null
+++ b/drivers/net/wireless/morsemicro/mm81x/mmrc.h
@@ -0,0 +1,198 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2017-2026 Morse Micro
+ */
+
+#ifndef _MM81X_MMRC_H_
+#define _MM81X_MMRC_H_
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/random.h>
+#include <linux/time.h>
+
+#define BIT_COUNT(_x) (hweight_long(_x))
+
+/* The max length of a retry chain for a single packet transmission */
+#define MMRC_MAX_CHAIN_LENGTH 4
+
+/* Rate minimum allowed attempts */
+#define MMRC_MIN_CHAIN_ATTEMPTS 1
+
+/* Rate upper limit for attempts */
+#define MMRC_MAX_CHAIN_ATTEMPTS 2
+
+/* The frequency of MMRC stat table updates */
+#define MMRC_UPDATE_FREQUENCY_MS 100
+
+/* Used to spehify supported features when initialising a STA */
+#define MMRC_MASK(x) (1u << (x))
+
+enum mmrc_flags {
+	MMRC_FLAGS_CTS_RTS,
+};
+
+enum mmrc_mcs_rate {
+	MMRC_MCS0,
+	MMRC_MCS1,
+	MMRC_MCS2,
+	MMRC_MCS3,
+	MMRC_MCS4,
+	MMRC_MCS5,
+	MMRC_MCS6,
+	MMRC_MCS7,
+	MMRC_MCS8,
+	MMRC_MCS9,
+	MMRC_MCS10,
+	MMRC_MCS_UNUSED,
+};
+
+enum mmrc_bw {
+	MMRC_BW_1MHZ = 0,
+	MMRC_BW_2MHZ = 1,
+	MMRC_BW_4MHZ = 2,
+	MMRC_BW_8MHZ = 3,
+	MMRC_BW_16MHZ = 4,
+	MMRC_BW_MAX = 5,
+};
+
+enum mmrc_spatial_stream {
+	MMRC_SPATIAL_STREAM_1 = 0,
+	MMRC_SPATIAL_STREAM_2 = 1,
+	MMRC_SPATIAL_STREAM_3 = 2,
+	MMRC_SPATIAL_STREAM_4 = 3,
+	MMRC_SPATIAL_STREAM_MAX,
+};
+
+enum mmrc_guard {
+	MMRC_GUARD_LONG = 0,
+	MMRC_GUARD_SHORT = 1,
+	MMRC_GUARD_MAX,
+};
+
+#define MMRC_RATE_TO_BITFIELD(x) ((x) & 0xF)
+#define MMRC_ATTEMPTS_TO_BITFIELD(x) ((x) & 0x7)
+#define MMRC_GUARD_TO_BITFIELD(x) ((x) & 0x1)
+#define MMRC_SS_TO_BITFIELD(x) ((x) & 0x3)
+#define MMRC_BW_TO_BITFIELD(x) ((x) & 0x7)
+#define MMRC_FLAGS_TO_BITFIELD(x) ((x) & 0x7)
+
+struct mmrc_rate {
+	u8 rate : 4;
+	u8 attempts : 3;
+	u8 guard : 1;
+	u8 ss : 2;
+	u8 bw : 3;
+	u8 flags : 3;
+	u16 index;
+};
+
+struct mmrc_rate_table {
+	struct mmrc_rate rates[MMRC_MAX_CHAIN_LENGTH];
+};
+
+#define SGI_PER_BW(bw) (1 << (bw))
+
+struct mmrc_sta_capabilities {
+	u8 max_rates : 3;
+	u8 max_retries : 3;
+	u8 bandwidth : 5;
+	u8 spatial_streams : 4;
+	u16 rates : 11;
+	u8 guard : 2;
+	u8 sta_flags : 4;
+	u8 sgi_per_bw : 5;
+};
+
+struct mmrc_stats_table {
+	u32 avg_throughput_counter;
+	u32 sum_throughput;
+	u32 max_throughput;
+	u16 sent;
+	u16 sent_success;
+	u16 back_mpdu_success;
+	u16 back_mpdu_failure;
+	u32 total_sent;
+	u32 total_success;
+	u16 evidence;
+	u8 prob;
+	bool have_sent_ampdus;
+};
+
+struct mmrc_table {
+	struct mmrc_sta_capabilities caps;
+	struct mmrc_rate best_tp;
+	struct mmrc_rate second_tp;
+	struct mmrc_rate baseline;
+	struct mmrc_rate best_prob;
+	struct mmrc_rate fixed_rate;
+	u32 cycle_cnt;
+	u32 last_lookaround_cycle;
+	u8 lookaround_cnt;
+
+	/* The ratio of using normal rate and sampling */
+	u8 lookaround_wrap;
+
+	/*
+	 * A counter that is used to determine when we should force a
+	 * lookaround. Should be a portion of the above lookaround with
+	 * less constraints
+	 */
+	u8 forced_lookaround;
+
+	u8 current_lookaround_rate_attempts;
+	u16 current_lookaround_rate_index;
+	u32 total_lookaround;
+
+	/*
+	 * A counter to detect if the current best rate is optimal
+	 * and may slow down sample frequency.
+	 */
+	u32 stability_cnt;
+
+	u32 stability_cnt_threshold;
+	u8 probability_variation;
+
+	/* The difference in MCS from each of the last 2 rate changes */
+	s8 best_rate_diff[2];
+
+	/* Indication of random versus consistently one-sided variation */
+	s8 probability_variation_direction;
+
+	/* Has rate control detected possible interference */
+	bool interference_likely;
+
+	/* Has rate control detected the best rate is no longer converged */
+	bool unconverged;
+
+	/* Is rate control just entering unconverged state */
+	bool newly_unconverged;
+
+	/*
+	 * Number of rate control cycles the best rate has remained
+	 * unchanged
+	 */
+	s32 best_rate_cycle_count;
+
+	/*
+	 * The probability table for the STA. This MUST always be the last
+	 * element in the struct.
+	 */
+	struct mmrc_stats_table table[];
+};
+
+void mmrc_sta_init(struct mmrc_table *tb, struct mmrc_sta_capabilities *caps,
+		   s8 rssi);
+size_t mmrc_memory_required_for_caps(struct mmrc_sta_capabilities *caps);
+void mmrc_get_rates(struct mmrc_table *tb, struct mmrc_rate_table *out,
+		    size_t size);
+void mmrc_feedback(struct mmrc_table *tb, struct mmrc_rate_table *rates,
+		   s32 retry_count, bool was_aggregated);
+void mmrc_update(struct mmrc_table *tb);
+bool mmrc_set_fixed_rate(struct mmrc_table *tb, struct mmrc_rate fixed_rate);
+u32 mmrc_calculate_theoretical_throughput(struct mmrc_rate rate);
+u32 mmrc_calculate_rate_tx_time(struct mmrc_rate *rate, size_t size);
+
+#endif /* _MMRC_H_ */
-- 
2.43.0

