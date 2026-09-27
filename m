Received: from mail-yx2-f31.google.com (mail-yx2-f31.google.com [74.125.224.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC2F379EEF
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543022; cv=none; b=EUwKBdAXMz1MVWy2m9Bpu0AdR2TIre0XYp9QFyMntP+A4CtceBjD8Kq/b7XNAHIKXHUS+k2fJzHDfx0veoisJYWTU6riTCTbZlBxF2jwvt+CViPH6Rsy4hFLWTbvU+YYWV4kuxNPoWd5j6z4WzF8QzoHQnsw8I9TfsRfh6Ffm+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543022; c=relaxed/simple;
	bh=4G9vEmxAsDCQVhqNAVSy/XJaQMpKKPNZQtiOhdVhWGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPk3N6I9EdeF5mdj9rVNhjdDTeu3CFm/gYv5GHd4/hvqldiG4ie9r8P6mi5LP/iBWgjI190PwZrtvkZN75WUg8zUrLkEVqk8/R8/lzni2ch8U8kokUH6THkQlcRaoDLnURndl9kWJgD1UZziC8w/Tsi/MkxQj/XhWUTKhRa1O7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f31.google.com with SMTP id 00721157ae682-8659af7454eso26107047b3.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543019; x=1791147819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xIz9ipdGqN0Ec+YYE5JVHummumioDMVEQAqS4Zma/O4=;
        b=homaDwz5RvfqtrI55eQnh4o0u3j8JV+l4G+e96XibwUSFtfvgwg5cFKq1+xUpv2aMZ
         q5Veaqp+OCnwW6EuohLhELcqWvk+gs6snqmYpqIaJ3LdmlchZgFhDwEDsAmjNFH2L1vy
         Cm2JjfjEMwYfpDWR4SHFAjSIMx73vJ37zTCWl3krwwkqZ6tC3J8POrHB0v4t5AGx0A9R
         oyGR2YuXrZfLi25U6Zt2/Ou0pdveJQTENWZjgnDxmRC/NmXISo0ZVKjEPsu2JDrkXH4d
         reM9m72iGZ4KCzaT9yuIXb544gEoRy17ISAFiOAomyR/qoR/doOWEr3pNKdsL5Xy+Jk9
         Fidw==
X-Gm-Message-State: AFq9FYKS+1E1XGVohlDk4/wLmMw/Ngi+HAF5hMsAukd/9X04WlcYzVTN
	bAzajq9plNeP7gLl7v7TBePJtvM9B6I2t/ePfemfymyeAzHCpsIIcJXK
X-Gm-Gg: AYBFou2x8YaLGdS20xEOhKqeB0a9sj0WDPxaMZ5fnFiJh1fiVEIKUc8axhldf1y2QmW
	pPymw78uG+FRtT65PZhJwwgTF0unnaAYKoVI8EjAkqA7X9Plcp6w8z6JLefwRq0EQbPKwfczMdX
	TxXgUVCYeob0h4fzRTVFS4oCOARiBRzji9nts0jHaDlTysZKSB8shzYZvrruqLYrzKl6F2iQfIj
	oXtyog7WgmOn8FDb9fSiBhaR0kJ5rlOiXljU/1+xb6KjN9qWod6WkMBx3xTK1HzjDfHE8+rswIe
	+lTzFthGXCobT/vPQPlq357y2onXhYPfGyTAM2nD7hW45L4lX2CiCXHh6OdnPUbgB2MLdFRyNK6
	C3hsaG1K3NwUv5XCVBa2K4kbGfBmZjVqpMhNOIWIX6bKILtcINYFZozi0GsLNIbrWEmUdUhg3do
	gsX1lsRasPxxpSOmzmOByTzC19CP0Frt1hPCccAY7s/cjp0yBbukQJr7v6KJxLisYeF3iJkAmst
	YQY5laa2m+SkJYHIJfewnvkHyY5Jrv+04E7ER7IJcN0AsrYYBZCrbNhUGtzQMR+evzIkA==
X-Received: by 2002:a05:690c:6e09:b0:8a8:5c3d:930 with SMTP id 00721157ae682-8a85c3d17fdmr34943737b3.0.1790543019500;
        Sun, 27 Sep 2026 14:03:39 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:38 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 07/23] wifi: mt76: mt7925: add per-peer RX IGTK/BIGTK and RX GTK WTBLs
Date: Sun, 27 Sep 2026 16:02:49 -0500
Message-ID: <20260927210306.737669-8-sean.wang@kernel.org>
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

From: Chengwei Yu <chengwei.yu@mediatek.com>

NAN RX group keys are per-peer: each NAN peer can carry an independent
IGTK/BIGTK, and each NAN_DATA peer an independent GTK. Add
nan_rx_igtk_wcid and nan_rx_gtk_wcid to mt792x_sta to hold dedicated
WTBL entries for these keys.

WTBLs are allocated lazily: mt7925_nan_sta_wcids_init() marks both
fields MT792x_WCID_IDX_UNSET at peer-add time, and
mt7925_nan_peer_wcids_free() releases whichever slots were actually
allocated at peer-remove time. Peers that never install a NAN group
key carry zero overhead.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 47 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   | 11 +++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 3e1c223e8da6..2d3bf7d806a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -923,6 +923,8 @@ mt7925_get_rates_table(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return mvif->basic_rates_idx;
 }
 
+static void mt7925_nan_sta_wcids_init(struct mt792x_sta *msta);
+
 static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_link_sta *link_sta,
@@ -1060,6 +1062,9 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 			goto out_pm;
 	}
 
