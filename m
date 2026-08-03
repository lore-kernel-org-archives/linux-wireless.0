Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AED34A79D
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785774472; cv=none; b=szRLgfC79wpTZ4htdQaNPtaq4dU/CRFtjtKGz31XDPNM//1rUae7LWXOEvQ1hsBdjolR692ymiqMN4utzSQr4fapLH+b0pjkbh23AyaDQs7E1gHl9xKrH7G7vvMJCOUbcSVnep7isTjOtfwofHSTICly6IMXaRQaxiD6uUsjIc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785774472; c=relaxed/simple;
	bh=VQo1bW0hm9hgY9T33j0TouICWPsJ4lrP07kth8h4+Vw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FBmMpmIjCOwGf7lYFwFn3/c/mnM/CGxcN7sgV7AGzu+VXG6uhx4hScc7codwjUU6zG3QYgGAeSXhuMNSFc8vLiYTf6cPGrVkq3Js9GogjrfnIVE4/VcvM6sQvCW5ZfUiZ+ShjS0P5+wd+HVEf2Cx/XG96ZrUIvgU5QItyXCsJ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTK8HXqV; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTK8HXqV"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cacf197759so52567865ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 09:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785774469; x=1786379269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TIiDESccwzblN/501hAeBpzSidh0kuFRQ/arO3hete4=;
        b=dTK8HXqVeRh7uc3Cz6xUGpWRc3EpuP0D6Pz6zkWoTPLrefM3qotOYa9udzH3slMK8i
         6w2/L/n2ohzOaLsdem4EHb+x7zgL0qSWMpWWHWlKgFghwFssWpgTRwNleSogc2PHRmjc
         P1vrCY0l7pgKl1TrlQvPRBu494K5pbaYouW2J8q8t6Os1lO4kwKlXlJsIXy9L/K+HeRB
         b0zmc/nwrDCfOi+EffVrH9w6riP7MHZ6xZ92b6fs+zTArzDTnnLynVboyEeb2GpYv/Tt
         KAAJLZnDm797eaer+YuvOe1er/vHCQSb/g6jtvjZIyDvHaNDkfBUo4VlxiWwXXR8x/1R
         uHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785774469; x=1786379269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TIiDESccwzblN/501hAeBpzSidh0kuFRQ/arO3hete4=;
        b=sdDiKAFCN2hyQ4SPnUq5g+/21BQSn2KgOW5jwHn+a3rFsnwYhn9KE1QJpyOH1sR2LC
         lYUiv4HzlJmMTV4WXNf+85MEzvdw22m/joCYdCWCchtDKf+LDNb0Z7XG2eFvDRk1afzI
         kfr++OxkNxPZcf6EXbqnzFiSk+FNGIjKUsc4biiK08Kjcv3XDrA13a2NaVoUonCyJlVQ
         iCr0tIEn6pyHyrPckQqsa4qaeZ4povvW2qzgce5n1sSCDP+glyZ1yimRYuY54611TUi/
         G+E+boZvkMXComs7bpXT8VcFDNEoZcebEYrP2Q17Z6o1vFEle8NMf9/e5sPb6hpR2gNP
         6g6Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro6OJGCyW/1jVYqNptPWoosvOTyV18eYFI/MC5S94kkyM3Xm2p8ufYDlU7H3rzPpNevCHzyMOQs8Vr943XVuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXwHb9hfnqEoVBLdNy6np6/BzmZ38s3Ereq6FEaxvNAZm3UlVw
	dbSvCppZWh0tdPNSYwKahBQpSM9vyJot3silRMRC50cEetaxe6zIjnpT
