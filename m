Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85EC231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543054; cv=none; b=Qwd85W65Ms1bGWqlb7eAaYHVqF4Xp6oCmoQ1ZaSGCmNA9VqIlqW08xuhwbeSWXelDC1vYQg85ElpJD9w3QN+EDyFQcpObsr1M9mM9dIwnhNpUVIYvHtgu8QPqoQ0cOJZJxd7hqbLKM/wSQy8w6vuwa9G4QGfRUGwTLCT27LQvfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543054; c=relaxed/simple;
	bh=t/8q/wiFsa4YRWNC9x+le5+x3PoKtlv3U9yeU77GIi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtuMWLUUxGfoqNMitjnCyYEDEqtSnQRJZFY12ot7AH+4+RlZXOJAtmtFbHheeHZ75PMx+z4QMlLztxsZw1b3OI/dmPqxvg02CEHNdWsESt5hb/KrQD0ABpXH1Ih5oFgo7ZsylEj91pfgE91yaPzFMT7ORB/Z6b+ln2B4nPkdevM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672f516c271so2026087d50.2
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543051; x=1791147851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u8CyGPpUHk1CF6deWIX2Eqf04ykxCmD/T/zMHytXwq0=;
        b=cEXQBsXwXQ/2tybZXnyw5tIxaomd6jd6bQ8nUqDw5x0vFqiKgDjSbqyLxaiM+jKybi
         TO9X1kh0Vapgey37x6F9gqYMiOKCoseb8xEIufqBLjI2znOo4vw8M+YAMWVeIm+q9IJt
         BavSQU8d3kkjkqNazjggaYj9iAWSsmlIQChNtyt00DWk+MaQth05X8usu9Hb6qtRewSh
         WnqnzqgwR/tAF6WyC6iNQR5vBRcCszCfmbU5WBcjn2H/h+wg6/vgHHFXdbMncENV3XHK
         zofDSj2I3AaELR+nF6L79Hru8t/ZqsUkmwsDMYRCLgM/R1w8YgpQ0mTVQ5sKtPO5zdEC
         3RGA==
X-Gm-Message-State: AFq9FYKwnz2OHi/JDZdNMJRTROTm2MWTlOZE8XRG38FKsxa62OOZmNxU
	SLA8/oYX2MoOuiWZnCg3WwqxVgo9kRx5wULTKkxJJIZYLlWqLZ2TMLWC
X-Gm-Gg: AYBFou2S6VFiHNVlVy9y0IuWeVeHWgtvueB6qWQX21Okn4S0GNpgldnC+dPD+KtswZQ
	IDgR78J07zg2cFyVKrlSTFhtTXkLlwxALFncTEMuxHd7ghMNwY5/Tm+JOmP6aw/rE9Znt3lGrEg
	hWAbIf5ev8UDEHdYkVgnRB4MTI88O2zPYRnpgIx6ylImBog16u5mcKml1a4mynUFrwXAu0Jpz0I
	Z9ywq9Z3BThi97i2EHlUFARhdjpHVnc5Mp/4k+xCCNJNTbs80z+9iX58iTZMphLXFX8pStRlIJy
	Ge2L9SIK/6eN+vKbu1D6NDk34zkcilRBAxU3SpSUwtLdsfIlgtc1dipukvxsB9mxvVUdoSOnLFp
	wIZLqWkbwoItHWEOSi6xtAO/vXZmrYBiMBMYuANYysDTy2JgqjoWra9IHqiQK8hx9rkpjKxJ00W
	p5J/oHvhh88PgTF9VuThSDADRA0qR2bo5vKRsCiMRVfRM/fegU8hMWStmDSDdZEtapgWCHp5h+C
	kZVzOjFNvzH49+YndU6+OsXBesyl+TylzMI7LYNZxtux3sXz0bCVhHsZmHtWqxxnaa3yQ==
X-Received: by 2002:a05:690e:1c1c:b0:672:e9ad:a823 with SMTP id 956f58d0204a3-672ed5a15bemr4809864d50.100.1790543051450;
        Sun, 27 Sep 2026 14:04:11 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:11 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 15/23] wifi: mt76: mt7925: hold NAN mgmt TX to the discovery window
