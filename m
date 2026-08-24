Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD60F439F96
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581475; cv=none; b=BNhcfWEIYmf6uxqt6fG1eaC5wzp3WbuIe5NC+4g6gIqj+8lEsPiD33pOiJYzW7fe51d1YhvScP2+aX3pTF5mTlT9Sy9TwShTqNFPyOsydBKWxMGSCBroodWjUFFA70n31sllQOOxQWwQxYxgHf0wJ5f/XvZJlOKp8MWipkT/XMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581475; c=relaxed/simple;
	bh=Vutdc8gNGEiDSB/PvBkPav8VKriNXv1N6grQ/8mvoeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsIPGZFtRnnAxnaPI7SXGAg10xM9lYj7HF+3RBmjVf5K+hTvYfgNb9Q5ACmkKuTgfwTgYjOX9LYWJOu77eHLPI46om0ejbiglkK/a8P8zD8dnxtrQXl6lM1DBk6u3kn/I4q08QfUATkwi7ahvx19ADsoIvKYeWTNcBHchlQAnIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=YQxBALvY; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="YQxBALvY"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c160420289bso519640966b.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581471; x=1788186271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X6pRZ9lo49gs2yifUnauSOrX6fxKPA05MA7r7zA0lK4=;
        b=YQxBALvYe/G1eEX4ofkVR0QrEozq9Sw6ZE55C2ruxe0dK9P0KSc3eSMx6UiiJJ9KnY
         1e5v5TnFFmu4dxZ/kwuN8nJCt3nRn5vgS9P4lTHtiSvnvSsXBtLQeVm/lyP0QWSLbS8R
         usTwn850EZci/MFGji1MKf6C2gEMSq2+ylXm+FBety0QF/KuFSLduFnsjKGyGSPbZc5G
         urVxG8lXQ8OyBzjrdoSSX5ubf7UF5wsQ0fPhP89n1YxtlgFRXXCHVMYuw1nT5JR++3j/
         Sn3gNe3AfSToallxzF59X30/7fVtLrz/HrwJqTg0jAsviU64n59xRYL7oII3BKNUbLu3
         bxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581471; x=1788186271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X6pRZ9lo49gs2yifUnauSOrX6fxKPA05MA7r7zA0lK4=;
        b=S8me4LVcvmwr/3ILrvz3nKPkCjFho2JNNeKdB74KeB4lHHD6EhMuMytsOFqK2a/5Ya
         48biHIb1R6//lh+ewwcqSXgyuMhbQT4iiVBYpeEoninZfyecUNZJOmvRD340mExWSmYM
         53WaN9plrZElPNzUNUnmNUNLNR/kduQcVLnXSVMkswoHx1ywLhM06numiGCGyDfMPjhB
         mcNBWbNMr/vvzSKVwQdXxPPX9yJ9MYbiIqbv0XkmDbi31zQ+w0egCbKj61ReJUpuEdaW
         ayXgwWNsuuf4Ww/YQbrS3zwe3qTQ3ftQjUD7I1/UkGzQbunckYHroyF+LUOV0ojcWory
         QhCQ==
X-Gm-Message-State: AFuF++nOsZg6o+vbDqQZq16IdhbadXGDoNBB0HINBtGgyeQKYUF5GoZq
	xFK01vFVpI3jv/WS9i1bRrMMpAug/0mKDG9KDsjAqb1+U0e7vM4/T/9Ct1YSBYotMg==
X-Gm-Gg: AR+sD11vC4aIqlkb6QEzjslST5SQQLqbKRBJUte7sL/bMZxY7pJLq2CVUxKTnwr2qpK
	COsFXFwFW8kLl9uM9VGosgZcU8P7na/QKENxDTpwib1tI9qDhk42rB9Yfl/5h9cMhFc38BtHNUw
	xcsgvLcjwP2vaOm+TgpnLJMORM0suOFFPz24O+3ovQYkJ6d1XwrPgTiJ0VHo4F9nzKzBcfd6KEJ
	QIjn8q4emiGF27jMCCw+1R+MtUlqiAAIsPUvpWnPio11QoWCbMfcrz49i3vSOXLb76WYop0UHi3
	2C3Ks5T03Vag0V8MaGD2H2ceNe6y5qFLDaPD6yqs4SzfLnkY8XhMRslHXghzuUBFG1n7HQekLfy
	cz+xLW1B7iFQmUMqyxwm66xElV22Npp8vP3ORXGZc5wBUXTt11TmaDCFzBFBwwJPs1qBbeOaq9Q
	3HchYmRK2/mszvq9gR2tQKFD2HfZKsf3HT6R+UOl84QfYrU0JpsT2CdOaykj3l7Dz+mhUPI/XIW
	tlW9UTI2UpDwEgJ6w2W+itQCQVIeEZldlCkrmtwSY65Rzv6bEW4yYzXsi8btBY4muQo1Z8p55KX
	eAUyzZgMLcOHTZ48CFwr/HN1cRkDS/NMm9Igrh+FpXJiIL9lceXxtlske0ilXK/Qh6D9WXhMxtP
	2cG0FrVIrYfGqcC1Z6sgGdgeXJ8LiDeU3/jcxiaxskNxaQPZ+wbXvD9rebe7Y5B+l2eHM+bWI
