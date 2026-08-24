Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D9A2BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601214; cv=none; b=i7GxIjoHXPh8oiq0sNs+5B+dkBSUx56X9mprQRm7ztTz8d1J2Hw+PHYHOu95s5Thjm4c3ACMKr+4uEtiXDxLT+gnqF5l+AYSDn8dCp2fpSDAK5kX6z/h5ZIp8fISSBcDRXpYviubD2CD/qoD5lWkZz5ukFsQt509EEWDWdqHW5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601214; c=relaxed/simple;
	bh=Q+jzTvIxM1TqpkzUTAojuJTIUgN+l38AT/dvGrJIaIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQQjGqTcnR4/qGSMqCW6EqR1NUKQXnofIynBChZ9eWc00svIT9/9Of5fZJASF8jhPkANehXKIeE9xyeuLZyBeRT2uWi3HDIPgC/jc37kpzH9NsYcppP2N+dZMAgWemqm6i8+Z9Paga4Bjt+gixrKcGPMA22jICR2iH/DRFDTKoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7f48c750afcso1673745a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601212; x=1788206012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EriCpE7nLrKxCs8zjRjnWUKrJxVNObqHZPSmW7MiZOs=;
        b=haDFfVJxloFqAni5kuhZ/ArcCe6mOtP8XVArSa0/8ykEhbuVyf7W+fh9XVSxP6ZEM+
         pPN0PM8Est8jNajvGy7cbgkn0NMZJw6XmCEgF9hT1jpXU/2vzsPPxB4F1ktr9V3yO6vx
         AhogYsJLuolrNonT8iRyZiMhWHUQL9fiDiCXzAKJKBNRnV9hbLEOcb/cBEQ820yVKrdl
         Ht6041v40TyJAhX3fzmAjfqTq4qaPJxkZ+xwbwV1IRAXn13VDjGIgfXYQBaFMepqDqZA
         XhkcuknGDVerlnbk3mx+f1BkCDwhYO2I95Sq0enAxuwfR5yrHVhRL2dxngGplXXz4346
         wcXQ==
X-Gm-Message-State: AFuF++ms4jxHMZQ/mfJ0IHE06736WqV9femWVpFInLTWmHHQUwHxtN23
	T1DotzPsJk7sQ8f0QEuJ8qN3cwd3BSz/OF13Mq9/RkmlRZBbeR10gFWh
X-Gm-Gg: AR+sD13aigUtmuqVeAqxfwDLEtmLSTN8BXcfuBCTSJr0/WA1REIuoG+yH/96ibMChTG
	6DQ4fWO9d+0VMiSy3IANS4IK9bFFVp18wpkC86gouDttms9tt6I2/YeTST3ZTVkhxA4D7uEVbqB
	ttzXW8d26RhiqiTP+2Dx0BY2WPxVuocg53tA2iI8B3lCXN3JZ3VVYQA/pmRsjU4a7Y/dCn1pnCH
	KQ1gA2RCW9/QU1QudfGjfn7x+EQDvsBvmc2xLuS3NmsFQuZrEi5WrvVKTwqba7CuMXygkXrupoB
	mSuGGABu4C1r8GQ9nqQqiyi/nUqS9C78ASTwt6tpmYN8CBS2ZL7plxdC9MERn5lpDmPjxqzpN+b
	Ar54iisBVZsEpE1ojIvtEIJD+H3dy6X4ChVKj5FNtDgXlzQdtXqQpqftkDhr/Fo3ziLBBECpxZ0
	i37mpAXsdXlPKUYFN3xO2TQrYboU/gbaTdd9d8ehf90ThmoOf9kpHgsIGH+OOrGWT2KRcCxUegw
	IzizU5dDUJzyTahVJGCwC2+QSrL3kusEQWR8B7Z697buQ+wjIHxFQQ=
X-Received: by 2002:a4a:ec46:0:b0:6b1:63f4:daef with SMTP id 006d021491bc7-6b1905225f2mr959043eaf.30.1787601211747;
        Mon, 24 Aug 2026 12:53:31 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:31 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 11/15] wifi: mt76: mt7925: clear CRB before deactivating NAN peer record
Date: Mon, 24 Aug 2026 14:52:23 -0500
Message-ID: <20260824195227.12589-12-sean.wang@kernel.org>
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

Send a zero avail_map CRB TLV before the peer record deactivation
command. This ensures FW clears the committed schedule slots for
the departing peer, preventing stale CRB entries from affecting
subsequent NDP connections.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 4a1f80fac1b5..16fb196e1bf5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -809,18 +809,18 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 int mt792x_nan_set_peer_rec(struct mt76_dev *mdev,
 			    struct ieee80211_sta *sta)
 {
+	struct mt7925_nan_sched_update_crb_tlv *crb_tlv;
 	struct mt7925_nan_common_hdr *hdr;
 	struct mt792x_sta *msta;
 	struct mt792x_nan *nan;
 	struct sk_buff *skb;
+	struct tlv *tlv;
 	int ret;
 
 	if (!mdev || !sta)
 		return -EINVAL;
 
-	skb = mt76_mcu_msg_alloc(mdev, NULL,
-				 sizeof(struct mt7925_nan_common_hdr) +
-				 sizeof(struct mt7925_nan_sched_manage_peer_rec_tlv));
+	skb = mt76_mcu_msg_alloc(mdev, NULL, MT7925_NAN_PEER_MAX_SIZE);
 	if (!skb)
 		return -ENOMEM;
 
@@ -835,6 +835,25 @@ int mt792x_nan_set_peer_rec(struct mt76_dev *mdev,
 		return 0;
 	}
 
+	/* Send a zero-avail_map CRB TLV before deactivating the peer record so
+	 * firmware clears the committed schedule slots for this peer.  Without
+	 * this, stale CRB entries linger and cause scheduling conflicts for
+	 * subsequent NDP connections that reuse the same sch_idx.
+	 */
+	tlv = mt76_connac_mcu_add_tlv(skb, NAN_UNI_CMD_UPDATE_CRB,
+				      sizeof(struct mt7925_nan_sched_update_crb_tlv));
+	if (!tlv) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+	crb_tlv = (struct mt7925_nan_sched_update_crb_tlv *)tlv;
+	crb_tlv->sch_idx = msta->nan_sched.sch_idx;
+	crb_tlv->flags = NAN_CRB_USE_DATA_PATH;
+	crb_tlv->is_use_ranging = false;
+	crb_tlv->comm_ndc_ctrl.is_valid = false;
+	/* avail_map is zero-initialised by mt76_connac_mcu_add_tlv */
+
+	/* Deactivate peer record and release connection index */
 	if (mt7925_nan_peer_rec_tlv(skb, sta, msta, false)) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
-- 
2.43.0

