Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651921;
	b=5ohBDWJQVSq+LvlVLJZc2qulNsMeo5nWOxhU3qgyAakosaXgA5vv1J7eWLzQKdZqLNUH
	 I6hVaTEO1Hxh10WpLthdaMjpIUIlCar3dh1adS9CC/vQKi2Cf9vKtp0TU52KqkqMDulXR
	 unTz6szgccX5Xv//35x5VHFnF+GopVsJjLfWGJz9Jm34QP2Y8EL6bXXj6Z7UInBnWHBun
	 CWOhPZtXhkJfdVmZNyGidnK3A2QawRhVJAYWjRXA6pv/JZSdpbV2RSA9kGmRNkAdymsih
	 tspFW9h7v3XsuK7JsGyUPZypDDrjQ79tZ/dX+LDAK/Rvl0Qxligt95Yc9Amg0qCAOGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651921;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZCiShBDu/nL+TLmQzzq/Amk0Qa+jTKGidYUNOj4dHuo=;
	b=naHuXWzF+NHryGQoRCgXh1PJLIMAjgvHzNGFb2cxLBbGRx5uEl7LDuc+1ppHgz3NyFVk
	 zl75xaLn9NM8DCclGi8w+k1Gr3SR4fVMkFMmlZHlUkbc4VbpVIE6L2MsXOHlmAyKxBAVl
	 htmRZgAF27rgpWzGjGQoAjYhSXSmk8APZK7LNg2K+nFeVE9xXzWaq2qcVp5uEW4YnMhGq
	 tnmhryVy03EEUj4SA/JDjBKYajng5Eq8l5Oyqsuul2PZ1E/OgV3wLh7rtZw8hvptuWmUU
	 rWzfGW0I/w4zWM83XOLyhFquEZ/RGbB8FaHpIu8BDpHnLQNFQPkJgqZIl7rXtW80iVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=fpi9b+pc;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79288606A338
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=fpi9b+pc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ZCiShBDu/nL+TLmQzzq/Amk0Qa+jTKGidYUNOj4dHuo=;
	t=1793651920; x=1794861520; b=fpi9b+pcL26M2CByRJLwy9S6hzD48lBzry/MWdJBREaH5n4
	yp337Z25ECYXFnbfEwAn7ICmXerZTCDbgkUTDjFHW5Z1yb2ByqPr32LFu47w8uB0J1EZG6wCGx0JI
	4X4eoWBfsQshj8tTkGmfOGLriptO9g8+YwCMOZXeV7lFR2E6IdkdDTdiysvyH1YY7kTRqrKrj28jP
	hBViK6YqW2N6pVtEYhy1nZ2DrOeS4+uVgVsGfyrdpk7XbaByCPZPQj6pdvcPvbRFgIJJ/NteGsouu
	diFGJe6GdW32qbs/5kBPWlJghH0lGz3Kk7hp9pvRzBHL14PCuDD9OsOI+ffeF5Mw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynd-00000001vzr-2TWe;
	Mon, 02 Nov 2026 21:38:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/30] wifi: mt76: correctly set more-data flag on PS release
Date: Mon,  2 Nov 2026 21:22:53 +0100
Message-ID: <20261102203831.1058362-35-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

When releasing buffered frames, mt76_release_buffered_frames() only
sets the bit on frames that aren't last, but mac80211 might request
it to be set if there's more buffered, and there could also be some
on other TXQs. Handle that correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b022d3843473..89ecf6b5580f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -420,7 +420,7 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
 static void
 mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
-		  struct sk_buff *skb, bool last,
+		  struct sk_buff *skb, bool last, bool more_data,
 		  enum ieee80211_frame_release_type reason)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
@@ -437,7 +437,7 @@ mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
 			*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
 	}
 
-	mt76_skb_set_moredata(skb, !last);
+	mt76_skb_set_moredata(skb, more_data);
 	__mt76_tx_queue_skb(phy, MT_TXQ_PSD, skb, wcid, sta, NULL);
 }
 
@@ -451,6 +451,7 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 	struct mt76_dev *dev = phy->dev;
 	struct sk_buff *last_skb = NULL;
 	struct mt76_queue *hwq = phy->q_tx[MT_TXQ_PSD];
+	unsigned long release_tids = tids;
 	int i;
 
 	spin_lock_bh(&hwq->lock);
@@ -470,14 +471,24 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 			nframes--;
 			if (last_skb)
 				mt76_queue_ps_skb(phy, sta, last_skb, false,
-						  reason);
+						  true, reason);
 
 			last_skb = skb;
 		} while (nframes);
 	}
 
 	if (last_skb) {
-		mt76_queue_ps_skb(phy, sta, last_skb, true, reason);
+		for_each_set_bit(i, &release_tids, IEEE80211_NUM_TIDS) {
+			unsigned long frame_cnt;
+
+			if (more_data)
+				break;
+
+			ieee80211_txq_get_depth(sta->txq[i], &frame_cnt, NULL);
+			more_data = frame_cnt > 0;
+		}
+
+		mt76_queue_ps_skb(phy, sta, last_skb, true, more_data, reason);
 		dev->queue_ops->kick(dev, hwq);
 	} else {
 		ieee80211_sta_eosp(sta);
-- 
2.56.0

