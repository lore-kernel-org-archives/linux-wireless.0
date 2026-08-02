Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CBB3921FA
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785661106; cv=none; b=futWnqjG+D6Mbwbxa+9/DwOjzp48ny+sEAZnJGNIjHbIxsxRgx61kt8uq1D5NjcOo//owDjjUEzX2agC6wC/8imVzMMcuZU+q2JYLZ6ksSExOfWRwo8s0akw9S3AGpzSKMpJXZUjDdhZkwhGaM8LU6DtlvDDNoorwAmhc+TVEJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785661106; c=relaxed/simple;
	bh=3HSg/+CM6VhiNqIqHZ+LB3RYEalpOHUa5VYDytQpCC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrwHU8FboMDioDNq+416JddUXiLH1gEMKx+90t69qVAokCjPx1FHwzOvtnaSRty3z7/9CZOS2NTWfynhpqhhMg4LF4XaVrbrVc/c/y2DNies/6qtVPlWf2yscAeaQGU0lmPLvG5f2kksIP8G1W2hOUVcUYc9b7uB+enp85xFQlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gYgW5WHD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gYgW5WHD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=QWMQ/xX/znLd0lD65MvlBIiR9S+mMg/C2X2i73ps/tY=;
	t=1785661105; x=1786870705; b=gYgW5WHDkrv558NbpFfEgINOPdIwg1lWnDVXA9LpHf9/vS4
	SGE8KAgyB2DaMy8O77P2mOaM/TQq49XnXvj/yomXIxjm29qZ2YPB8UnbUmBSnIZxF9HDYDRzdoA3N
	XMUzTXXfQqvylFq8PSLd0knJEf3DPL9DXoz3lGFWNwoK2U2UXNtUZFrdNZ9T5dca2zStcKem1SbhJ
	8bZSaKyaF670LGB/5cVjgVPtkhLX9LCd1m/2ENjd5+y8zwmuDJL0QpdUm5aKbvGItkhCNpslsXbPZ
	OE99Ehtz9kuYV2j8p4o4M8+qznOtfvg8mMkcb348tfzeE6PTbKh7EpS4Zy3+l2gQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqS1W-00000004NaL-0RcQ;
	Sun, 02 Aug 2026 10:58:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/4] wifi: mac80211: fix key selection for encap offload frames
Date: Sun,  2 Aug 2026 10:57:19 +0200
Message-ID: <20260802105818.0feb7ad61047.Ia506ca211176a3c466bc60e4cc3e506df34a4a67@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802085818.1336616-6-johannes@sipsolutions.net>
References: <20260802085818.1336616-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_tx_h_select_key() assumes the frame is in 802.11 format
for picking the key, at least when there's no pairwise TK for the
STA to transmit with.

For unicast this is likely not relevant because if there's no
pairwise TK for the STA there's probably not going to be any other
key either. But multicast encapsulation offload frames have no
STA, so it looks at the ethernet header as if it was 802.11. This
may not matter very much since multicast encapsulation offload is
likely to ignore the key selection, but it's still wrong.

Create a separate selection function that doesn't (need to) look
at the frame header - it's data anyway, so either unicast to a
station (with sta pointer) or multicast. For MLO, the driver has
to duplicate the frame and select the key anyway, so just skip
it in that case entirely.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 44c40c98b497..2ef77bb80b92 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -592,6 +592,34 @@ ieee80211_select_link_key(struct ieee80211_tx_data *tx)
 	return NULL;
 }
 
+/*
+ * An 802.3 frame is always a data frame, so there are no 802.11 addresses to
+ * look at: with a station the pairwise key is all that can apply, without one
+ * the frame is group addressed. On an MLD the driver has to pick the group key
+ * itself, as the same frame goes out on several links that each have their own.
+ */
+static ieee80211_tx_result
+ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
+		return TX_CONTINUE;
+
+	if (tx->sta) {
+		tx->key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
+		if (!tx->key)
+			tx->key = rcu_dereference(tx->sdata->default_unicast_key);
+	} else if (!ieee80211_vif_is_mld(&tx->sdata->vif)) {
+		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
+	}
+
+	if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+		info->control.hw_key = &tx->key->conf;
+
+	return TX_CONTINUE;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
@@ -599,6 +627,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
+	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return ieee80211_select_key_8023(tx);
+
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
 		tx->key = NULL;
 		return TX_CONTINUE;
@@ -615,12 +646,6 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else
 		tx->key = NULL;
 
-	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
-		if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
-			info->control.hw_key = &tx->key->conf;
-		return TX_CONTINUE;
-	}
-
 	if (tx->key) {
 		bool skip_hw = false;
 
-- 
2.55.0

