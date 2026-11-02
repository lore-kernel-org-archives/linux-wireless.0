Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651928;
	b=GtlaXBT+nuHDW4eMyNd5J9nMFFtgcKmPCpxu2r7yWIX7W0xmkrWXFaPK4Q9kDxVKUS0Q
	 W6ctQf0K8dxl+e3+p3pcL79PhVzzm502I4PnaAMwIhkYx7doJ6wFx41S/6YtietBNSxUC
	 CSQx+0HFIfDJQUlPnUTRgIk8fHaYg19LlYPNBsSGQ9053XLFQlFbjaOCNHU/AUFn9fZyU
	 dK/bFBo2FRG2NWYNktBEKtAlEwOUc8COIBUbNtDNdsUFCBXYUeBNQ5uMZzZU2kKu1aYuI
	 OQRjBUinD/2hT2QlbTnmKDRG22pkRuvk5cgT0gJrV2VQepY6S9lLOZ9X3nFXpo8WRzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651928;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oZfVkYglp2cnNyGkrWUM7Mcdrg+Ti8irgS02Fa8b0Ig=;
	b=MXR9qsKnYnMU8yU26/2EyBaIZxuLbuhoyMwygltlySSDiOL9muKto+GTqy+eap21pa/L
	 3+Z0mJGWpLQnuW0g9LYh42PkBZg22IsWWX0FlcVG2UOyPR4N5GNIIg9C+4Ht3YmQo08IV
	 fpaurVjqr4ij+mxk/IPg3gBIlor18+1Yel6nyTsOKHpXtIW1/N9Pr9ATbBFeJ29wk6SNO
	 SVsriA9SmdBpmoxY4TdEZojq2KmuDwPQwNaD4xtZxicJprGf3d7PnCvc2Al8w4Zp4/fek
	 9+0N+x+rl8HuL9ibYGg6Kmw1oobb1jYLakbmJ5T3OXVL2hTpwMKwS2dxey7j+CGqQ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=n3kVib79;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E1F606EE97
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=n3kVib79
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=oZfVkYglp2cnNyGkrWUM7Mcdrg+Ti8irgS02Fa8b0Ig=;
	t=1793651927; x=1794861527; b=n3kVib790tbY69811JWBJJqU/QLz/uI+3mw/3uIl0Gawi4L
	+/q5e18LDGkzvjV0t3FF3WVXkhyaRp6ppgBCYW5MxKtLMQHf1iswH5rL8hhCGAPCsmtqXYrWLbJ8v
	h9WSqebPeUyHh3/uPD9zA8rPp4cE0D954ouF2upjTcA+c1SvTwWQVhy+hw0vwitn4Fpi+Sr5BvnLe
	5aqhVN5MxSdvYnPE9QsBjqcvdiA5G3KqXSU7jlO5wI630pKUULmS+xUGaRxOksod1Ve2D9lPoCjxe
	ypzUi301c2rehv1kL7t5vQvcvavygpZsa6qmCwtE/PS6A5e7DplRjKtFKJZjkQwQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynk-00000001vzr-42yu;
	Mon, 02 Nov 2026 21:38:45 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/30] wifi: mac80211: mesh: release frames from TXQs sleeping peers
Date: Mon,  2 Nov 2026 21:23:01 +0100
Message-ID: <20261102203831.1058362-43-johannes@sipsolutions.net>
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