X-Gm-Gg: AR+sD10S2kQLTu+kiYCcIljLRoEdXUlUdOA35oBhmy6fZ9s16txMOrlliuD46l91TjM
	vR/K4BXG8ghS2bAiqcdDCw8a4q5DAP9hyYCzwh4e2DLKD6DROwK1wEAwzo2vzZYqFfTumH3vol5
	3YfchyT4OPqrwD4alKvXhl/J4TxI9Buyx3hN2CcvOKz49KPAIncYpzjDsdTwzj/n6LIewav723t
	RAo+tyZlfVYoB+iZXId7jXAUe/+nUhDGaSB2pEn/ESZQhcCvAIsnG+JRQ+2YL8H+l53ytvQOIii
	bteZvpGrBaGvrzke3bs2Nc2zxJlZFVH7PAOxHJeRJ0JJBp7779C2toOqZ1mN53BYvKkhRyF87u4
	oFWUkySqUUHClMDJrOlyLlGV2u6HxJUojNdYlOYQrl4B1cPewsvebfBr4o99xzfM0JFPOoSh+bP
	W4qUtdqlRP6L5FZUVC4po+v/NE76vlibpBAGUVbiVsNTOSNxcFhAPOIgHnBWG2KKqsLrKL4joyV
	ZOpkX/RC58uTgD+VNJy5Hqa/kSrDG/kmU3pZQhpcy1iJ1pix4L0ePLfKP6M4ra8FDa23boEq3qy
	6/Q2DyPSKrTLMGIo
