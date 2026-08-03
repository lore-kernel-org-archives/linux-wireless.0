Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE15409102
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 12:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760275; cv=none; b=SqQZd7/4Cmtb+NfLK9gopYP3YH3PZma6pkUDrvme5wkIDRvj9x05AGF4ViEYZDD+m+PyvHqQRkzpPZpxXr98hiwZg0JMriBmmxAKLaw56KKn8rC9zqvY1oa24rkU9mocpT1A13yhVhkR2wOAfqwPDI5Nr272+jJItXn6aScriHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760275; c=relaxed/simple;
	bh=XBfKh1ICi2IxoXxahqmIWvYK8jTKWf5Dtt2BzxGbxS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBp8eoY27oZRn2xX6s+NLGcw56eYze4WudSB8EF0VcZPDuK8glu/FENEPPOmyp94nv/pUgBaP6BEzmxQB5pP7NKwB7DadtisWapLaBDOEmd/UBSiGpK780CbP5+tBw8N9kqmkO6/Sc62jHO+cmypBzJeTyHAeXCxaNtNNTEPRF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nb0zNNWU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nb0zNNWU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=uUb98vWHY47x/OyJ3OvJ39TPtXY6vNFaXTjFWN1XWoE=;
	t=1785760274; x=1786969874; b=nb0zNNWUy/SE12jACnTJyuoTPoS9C6JTCYH9LIqxDNHujaw
	I6hd8J27S9/a2+c8WzfFt6hLUfF1MM16dmK4ie2SurkR7HHx7G9LkT9SvsSfCYEEkAL7jt5LYKGUJ
	7UegidjbQ8TD0HgNzDPllUuX/5o1eY24Q8JJ5j2QVTVRdE0Y00KvGQLP53AZ6uy8/Bmmt5dfx1P49
	4XVeHaoiDIbe7S1cMSseXt9zYWrA1eOGe0Lp41H6GnNdFhAfDVeMztKMYYh72EshyBLnPPRZ/7Pj/
	iSTNYZG9wYbKZInMpqzelo6+LoCTA/Nk3J9oMNReWT8iytGv/fsAU+kzbkHC3/oA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wqrp1-0000000CbZU-1Y2K;
	Mon, 03 Aug 2026 14:31:11 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v2 7/8] wifi: mac80211: pass station to ieee80211_tx_skb_tid
Date: Mon,  3 Aug 2026 14:30:12 +0200
Message-ID: <20260803143005.db3cc4b3a747.Ib7be90db0d3712d14e7a292023ff3d922baef860@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803123004.281626-10-benjamin@sipsolutions.net>
References: <20260803123004.281626-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The station may be relevant for queuing and will also generally be
resolved in some cases. However, we want to be able to prevent looking
up the station based on the address.

Add a station parameter, which can be set to the correct station, to an
error value to prevent station lookup or to NULL to get the old
behaviour where the address is used to find the appropriate station.