X-Received: by 2002:a17:907:7283:b0:c24:b11a:470f with SMTP id a640c23a62f3a-c24b11a493emr1213893666b.0.1787581471018;
        Mon, 24 Aug 2026 07:24:31 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:30 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 4/9] wifi: ath11k: report tx airtime and enable airtime fairness
Date: Mon, 24 Aug 2026 16:23:45 +0200
Message-ID: <20260824142350.1757379-5-julius@bairaktaris.de>
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

mac80211's airtime scheduler charges sta->airtime[ac].deficit from one
place, ieee80211_sta_register_airtime(). Unlike AQL there is no estimator
fallback, and ath11k never calls it, so the ATF feature bit cannot be
advertised on its own: the deficit would only ever be replenished, every
station would stay permanently in credit, and the DRR would be inert. The
bit is not a no-op in that state either, because it also moves txq
insertion to the head of the active list, which __ieee80211_schedule_txq()
documents as safe only because the DRR moves a station back once its
deficit goes negative.

fes_duration_us arrives with every PPDU's stats and is already
accumulated into arsta->tx_duration a few lines above. Register it, and
set the feature bit in the same change so the two cannot be separated.

The access category the airtime is charged to comes from the TID, and the
ack/BA status TLV that ath11k took it from is emitted only for a PPDU that
drew a response. A transmission that timed out, was filtered or was aborted
names its TID only in the completion and rate TLVs, both of which already
reach the driver and were read nowhere. Take the first of the three the
firmware supplied that names one of the sixteen QoS TIDs; a PPDU that names
none is charged to best effort, the access category mac80211 queues a frame
without a QoS TID in.

Measured on an IPQ8074 AP with two stations on one radio, a 1x1 VHT
client and a 2x2 HE client, both receiving at once. Before, 'iw station
set <mac> airtime_weight' is refused with -EOPNOTSUPP and the per-station
airtime file reads zero. After, the weight is accepted and read back, TX
airtime accumulates, and the per-AC deficits move.

What the deficit can do with that is bounded by how the driver hands
frames to the hardware, which the following patches change; the airtime
share this alone produces is reported with them rather than here.

fes_duration_us spans the frame exchange sequence, so it includes the
SIFS and the responding BlockAck, time the radio spends receiving; the
airtime registered is therefore larger than the airtime transmitted. It
is also a per-PPDU field, so on a downlink MU PPDU each user is charged
the whole sequence. No per-user duration is reported in these stats. On
the firmware tested here every PPDU carried exactly one user, measured
over 21051 PPDUs, so the MU case is latent rather than observed.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/mac.c   |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c084..28aaf39cf342 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1377,6 +1377,7 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 	u16 rate = 0, succ_pkts = 0;
 	u32 tx_duration = 0;
 	u8 tid = HTT_PPDU_STATS_NON_QOS_TID;
+	u8 airtime_tid;
 	bool is_ampdu = false;
 
 	if (!(usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_RATE)))
@@ -1485,6 +1486,25 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 
 	arsta->txrate.bw = ath11k_mac_bw_to_mac80211_bw(bw);
 	arsta->tx_duration += tx_duration;
+
+	/* The ack/BA status TLV is emitted only for a PPDU that drew a
+	 * response, so a transmission that timed out, was filtered or was
+	 * aborted names its TID only in the completion and rate TLVs. Take the
+	 * first of the three the firmware supplied that names one of the sixteen
+	 * QoS TIDs; a PPDU that names none is charged to best effort, the access
+	 * category mac80211 queues a frame without a QoS TID in.
+	 */
+	airtime_tid = tid;
+	if (airtime_tid >= IEEE80211_NUM_TIDS &&
+	    usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_COMPLTN_COMMON))
+		airtime_tid = usr_stats->cmpltn_cmn.tid_num;
+	if (airtime_tid >= IEEE80211_NUM_TIDS)
+		airtime_tid = user_rate->tid_num;
+	if (airtime_tid >= IEEE80211_NUM_TIDS)
+		airtime_tid = 0;
+
+	if (tx_duration)
+		ieee80211_sta_register_airtime(sta, airtime_tid, tx_duration, 0);
 	memcpy(&arsta->last_txrate, &arsta->txrate, sizeof(struct rate_info));
 
 	/* PPDU stats reported for mgmt packet doesn't have valid tx bytes.
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 38f641bbc53c..40a2b6d2f804 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10593,6 +10593,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_AQL);
+	wiphy_ext_feature_set(ar->hw->wiphy,
+			      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 	if (test_bit(WMI_TLV_SERVICE_BSS_COLOR_OFFLOAD,
 		     ar->ab->wmi_ab.svc_map)) {
-- 
2.53.0

