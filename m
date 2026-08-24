Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5954399D5
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581473; cv=none; b=H/bWUGIrrcO+H9DZ8VMkP+UepdYWDQ+X0zaSMaUFz4UnN9h87w2EpNiQyvKKUh/qRU5ZiYvLy0H7LoVKdlicZzJahZ553zP8ZcxeJgXHzb7NtW+fUNHnrJO3mmHzu4YtPTKhkIMd63Uz72VjwjCixKCYb+StyOtkHtXMzGOmwDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581473; c=relaxed/simple;
	bh=vTc814XAlRbyqcyz0aglImjk3JKk8XWV6raVzMBMfiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCe0fGL4wacov6rKNpgHZzElHwACnQQha1YPJsyhaxKoi+lyLxuKFYLGX8I/X9aB2UbRxjrbASwCzkL3NBXH5HuHqK/F/sZeU6U85zsF0NsJMLkPUb9mxjolT70iJc5KAK2dn8Ak3VrTot9w81FXQy/EkNaV7Swy3iipaZzamtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=hwJ5YvLZ; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="hwJ5YvLZ"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so402908166b.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581470; x=1788186270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KfowLqhDZunasKyUhow1L2/oi1+oZM/zPnoYhQBWbJo=;
        b=hwJ5YvLZYfUgFd9D2JAAEprNCbAWwwoU8FXsBIFa8qvJKB14Qymde9/SpDKYvoGUE9
         e6fTVCPQ3Jg370giVRN6cYINLd3cEBPyNOiFoCWW06NnSL+R8UoIJN+gquYZeI9gY+Oq
         ib2S+4wtVzFk6caz62Edjej257mPH0R6RXoA7O8XLshT+t1IZ8FgzvDRcrxgIUBOozcy
         GJ2+jradJSnzdNhDFL3HqPI535YNOsDVPPcB97RXx/fKlRoWnv2qUMv39zGxxzZ4TXAR
         5NKnnKexPHRlpQcAJJYqSnG1NKI/cLdPdxuCHHBta02yO6c6v9RAJVbKn51e+vAGbY4B
         jCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581470; x=1788186270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KfowLqhDZunasKyUhow1L2/oi1+oZM/zPnoYhQBWbJo=;
        b=GbgV2J8cebH3uyqb/4V4vNCK4sB9KObYe5ta1trdkDRq6qBjtuM4HLhJMF1SLJZsQ4
         8V3gmOIU7C5NTuQ1espLZuGJbwi+qDqcydvYR8Z1SHdLz4sCuUoujBdEeUskL6D2j16j
         qlVvvVTlvlTcSuK9XKanPvdxeBui+BXZl8xKd0V+inezimTdb1aIwQ5o2JnN1Ylc0J7r
         sJydL5iWWiVHH5SPkjYXTItPmnjVLGz7znQHWhklAU/7pe70kT/ntaxyxkbkwzqZWxhB
         uL2lx/RHuhYMOJ82Z7JplfHt/THk5+xH4X07dWGpsBN0FpnJ2g4BFeqI1L9xSadxcUZ8
         05xw==
X-Gm-Message-State: AFuF++kV2aoRp5bqrnceRKUEVLJzGmL1GLygWwWdHGo8qrMkqV86xqHh
	1UIZz//WPxFaVBmb32Xw4lFDOxWY23LpD1JS896CKutXC7XunqhjCxMabE7m6KdOkw==
X-Gm-Gg: AR+sD10RZ/OeOxXK8gDDe5u8EClZjmUpQNoWk0RhnKdemoryYoh59Bj+A+HvrRlxWeY
	SEa5Uv5neHGSgRfcykLPuWbzf7jmEViG1/zUq+ALx2YxV6nN2eUkPLgBDDAPXnrOWsZu+kLAxKg
	xkmN9j8QExI+t0T8MryS808hwE4SPzN9NGDQrCyefyPkUo6uv2ZlMJmCRbG6MFherBC0U/o+IrB
	oDuyr5GovnpRy6AW/MIgL0Fdu8QQNlmTObUD/q9BroUL7x3pJkJ+vg6gXFTp+1Yo2hicMLfGg/W
	ak9I2DfqAbdyUQqRBXo27YqgjKP2lZr1GnJy0da7zTzXGlHw+tT55lPSlD6oKkqkPoKHObipIEf
	6x/q2PPt6t6JVrgXqZ7Rh8FISDThMuGHHJxuusT0SendamK6BCffAJ9LEA6HLiv/6LLBdDI2X+f
	kQhPR0p6GAo8eVqICy8ADhSjdFL3vM733f5Rp4r8zpkOCYNf/exSK6lWZXVQiGvsI8ps0o3DajQ
	dG4NESkS0CXNqRXriqfmG3HWPp2FozIyI5bNxIeICVaJJbgfOocm/RrDqQ16K73yWyk3MrWUwQh
	j8bje+hPXWGTPcJiJz8uHN0dzBoJp9hEjBNNq9Trryq1MbtnaBeRfxgSO+Ju2rJzgN/74vkBnSE
	MQCWMj5VhPLB0P1LUeJB3C0oyIcSCMZr6cBe5OE8eDSGjxRRCxD9bb4U4u79EbK4Iw2jpQOUH
X-Received: by 2002:a17:907:cd07:b0:c24:b11c:6c05 with SMTP id a640c23a62f3a-c24b11c6ce6mr1396610166b.14.1787581469243;
        Mon, 24 Aug 2026 07:24:29 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:28 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 2/9] wifi: ath11k: enable airtime queue limits
Date: Mon, 24 Aug 2026 16:23:43 +0200
Message-ID: <20260824142350.1757379-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824142350.1757379-1-julius@bairaktaris.de>
References: <20260824142350.1757379-1-julius@bairaktaris.de>
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
debugfs, which is not even created.

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
limit is lowered to 500/1000 us. Pending airtime stands above the limit it
is tested against because ieee80211_txq_airtime_check() admits a frame
while pending is still below it, and the TIDs of one station test it
independently. Without this patch the file does not exist and the limits
are never consulted.

The rate the estimator needs is already there: ath11k keeps a per-station
rate_info in arsta->last_txrate and passes it to ieee80211_tx_status_ext(),
which stores it as tx_stats.last_rate_info, and that is what
ieee80211_calc_expected_tx_airtime() reads. Where no rate is known yet the
estimator falls back to its 4 us floor, so a station's queue is charged the
minimum until the first HTT PPDU stats arrive and the per-AC limits of 5000
and 12000 us stay loose over that window. The current code charges nothing
and consults no limit at all, so nothing is held back that is not held back
today. A rate that has gone stale low overcharges a station that has since
sped up, bounded by the same lag.

The estimate is only as fresh as arsta->last_txrate, which is updated from
the HTT PPDU stats when a descriptor is evicted from ar->ppdu_stats_info,
so the rate behind it can lag a rate change by up to
HTT_PPDU_DESC_MAX_DEPTH PPDUs.

ieee80211_sta_update_pending_airtime() returns the airtime but does not
reschedule the txq, and ath11k has no completion-side push, so a queue held
back by AQL is re-poked only by the next enqueue or queue wake.

The bit alone brakes the queue but does not refill it: the check at the top
of ieee80211_tx_dequeue() stops the drain, and nothing restarts it until
mac80211 next calls the wake_tx_queue callback. Later patches in this
series give the driver a scheduling round and run it from tx completion,
which is what makes a binding limit affordable.

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