Also disable the station lookup for ieee80211_tx_skb_tid_band already as
it does not make any sense to find a station when doing an off-channel
transmit.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 net/mac80211/agg-tx.c      |  4 ++--
 net/mac80211/ht.c          |  2 +-
 net/mac80211/ieee80211_i.h | 11 +++++++----
 net/mac80211/offchannel.c  |  2 +-
 net/mac80211/rx.c          |  2 +-
 net/mac80211/tdls.c        |  2 +-
 net/mac80211/tx.c          | 10 ++++++----
 7 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 4833b46770b6..dd8a11ef6e52 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -98,7 +98,7 @@ static void ieee80211_send_addba_request(struct sta_info *sta, u16 tid,
 	if (sta->sta.deflink.he_cap.has_he)
 		ieee80211_add_addbaext(skb, 0, agg_size);
 
-	ieee80211_tx_skb_tid(sdata, skb, tid, -1);
+	ieee80211_tx_skb_tid(sdata, skb, NULL, tid, -1);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
@@ -127,7 +127,7 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					IEEE80211_TX_CTL_REQ_TX_STATUS;
-	ieee80211_tx_skb_tid(sdata, skb, tid, -1);
+	ieee80211_tx_skb_tid(sdata, skb, NULL, tid, -1);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index e1e1b7f82f3f..c5c2113fa4f7 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -545,7 +545,7 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 	info->status_data = IEEE80211_STATUS_TYPE_SMPS |
 			    u16_encode_bits(status_link_id << 2 | smps,
 					    IEEE80211_STATUS_SUBDATA_MASK);
-	ieee80211_tx_skb_tid(sdata, skb, 7, link_id);
+	ieee80211_tx_skb_tid(sdata, skb, NULL, 7, link_id);
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5761e9621491..0d8eb042887a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2463,7 +2463,8 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		    struct sta_info *sta, struct sk_buff *skb);
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
-				 struct sk_buff *skb, int tid, int link_id,
+				 struct sk_buff *skb, struct sta_info *sta,
+				 int tid, int link_id,
 				 enum nl80211_band band);
 
 static inline bool ieee80211_require_encrypted_assoc(__le16 fc,
@@ -2483,18 +2484,20 @@ ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  enum nl80211_band band)
 {
 	rcu_read_lock();
-	__ieee80211_tx_skb_tid_band(sdata, skb, tid, -1, band);
+	__ieee80211_tx_skb_tid_band(sdata, skb, ERR_PTR(-ENOENT),
+				    tid, -1, band);
 	rcu_read_unlock();
 }
 
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
-			  struct sk_buff *skb, int tid, int link_id);
+			  struct sk_buff *skb, struct sta_info *sta,
+			  int tid, int link_id);
 
 static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 				    struct sk_buff *skb)
 {
 	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
-	ieee80211_tx_skb_tid(sdata, skb, 7, -1);
+	ieee80211_tx_skb_tid(sdata, skb, NULL, 7, -1);
 }
 
 /**
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 7acef80d5f1f..5cec8747b193 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -1022,7 +1022,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	if (!need_offchan) {
-		ieee80211_tx_skb_tid(sdata, skb, 7, link_id);
+		ieee80211_tx_skb_tid(sdata, skb, NULL, 7, link_id);
 		ret = 0;
 		goto out_unlock;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index edf0e7700d0f..ed5a2e059075 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4106,7 +4106,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 					local->hw.offchannel_tx_hw_queue;
 		}
 
-		__ieee80211_tx_skb_tid_band(rx->sdata, nskb, 7, -1,
+		__ieee80211_tx_skb_tid_band(rx->sdata, nskb, rx->sta, 7, -1,
 					    status->band);
 	}
 
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index dc2f662fe4c4..e17d492be590 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1066,7 +1066,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
-		ieee80211_tx_skb_tid(sdata, skb, 7, link_id);
+		ieee80211_tx_skb_tid(sdata, skb, sta, 7, link_id);
 		return 0;
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a1e2c9e1565..6f52e8840237 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -6436,7 +6436,8 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 EXPORT_SYMBOL(ieee80211_unreserve_tid);
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
-				 struct sk_buff *skb, int tid, int link_id,
+				 struct sk_buff *skb, struct sta_info *sta,
+				 int tid, int link_id,
 				 enum nl80211_band band)
 {
 	const struct ieee80211_hdr *hdr = (void *)skb->data;
@@ -6488,12 +6489,13 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	 */
 	local_bh_disable();
 	IEEE80211_SKB_CB(skb)->band = band;
-	ieee80211_xmit(sdata, NULL, skb);
+	ieee80211_xmit(sdata, sta, skb);
 	local_bh_enable();
 }
 
 void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
-			  struct sk_buff *skb, int tid, int link_id)
+			  struct sk_buff *skb, struct sta_info *sta,
+			  int tid, int link_id)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	enum nl80211_band band;
@@ -6519,7 +6521,7 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
 		band = 0;
 	}
 
-	__ieee80211_tx_skb_tid_band(sdata, skb, tid, link_id, band);
+	__ieee80211_tx_skb_tid_band(sdata, skb, sta, tid, link_id, band);
 	rcu_read_unlock();
 }
 
-- 
2.55.0

