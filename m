Received: from mail-yx2-f39.google.com (mail-yx2-f39.google.com [74.125.224.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A2838736C
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543027; cv=none; b=CUvizjTS4Zs4BOt0NYTvWDAzM7XxDcQrL78dd2N1NnHJvMYoxYZfQNWInng3yrHUG5x2Shbl3OUEr+I9ESChoNiqTw7M/ajaKXrXRsq8+iTcnwosxGlUPSz/tWuHUdyHyygjWPcfRTjhSEGUKLroTWAYLshUor0ycrSd0LoG8qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543027; c=relaxed/simple;
	bh=J2ib6KRMKOSSUBZxSJ14iaeufbxO4RYpNkahfZADc+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDK7J7qfFpXALjEfcYfW2niXquwPEqTiV0efWI/tXywJotdktDTfidnTR7gpFHJHsJo70w7jZUh09AfhUKL07h9xNsy1rXsmiaWCtnebc3Z5LI9Tz/Wc5fxlIi3OktJYo2Ma+zvJuc7E0Ki9qcIwRbYmejx9uXM/8Biszpb7h60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f39.google.com with SMTP id 00721157ae682-8a8f3f7ff7cso11683397b3.3
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543025; x=1791147825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UkhZ2kma8HhtbeCDUYXPoOTXgHUsrl8wufpj1Cp5KIo=;
        b=hXGbRHS8b57oIZr+hCs5+5wBLN1NQM/Kh8Af9M4U1gOd4jvy1iOkRkogWF7hR1AHQY
         IHr1xauTCW00QfvNwkw0jdBgq0XRc4rpMFFvmZ+lANluwMc435wYyOS+NSoccu+kfkpF
         pecHVzFqJI8AZfA6VayL3oHsLLAAYteMKYdBSGq66/4Al+nBkuDkRwpDlOCZdNXeeHdj
         UOZdaP1XDnr426PwYK/H2ICLy0unbXxue8WleLnN+ePtkBq6Gfli9e7jNHLpX04wK342
         EuBIeLk0XEVDD7JgTdLkfO29FiXEKcZx64afPeEGxDN8SVzExBbNo9jHRBH6kmCj4m5b
         fzjA==
X-Gm-Message-State: AFq9FYKzJ07H+dfTahMdHcSdS6avowrloNaIV6Jdoa5dnDtE8g6l3NLV
	NOjkuwEqG2eNaFB38Fpkt6XVKblRhg1g6/vi6mi11pUE/+zGvTSP0Sgw
X-Gm-Gg: AYBFou220ieIqy0wQh3nJsN7ixRw1WNSIFXHBEqZhF8rJ8ohkPxK9yjM9/Qk1OJeq3I
	y73uZbhLEEBOWBWREddWXUCrRa5xFPmdBFe2bU2HS1HzyFuJi7PNlshNk1LKkzfo8Uvcz7RcH0L
	hp/mVRGMeLHrhF7usZ4+wzEjNJ2cqMGl+SL/vBgujaUpCRJZ1fIl6pTQmzPWme+UsmfIMf+Dbz2
	yrWZ7Qcgy6ikg37N7dCuv+EPBXX+loUG8+5eWK293xCcb7+pMv2jC1oBeln88wXalxy5L1oXKK4
	wrjrleJ4TZmXbnHwBiMwoKH86ehCD5UORuYqO6e+PPD+k24FotxAHphkYHyfpyHdD7/uxnjvXAl
	nprJ+t7MNifh4Ew50DifY/wtQDECbOfl0JERf/KT91wmaz9gOHMvA2whLk1fHQyzvkth4Y8Vifl
	IJldRxqlWLuq7Tw/sXvcFN3FxomD2OdoRY6QLDUC+deURs93qABbes9Hft8Nj12+MX7Prcre85V
	D0fNR6KRcDXzgOgGUJeTMjzyBOfcHQzE0QZG+Zyh/DKu5DcpjUk/d72MUvRWgkbxY1f+Q==
X-Received: by 2002:a05:690c:c4fa:b0:8a8:7688:2d99 with SMTP id 00721157ae682-8a876885069mr40362257b3.26.1790543024585;
        Sun, 27 Sep 2026 14:03:44 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:44 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 08/23] wifi: mt76: mt7925: add NDC-aware TX GTK table for NAN_DATA
Date: Sun, 27 Sep 2026 16:02:50 -0500
Message-ID: <20260927210306.737669-9-sean.wang@kernel.org>
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

NAN TX GTK is NDC-scoped: every station in the same NAN Data Cluster
shares one key, and a single NAN_DATA vif can join multiple NDCs
concurrently. Add mt792x_nan.nan_tx_gtk_table[] (up to
MT792X_MAX_NAN_NDC = 8 RCU on-demand entries, one per NDC) and route
interface-directed NAN_DATA multicast through the matching WTBL in
mt792x_tx(), falling back to the interface WTBL when no entry exists.

Teardown lives in mt7925_remove_interface(), not the shared
mt792x_remove_interface(): NAN_DATA vifs are mt7925-only so cleanup
in the shared path would never run.

NOTE: NDC selection from skb context is not yet implemented; the
lookup always picks the first installed entry until mt7925_nan_set_key()
populates the table.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 36 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   | 64 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 27 ++++++--
 3 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 2d3bf7d806a7..1b253989f43b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -486,12 +486,22 @@ mt7925_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		INIT_DELAYED_WORK(&mvif->nan.mac_rand_work,
 				  mt7925_nan_mac_rand_work);
 
+	if (vif->type == NL80211_IFTYPE_NAN_DATA) {
+		/* nan_tx_gtk_table[] slots are NULL from mac80211's kzalloc of
+		 * drv_priv; entries are allocated on demand by set_key when a
+		 * TX GTK is installed.
+		 */
+		spin_lock_init(&mvif->nan.nan_tx_gtk_lock);
+	}
 out:
 	mt792x_mutex_release(dev);
 
 	return ret;
 }
 
