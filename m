Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953818;
	b=l2snWI45c2n44YrUxUPNL6GGaP4n5SFTUjAxsrdJEb64ev8fYKGlOGcKUxgsc7e2RqV/
	 kmolF5JoYoAvedDMQwbhIftf5F6DU7yDDVe8DfzjKIqswmtYcVCvf3helb7uIkP3AU354
	 W7MqT8QjYKXRrXf7Ijg5MXh+2YvfDUKoLbU2sY7D9OHJ1YHeMyMpB3gsfTangtbHTN7qD
	 V6KF6bXQdxtaJXQ4zUzM/UVH7QAcwf1xCM18HmaWqptWAxVZCiSkup3VKQc10l6fpdQtx
	 QigUx77m52Ig44hflhy8efQdzjk1CD+xg3nnWG8D0G9y0RSodugASW9C9XfJiwEK/NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953818;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=Onxhd/DO9QQu/MS7DnsUyIRjDUpepoFOd57MpnUZbFc=;
	b=QlOwPYjeadK88e7bDPJlnMF5LXouNw20BHFEET23ZIa7/6fhxu6/U1Ak/wkqZq2PJ5I3
	 z/NNFwOih4/SXIFSLXKjDQ0xIEgB/gXePo+Xu0TBoIEXo83tCOXfqrxbomWT8+BOs5T/7
	 9OxYRjD93PAYfbILRK+xPVJLmRGyikaBkfL8cNN9LLbp83gO8y5znYNf75JoXyWzCaHJq
	 FPnSx+GEIvsR6IVsDPMEjdveqPkFyJjbhX18n5lvKa/MqPcuD6a3IBpV4LM/fl7d+/YD+
	 p0aXCJE/q+3Y5lD+nNxpx0ETHanf61XMIVDAD4hOsQY1IcGcE916tdMBhmqps4lmZKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=XFwdw14H;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEC7606D80F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DEC7606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=XFwdw14H
X-UUID: 48f693c6d9bc11f1b1788b6acf885367-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Onxhd/DO9QQu/MS7DnsUyIRjDUpepoFOd57MpnUZbFc=;
	b=XFwdw14HR3eagCKRAUokHc/vZDWTMOsUr0eQtlKJszyu4UdZkxk5n5J+yHWRZ9LN1E9MU90Xrc3u/ibtLveNo0Mx+q7XQF0XtN7lmlqokdQB9GstMd30GAd/7ntNA8NhYLlaVF2udrC4Nxd3niad3lBBpg4MBD6dar3zI7xjSEE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:313894d5-10fe-4fe0-a195-8bcd26c92dc4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:73e574bb-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|136|836|865|888|898,TC:-5,Content:0|
	15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 48f693c6d9bc11f1b1788b6acf885367-20261106
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <james-ly.huang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 308104559; Fri, 06 Nov 2026 16:30:12 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 16:30:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Nov 2026 16:30:09 +0800
From: James-LY Huang <james-ly.huang@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<sean.wang@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<James-LY.Huang@mediatek.com>, james-ly huang <james-ly.huang@mediatek.com>
Subject: [PATCH v2 5/9] wifi: mt76: mt7925: describe the real chandef in ROC requests
Date: Fri, 6 Nov 2026 16:30:00 +0800
Message-ID: <20261106083004.3156085-6-james-ly.huang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
References: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
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

Resolve the full chandef behind the bare channel (mt7925_mcu_roc_chandef):
for a BSS-bound request the BSS's own chanctx already describes that
channel; everything else (off-channel dwell) keeps the 20 MHz NOHT
description, which is what a listen dwell actually uses. Program bw /
center_chan / center_chan2 accordingly, and derive sco from the
primary 40 MHz block instead of comparing against the center channel.

Map the nl80211 channel width to the fw ENUM_CHANNEL_WIDTH_T encoding
via mt7925_chandef_to_cw() and the new MT7925_CW_* enum (the fw casts
roc.bw straight to that enum, so CMD_CBW_* values must not be used).

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
v2: no change
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 88 +++++++++++++++++--
 .../wireless/mediatek/mt76/mt7925/mt7925.h    | 13 +++
 2 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 2ce403000765..056f7e2f284e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1593,11 +1593,57 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf
 				 &req, sizeof(req), true);
 }
 
