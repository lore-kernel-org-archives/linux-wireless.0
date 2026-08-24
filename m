Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116B3384CCA
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601172; cv=none; b=gS35+zIzr8kof9KEK3R41be4S+wuUTC0a5CmylpVA7gTEaGWCW7FNT9OjWX9cabeRk+SbhTFhUCapmaLzJJDZ6lPhICLkaLkmPS8xUfH43ekWVifbRNyLAXgjUjoLqi3mMCRCshTXBIwZwcMVD1AdiTxs+Eu7caphCorYT6Q0nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601172; c=relaxed/simple;
	bh=ug5iZA6gMqBoaqzvdycIe9OSsSLoME4lwo+7WT+0mic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKH0K503aonJ6xWSPr6MrXauBK2y20KNFMbrMdWGPlw4CYypDQPW6yMpYn4hj+lwVl2kgZLhbsxF0LJnqNYw8+Q9BaOHR10IBvmQtwbBifsB6K+ILMsxrtAKMio6xyqjBp+qMwkHCBB2yNKpLfgByppxaT+ioNKqKcHmmmY7mxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-45e2fd33133so2835012fac.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601170; x=1788205970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iFik3syta/xa+rpQ6R4qogLWpplWvKVpUybzi1DcPYA=;
        b=A6063W6caWq83kJFCRQ7WQ95I/56XeAMoWb7LCJl+1rvP6KZ1Eydn+YlduGzGGrlVh
         ATaXTqWsgGZfrh52/wLLVEuS7ZDFco1EN88RcRUquHqsOEHDKT187U7/gtRf433PlJC0
         E4dFYf7j4Hq6Ex0oqtLbbHTs4xaHCWH/k30rKJvRur3NtrKYKbH/zLH1Mjuc1Qc5p9+Z
         zKgdAWmutfIejGNNsHvz2aStXvGnlgWT1j+AVVtU5QixUtjY2aK+EOqdHPWZy8jTBW2V
         DS4oLbwXSwkNNdtzLyrtZXlYjrF8jfmDffM1Gq0dXHpxplcnrN4eHLl5mdK4t+M0HZgJ
         VjhA==
X-Gm-Message-State: AFuF++mtbQzP1jWKMUVVTI2ltuN9YHJJ9GtAEMz4bfjgQnXqgKtxHEI1
	yk4zMFPX7YAd68KGi9Zcc0cROCez4A4oeyus1S1ui4g8w8pTJEmlDYJyJLp6iRmiGLE=
X-Gm-Gg: AR+sD12vPodiiuj2z5yZTOc2pcOD2R21S/wchwewkYKOjxImajKgLIVMEqSHRPOi9aK
	d0C8POB5F5ToaI2R5O5Ca6LnptvxYw5p2SCUvo/snpujV0MUlBqoVVu1qhyryMqfwRVyt7m1g6U
	e1LmE9SvjunhtW5GgTdyfJ/Oly28K3wlhJbipqD2Ez9viGIyGgXmvAOmadCwYQoRfuVcwROnRRk
	GoluwpXfxsyMjWdF9hG8+d1KzfwTrlxY+xj7HwdKpioy12/dALJnUx2Gzwy4mnRtISHCZbVFUev
	sLzjBqhmrSrWeOh540t0qfN0Pesx6ZEp7fYTIrMq3/9tarDU5eIVTwNpvUc/yiyjaPpS7oEFiPg
	/BfaxCV8OE0c6FW3f9mSJvbBZR5ebBJo6Ax+P+j7AyaXTAbaXfdyKx3vZuv1OuaczjOZcpx/mk6
	rrdDv8pWTkOc9OPkQwCUPwxEU3auL5mzNp/10q1eaYyNCkGN0juYmJcYHU86lHGLTuHirTb3Ja8
	RHWjmgEcCjlqAazR560SumOAjNSrVJGKRjbCDBOGc4l7hbPAg==
X-Received: by 2002:a05:6871:14e:b0:452:213:bd4d with SMTP id 586e51a60fabf-4635173f31emr26372209fac.17.1787601169781;
        Mon, 24 Aug 2026 12:52:49 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:52:49 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 01/15] wifi: mt76: mt7925: fix NAN NDP STA record role index