+static void mt7925_nan_gtk_table_cleanup(struct mt792x_dev *dev,
+					 struct mt792x_vif *mvif);
+
 static void
 mt7925_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -516,6 +526,9 @@ mt7925_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	mconf = mt792x_link_conf_to_mconf(&vif->bss_conf);
 	mt792x_mac_link_bss_remove(dev, mconf, &mvif->sta.deflink);
 
+	if (vif->type == NL80211_IFTYPE_NAN_DATA)
+		mt7925_nan_gtk_table_cleanup(dev, mvif);
+
 	mt792x_mutex_release(dev);
 }
 
@@ -1331,6 +1344,29 @@ static void mt7925_nan_wcid_free(struct mt76_dev *mdev, struct mt76_wcid *wcid)
 	wcid->idx = MT792x_WCID_IDX_UNSET;
 }
 
+/* Free all TX GTK WTBL entries for a NAN_DATA vif on interface teardown.
+ * Caller must hold dev->mt76.mutex.
+ */
+static void mt7925_nan_gtk_table_cleanup(struct mt792x_dev *dev,
+					 struct mt792x_vif *mvif)
+{
+	int i;
+
+	for (i = 0; i < MT792X_MAX_NAN_NDC; i++) {
+		struct mt792x_nan_gtk_entry *e;
+
+		e = rcu_dereference_protected(mvif->nan.nan_tx_gtk_table[i],
+					      lockdep_is_held(&dev->mt76.mutex));
+		if (!e)
+			continue;
+		rcu_assign_pointer(mvif->nan.nan_tx_gtk_table[i], NULL);
+		rcu_assign_pointer(dev->mt76.wcid[e->wcid.idx], NULL);
+		mt76_wcid_cleanup(&dev->mt76, &e->wcid);
+		mt76_wcid_mask_clear(dev->mt76.wcid_mask, e->wcid.idx);
+		kfree(e);
+	}
+}
+
 /* Release any lazily-allocated per-peer NAN group key WTBLs for a departing
  * station.  Called from mt7925_mac_link_sta_remove() after the primary WTBL
  * is already freed, so the NAN-specific cleanup is clearly separated from the
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 707ca24193f9..342733e1001c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -155,7 +155,7 @@ struct mt792x_sta {
 	struct mt792x_sta_nan_sched nan_sched;
 
 	/* NAN per-peer group key WTBLs (allocated lazily when keys are installed)
-	 * Note: TX GTK is interface-level, see mt792x_vif->nan_tx_gtk_table
+	 * Note: TX GTK is interface-level, see mvif->nan.nan_tx_gtk_table
 	 */
 	struct mt76_wcid nan_rx_gtk_wcid;    /* NAN_DATA peer: RX GTK WTBL (per-peer) */
 	struct mt76_wcid nan_rx_igtk_wcid;   /* NAN peer: RX IGTK/BIGTK WTBL (per-peer) */
@@ -183,6 +183,60 @@ struct mt792x_nan_conf {
 	bool enable_dw_notification;
 };
 
