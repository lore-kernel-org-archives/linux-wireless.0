Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C38331ED2
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787515060; cv=none; b=hUwecv3X2aB8RhbTwit16js1XZ7LeSy4LCH/LenZAnCJzjEjhDd6CGCtmNwWKDRQL1JU5Xcx8th5jDBg4epeTCUFb6X1eHCiXvAg0/0QdwLs6bQ67EsGONpCzwLg6wdfhy7DnCheUhYqZT5QG3oIxTHSaX6gIlArk5I+FteCHUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787515060; c=relaxed/simple;
	bh=U2wwLi9beo2qaua/L9SrRiyKXq1ywTVfoeVdWdjPOHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJk1s5+KqUiovs7yOPh9cJ0kL0CRwc4jdyTQEsTHrqj1OBQpYUHIA1LNhcH1h6O3eOTC50dtHkbSNKcvbKUVXXkxg39dn2d8f2yV51iE1Ns1742sNpE/MjhETDzadoAIX1t9L1vBY0oZemZ/rmdDe9C1A/HbDuSV/ecW4Rhf6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=XxWspGqa; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="XxWspGqa"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c247f6687dcso300569466b.2
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 12:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787515057; x=1788119857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dkjpekjfGs9gr2eeO5fTYbep26DOExkXq9P/fdtSzww=;
        b=XxWspGqawQ82A+9HE8ugKzBasa77ZOL79YTciOi5opaS5xetBNoDjvlj2jhbiwMBRT
         dbypw56mvTVpnQUriOJCMjFpFX/Us6p6WvFKlxRG1WdV3a8SsMGGMU+SzYDSYI2xBdQz
         UlhajtmYSGM8ehEs+l9V+tndnnQG3uzSbvTlM2kJUPQkK3WDEqxiI1YC2w06oLN2SsUB
         rVnIUpzRLNW3uQtwXO+TLMRIX30uWXMIli91iq+rl341jDiG9q7Hao8mk96y+EL8+G4E
         Wzg6cxwJyx6eHU94BIXfMCXRJz21ZNlMynTCNXNstHwNbbctHi2G9h33Ut5PyuZydgIC
         dCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787515057; x=1788119857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dkjpekjfGs9gr2eeO5fTYbep26DOExkXq9P/fdtSzww=;
        b=BU/fIbHCIAkBSRZeNS5ZDT9uM87hndixo9LMEUeCfBrkSUbwc1FO6GzMOnQQIPyW/+
         35Q7YhUdSpIYa35Awpjvn2pVukNoe09A8BO308hT0Ky5/uIIJ4fXx4zPkgYwZnIrE2tZ
         jXPhtcCEzB5Oh7NriaCQq4mX+fQO5+yiztcm+BNA0UhvAiV7mWwpR0cK2UpQCqxGsEzF
         75iGIGZIxVqjiRlPNKZdZoYxxzWPW8N3aNb4I4Nyw2mJPlgAj8cUEVNIPKKh9kEHpEG1
         wv6TwrrU609piyunlzAAj7b0nUACIkp/WuTaOE81Dn+D0gPfMIdgmkxFA6fpxIuAHibl
         B98w==
X-Gm-Message-State: AFuF++mMV0h8JSYOoeSDXKFX5Kmppqd4Xo5vRuv3U/AIKAQ6ZsbfFvGo
	32+KRd8Ds1Oxjxii4QsOihIVzGn2cbNH5nhgs8WIeLlFdyb0780YC7ElY88EokEh3oJYd8KL0EJ
	kvyTWjZsj
X-Gm-Gg: AR+sD12YJ+clrg/r3jL8eLBOxXy1DS7iUWZxC6phX1XfB2mz8U5Abvyd4YsV3HFDDrN
	MLCVLMYLQ+kXa8Khl4y342569ruRAlwDltNbKMbekVFlFF3Wqu4LW1FwXqhPKCWY1o82ABKkl3x
	Krhx8l0yaeeIN0BgJPbN59ayfD5PIHxoX39/Xs6m8APal9JswGZTjxsan0e/UEvoRlxpbLzf/Jz
	YH+xVazobgti1ErJMFus58B7r+Yl2we2XvFaVqkxMLdqXVngZi5cHqBIYwwN+q75/6tpsIDzpOk
	vQiK6W21drNUDWQ/z3whL8mWLL7FdlpJe2vQV/0lhDG308F4zyAJ89fnTaiUMZ5F+Mv9bTaKZ+v
	c9Y0ekooFWK/IjfCr9em1SCzODE9cwEkBtqm8Q4ryygK+T++NPPnhJDXgnKwZyc+QfSC9aTYnMC
	wQe3j0mrOqY3ksBOhZaemMmqu1B03wMHvwk1IbPMM+Z9IWAPRUAPpWyWj0fvQ4rLcWEtDP2AYP0
	J0fAc2GxAX0wQAo1aBBxXcBZp8be7IQXFiF/wmf8zQ1iH6LKrcLZZzDMUxS3EIXRKcXeievEAeQ
	gljixEtumICu88INOPa1JHPMppQ+JmISrG14idRBdJVUKtRCmJhK4moAvhVQ/7m/Fbp/vlvktM4
	2/G3Uj4mmihv1wVlhYiK3a4gRUTaj+6P31FXSpVoRnnEgs14bZwHpm/6n3XdMTv3mVq4Gi5/aZJ
	UIzLvn1PP/WG0b
X-Received: by 2002:a17:907:97c1:b0:c1c:64d4:5ba3 with SMTP id a640c23a62f3a-c246a651d39mr2378935866b.20.1787515056375;
        Sun, 23 Aug 2026 12:57:36 -0700 (PDT)
Received: from Desktop (pd9513a95.dip0.t-ipconnect.de. [217.81.58.149])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a8edsm889532666b.6.2026.08.23.12.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:57:35 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v1 2/4] wifi: ath11k: enable airtime queue limits
Date: Sun, 23 Aug 2026 21:57:01 +0200
Message-ID: <20260823195703.49198-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260823195703.49198-1-julius@bairaktaris.de>
References: <20260823195703.49198-1-julius@bairaktaris.de>
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
estimator returns zero, no airtime is charged, and AQL stays inert, so this
cannot behave worse than the current code.

The estimate is only as fresh as arsta->last_txrate, which is updated from
the HTT PPDU stats when a descriptor is evicted from ar->ppdu_stats_info,
so the rate behind it can lag a rate change by up to
HTT_PPDU_DESC_MAX_DEPTH PPDUs.

ieee80211_sta_update_pending_airtime() returns the airtime but does not
reschedule the txq, and ath11k has no completion-side push, so a queue held
back by AQL is re-poked only by the next enqueue or queue wake.

An AQL enable was proposed once before [1] with a custom .wake_tx_queue and
a tx-completion driven push. That scheduler is not needed:
ieee80211_tx_dequeue() performs the check itself, so the generic handler is
already braked.

ath10k and mt76 set the same feature bit.

Link: https://lore.kernel.org/all/20230501130725.7171-1-quic_tamizhr@quicinc.com/ [1]
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

