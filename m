Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A453D3B3
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557376; cv=none; b=IJoVaJiNSZEfOGtqyM2K3Ce4Vi9eKBaeG11kiSCXQc5g+JcpxbGaEwceF25rWbj6Hd9PzkW2MA7ytkvc0RnbBwmRQXGPOgFrPpUw5N8hWSV+NNdcgPlJfOOKUt1XT94f3KbXnxWi1+C97q9lgfFYKq8NlS1RLlj/o0OgkVXS9pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557376; c=relaxed/simple;
	bh=nsfC7er9O7ftVCg4xAeP9Kmru08PDh/fEWSlZI/yvuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZaS4BS3Uzk3GUO4joD5glvyv+clJB2JUXaxH4fUFyJT3/OBCsnPwSTBs6ZyUeDWXJOFpbTHdNW+AlmxbhgthpQ26ahVLOT2v3ArHy6ApHeq20iCDIvOs8ArzAA7urGXyEiPOb4lebEq6smvBzMBxffjoeCCFsfchQb8udAj6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=lNvHnBgG; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="lNvHnBgG"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15e2dab83eso591777966b.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557373; x=1788162173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NseC193O6mLkVIeO24aPT+5wuVWeRgDqN0479cwztvs=;
        b=lNvHnBgGHOZ/PNl8LGImCGJ2hnWjVFZYahteV4GigqkpS3hURRCvwa5GP03oDKR3tE
         VE33Bt5E//N+yRKMR+ZrFw1Yr2C5ES5T5RmVfz5Usx5SC81JbeGDfsb1UduaRq9zjQda
         FasfKKss+EBRREauFbNu/GqpcHWMhObCeqBuPuDStirr87GfI7m3zOUiUr2BiZTYojmb
         7yQ9h7dxfwf50nPGRblFEtbtH2HPT4SlcEhd4giHabox4B4/7UtsSOFnYZe/cCeHG1w/
         MWpYH49kRyDSP2PT2YDdSJVZ5Vgcp/KJaMnOYxjzwqigetZp5mSUZtZFz/RG6n1mJE8U
         yzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557373; x=1788162173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NseC193O6mLkVIeO24aPT+5wuVWeRgDqN0479cwztvs=;
        b=Tudug73nmSOZHKMqT3HsujhIA9Zl5+2+E4K5paYIR4mxB9ESycSCgilTty9oDkkAhV
         Q8cT9/Xj9vHTAAL6nySuK8wQq6OzCSQ7rqKY4fU/NPnkMcefEEbRdOSwg8sR6+RqTQg4
         EmOmRmBIpyFXJ8bvYsfu34kY/wSqK7b99T8NMhwki/GWYjUx64QouOnSkHDHGDyR+Je0
         PIGWzsWcUHwv+lqBQvR+COhtOYWeNNaz5dfOv40O3rQIIOJ+B3xBfOLcRh42t1mW7aOJ
         SULDQZokMnlMQMRc5McShuKoXZu6BUIWWBCmHWd10O0pjNKlzAssr3yAtdDv3X4lCiTj
         1KCQ==
X-Gm-Message-State: AFuF++la6iKy0t3XiwwR0Q4iho13K3xqqjKM4DQ4BVGrFMUHaPr2cP/9
	vevwNgs2UvGjie3+OdctAfAoG3LgwmJZzh+SiwH70KZfNtFFQR0SIj9Jrpnq+46xX+p/SzvzDoP
	Oal7wmFql