Date: Sun, 27 Sep 2026 16:02:57 -0500
Message-ID: <20260927210306.737669-16-sean.wang@kernel.org>
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

Host-initiated NAN management - SDF follow-ups and the frames that open
an NDP setup - rides the interface WTBL and airs the moment the host
hands it over. Until its NDL is confirmed a peer is only reliably awake
in the discovery window, so those frames regularly land while it is off
channel. The same WTBL carries the beacons and the multicast data that
must never be held, so gating that queue is not an option.

Create a dedicated STA and steer host management TX onto it, so the
firmware can hold that one queue outside the DW while the interface
WTBL keeps flowing. The driver hands the STA's WTBL index down with
NAN_UNI_CMD_DW_WTBL_IDX right after the STA record is added - the index
is the handle the firmware's queue pause works on, so no reserved
address is agreed on and the record's address is an arbitrary locally
administered one that never goes on air. A firmware that predates the
tag ignores it, and on a failed handoff the firmware's gate stays
disarmed, so management TX degrades to stock (ungated) behavior rather
than breaking NAN. The split is done per frame: multicast stays on the
interface WTBL, since a STA-type WTBL spends the full retry budget on an
unACKable multicast RA and one frame then eats a whole DW window, and
only unencrypted unicast - discovery and NDP setup - is held to the DW.
Secured frames belong to an established peer and keep its own WTBL and
key.