X-Received: by 2002:a17:902:c409:b0:2c9:c46b:1286 with SMTP id d9443c01a7336-2d0523ea309mr108869215ad.34.1785774469345;
        Mon, 03 Aug 2026 09:27:49 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (61-228-195-211.dynamic-ip.hinet.net. [61.228.195.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b0ea23dsm40720275ad.44.2026.08.03.09.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 09:27:48 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: lkp@intel.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	Jeff Chen <jeff.chen_1@nxp.com>
Subject: [PATCH v2] wifi: nxpwifi: fix multiple static analysis errors and warnings
Date: Tue,  4 Aug 2026 00:27:41 +0800
Message-Id: <20260803162741.438820-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202608020855.QwN5n7i5-lkp@intel.com>
References: <202608020855.QwN5n7i5-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

Fix various development-phase bugs, code quality, and logical issues
reported by the kernel test robot (using the Smatch static analysis tool).

The following addressable fixes are included:

- 11n.c & 11ax.c: Fix potential NULL pointer dereferences by correcting
  logical operators (&& to ||) in 11n.c and hoisting the bss_desc
  verification to the top of the function in 11ax.c.
- 11n.c: Fix a severe Use-After-Free (UAF) memory corruption during RCU
  list traversal. Restore the proper list_for_each_entry_safe() loop
  structure along with the required array index [i] within the locked
  writer path.
- sdio.c: Fix a missing unwind resource cleanup pathway where a protocol
  error branch returned directly via -EINVAL instead of using
  'goto term_cmd', leaving the SDIO hardware state machine out of sync.
- main.h: Fix a signedness mismatch bug where nxpwifi_get_unused_bss_num()
  could return -2 as an unsigned integer fallback.
- util.c: Remove a redundant and dead condition check (position <= 15)
  which was always true for a 4-bit unsigned bit-field member variable.
- cfg80211.c: Clean up a dead unreachable 'return 0' at the bottom of the
  switch-case logic.
- uap_txrx.c: Clean up mismatched and inconsistent indentations within the
  handling of multicast RX forward paths.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608020855.QwN5n7i5-lkp@intel.com/
Assisted-by: Gemini:unknown-model
Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c     |  5 ++-
 drivers/net/wireless/nxp/nxpwifi/11n.c      |  7 +--
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 14 ++++--
 drivers/net/wireless/nxp/nxpwifi/main.c     |  2 +-
 drivers/net/wireless/nxp/nxpwifi/main.h     | 21 ++++++---
 drivers/net/wireless/nxp/nxpwifi/sdio.c     |  3 +-
 drivers/net/wireless/nxp/nxpwifi/uap_txrx.c |  4 +-
 drivers/net/wireless/nxp/nxpwifi/util.c     | 47 ++++++++++-----------
 8 files changed, 60 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index cc47c435eb70..96540914f3cf 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -413,7 +413,10 @@ bool nxpwifi_is_11ax_twt_supported(struct nxpwifi_private *priv,
 	struct nxpwifi_ie_types_he_cap *user_he_cap;
 	struct nxpwifi_ie_types_he_cap *hw_he_cap;
 
-	if (bss_desc && (!nxpwifi_is_ap_11ax_twt_supported(bss_desc))) {
+	if (!bss_desc)
+		return false;
+
+	if (!nxpwifi_is_ap_11ax_twt_supported(bss_desc)) {
 		nxpwifi_dbg(priv->adapter, MSG,
 			    "AP don't support twt feature\n");
 		return false;
diff --git a/drivers/net/wireless/nxp/nxpwifi/11n.c b/drivers/net/wireless/nxp/nxpwifi/11n.c
index e46c5053d509..c2a54d781b42 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n.c
@@ -451,7 +451,7 @@ void
 nxpwifi_11n_delete_tx_ba_stream_tbl_entry(struct nxpwifi_private *priv,
 					  struct nxpwifi_tx_ba_stream_tbl *tbl)
 {
-	if (!tbl && nxpwifi_is_tx_ba_stream_ptr_valid(priv, tbl))
+	if (!tbl || nxpwifi_is_tx_ba_stream_ptr_valid(priv, tbl))
 		return;
 
 	nxpwifi_dbg(priv->adapter, INFO,
@@ -694,7 +694,7 @@ int nxpwifi_get_tx_ba_stream_tbl(struct nxpwifi_private *priv,
 /* Delete Tx BA stream entry by RA. */
 void nxpwifi_del_tx_ba_stream_tbl_by_ra(struct nxpwifi_private *priv, u8 *ra)
 {
-	struct nxpwifi_tx_ba_stream_tbl *tbl;
+	struct nxpwifi_tx_ba_stream_tbl *tbl, *tmp;
 	int i;
 
 	if (!ra)
@@ -702,7 +702,8 @@ void nxpwifi_del_tx_ba_stream_tbl_by_ra(struct nxpwifi_private *priv, u8 *ra)
 
 	for (i = 0; i < MAX_NUM_TID; i++) {
 		spin_lock_bh(&priv->tx_ba_stream_tbl_lock[i]);
-		list_for_each_entry_rcu(tbl, &priv->tx_ba_stream_tbl_ptr[i], list)
+		list_for_each_entry_safe(tbl, tmp,
+					 &priv->tx_ba_stream_tbl_ptr[i], list)
 			if (!memcmp(tbl->ra, ra, ETH_ALEN))
 				nxpwifi_11n_delete_tx_ba_stream_tbl_entry(priv, tbl);
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index c820f08d2835..5cc8cdf594d3 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -717,6 +717,7 @@ nxpwifi_init_new_priv_params(struct nxpwifi_private *priv,
 			     enum nl80211_iftype type)
 {
 	struct nxpwifi_adapter *adapter = priv->adapter;
+	int ret;
 
 	nxpwifi_init_priv(priv);
 
@@ -740,7 +741,15 @@ nxpwifi_init_new_priv_params(struct nxpwifi_private *priv,
 		return -EOPNOTSUPP;
 	}
 
-	priv->bss_num = nxpwifi_get_unused_bss_num(adapter, priv->bss_type);
+	ret = nxpwifi_get_unused_bss_num(adapter, priv->bss_type,
+					 &priv->bss_num);
+
+	if (ret) {
+		nxpwifi_dbg(adapter, ERROR,
+			    "%s: no unused bss_num for type %d\n",
+			    dev->name, priv->bss_type);
+		return ret;
+	}
 
 	flush_workqueue(adapter->workqueue);
 	atomic_set(&adapter->iface_changing, 0);
@@ -943,7 +952,6 @@ nxpwifi_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		case NL80211_IFTYPE_STATION:
 			return nxpwifi_change_vif_to_sta(dev, curr_iftype,
 							 type, params);
-			break;
 		default:
 			goto errnotsupp;
 		}
@@ -952,8 +960,6 @@ nxpwifi_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 		goto errnotsupp;
 	}
 
-	return 0;
-
 errnotsupp:
 	nxpwifi_dbg(priv->adapter, ERROR,
 		    "unsupported interface type transition: %d to %d\n",
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index 4e01f45f3a00..b4c63829024a 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -204,7 +204,7 @@ static bool nxpwifi_drain_tx(struct nxpwifi_adapter *adapter)
 					  NXPWIFI_ASYNC_CMD);
 			adapter->hs_activated_manually = false;
 		}
-			nxpwifi_process_bypass_tx(adapter);
+		nxpwifi_process_bypass_tx(adapter);
 		if (adapter->hs_activated) {
 			clear_bit(NXPWIFI_IS_HS_CONFIGURED,
 				  &adapter->work_flags);
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.h b/drivers/net/wireless/nxp/nxpwifi/main.h
index 349dfa4d3f85..b25a6a4f2936 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.h
+++ b/drivers/net/wireless/nxp/nxpwifi/main.h
@@ -1166,8 +1166,9 @@ nxpwifi_get_priv(struct nxpwifi_adapter *adapter,
 }
 
 /* find unused BSS number for new interface */
-static inline u8
-nxpwifi_get_unused_bss_num(struct nxpwifi_adapter *adapter, u8 bss_type)
+static inline int
+nxpwifi_get_unused_bss_num(struct nxpwifi_adapter *adapter, u8 bss_type,
+			   u8 *bss_num)
 {
 	u8 i, j;
 	int index[NXPWIFI_MAX_BSS_NUM];
@@ -1179,9 +1180,14 @@ nxpwifi_get_unused_bss_num(struct nxpwifi_adapter *adapter, u8 bss_type)
 		      NL80211_IFTYPE_UNSPECIFIED)) {
 			index[adapter->priv[i]->bss_num] = 1;
 		}
-	for (j = 0; j < NXPWIFI_MAX_BSS_NUM; j++)
-		if (!index[j])
-			return j;
+
+	for (j = 0; j < NXPWIFI_MAX_BSS_NUM; j++) {
+		if (!index[j]) {
+			*bss_num = j;
+			return 0;
+		}
+	}
+
 	return -ENOENT;
 }
 
@@ -1195,8 +1201,9 @@ nxpwifi_get_unused_priv_by_bss_type(struct nxpwifi_adapter *adapter,
 	for (i = 0; i < adapter->priv_num; i++)
 		if (adapter->priv[i]->bss_mode ==
 		   NL80211_IFTYPE_UNSPECIFIED) {
-			adapter->priv[i]->bss_num =
-				nxpwifi_get_unused_bss_num(adapter, bss_type);
+			if (nxpwifi_get_unused_bss_num(adapter, bss_type,
+						       &adapter->priv[i]->bss_num))
+				return NULL;
 			break;
 		}
 
diff --git a/drivers/net/wireless/nxp/nxpwifi/sdio.c b/drivers/net/wireless/nxp/nxpwifi/sdio.c
index d8536354f093..8ef0f6eb49e2 100644
--- a/drivers/net/wireless/nxp/nxpwifi/sdio.c
+++ b/drivers/net/wireless/nxp/nxpwifi/sdio.c
@@ -1347,7 +1347,8 @@ static int nxpwifi_process_int_status(struct nxpwifi_adapter *adapter, u8 sdio_i
 			     ((rx_blocks * NXPWIFI_SDIO_BLOCK_SIZE) >
 			      card->mpa_rx.buf_size))) {
 				nxpwifi_dbg(adapter, ERROR, "invalid rx_len=%d\n", rx_len);
-				return -EINVAL;
+				ret = -EINVAL;
+				goto term_cmd;
 			}
 
 			rx_len = (u16)(rx_blocks * NXPWIFI_SDIO_BLOCK_SIZE);
diff --git a/drivers/net/wireless/nxp/nxpwifi/uap_txrx.c b/drivers/net/wireless/nxp/nxpwifi/uap_txrx.c
index f3d24bf861ca..840dddfc4f5a 100644
--- a/drivers/net/wireless/nxp/nxpwifi/uap_txrx.c
+++ b/drivers/net/wireless/nxp/nxpwifi/uap_txrx.c
@@ -246,8 +246,8 @@ int nxpwifi_handle_uap_rx_forward(struct nxpwifi_private *priv,
 		} else {
 			nxpwifi_dbg(adapter, ERROR,
 				    "failed to copy skb for uAP\n");
-				    priv->stats.rx_dropped++;
-				    dev_kfree_skb_any(skb);
+			priv->stats.rx_dropped++;
+			dev_kfree_skb_any(skb);
 			return -ENOMEM;
 		}
 	} else {
diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index 29ef031f8ec9..bbfefb81d8d3 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -799,34 +799,33 @@ int nxpwifi_recv_packet_to_monif(struct nxpwifi_private *priv,
 		__le16 acc_le;
 		u8 flags = 0;
 
-		if (ext.timestamp.position <= 15) {
-			hdr->it_present |= cpu_to_le32(BIT(IEEE80211_RADIOTAP_TIMESTAMP));
-			off = ALIGN(off, 8);
-
-			if (ext.timestamp.flags & 0x01) {
-				flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_32BIT;
-				ts = (u32)ext.timestamp.device_timestamp;
-			} else {
-				flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_64BIT;
-				ts = ext.timestamp.device_timestamp;
-			}
+		hdr->it_present |=
+			cpu_to_le32(BIT(IEEE80211_RADIOTAP_TIMESTAMP));
+		off = ALIGN(off, 8);
 
-			ts_le = cpu_to_le64(ts);
-			memcpy(rthdr + off, &ts_le, sizeof(ts_le));
-			off += sizeof(ts_le);
+		if (ext.timestamp.flags & 0x01) {
+			flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_32BIT;
+			ts = (u32)ext.timestamp.device_timestamp;
+		} else {
+			flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_64BIT;
+			ts = ext.timestamp.device_timestamp;
+		}
 
-			if (ext.timestamp.flags & 0x02) {
-				accuracy = ext.timestamp.accuracy;
-				flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_ACCURACY;
-			}
+		ts_le = cpu_to_le64(ts);
+		memcpy(rthdr + off, &ts_le, sizeof(ts_le));
+		off += sizeof(ts_le);
 
-			acc_le = cpu_to_le16(accuracy);
-			memcpy(rthdr + off, &acc_le, sizeof(acc_le));
-			off += sizeof(acc_le);
-			rthdr[off++] = (ext.timestamp.unit & 0x0f) |
-					((ext.timestamp.position & 0x0f) << 4);
-			rthdr[off++] = flags;
+		if (ext.timestamp.flags & 0x02) {
+			accuracy = ext.timestamp.accuracy;
+			flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_ACCURACY;
 		}
+
+		acc_le = cpu_to_le16(accuracy);
+		memcpy(rthdr + off, &acc_le, sizeof(acc_le));
+		off += sizeof(acc_le);
+		rthdr[off++] = (ext.timestamp.unit & 0x0f) |
+				((ext.timestamp.position & 0x0f) << 4);
+		rthdr[off++] = flags;
 	}
 
 	if (format == NXPWIFI_RATE_FORMAT_HE && has_ext) {

base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
-- 
2.34.1

