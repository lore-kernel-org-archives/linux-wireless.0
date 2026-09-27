Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F4A39E6DE
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543066; cv=none; b=mBUPk/OocvZ21kCic2rIPsipDWZlQXuXj5aeiLlqq//CNB9uU5Bwe0BqfCuvgziS0u9hfO+1bu+Jp1IRv26lZJ7EIh5Fjfr1bQIuZgbyBv6q6FT0dVh7HMmcdaTdJJFcFb5XdwXHvJrenam0+9lySUNGN0KN2DqHgMdg3uZG8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543066; c=relaxed/simple;
	bh=+Y8HbK0F/iJL4ZFqEHk+e3QPMD2QTTTAbQRXIUv8Ivk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU81Z5w1VchY0RS/xHUt7uEtwi3VMSrBPVIR21BB1XILmbEPM9G0XTv3HVNoNGutxtGjeR1QWGWtTvvL0Pj+idE8CKUbc6soYNCWRlHqjDfjjEdbDv5+GgnjZpxfoDpb6j65vFivxkEgs2D86ALwVBeBEGLNReohh3QsQSZdDzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66fabb1a601so2343504d50.3
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543063; x=1791147863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rqDpf6qzt1wZmK380MU1FK+A/S9BmuqJMXY6+W4+KOw=;
        b=yIbP+lyV1DJk4U7yTeQKNiU7mJ2d7q33vuuqit5/GDwL3wEjr+NKDXzJL/hL/Vk7qP
         4m/SKJ3Sm0TVNdIlYk36gx/fNh+5IRFSSTKckwBUL/uVd+li7wZ0kUMD3DJqAOBurte/
         LOK7yTKc256G2Twecxj+z7OxZ2DXxU/XnOOkCa1ObHFR57FTcP6yfvpDpWB9ZAhOOlFJ
         bcZRx/BGlGySqvz6WRdsrZccgU81ldokaH3r6NnNnVJFjNaHSXKlO2lXABXV12jEKbZ7
         GB1wRikdc/90LI8muqywqbKPBeg9UAkjCdfsj+OR38WqRJfYX93+RDLeRb9k0/ETA4WY
         29rQ==
X-Gm-Message-State: AFuF++mvSoIM/T49u0xmgCoQwbrHygtnf/xwY16SIe9dx/oQ3Hq6IYpy
	dp/RftmIMcYO5xiPtHzlusbpBjTgWIOoccEKjEu6+M7A5zWgtfuExE5HSwJHIBYq
X-Gm-Gg: AYBFou3AilgJtoYvDUvteLHjsrlitd8Zj1LnMFFokVu8y+rd6NUBMV+vtA11BrJnyL1
	v8HA5spwX/PtWjSl8c+5/JW/pC4Klpcfiz/bK+O93rWY+TQxcepLJ1IntaXAwGrAriHOs6PhG/N
	EcL3jUU7b2D8Vmr5A9RULyc6YzyddJZ4dqxZNQ02WnU0suGnSL29dCTPuGhSzGHPGSyIrBB98/R
	y8QVTldl3cAm9aerlWaStE68nkHgT5n8hLmRcum+q2A2bLt8iB1AsYvruiWjc71taUUqq8rtT6d
	OIKRhgwfjbJcu99kcvyIyhHky+GpH6rXjJGRfUg7NiqnZtSN0OZATG1UpJgGQ5AsU/CJL/XgTRO
	+xqBulYNgE+Lc6kivMDp01fB8F5fK6+viQ7+YvDoVawKk+zzFv7UyL7tOuODH4erK28T3H7qqdB
	kKb+1WfcCb9ijC4wAfT3aYTCyKbj+UnxihY9XffSKURXGYfUKeBrR2EpWBoQgVt3oyn2bFVAFpm
	bA0AF7lXuRvSy/rt3JWJ1pux8ghz6uGHkvSEqZJSSB2JJdTQViM7+CyUkLwZVfaKufbjw==
X-Received: by 2002:a05:690e:134c:b0:673:a6e4:cb7f with SMTP id 956f58d0204a3-673a6e4ceddmr3584561d50.29.1790543063362;
        Sun, 27 Sep 2026 14:04:23 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:22 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 19/23] wifi: mt76: mt7925: steer NAN handshake frames by committed-bitmap state