Date: Mon, 24 Aug 2026 14:52:13 -0500
Message-ID: <20260824195227.12589-2-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824195227.12589-1-sean.wang@kernel.org>
References: <20260824195227.12589-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stella Liu <yu-ching.liu@mediatek.com>

The NDP STA record role_idx must carry the NAN BSS band0 index
rather than the mac80211 BSS index, otherwise the firmware maps the
NDP peer to the wrong role. Use the fixed NAN_BSS_INDEX_BAND0 value.

While at it, drop the inline peer-schedule setup in
mt792x_nan_map_sta_rec(): the peer schedule is already driven by the
upper layer through the peer_sched_changed callback
(mt792x_nan_set_peer_schedule()), so the redundant call and its
now-unused local variable are removed.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 31 +------------------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  2 ++
 2 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index d260e803d056..70cb2c44869c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -990,13 +990,11 @@ int mt792x_nan_map_sta_rec(struct mt76_dev *mdev,
 	struct sk_buff *skb;
 	int ndp_ctx_id = 0;
 	int ret = -ENOMEM;
-	struct mt792x_dev *dev;
 	struct tlv *tlv;
 
 	if (!mdev || !vif || !sta)
 		return -EINVAL;
 
-	dev = container_of(mdev, struct mt792x_dev, mt76);
 	msta = (struct mt792x_sta *)sta->drv_priv;
 	mvif = (struct mt792x_vif *)vif->drv_priv;
 
@@ -1012,33 +1010,6 @@ int mt792x_nan_map_sta_rec(struct mt76_dev *mdev,
 	memcpy(nmi_addr, nmi_sta->addr, ETH_ALEN);
 	nmi_msta = (struct mt792x_sta *)nmi_sta->drv_priv;
 
-	if (!nmi_msta->nan_sched.idx_assigned) {
-		if (!nmi_sta->nan_sched) {
-			rcu_read_unlock();
-			dev_err(mdev->dev,
-				"NAN: peer schedule missing for NDI sta %pM\n",
-				sta->addr);
-			return -EAGAIN;
-		}
-
-		rcu_read_unlock();
-		ret = mt792x_nan_set_peer_schedule(dev, nmi_sta);
-		if (ret)
-			return ret;
-
-		rcu_read_lock();
-		nmi_sta = rcu_dereference(sta->nmi);
-		if (!nmi_sta) {
-			rcu_read_unlock();
-			dev_err(mdev->dev,
-				"NAN: NMI sta not found for NDI sta %pM\n",
-				sta->addr);
-			return -EINVAL;
-		}
-
-		nmi_msta = (struct mt792x_sta *)nmi_sta->drv_priv;
-	}
-
 	ndp_ctx_id = find_first_zero_bit(&nmi_msta->nan_sched.ndp_ctx_bitmap,
 					 NAN_MAX_NDP_CXT);
 	if (ndp_ctx_id >= NAN_MAX_NDP_CXT) {
@@ -1073,7 +1044,7 @@ int mt792x_nan_map_sta_rec(struct mt76_dev *mdev,
 	memcpy(map_tlv->nmi_addr, nmi_addr, ETH_ALEN);
 	map_tlv->sta_rec_idx = msta->deflink.wcid.idx;
 	map_tlv->ndp_ctx_id = ndp_ctx_id;
-	map_tlv->role_idx = cpu_to_le32(mvif->bss_conf.mt76.idx);
+	map_tlv->role_idx = NAN_BSS_INDEX_BAND0;
 	memcpy(map_tlv->ndi_addr, vif->addr, ETH_ALEN);
 
 	ret = mt76_mcu_skb_send_msg(mdev, skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index f55730e25f46..1dcc888d98f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -65,6 +65,8 @@
 #define UNII3_LOWER_BOUND	149
 #define UNII3_UPPER_BOUND	165
 
+#define NAN_BSS_INDEX_BAND0 0
+
 enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_SET_MASTER_PREFERENCE	= 0,
 	NAN_UNI_CMD_ENABLE_REQUEST		= 7,
-- 
2.43.0