MT_TXQ_PSD reaches ALTX and escapes the pause, so the existing NAN
reroute is extended to cover this WTBL. The STA record is driven to the
associated state with its rate table configured; without either the
firmware buffers the queue or the hardware falls back to the lowest rate,
both of which show up as management frames failing after seconds. On
teardown the wcid is released only after pending TX status entries are
flushed, or the next status sweep dereferences them (KASAN use-after-free
via wpdma_reset -> mt76_tx_status_check).

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  11 +-
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  11 ++
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 174 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |   8 +
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   |  48 +++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   7 +
 drivers/net/wireless/mediatek/mt76/tx.c       |   2 +-
 8 files changed, 250 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 62b41c8bb7c0..8122da3301ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -397,6 +397,7 @@ struct mt76_wcid {
 	u8 sta:1;
 	u8 sta_disabled:1;
 	u8 amsdu:1;
+	u8 nan_dw:1;
 	u8 phy_idx:2;
 	u8 link_id:4;
 	bool link_valid;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d494753cdf04..4dcb1fbda793 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1972,16 +1972,7 @@ mt7925_mcu_sta_state_v2_tlv(struct mt76_phy *mphy, struct sk_buff *skb,
 			    struct ieee80211_vif *vif,
 			    u8 rcpi, u8 sta_state)
 {
-	struct sta_rec_state_v2 {
-		__le16 tag;
-		__le16 len;
-		u8 state;
-		u8 rsv[3];
-		__le32 flags;
-		u8 vht_opmode;
-		u8 action;
-		u8 rsv2[2];
-	} __packed * state;
+	struct sta_rec_state_v2 *state;
 	struct tlv *tlv;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_STATE, sizeof(*state));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 11f9eac13ffc..212c8caadd0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -466,6 +466,17 @@ struct sta_rec_hdr_trans {
 	u8 rsv;
 } __packed;
 
+struct sta_rec_state_v2 {
+	__le16 tag;
+	__le16 len;
+	u8 state;
+	u8 rsv[3];
+	__le32 flags;
+	u8 vht_opmode;
+	u8 action;
+	u8 rsv2[2];
+} __packed;
+
 struct sta_rec_mld {
 	__le16 tag;
 	__le16 len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index e1dfcdc88382..715e080ce4ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -4,6 +4,7 @@
 #include <asm/byteorder.h>
 #include <linux/bitfield.h>
 #include <linux/errno.h>
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/string.h>
@@ -329,6 +330,167 @@ mt7925_nan_seed_link_sta(struct mt792x_dev *dev,
 	return nan_ctx;
 }
 
+/* Hand the DW-WTBL STA's WTBL index down to the firmware, which gates the
+ * queue by index alone - no address has to be agreed on. Until the index
+ * arrives the firmware's gate stays disarmed, so a failure here degrades
+ * to stock (ungated) management TX rather than breaking NAN.
+ */
+static int mt7925_nan_set_dw_wtbl_idx(struct mt792x_dev *dev, u16 wlan_idx)
+{
+	struct {
+		u8 rsv[4];
+		struct mt7925_nan_dw_wtbl_idx_tlv tlv;
+	} cmd = {
+		.tlv = {
+			.tag = cpu_to_le16(NAN_UNI_CMD_DW_WTBL_IDX),
+			.len = cpu_to_le16(sizeof(struct mt7925_nan_dw_wtbl_idx_tlv)),
+			.wlan_idx = cpu_to_le16(wlan_idx),
+		},
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(NAN), &cmd,
+				 sizeof(cmd), true);
+}
+
+/* Create the DW-WTBL STA and steer host mgmt TX onto it. The firmware is
+ * handed its WTBL index and holds that queue outside the DW, so unicast
+ * discovery only airs when every synced peer is awake. Best-effort: on
+ * failure the stock path keeps mgmt on the interface WTBL.
+ */
+static void mt7925_nan_dw_wcid_setup(struct mt792x_dev *dev,
+				     struct ieee80211_vif *vif)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt792x_bss_conf *mconf = &mvif->bss_conf;
+	struct mt76_wcid *own = &mvif->sta.deflink.wcid;
+	struct sta_rec_basic *basic;
+	struct mt76_txq *mtxq;
+	struct sk_buff *skb;
+	struct tlv *tlv;
+	int idx, ret;
+
+	if (mvif->nan_dw_wcid.idx > 0 &&
+	    mvif->nan_dw_wcid.idx < MT792x_WTBL_STA)
+		return;
+
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT792x_WTBL_STA - 1);
+	if (idx < 0)
+		goto err;
+
+	mvif->nan_dw_wcid.idx = idx;
+	mvif->nan_dw_wcid.phy_idx = own->phy_idx;
+	mvif->nan_dw_wcid.nan_dw = 1;
+	mvif->nan_dw_wcid.tx_info |= MT_WCID_TX_INFO_SET;
+	mt76_wcid_init(&mvif->nan_dw_wcid, mconf->mt76.band_idx);
+	mt7925_mac_wtbl_update(dev, idx, MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
+
+	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &mconf->mt76,
+					      &mvif->nan_dw_wcid,
+					      MT7925_STA_UPDATE_MAX_SIZE);
+	if (IS_ERR(skb))
+		goto err_free;
+
+	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_BASIC, sizeof(*basic));
+	basic = (struct sta_rec_basic *)tlv;
+	basic->conn_type = cpu_to_le32(CONNECTION_NAN);
+	basic->conn_state = CONN_STATE_PORT_SECURE;
+	basic->extra_info = cpu_to_le16(EXTRA_INFO_VER | EXTRA_INFO_NEW);
+	/* The record needs an address but nothing ever matches on it: frame
+	 * headers carry the real NMI/peer addresses and the firmware gates the
+	 * queue by WTBL index. Any locally administered address will do.
+	 */
+	eth_random_addr(basic->peer_addr);
+
+	/* A bare STA_REC leaves the WTBL rate table unconfigured and HW
+	 * unicast from it crawls (multi-second delivery). Give it the NAN
+	 * base rates: OFDM+ERP, no CCK.
+	 */
+	{
+		struct sta_rec_phy *phy;
+		struct sta_rec_ra_info *ra_info;
+
+		tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_PHY, sizeof(*phy));
+		phy = (struct sta_rec_phy *)tlv;
+		phy->phy_type = PHY_TYPE_BIT_OFDM | PHY_TYPE_BIT_ERP;
+		phy->basic_rate = cpu_to_le16(0x150);
+
+		tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_RA,
+					      sizeof(*ra_info));
+		ra_info = (struct sta_rec_ra_info *)tlv;
+		ra_info->legacy = cpu_to_le16(FIELD_PREP(RA_LEGACY_OFDM, 0xff));
+	}
+
+	/* Drive the record to the associated state: firmware buffers TX for
+	 * a STA that never left the initial state, which shows up as NAFs
+	 * sitting in the queue for seconds and then failing.
+	 */
+	{
+		struct sta_rec_state_v2 *state;
+
+		tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_STATE,
+					      sizeof(*state));
+		state = (struct sta_rec_state_v2 *)tlv;
+		state->state = MT76_STA_INFO_STATE_ASSOC;
+	}
+
+	ret = mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				    MCU_UNI_CMD(STA_REC_UPDATE), true);
+	if (ret)
+		goto err_free;
+
+	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->nan_dw_wcid);
+
+	/* Arm the firmware's DW gate for this WTBL index; on failure the gate
+	 * stays disarmed and management TX degrades to stock (ungated).
+	 */
+	ret = mt7925_nan_set_dw_wtbl_idx(dev, idx);
+	if (ret)
+		dev_warn(dev->mt76.dev,
+			 "NAN: DW-WTBL index handoff failed (%d)\n", ret);
+
+	if (vif->txq_mgmt) {
+		mtxq = (struct mt76_txq *)vif->txq_mgmt->drv_priv;
+		mtxq->wcid = idx;
+	}
+
+	dev_info(dev->mt76.dev, "NAN DW-WTBL up: wcid=%d\n", idx);
+	return;
+
+err_free:
+	mt76_wcid_cleanup(&dev->mt76, &mvif->nan_dw_wcid);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
+	mvif->nan_dw_wcid.idx = 0;
+err:
+	dev_warn(dev->mt76.dev, "NAN DW-WTBL setup failed, stock mgmt path\n");
+}
+
+/* Rebind host mgmt TX to the interface WTBL and drop the DW-WTBL STA.
+ * The firmware frees the STA record (and force-releases the gate) as
+ * part of NAN disable, so only the driver-side wcid is torn down here.
+ */
+static void mt7925_nan_dw_wcid_release(struct mt792x_dev *dev,
+				       struct ieee80211_vif *vif)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt76_txq *mtxq;
+	int idx = mvif->nan_dw_wcid.idx;
+
+	if (idx <= 0 || idx >= MT792x_WTBL_STA)
+		return;
+
+	if (vif->txq_mgmt) {
+		mtxq = (struct mt76_txq *)vif->txq_mgmt->drv_priv;
+		mtxq->wcid = mvif->sta.deflink.wcid.idx;
+	}
+
+	/* Flush TX-status entries still tracked on this wcid before it goes. */
+	mt76_tx_status_check(&dev->mt76, true);
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
+	mt76_wcid_cleanup(&dev->mt76, &mvif->nan_dw_wcid);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
+	mvif->nan_dw_wcid.idx = 0;
+}
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
@@ -338,6 +500,7 @@ int mt7925_nan_enable(struct ieee80211_vif *vif,
 	struct mt7925_nan_common_hdr *hdr;
 	struct mt7925_nan_enable_req_tlv *req;
 	struct sk_buff *skb;
+	int ret;
 
 	if (!vif || !dev || !conf)
 		return -EINVAL;
@@ -377,7 +540,13 @@ int mt7925_nan_enable(struct ieee80211_vif *vif,
 
 	mt7925_nan_update_conf(mvif, conf);
 
-	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
+	ret = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
+	if (ret)
+		return ret;
+
+	mt7925_nan_dw_wcid_setup(dev, vif);
+
+	return 0;
 }
 
 int mt7925_nan_disable(struct ieee80211_vif *vif, struct mt792x_dev *dev)
@@ -397,6 +566,9 @@ int mt7925_nan_disable(struct ieee80211_vif *vif, struct mt792x_dev *dev)
 	if (!dev)
 		return -EINVAL;
 
+	if (vif)
+		mt7925_nan_dw_wcid_release(dev, vif);
+
 	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 9a47940f5d61..415fd6b6f0e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -92,6 +92,7 @@ enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_SET_SYNC_RSSI		= 39,
 	NAN_UNI_CMD_SET_CLUSTER_ID		= 40,
 	NAN_UNI_CMD_KEY_MANAGEMENT		= 53,
+	NAN_UNI_CMD_DW_WTBL_IDX			= 55,
 };
 
 enum nan_uni_event_tag {
@@ -379,6 +380,13 @@ struct mt7925_nan_nmi_addr_tlv {
 	u8 reserved[2];
 } __packed __aligned(4);
 
+struct mt7925_nan_dw_wtbl_idx_tlv {
+	__le16 tag;
+	__le16 len;
+	__le16 wlan_idx;
+	u8 reserved[2];
+} __packed __aligned(4);
+
 struct mt7925_nan_avail_ctrl_tlv {
 	__le16 tag;
 	__le16 len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 8477d21abc66..5bdf3ebe6aef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -14,6 +14,8 @@ int mt7925e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
+	struct ieee80211_hdr *hdr = (void *)tx_info->skb->data;
+	struct ieee80211_vif *vif = info->control.vif;
 	struct mt76_connac_hw_txp *txp;
 	struct mt76_txwi_cache *t;
 	int id, pid;
@@ -25,6 +27,52 @@ int mt7925e_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
+	/* Split NAN mgmt TX per frame, by what is known about the destination.
+	 *
+	 * Multicast must not ride the DW-WTBL STA: a STA-type WTBL spends the
+	 * full retry budget on an unACKable multicast RA, so one frame eats a
+	 * whole DW window and the publish SDF queue backlogs.
+	 *
+	 * Unencrypted unicast to a peer we have no station for is first
+	 * contact (SDF, NDP request): the DW is the only rendezvous, so it
+	 * goes on the DW-WTBL and waits for it.
+	 *
+	 * Once its schedule is known - the peer station exists, which is also
+	 * when firmware holds its committed bitmap - the frame belongs on that
+	 * station instead. Firmware then airs it inside the peer's own
+	 * committed slots, where the peer is awake and the medium is not the
+	 * DW pile-up, and follows the FAW onto whatever channel the window
+	 * actually uses rather than being pinned to the DW channel.
+	 *
+	 * Secured frames belong to an established peer and keep its own WTBL
+	 * and key.
+	 */
+	if (vif && vif->type == NL80211_IFTYPE_NAN &&
+	    ieee80211_is_mgmt(hdr->frame_control)) {
+		struct mt792x_vif *mvif = (void *)vif->drv_priv;
+		bool mcast = is_multicast_ether_addr(hdr->addr1);
+
+		if (mcast && wcid == &mvif->nan_dw_wcid) {
+			wcid = &mvif->sta.deflink.wcid;
+		} else if (!mcast && !key &&
+			   mvif->nan_dw_wcid.idx &&
+			   mvif->nan_dw_wcid.idx < MT792x_WTBL_STA) {
+			struct ieee80211_sta *psta;
+			struct mt792x_sta *pmsta;
+
+			rcu_read_lock();
+			psta = ieee80211_find_sta(vif, hdr->addr1);
+			pmsta = psta ? (struct mt792x_sta *)psta->drv_priv :
+				       NULL;
+
+			if (pmsta && pmsta->deflink.wcid.idx)
+				wcid = &pmsta->deflink.wcid;
+			else
+				wcid = &mvif->nan_dw_wcid;
+			rcu_read_unlock();
+		}
+	}
+
 	t = (struct mt76_txwi_cache *)(txwi + mdev->drv->txwi_size);
 	t->skb = tx_info->skb;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 342733e1001c..ee462eab4028 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -288,6 +288,13 @@ struct mt792x_vif {
 	struct timer_list csa_timer;
 
 	struct mt792x_nan nan;
+
+	/* NAN DW-WTBL: driver-created STA the firmware gates to the DW;
+	 * host mgmt TX (SDF / pre-NDP NAF) is steered onto it so the BMC
+	 * WTBL carries multicast data only and is never paused for it.
+	 * idx == 0 or >= MT792x_WTBL_STA means not set up.
+	 */
+	struct mt76_wcid nan_dw_wcid;
 };
 
 struct mt792x_phy {
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index a3688b9fe635..72a4bc505aed 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -686,7 +686,7 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		 * which escapes the per-peer STA_PAUSE availability gating
 		 * and transmits regardless of the peer's committed bitmap.
 		 */
-		if (qid == MT_TXQ_PSD && wcid->sta &&
+		if (qid == MT_TXQ_PSD && (wcid->sta || wcid->nan_dw) &&
 		    info->control.vif &&
 		    (info->control.vif->type == NL80211_IFTYPE_NAN ||
 		     info->control.vif->type == NL80211_IFTYPE_NAN_DATA) &&
-- 
2.43.0