+/* Resolve the full chandef behind a bare ieee80211_channel.
+ *
+ * The CNM channel-privilege request carries bw / center_chan / center_chan2 /
+ * sco, and for a BSS-bound request they must match the BSS's own channel.
+ * mt7925 only has a bare channel at this point, but for a BSS-bound
+ * request (JOIN) the BSS's own chanctx already describes exactly that
+ * channel, so use it.
+ *
+ * Everything else - an off-channel dwell (ROC / OFFCHNL_TX), or a request for a
+ * channel that is not the one this BSS is parked on - keeps the previous 20 MHz
+ * NOHT description, which is what a listen dwell actually uses anyway.
+ */
+static void
+mt7925_mcu_roc_chandef(struct mt792x_bss_conf *mconf,
+		       struct ieee80211_channel *chan,
+		       enum mt7925_roc_req type,
+		       struct cfg80211_chan_def *chandef)
+{
+	if (type == MT7925_ROC_REQ_JOIN &&
+	    mconf->mt76.ctx && mconf->mt76.ctx->def.chan == chan) {
+		*chandef = mconf->mt76.ctx->def;
+		return;
+	}
+
+	cfg80211_chandef_create(chandef, chan, NL80211_CHAN_NO_HT);
+}
+
+static u8 mt7925_chandef_to_cw(const struct cfg80211_chan_def *chandef)
+{
+	static const u8 width_to_cw[] = {
+		[NL80211_CHAN_WIDTH_20_NOHT] = MT7925_CW_20_40MHZ,
+		[NL80211_CHAN_WIDTH_20] = MT7925_CW_20_40MHZ,
+		[NL80211_CHAN_WIDTH_40] = MT7925_CW_20_40MHZ,
+		[NL80211_CHAN_WIDTH_80] = MT7925_CW_80MHZ,
+		[NL80211_CHAN_WIDTH_160] = MT7925_CW_160MHZ,
+		[NL80211_CHAN_WIDTH_80P80] = MT7925_CW_80P80MHZ,
+		[NL80211_CHAN_WIDTH_5] = MT7925_CW_5MHZ,
+		[NL80211_CHAN_WIDTH_10] = MT7925_CW_10MHZ,
+		[NL80211_CHAN_WIDTH_320] = MT7925_CW_320MHZ,
+	};
+
+	if (chandef->width >= ARRAY_SIZE(width_to_cw))
+		return 0;
+
+	return width_to_cw[chandef->width];
+}
+
 int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 		       struct ieee80211_channel *chan, int duration,
 		       enum mt7925_roc_req type, u8 token_id)
 {
-	int center_ch = ieee80211_frequency_to_channel(chan->center_freq);
 	struct mt792x_dev *dev = phy->dev;
 	struct {
 		struct {
@@ -1613,18 +1659,42 @@ int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 			.maxinterval = cpu_to_le32(duration),
 			.bss_idx = mconf->mt76.idx,
 			.control_channel = chan->hw_value,
-			.bw = CMD_CBW_20MHZ,
-			.bw_from_ap = CMD_CBW_20MHZ,
-			.center_chan = center_ch,
-			.center_chan_from_ap = center_ch,
 			.dbdcband = 0xff, /* auto */
 		},
 	};
+	struct cfg80211_chan_def chandef;
+	int center_ch, pri40_freq;
+	u8 bw;
+
+	mt7925_mcu_roc_chandef(mconf, chan, type, &chandef);
+	center_ch = ieee80211_frequency_to_channel(chandef.center_freq1);
+	bw = mt7925_chandef_to_cw(&chandef);
+
+	/* Describe the REAL chandef, not a 20 MHz stub: CNM uses bw / center_chan
+	 * to pick the band and to decide whether the request can share an existing
+	 * SCC.
+	 */
+	req.roc.bw = bw;
+	req.roc.bw_from_ap = bw;
+	req.roc.center_chan = center_ch;
+	req.roc.center_chan_from_ap = center_ch;
 
-	if (chan->hw_value < center_ch)
-		req.roc.sco = 1; /* SCA */
-	else if (chan->hw_value > center_ch)
-		req.roc.sco = 3; /* SCB */
+	if (chandef.center_freq2) {
+		u8 center_ch2 = ieee80211_frequency_to_channel(chandef.center_freq2);
+
+		req.roc.center_chan2 = center_ch2;
+		req.roc.center_chan2_from_ap = center_ch2;
+	}
+
+	/* Secondary channel offset of the PRIMARY 40 MHz block.
+	 * sco: 0 = SCN, 1 = SCA (secondary above), 3 = SCB (secondary below).
+	 */
+	if (nl80211_chan_width_to_mhz(chandef.width) >= 40) {
+		pri40_freq = cfg80211_chandef_primary(&chandef,
+						      NL80211_CHAN_WIDTH_40, NULL);
+		if (pri40_freq > 0)
+			req.roc.sco = chan->center_freq < pri40_freq ? 1 : 3;
+	}
 
 	switch (chan->band) {
 	case NL80211_BAND_6GHZ:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 636efe038392..36cbeaedb7b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -60,6 +60,19 @@ enum {
 	UNI_ROC_NUM
 };
 
+/* firmware channel width encoding (FW ENUM_CHANNEL_WIDTH_T), differs from
+ * CMD_CBW_*
+ */
+enum mt7925_fw_chan_width {
+	MT7925_CW_20_40MHZ,
+	MT7925_CW_80MHZ,
+	MT7925_CW_160MHZ,
+	MT7925_CW_80P80MHZ,
+	MT7925_CW_5MHZ,
+	MT7925_CW_10MHZ,
+	MT7925_CW_320MHZ,
+};
+
 enum mt7925_roc_req {
 	MT7925_ROC_REQ_JOIN,
 	MT7925_ROC_REQ_ROC,
-- 
2.45.2