X-Gm-Gg: AR+sD10R2QQFYUGY1lBXI5uXQGdzoYv0+c7G06fOYkSORZHk+437nLKN+aqgC7ebBIt
	x8hbRVN8jFk145DcSrKj/CV7LVKo78JhWpS7oH8+xlVXzpzV06vAVmrZyP01uODbBCjYUKhWmkX
	A+o1YNK9OsxYSF8G77B79WSwRE2fR+tfuj5iN85uBwPIIv9kkTwHPpBSwgxfihFWIiFxoTlC3hs
	dKIvXEmFJR1PZ7AmblS04NzGUgvfCvr4oauPAgBW+zEAAEMkGRvY8vemyugv3kUHbwY6LDamhLV
	qS0AUD0/6Xh37bp70ay1E8vCxEM7ng5IO3mHDaAJ+bWYdyOEqjNYma4RM5pjD9/fAvxYvLuw1s9
	X0nM9vZPl+YXCYR/Xf74e9QuEbffLe3H+sKl3k3JFp4wDuYeBc8ov4+cfH56+3w02bj8MsPbtvc
	igO7OKSt98DPBNMqQbFAqBUi5e8RnTR3OL2BWuBOvRLYRrxQ1Zt+EtPFVK411imWcXM9vwkhVHZ
	eG2CFviphHUcGVUCRE1qhJ76Q3cLr8fDPneG28JDwdVfxhlnAfdMDvwjkMN7miWDde3oDxGQ8xM
	yWAket1RGcd0ylhKbjx4k10ucPt8Q1uJoVVZuB+JP3lY1VpP9OW2pQe74VugqllKerRVdzyMZjC
	V11duV+40PJQkfEEbK6Jreka+SXIU8rnWALJAIVDNxxOHJXuW20LSTTd3MpdIaph5p2E2zwseON
	1JRyk/t6sSIftuPg==
X-Received: by 2002:a17:907:3e02:b0:c21:6f8c:2335 with SMTP id a640c23a62f3a-c246a6b1745mr2800831166b.16.1787557372785;
        Mon, 24 Aug 2026 00:42:52 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:52 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 2/9] wifi: ath11k: enable airtime queue limits
Date: Mon, 24 Aug 2026 09:42:21 +0200
Message-ID: <20260824074228.2114579-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824074228.2114579-1-julius@bairaktaris.de>
References: <20260824074228.2114579-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k does not advertise NL80211_EXT_FEATURE_AQL, and every user of AQL in
mac80211 is gated on that bit: the airtime charge in
ieee80211_tx_dequeue(), ieee80211_txq_airtime_check(),
ieee80211_sta_update_pending_airtime(), and the per-station aql file in
debugfs, which is not even created. AQL is not untuned on this driver, it
is absent.

That matters here more than it would elsewhere, because AQL is the only
brake. ath11k uses ieee80211_handle_wake_tx_queue(), whose
wake_tx_push_queue() drains a selected txq whole into the driver, and the
check at the top of ieee80211_tx_dequeue() is what stops that drain.
Without the feature bit nothing does, so mac80211 holds no backlog and
every queued byte of a saturated download sits in the hardware TX rings,
where there is no AQM and no flow separation.

Measured on an IPQ8074 AP against one HE 160 MHz station at MCS 11, taken
from that station's own aql file while it received 280 Mbit/s: its BE queue
depth reaches 6356 us of the 12000 us default limit, and 2972 us when the
limit is lowered to 500/1000 us. Without this patch the file does not exist
and the limits are never consulted.

The rate the estimator needs is already there: ath11k keeps a per-station
rate_info in arsta->last_txrate and passes it to ieee80211_tx_status_ext(),
which stores it as tx_stats.last_rate_info, and that is what
ieee80211_calc_expected_tx_airtime() reads. Where no rate is known yet the
estimator falls back to its 4 us floor, so a station's queue is charged the
minimum until the first HTT PPDU stats arrive and the per-AC limits of 5000
and 12000 us stay loose over that window. The current code charges nothing
and consults no limit at all, so this cannot behave worse.

The estimate is only as fresh as arsta->last_txrate, which is updated from
the HTT PPDU stats when a descriptor is evicted from ar->ppdu_stats_info,
so the rate behind it can lag a rate change by up to
HTT_PPDU_DESC_MAX_DEPTH PPDUs.

ieee80211_sta_update_pending_airtime() returns the airtime but does not
reschedule the txq, and ath11k has no completion-side push, so a queue held
back by AQL is re-poked only by the next enqueue or queue wake.

The bit alone brakes the queue but does not refill it: the check at the
top of ieee80211_tx_dequeue() stops the drain, and nothing restarts it
until the next frame arrives from the network stack. Later patches in
this series give the driver a scheduling round and run it from tx
completion, which is what makes a binding limit affordable.

ath10k and mt76 set the same feature bit.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2d55cdc4d165..38f641bbc53c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10592,6 +10592,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ar->hw->sta_data_size = sizeof(struct ath11k_sta);
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_AQL);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 	if (test_bit(WMI_TLV_SERVICE_BSS_COLOR_OFFLOAD,
 		     ar->ab->wmi_ab.svc_map)) {
-- 
2.53.0

