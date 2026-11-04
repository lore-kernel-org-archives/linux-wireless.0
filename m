Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784236;
	b=be4Ng0U9ZWBJXnCSsA8xi1rq34ZfzEUfG99aLYnVyBr0/rYT+KkIZ1mLFLQ3aNk8IXla
	 NbnoSVhyQZbkzQPcE+M48LAq6AUL3IbxYWpDj5Kud2qT0MShxMfM9V81VCPRITtRo2mr5
	 jRjkvzDjLKlphz4t4qRTxv49DQQXVMQW5hevKT42D7QRO1pEfniaErrsauWefI/6IewJL
	 cKK57vV8M69IB1fRoywHxanD9L6xe0HJx9+ijXEL4YwX5BKJwKyJeFmeZct0g3pNZdQ49
	 UTH0k8iXnhfjGNUqO2q/Trt9JSDpXhQGZgLd11rYds0A8RkQuHPXcNd/gIDMlaLtfJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784236;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=RniTSC7vYIpPzGUbyDp7Fd8gv+ddi2hOHsrrNHe4dKc=;
	b=fDcnr3NurlMcLVNv8llhtyKs4El7xDkwlqp3jLGdxOJySsPkMZSdyJoh9A3mnlAlGhk+
	 BM9mWzvX2BIE3gW4oOR1Kw8h7rH7xoI6naVU6ziIVM1BYCbza8CyOhcSJjTWSpjyZMVOO
	 l4c5T/3o1S3kEuKwiCwxFXNAJx1tPJ3F2WztnEYZ8z/+b31HetP4JQqsWNpFflCP9KpP/
	 t5a9Pr51ahwge+27VGAQ7dLQztzfG3mFL1NVWz7lJa8K/M976WDw7uYEYFWX1A29pyTWt
	 x3HCGS5niqyZWm3nKCxClE5BdqfuSJFOKm1AUlY5ZBekGtJvtwnlKPffDuHB+rsKRAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Zi9JYyyg;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4716E606D809
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 09:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4716E606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=Zi9JYyyg
X-UUID: 71ac2f88d83111f1b1788b6acf885367-20261104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=RniTSC7vYIpPzGUbyDp7Fd8gv+ddi2hOHsrrNHe4dKc=;
	b=Zi9JYyyghtu7rur6oNzLfDXdjHH/rm5Hc0qfnSgAyMNSX754/U5rGNEX8Bky5a0/Bbzw1anBK27q8BqiDYgbE/QayIJdq6OYT4X9Io5wUAZWNvMI19BlY1zjlNB+6qt0MGJhJrqq0WyFnNJaTHZ0C9IWypWEE2gKaYMTo1vDguY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:a770c840-72de-460e-a0d0-d3c898d2b159,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:c5fd16ee-6961-456c-adce-6d277e14e6ad,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|136|836|865|888|898,TC:-5,Content:0|
	15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 71ac2f88d83111f1b1788b6acf885367-20261104
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1798022471; Wed, 04 Nov 2026 17:23:49 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 4 Nov 2026 17:23:49 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 4 Nov 2026 17:23:49 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <James-LY.Huang@mediatek.com>,
	<jb.tsai@mediatek.com>, james-ly huang <james-ly.huang@mediatek.com>
Subject: [PATCH 6/9] wifi: mt76: mt7925: request the channel before programming a GO BSS
Date: Wed, 4 Nov 2026 17:23:41 +0800
Message-ID: <20261104092344.1932406-6-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261104092344.1932406-1-jb.tsai@mediatek.com>
References: <20261104092344.1932406-1-jb.tsai@mediatek.com>
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
Content-Type: text/plain
X-MTK: N

From: james-ly huang <james-ly.huang@mediatek.com>