+	if (vif->type == NL80211_IFTYPE_NAN || vif->type == NL80211_IFTYPE_NAN_DATA)
+		mt7925_nan_sta_wcids_init(msta);
+
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 
 	return 0;
@@ -1306,6 +1311,45 @@ int mt7925_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt7925_mac_sta_event);
 
+/* Mark per-peer NAN group key WTBLs as unallocated at station add time.
+ * Pairs with mt7925_nan_peer_wcids_free() at station remove time.
+ */
+static void mt7925_nan_sta_wcids_init(struct mt792x_sta *msta)
+{
+	msta->nan_rx_gtk_wcid.idx = MT792x_WCID_IDX_UNSET;
+	msta->nan_rx_igtk_wcid.idx = MT792x_WCID_IDX_UNSET;
+}
+
+/* Free a lazily-allocated per-peer NAN group key WTBL and reset its sentinel. */
+static void mt7925_nan_wcid_free(struct mt76_dev *mdev, struct mt76_wcid *wcid)
+{
+	u16 idx = wcid->idx;
+
+	rcu_assign_pointer(mdev->wcid[idx], NULL);
+	mt76_wcid_cleanup(mdev, wcid);
+	mt76_wcid_mask_clear(mdev->wcid_mask, idx);
+	wcid->idx = MT792x_WCID_IDX_UNSET;
+}
+
+/* Release any lazily-allocated per-peer NAN group key WTBLs for a departing
+ * station.  Called from mt7925_mac_link_sta_remove() after the primary WTBL
+ * is already freed, so the NAN-specific cleanup is clearly separated from the
+ * generic STA teardown path.
+ */
+static void mt7925_nan_peer_wcids_free(struct mt76_dev *mdev,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta)
+{
+	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
+
+	if (vif->type == NL80211_IFTYPE_NAN_DATA &&
+	    msta->nan_rx_gtk_wcid.idx != MT792x_WCID_IDX_UNSET)
+		mt7925_nan_wcid_free(mdev, &msta->nan_rx_gtk_wcid);
+
+	if (msta->nan_rx_igtk_wcid.idx != MT792x_WCID_IDX_UNSET)
+		mt7925_nan_wcid_free(mdev, &msta->nan_rx_igtk_wcid);
+}
+
 static void mt7925_mac_link_sta_remove(struct mt76_dev *mdev,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_link_sta *link_sta,
@@ -1350,6 +1394,9 @@ static void mt7925_mac_link_sta_remove(struct mt76_dev *mdev,
 	mt76_wcid_cleanup(mdev, wcid);
 	mt76_wcid_mask_clear(mdev->wcid_mask, idx);
 
+	if (vif->type == NL80211_IFTYPE_NAN || vif->type == NL80211_IFTYPE_NAN_DATA)
+		mt7925_nan_peer_wcids_free(mdev, vif, link_sta->sta);
+
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index fa28a77d12bb..707ca24193f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -18,6 +18,11 @@
 #define MT792x_WTBL_SIZE	20
 #define MT792x_WTBL_RESERVED	(MT792x_WTBL_SIZE - 1)
 #define MT792x_WTBL_STA		(MT792x_WTBL_RESERVED - MT792x_MAX_INTERFACES)
+/* Sentinel for a lazily-allocated wcid that has not yet been assigned a slot.
+ * U16_MAX is outside every valid alloc range and matches the 0xffff value
+ * used in mt76 DMA ring entries to mark an unused wcid field.
+ */
+#define MT792x_WCID_IDX_UNSET	U16_MAX
 
 #define MT792x_CFEND_RATE_DEFAULT	0x49	/* OFDM 24M */
 #define MT792x_CFEND_RATE_11B		0x03	/* 11B LP, 11M */
@@ -148,6 +153,12 @@ struct mt792x_sta {
 
 	/* NAN peer schedule */
 	struct mt792x_sta_nan_sched nan_sched;
+
+	/* NAN per-peer group key WTBLs (allocated lazily when keys are installed)
+	 * Note: TX GTK is interface-level, see mt792x_vif->nan_tx_gtk_table
+	 */
+	struct mt76_wcid nan_rx_gtk_wcid;    /* NAN_DATA peer: RX GTK WTBL (per-peer) */
+	struct mt76_wcid nan_rx_igtk_wcid;   /* NAN peer: RX IGTK/BIGTK WTBL (per-peer) */
 };
 
 DECLARE_EWMA(rssi, 10, 8);
-- 
2.43.0