Frames may be held on the TXQs of a mesh peer in powersave,
e.g. frames that were already queued when the peer entered
powersave. Release them in mesh peer service periods, and
consider them for more-data and service periods.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_ps.c  | 42 +++++++++++++++++++++++++++++------------
 net/mac80211/sta_info.c |  9 ++++-----
 net/mac80211/sta_info.h |  4 ++++
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 0ec207ee845b..0916de33e6a9 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -458,6 +458,7 @@ static void mpsp_qos_null_append(struct sta_info *sta,
 static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 {
 	struct ieee80211_local *local = sta->sdata->local;
+	unsigned long txq_buffered_tids;
 	int ac;
 	struct sk_buff_head frames;
 	struct sk_buff *skb;
@@ -465,18 +466,29 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 
 	skb_queue_head_init(&frames);
 
-	/* collect frame(s) from buffers */
+	if (n_frames < 0)
+		n_frames = INT_MAX;
+
+	txq_buffered_tids = ieee80211_sta_txq_buffered_tids(sta);
+
+	/*
+	 * collect frame(s) from buffers, frames on the TXQs were queued
+	 * before those on the PS buffer
+	 */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		while (n_frames != 0) {
-			skb = skb_dequeue(&sta->tx_filtered[ac]);
-			if (!skb) {
-				skb = skb_dequeue(
-					&sta->ps_tx_buf[ac]);
-				if (skb)
-					local->total_ps_buffered--;
-			}
-			if (!skb)
-				break;
+		while (n_frames > 0 &&
+		       (skb = skb_dequeue(&sta->tx_filtered[ac]))) {
+			n_frames--;
+			__skb_queue_tail(&frames, skb);
+		}
+
+		n_frames = ieee80211_sta_ps_dequeue_txqs(sta,
+				txq_buffered_tids & ieee80211_tids_for_ac(ac),
+				n_frames, &frames);
+
+		while (n_frames > 0 &&
+		       (skb = skb_dequeue(&sta->ps_tx_buf[ac]))) {
+			local->total_ps_buffered--;
 			n_frames--;
 			__skb_queue_tail(&frames, skb);
 		}
@@ -486,6 +498,9 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 			more_data = true;
 	}
 
+	if (ieee80211_sta_txq_buffered_tids(sta))
+		more_data = true;
+
 	/* nothing to send? -> EOSP */
 	if (skb_queue_empty(&frames)) {
 		mpsp_trigger_send(sta, false, true);
@@ -599,10 +614,13 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 	    (!elems->awake_window || !get_unaligned_le16(elems->awake_window)))
 		return;
 
-	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
+	if (!test_sta_flag(sta, WLAN_STA_MPSP_OWNER)) {
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
 					skb_queue_len(&sta->tx_filtered[ac]);
+		if (ieee80211_sta_txq_buffered_tids(sta))
+			buffer_local++;
+	}
 
 	if (!has_buffered && !buffer_local)
 		return;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 78a4c7d7ed1b..7175dfa41b01 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1081,7 +1081,7 @@ static inline bool __bss_tim_get(u8 *tim, u16 id)
 	return tim[id / 8] & (1 << (id % 8));
 }
 
-static unsigned long ieee80211_tids_for_ac(int ac)
+unsigned long ieee80211_tids_for_ac(int ac)
 {
 	/* If we ever support TIDs > 7, this obviously needs to be adjusted */
 	switch (ac) {
@@ -1099,7 +1099,7 @@ static unsigned long ieee80211_tids_for_ac(int ac)
 	}
 }
 
-static unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta)
+unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta)
 {
 	struct fq *fq = &sta->local->fq;
 	unsigned long tids = 0;
@@ -2099,9 +2099,8 @@ static bool ieee80211_sta_ps_frame_ends_bu(struct sk_buff *skb)
 	return !ieee80211_has_morefrags(hdr->frame_control);
 }
 
-static int ieee80211_sta_ps_dequeue_txqs(const struct sta_info *sta,
-					 unsigned long tids, int n_frames,
-					 struct sk_buff_head *frames)
+int ieee80211_sta_ps_dequeue_txqs(const struct sta_info *sta, unsigned long tids,
+				  int n_frames, struct sk_buff_head *frames)
 {
 	struct ieee80211_local *local = sta->local;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f3c22806cf6c..8edb95ccbfab 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -1004,6 +1004,10 @@ int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id);
 void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
+unsigned long ieee80211_tids_for_ac(int ac);
+unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta);
+int ieee80211_sta_ps_dequeue_txqs(const struct sta_info *sta, unsigned long tids,
+				  int n_frames, struct sk_buff_head *frames);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
 
-- 
2.56.0