Date: Sun, 27 Sep 2026 16:03:01 -0500
Message-ID: <20260927210306.737669-20-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacobs Wu <jacobs.wu@mediatek.com>

Unencrypted unicast NAN management is held to the discovery window on the
DW-WTBL, because a peer whose NDL is not yet confirmed is only reliably
awake there. That is the right call while nothing is known about the
peer, but it stays in force for the whole session, and the DW is a narrow
place to live: it opens for 16 ms every 512 ms and is shared with the
discovery queue, so roughly four transmit opportunities exist inside the
two seconds a Data Path Response has to complete. Under load the
handshake loses that race. Routing the same frames through the peer STA
WTBL was what made NDP setup reliable with a partial availability bitmap
in the first place, since the firmware then paces them by the committed
window instead of bursting blindly.

Neither placement is right on its own: the peer WTBL is only usable once
the firmware actually holds that peer's committed bitmap. A peer station
existing in mac80211 does not imply that - until the CRB download lands,
the peer's availability gate has no slots to open and a frame steered
there parks behind the pause until the session is torn down.

Track the committed state per peer. mt7925_nan_fill_crb_committed()
returns the number of committed slots it programmed, and
mt7925_nan_update_crb_tlv() latches whether that count was non-zero into
nan_sched.has_commit; the allocation rollback in
mt792x_nan_set_peer_schedule() and the peer record removal in
mt792x_nan_set_peer_rec() clear it again. Frames to a peer holding a
committed bitmap keep that peer's WTBL and are served in the slots it
has promised to be awake for; frames to a peer without one, and frames
with no station resolved, keep riding the DW-WTBL. Secured frames are
untouched and keep their own WTBL and key.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 30 +++++++++++----
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   | 37 +++++++------------
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 3 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 7aacfd6527e4..77a91a9ee4d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -1446,14 +1446,14 @@ static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 	return 0;
 }
 
-static void
+static u32
 mt7925_nan_fill_crb_committed(struct mt7925_nan_sched_update_crb_tlv *crb_tlv,
 			      struct ieee80211_nan_peer_sched *sched)
 {
-	u32 m, slot;
+	u32 m, slot, total = 0;
 
 	if (!sched)
-		return;
+		return 0;
 
 	for (m = 0; m < CFG80211_NAN_MAX_PEER_MAPS &&
 	     m < NAN_TIMELINE_MGMT_SIZE; m++) {
@@ -1479,10 +1479,14 @@ mt7925_nan_fill_crb_committed(struct mt7925_nan_sched_update_crb_tlv *crb_tlv,
 			if (!ch || !ch->chanctx_conf)
 				continue;
 
+			total++;
+
 			for (dw = 0; dw < NAN_TOTAL_DW; dw++)
 				tl->avail_map[dw] |= cpu_to_le32(BIT(slot));
 		}
 	}
+
+	return total;
 }
 
 static int mt7925_nan_update_crb_tlv(struct sk_buff *skb,
@@ -1507,9 +1511,10 @@ static int mt7925_nan_update_crb_tlv(struct sk_buff *skb,
 	crb_tlv->is_use_ranging = false;
 	crb_tlv->comm_ndc_ctrl.is_valid = false;
 
-	mt7925_nan_fill_crb_committed(crb_tlv, sta->nan_sched);
-
-	return 0;
+	/* Returns the number of committed slots programmed; the caller latches
+	 * has_commit only once the command has actually reached firmware.
+	 */
+	return mt7925_nan_fill_crb_committed(crb_tlv, sta->nan_sched);
 }
 
 static int
@@ -1552,6 +1557,7 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 	struct mt792x_nan *nan;
 	struct mt76_dev *mdev;
 	struct sk_buff *skb;
+	int committed;
 	int ret;
 
 	if (!dev || !sta)
@@ -1590,7 +1596,8 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 		}
 	}
 