+/*
+ * NAN WTBL layout (mt7925)
+ *
+ * TX scope -- determined by who shares the encrypting key:
+ *
+ *   mvif->sta.deflink.wcid          [NAN vif, interface-level]
+ *     TX IGTK/BIGTK: multicast management TX.  Shared by all NMI peers;
+ *     installed via the normal hardware key path (set_key fallback).
+ *
+ *   mvif->sta.deflink.wcid          [NAN_DATA vif, interface-level]
+ *     TX GTK fallback when nan.nan_tx_gtk_table[] has no entry for the NDC.
+ *
+ *   mvif->nan.nan_tx_gtk_table[i]->wcid [NAN_DATA vif, NDC-level, on-demand]
+ *     TX GTK: multicast data TX.  All peers in the same NAN Data Cluster
+ *     share one TX GTK; different NDCs use independent keys.  Each slot
+ *     is NULL until set_key installs a key for that NDC (up to
+ *     MT792X_MAX_NAN_NDC concurrent NDCs).
+ *     NOTE: currently returns -EOPNOTSUPP -- mac80211 does not pass an
+ *     NDC ID at set_key time, so the correct table slot cannot be
+ *     selected.
+ *
+ * RX scope -- always per-peer because each sender has its own key:
+ *
+ *   msta->deflink.wcid              [NMI or NDI peer, peer-level]
+ *     NM-TK (NMI unicast) or ND-TK (NDI unicast).
+ *
+ *   msta->nan_rx_gtk_wcid           [NDI peer under NAN_DATA vif, peer-level]
+ *     RX GTK: multicast data RX.  Keyidx 1-2; allocated lazily in set_key.
+ *
+ *   msta->nan_rx_igtk_wcid          [NMI peer under NAN vif, peer-level]
+ *     RX IGTK/BIGTK: multicast management RX.  Keyidx 4-7; allocated
+ *     lazily in set_key.
+ *
+ * Example -- 2 peers in different NDCs, full security (design intent):
+ *   1  NAN vif WTBL                 TX IGTK/BIGTK
+ *   1  NAN_DATA vif WTBL            TX GTK fallback
+ *   2  NMI peer WTBLs               NM-TK (one per peer)
+ *   2  NDI peer WTBLs               ND-TK (one per peer)
+ *   2  TX GTK WTBLs                 nan.nan_tx_gtk_table[], one per NDC
+ *   2  RX GTK WTBLs                 nan_rx_gtk_wcid, one per NDI peer
+ *   2  RX IGTK/BIGTK WTBLs          nan_rx_igtk_wcid, one per NMI peer
+ *  = 12 WTBLs total
+ *
+ * Maximum concurrent NDCs is based on NAN_MAX_CONN_CFG (8 peers).
+ */
+#define MT792X_MAX_NAN_NDC	8
+
+/* TX GTK WTBL for one NAN Data Cluster; allocated only when the key is installed */
+struct mt792x_nan_gtk_entry {
+	u8 ndc_id[ETH_ALEN];
+	struct mt76_wcid wcid;
+	u8 key_idx;
+};
+
 struct mt792x_nan {
 	struct mt792x_nan_conf conf;
 
@@ -208,6 +262,14 @@ struct mt792x_nan {
 	 */
 	struct delayed_work mac_rand_work;
 	u32 mac_rand_period_sec;
+
+	/* NAN_DATA TX GTK table (mt7925 only): one entry per NAN Data Cluster,
+	 * allocated on demand when set_key installs a TX GTK for that NDC.
+	 * Protected by nan_tx_gtk_lock; slots are NULL until populated.
+	 */
+	struct mt792x_nan_gtk_entry __rcu *nan_tx_gtk_table[MT792X_MAX_NAN_NDC];
+	/* Protects nan_tx_gtk_table. */
+	spinlock_t nan_tx_gtk_lock;
 };
 
 struct mt792x_vif {
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 0ad33f74c228..c8e42447f43a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -187,11 +187,30 @@ void mt792x_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		wcid = &mlink->wcid;
 	}
 
+	/* NAN_DATA multicast: route through the NDC-specific TX GTK WTBL.
+	 * Full WTBL layout is documented in mt792x.h.
+	 * NOTE: NDC selection is not yet implemented; always falls back to
+	 * the interface WTBL until set_key populates nan_tx_gtk_table[].
+	 */
 	if (vif && !control->sta) {
-		struct mt792x_vif *mvif;
-
-		mvif = (struct mt792x_vif *)vif->drv_priv;
-		wcid = &mvif->sta.deflink.wcid;
+		struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+
+		if (vif->type == NL80211_IFTYPE_NAN_DATA) {
+			struct mt792x_nan_gtk_entry *entry = NULL;
+			int i;
+
+			rcu_read_lock();
+			for (i = 0; i < MT792X_MAX_NAN_NDC; i++) {
+				entry = rcu_dereference(mvif->nan.nan_tx_gtk_table[i]);
+				if (entry)
+					break;
+			}
+			rcu_read_unlock();
+
+			wcid = entry ? &entry->wcid : &mvif->sta.deflink.wcid;
+		} else {
+			wcid = &mvif->sta.deflink.wcid;
+		}
 	}
 
 	if (vif && control->sta && ieee80211_vif_is_mld(vif) &&
-- 
2.43.0