Mirror the STA JOIN channel-grant handshake for a P2P GO
coming up. Without an ACQUIRE, mconf->mt76.band_idx stayed
at the 0xff auto value that only a ROC grant fills in, so
the BSS_INFO_BASIC always guessed the DBDC band:

  - .start_ap runs ACQUIRE (GO_START_BSS reqtype, which CNM treats
    as the BSS-owning request) -> add_bss_info with the granted
    band_idx -> ABORT, with per-role hold times (3s P2P GO /
    200ms SAP). Falls back to a JOIN request once on FW that
    predates GO_START_BSS; a refused grant is not fatal;
  - gate .change_chanctx on p2p: the RLM-only BSS_INFO_UPDATE
    that mac80211 issues BEFORE the grant reaches CNM with a
    guessed band - skip it, both roles send a full BASIC+RLM
    update once the grant supplied the real band_idx
    (mt7925_p2p_chanctx_bss_programmed in p2p.c);
  - P2P GC join: hold the channel for 4s instead of the 1s
    mac80211 default, so the whole auth/assoc exchange fits in
    one grant (a GO only listens part of the time);
  - renumber the channel-privilege reqtypes to match the FW CNM
    interface (OFFCHNL_TX / GO_START_BSS / DFS_CAC);
  - add mt792x_phy::roc_is_mlo so the grant handler can tell an MLO
    ROC apart from a plain remain_on_channel request.

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 65 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 10 +--
 .../wireless/mediatek/mt76/mt7925/mt7925.h    | 16 ++++-
 .../net/wireless/mediatek/mt76/mt7925/p2p.c   | 35 ++++++++++
 .../net/wireless/mediatek/mt76/mt7925/p2p.h   |  2 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  1 +
 6 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index b82360da9791..cfdb736f53ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2050,11 +2050,51 @@ mt7925_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+	struct mt792x_bss_conf *mconf = &mvif->bss_conf;
+	bool roc_taken = false;
+	u32 hold_time;
 	int err;
 
 	mt792x_mutex_acquire(dev);
 
-	err = mt7925_mcu_add_bss_info(&dev->phy, mvif->bss_conf.mt76.ctx,
+	/* Mirror the STA JOIN channel-grant handshake for a GO/AP coming up.
+	 * mt7925_mac_link_bss_add() leaves mconf->mt76.band_idx at 0xff (auto)
+	 * and mt7925_mcu_roc_iter() - reached only from a ROC grant event - is
+	 * the ONLY writer of it. A GO had no ROC at all, so the BSS_INFO_BASIC
+	 * below always carried band_idx=0xff: the host never learned which DBDC
+	 * band the FW parked the GO on, TXD1 TGID stayed FW-auto, and the
+	 * host-built IEs could end up describing a different channel than the
+	 * one the radio actually ended up on.
+	 *
+	 * The request type is GO_START_BSS, not JOIN: CNM treats
+	 * GO_START_BSS as the BSS-owning request, so it is allowed to
+	 * create a new channel context rather than only joining an
+	 * existing one.
+	 */
+	if (mconf->mt76.ctx) {
+		hold_time = vif->p2p ? MT7925_P2P_CHNL_HOLD_TIME_MS :
+				       MT7925_SAP_CHNL_HOLD_TIME_MS;
+
+		err = mt7925_set_roc(mvif->phy, mconf, mconf->mt76.ctx->def.chan,
+				     hold_time, MT7925_ROC_REQ_GO_START_BSS);
+
+		/* FW that predates the GO_START_BSS reqtype rejects the ACQUIRE
+		 * outright. JOIN is understood by every branch and produces the
+		 * same band_idx update, so fall back to it once. -EBUSY and
+		 * -ETIMEDOUT mean the command itself WAS accepted (another ROC
+		 * holds the flag / CNM never granted), so do not burn a second
+		 * 4s wait on those.
+		 */
+		if (err < 0 && err != -EBUSY && err != -ETIMEDOUT)
+			err = mt7925_set_roc(mvif->phy, mconf,
+					     mconf->mt76.ctx->def.chan,
+					     hold_time, MT7925_ROC_REQ_JOIN);
+
+		if (!err)
+			roc_taken = true;
+	}
+
+	err = mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
 				      link_conf, NULL, true);
 	if (err)
 		goto out;
@@ -2069,6 +2109,14 @@ mt7925_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 out:
 	mt792x_mutex_release(dev);
 
+	/* Release the grant now that the BSS is programmed. The GO keeps its
+	 * channel through the BSS_INFO RLM TLV, not through the ROC, and the FW
+	 * CNM arms a band-abort watchdog on GRANTED that asserts if the host
+	 * never sends the abort. Also covers the error paths above.
+	 */
+	if (roc_taken)
+		mt7925_abort_roc(mvif->phy, mconf);
+
 	return err;
 }
 
