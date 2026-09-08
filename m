Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F9538D89
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870535; cv=none; b=Y4JK55CkimTaBCIGOh8I0t0yE0irvguPeVTvWrl2oEDOx81nelU3yYoSvQY8idEO6I/yjqvHChw/NUFaT9rTew+ZnEly77drBsQ2yvaWsWXVCiI0b6xHGD1mNoVVTUqC2qDkYC5tkQHpMO/g6gzNi4Pucm9lGCpNE+EToqyj5UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870535; c=relaxed/simple;
	bh=wk9+LgGW3NNQ/0AXAm762s7AMHsX/UzGJYrFdkt4WdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaZ3GfJB1uBBHXLFtu+IAXCpO4dPqDpjWLwyafV15WBETkiOjGy2hLwVHlmcI4gj+UA9tFev88334ceXsSuTkhAfjnWEKmDNhPKmUhE5hXe64Ih05I8qijT5szrAr0zVSCbVhi7x0BcWJ0v4zV8dOohafoKB0Jxi+0aONNi1zig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rMw11Owl; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rMw11Owl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oMfNS0yjGpE9TuLcJcLKaXkW8dvHjOmpoBAEykSjkdI=;
	t=1788870534; x=1790080134; b=rMw11OwlPDKfAch4B7Ggvm3xry8vcTtRGt6ctiCzPrUVFG+
	fRs2SC4JEj61quBOOTlWsmx0HlwIafFaFK27XG4ujHYkcP7ggdyCLjTHmy3xO1tu3NmbB9ES1lS9U
	RcbOEp1ivuLFlgIqgveDKFKtAQ50SdmlOLZ91Q1BksLsoGksXbonV9q3kCID+e1+mV7RX3ykP13GJ
	SIbvvPZ12ceuAeDX8lgGajUQIosvsBfY2zQElXWxm1l7X8ZWO8o2ArreoIOqR2j3XSyrflseidNSJ
	Gm3LkNjG7FYBeqVs1NEohLWiEJTYtL5zGKFMkWIHQ3FxCe9TuijAtZ9fetV7JdRg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwV-0000000670J-35hx;
	Tue, 08 Sep 2026 14:28:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH RESEND wireless 10/10] wifi: mac80211: set up the TX info early to fix failure paths
Date: Tue,  8 Sep 2026 14:28:21 +0200
Message-ID: <20260908122838.201719-22-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908122838.201719-12-johannes@sipsolutions.net>
References: <20260908122838.201719-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The previous commit 2c51457d930f ("wifi: mac80211: free ack status
frame on TX header build failure") cleaned up the leak, but still
left the code a bit messy and the failed SKB didn't get reported
to userspace.

Fix this up by initialising skb->cb[] earlier, which allows using
ieee80211_free_txskb() and therefore reports it for the failure
in ieee80211_build_hdr(), and unifies the ieee80211_skb_resize()
failure path with it.

Assisted-by: LLM
Fixes: c3e7724b6bc2 ("mac80211: use ieee80211_free_txskb to fix possible skb leaks")
Link: https://patch.msgid.link/20260904170057.bc197594e025.I2c7d9e50cc9abeb45b8dc1ba9411a3619cc92b10@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c343ed56506a..814399989b5e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2981,10 +2981,23 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	 */
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb)) {
-		ret = -ENOMEM;
-		goto free;
+		/* skb_share_check() already freed the skb */
+		if (info_id)
+			ieee80211_remove_ack_skb(local, info_id);
+		return ERR_PTR(-ENOMEM);
 	}
 
+	/* set this up so failure paths can clean up ack skb */
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+
+	info->flags = info_flags;
+	if (info_id) {
+		info->status_data = info_id;
+		info->status_data_idr = 1;
+	}
+	info->band = band;
+
 	hdr.frame_control = fc;
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;
@@ -3023,10 +3036,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
 		if (ieee80211_skb_resize(sdata, skb, head_need, ENCRYPT_DATA)) {
-			ieee80211_free_txskb(&local->hw, skb);
-			skb = NULL;
 			ret = -ENOMEM;
-			goto free;
+			goto free_txskb;
 		}
 	}
 
@@ -3053,16 +3064,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	skb_reset_mac_header(skb);
 
-	info = IEEE80211_SKB_CB(skb);
-	memset(info, 0, sizeof(*info));
-
-	info->flags = info_flags;
-	if (info_id) {
-		info->status_data = info_id;
-		info->status_data_idr = 1;
-	}
-	info->band = band;
-
 	if (likely(!cookie)) {
 		ctrl_flags |= u32_encode_bits(link_id,
 					      IEEE80211_TX_CTRL_MLO_LINK);
@@ -3086,16 +3087,17 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					     pre_conf_link_id, link_id);
 #endif
 			ret = -EINVAL;
-			goto free;
+			goto free_txskb;
 		}
 	}
 
 	info->control.flags = ctrl_flags;
 
 	return skb;
+ free_txskb:
+	ieee80211_free_txskb(&local->hw, skb);
+	return ERR_PTR(ret);
  free:
-	if (info_id)
-		ieee80211_remove_ack_skb(local, info_id);
 	kfree_skb(skb);
 	return ERR_PTR(ret);
 }
-- 
2.55.0