-	if (mt7925_nan_update_crb_tlv(skb, sta, msta)) {
+	committed = mt7925_nan_update_crb_tlv(skb, sta, msta);
+	if (committed < 0) {
 		ret = -ENOMEM;
 		goto free_skb;
 	}
@@ -1603,6 +1610,13 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 	if (ret && idx_allocated)
 		goto clear_idx;
 
+	/* Latch only now: firmware holds this peer's committed bitmap, so its
+	 * availability gate has slots to open and unencrypted NAF may be
+	 * steered at the peer WTBL. Cleared when the CRB is torn down.
+	 */
+	if (!ret)
+		msta->nan_sched.has_commit = committed > 0;
+
 	return ret;
 
 free_skb:
@@ -1613,6 +1627,7 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 clear_idx:
 	clear_bit(msta->nan_sched.sch_idx, &nan->conn_bitmap);
 	msta->nan_sched.idx_assigned = false;
+	msta->nan_sched.has_commit = false;
 
 	return ret;
 }
@@ -1676,6 +1691,7 @@ int mt792x_nan_set_peer_rec(struct mt76_dev *mdev,
 
 	clear_bit(msta->nan_sched.sch_idx, &nan->conn_bitmap);
 	msta->nan_sched.idx_assigned = false;
+	msta->nan_sched.has_commit = false;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 5bdf3ebe6aef..6e9daf96da88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -33,16 +33,15 @@ int mt7925e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	 * full retry budget on an unACKable multicast RA, so one frame eats a
 	 * whole DW window and the publish SDF queue backlogs.
 	 *
-	 * Unencrypted unicast to a peer we have no station for is first
-	 * contact (SDF, NDP request): the DW is the only rendezvous, so it
-	 * goes on the DW-WTBL and waits for it.
-	 *
-	 * Once its schedule is known - the peer station exists, which is also
-	 * when firmware holds its committed bitmap - the frame belongs on that
-	 * station instead. Firmware then airs it inside the peer's own
-	 * committed slots, where the peer is awake and the medium is not the
-	 * DW pile-up, and follows the FAW onto whatever channel the window
-	 * actually uses rather than being pinned to the DW channel.
+	 * Unencrypted unicast is handshake traffic (SDF follow-up, NDP
+	 * request/response, pairing bootstrap). Until firmware holds the
+	 * peer's committed bitmap its availability gate has nothing to open,
+	 * so a frame steered at the peer WTBL would park behind the BY_NAN
+	 * pause; such frames ride the DW-WTBL, which firmware unpauses every
+	 * DW - the one rendezvous both peers must be awake for. Once the CRB
+	 * download latches has_commit, the frame keeps the peer's own WTBL
+	 * and firmware serves it in the committed slots, which a 2-second
+	 * handshake deadline needs (the DW alone offers only ~4 shots).
 	 *
 	 * Secured frames belong to an established peer and keep its own WTBL
 	 * and key.
@@ -52,24 +51,16 @@ int mt7925e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		struct mt792x_vif *mvif = (void *)vif->drv_priv;
 		bool mcast = is_multicast_ether_addr(hdr->addr1);
 
+		struct mt792x_sta *peer = (!mcast && sta) ?
+			(struct mt792x_sta *)sta->drv_priv : NULL;
+
 		if (mcast && wcid == &mvif->nan_dw_wcid) {
 			wcid = &mvif->sta.deflink.wcid;
 		} else if (!mcast && !key &&
+			   !(peer && peer->nan_sched.has_commit) &&
 			   mvif->nan_dw_wcid.idx &&
 			   mvif->nan_dw_wcid.idx < MT792x_WTBL_STA) {
-			struct ieee80211_sta *psta;
-			struct mt792x_sta *pmsta;
-
-			rcu_read_lock();
-			psta = ieee80211_find_sta(vif, hdr->addr1);
-			pmsta = psta ? (struct mt792x_sta *)psta->drv_priv :
-				       NULL;
-
-			if (pmsta && pmsta->deflink.wcid.idx)
-				wcid = &pmsta->deflink.wcid;
-			else
-				wcid = &mvif->nan_dw_wcid;
-			rcu_read_unlock();
+			wcid = &mvif->nan_dw_wcid;
 		}
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 8e1588970ac1..6ed0282775ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -133,6 +133,7 @@ struct mt792x_sta_nan_sched {
 	u16 committed_dw;
 	u32 sch_idx;
 	bool idx_assigned;
+	bool has_commit;	/* last CRB carried a non-empty committed map */
 	unsigned long ndp_ctx_bitmap;
 	bool ndp_ctx_assigned;
 	u8 ndp_ctx_id;		/* assigned NDP context ID (for NDI sta) */
-- 
2.43.0