@@ -2156,8 +2204,10 @@ mt7925_change_chanctx(struct ieee80211_hw *hw,
 			struct ieee80211_bss_conf *link_conf;
 
 			link_conf = mt792x_vif_to_bss_conf(vif, mconf->link_id);
-			mt7925_mcu_set_chctx(mvif->phy->mt76, &mconf->mt76,
-					     link_conf, ctx);
+
+			if (mt7925_p2p_chanctx_bss_programmed(vif, link_conf))
+				mt7925_mcu_set_chctx(mvif->phy->mt76, &mconf->mt76,
+						     link_conf, ctx);
 
 			if (changed & IEEE80211_CHANCTX_CHANGE_PUNCTURING)
 				mt7925_mcu_set_eht_pp(mvif->phy->mt76, &mconf->mt76,
@@ -2186,6 +2236,15 @@ static void mt7925_mgd_prepare_tx(struct ieee80211_hw *hw,
 	if (info->was_assoc)
 		return;
 
+	/* P2P GC join: hold the channel for
+	 * MT7925_P2P_GC_JOIN_CH_REQ_INTERVAL_MS (4s) instead of the 1s
+	 * mac80211 default, because a GO is only listening on its operating
+	 * channel part of the time and the whole auth/assoc exchange has to
+	 * fit inside one grant.
+	 */
+	if (!info->duration && vif->p2p)
+		duration = MT7925_P2P_GC_JOIN_CH_REQ_INTERVAL_MS;
+
 	mt792x_mutex_acquire(dev);
 	mt7925_set_roc(mvif->phy, &mvif->bss_conf,
 		       mvif->bss_conf.mt76.ctx->def.chan, duration,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 056f7e2f284e..6ec74d7bfd82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -405,7 +405,9 @@ static void mt7925_mcu_roc_handle_grant(struct mt792x_dev *dev,
 
 	if (grant->reqtype == MT7925_ROC_REQ_ROC)
 		ieee80211_ready_on_channel(hw);
-	else if (grant->reqtype == MT7925_ROC_REQ_JOIN)
+	else if (grant->reqtype == MT7925_ROC_REQ_JOIN ||
+		 grant->reqtype == MT7925_ROC_REQ_GO_START_BSS ||
+		 dev->phy.roc_is_mlo)
 		ieee80211_iterate_active_interfaces_atomic(hw,
 						IEEE80211_IFACE_ITER_RESUME_ALL,
 						mt7925_mcu_roc_iter, grant);
@@ -1598,8 +1600,8 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf
  * The CNM channel-privilege request carries bw / center_chan / center_chan2 /
  * sco, and for a BSS-bound request they must match the BSS's own channel.
  * mt7925 only has a bare channel at this point, but for a BSS-bound
- * request (JOIN) the BSS's own chanctx already describes exactly that
- * channel, so use it.
+ * request (JOIN / GO_START_BSS) the BSS's own chanctx already describes
+ * exactly that channel, so use it.
  *
  * Everything else - an off-channel dwell (ROC / OFFCHNL_TX), or a request for a
  * channel that is not the one this BSS is parked on - keeps the previous 20 MHz
@@ -1611,7 +1613,7 @@ mt7925_mcu_roc_chandef(struct mt792x_bss_conf *mconf,
 		       enum mt7925_roc_req type,
 		       struct cfg80211_chan_def *chandef)
 {
-	if (type == MT7925_ROC_REQ_JOIN &&
+	if ((type == MT7925_ROC_REQ_JOIN || type == MT7925_ROC_REQ_GO_START_BSS) &&
 	    mconf->mt76.ctx && mconf->mt76.ctx->def.chan == chan) {
 		*chandef = mconf->mt76.ctx->def;
 		return;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 36cbeaedb7b2..e3eee41b22c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -73,15 +73,25 @@ enum mt7925_fw_chan_width {
 	MT7925_CW_320MHZ,
 };
 
+/* Channel-privilege request types. The values are part of the FW CNM
+ * interface (CH_REQ_TYPE_*), so do not renumber.
+ */
 enum mt7925_roc_req {
-	MT7925_ROC_REQ_JOIN,
-	MT7925_ROC_REQ_ROC,
-	MT7925_ROC_REQ_SUB_LINK,
+	MT7925_ROC_REQ_JOIN,			/* CH_REQ_TYPE_JOIN */
+	MT7925_ROC_REQ_ROC,			/* CH_REQ_TYPE_ROC */
+	MT7925_ROC_REQ_OFFCHNL_TX = 2,		/* CH_REQ_TYPE_OFFCHNL_TX */
+	MT7925_ROC_REQ_GO_START_BSS = 3,	/* CH_REQ_TYPE_GO_START_BSS */
+	MT7925_ROC_REQ_DFS_CAC = 4,		/* CH_REQ_TYPE_DFS_CAC */
 	MT7925_ROC_REQ_MLSR_AG = 10,
 	MT7925_ROC_REQ_MLSR_AA,
 	MT7925_ROC_REQ_NUM
 };
 
+/* CNM channel-privilege hold times, per role. */
+#define MT7925_SAP_CHNL_HOLD_TIME_MS		200	/* SAP_CHNL_HOLD_TIME_MS */
+#define MT7925_P2P_CHNL_HOLD_TIME_MS		3000	/* P2P_CHNL_HOLD_TIME_MS */
+#define MT7925_P2P_GC_JOIN_CH_REQ_INTERVAL_MS	4000	/* P2P_GC_JOIN_CH_REQUEST_INTERVAL */
+
 enum {
 	UNI_EVENT_ROC_GRANT = 0,
 	UNI_EVENT_ROC_GRANT_SUB_LINK = 4,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
index 4e41ba9beca1..f41098b324ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
@@ -427,3 +427,38 @@ void mt7925_p2p_bmc_remove(struct mt792x_dev *dev,
 	mt76_wcid_mask_clear(dev->mt76.wcid_mask, wcid->idx);
 }
 
+/* ------------------------------------------------------------------ */
+/* .change_chanctx gate                                                 */
+/* ------------------------------------------------------------------ */
+
+/* Is this link's BSS already programmed in FW on a granted channel, i.e. is an
+ * RLM-only BSS_INFO_UPDATE from .change_chanctx a genuine *channel update*?
+ *
+ * mac80211 runs ieee80211_link_use_channel() -> ieee80211_assign_link_chanctx()
+ * before .start_ap and before the auth exchange, and that path calls
+ * ieee80211_recalc_chanctx_min_def() -> drv_change_chanctx(). For a P2P link
+ * that is still coming up the resulting RLM TLV therefore reaches the FW
+ * *before* the channel privilege request: CNM creates its channel-info entry
+ * from a band it has to guess, because mconf->mt76.band_idx is still the 0xff
+ * "auto" value that only the ROC grant fills in (mt7925_mcu_roc_iter).
+ *
+ * Nothing is lost by skipping it: once the grant has supplied the real
+ * band_idx both roles send a full BASIC+RLM BSS_INFO_UPDATE anyway, and every
+ * later .change_chanctx (bandwidth change, CSA) passes the test.
+ */
+bool mt7925_p2p_chanctx_bss_programmed(struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *link_conf)
+{
+	if (!vif->p2p || !link_conf)
+		return true;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+		return link_conf->enable_beacon;	/* P2P GO */
+	case NL80211_IFTYPE_STATION:
+		return vif->cfg.assoc;			/* P2P GC */
+	default:
+		return true;
+	}
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
index 25b6c57749a2..f7af45ee4c1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
@@ -51,5 +51,7 @@ int mt7925_p2p_bmc_add(struct mt792x_dev *dev,
 		       struct mt792x_bss_conf *mconf);
 void mt7925_p2p_bmc_remove(struct mt792x_dev *dev,
 			   struct mt792x_bss_conf *mconf);
+bool mt7925_p2p_chanctx_bss_programmed(struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *link_conf);
 
 #endif /* __MT7925_P2P_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 66c8722220cc..94186e9f77c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -242,6 +242,7 @@ struct mt792x_phy {
 	wait_queue_head_t roc_wait;
 	u8 roc_token_id;
 	bool roc_grant;
+	bool roc_is_mlo;
 };
 
 struct mt792x_irq_map {
-- 
2.45.2

