Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CA236AB77
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233403; cv=none; b=u511rIOXumkYxY36aCD0yx1gsDN+eePgMcAdSwkc2vDmuwd+ePfqWmh56INSEEO7lcyel35xzCem/AdJ1GMcuO7iQoRRdqmBJ6Yj6HDscN6Z7IWQ/R13Br59Eat8Milyi3rUEESyvwYLaWPB33w4ACxPTP/XMpOY7jSHPMhR2qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233403; c=relaxed/simple;
	bh=BDkRmWp3yH04s1t36wgYkhPesvga+QSKj/Igljv5nME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbzBVSmwWrpZylA5V0UulZoLJIDCwFleysQkBdYd9gtlh5eNoU8YQYtsIFhnmgOO0rQJwaVAxT6V5/HpFICGH7fGFt0PtEfuN6IyzgCAbMQOo1QNH2ViAKyLOA9cFlg+7CFpo3BRiJGUwVXdnnpclF6LbaoSTW8yI9lBE5+Y3Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nEonrEr2; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nEonrEr2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=IcTs8hTcRcGZt4jkRM1EJRdAES5LZBoHijwL9jfZ9rI=;
	t=1791233401; x=1792443001; b=nEonrEr2aZn8sx3rPRiox7YWrK8AvP+DN7jrDB59Iv4KZcM
	9tBYdpSDDqpPCdb7iMn8PVZiAxkRJ+LV68nGzL0ZHAXX3s6ceiSD5/tVyIDFInZ6JsLMC/bHn6Ltv
	78vTu7MWhgDSi7byB0sNDq1g60JaPqSJ+8mXooTgW31JqcA/w9q3LUZ0GozTvaXIW3vl7uTDa9czZ
	VZZPj0lvrfpoLxyAAzCwExctjAVIOMQTIhLaJUdVb2OvFaSrfs/4saSii/lkt3toeCPQL9RDCQIIq
	NeQjYA6g1y4gQR8bpTANC7o9/evtOPQmGSDUA+9X48lCjhzCDDRSMByrC/ipjlgw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdG-00000005cw8-3bpo;
	Mon, 05 Oct 2026 22:49:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/10] wifi: mac80211: fix mbssid/rnr allocation in beacon data
Date: Mon,  5 Oct 2026 22:47:59 +0200
Message-ID: <20261005224950.2f554b2c7c10.Ie961eb6b1435f956446e052936258758b966c67f@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

These structs are placed after the tail, but that can make
them unaligned. Change the order so the structs are after
one another, and then followed by the head/tail/elements.

Assisted-by: LLM
Fixes: 2b3171c6fe0a ("mac80211: MBSSID beacon handling in AP mode")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 53 +++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 69002d740a58..d0d14f621588 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1511,6 +1511,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
 	int size, err;
+	u8 *pos;
 	u64 _changed = BSS_CHANGED_BEACON;
 	struct ieee80211_bss_conf *link_conf = link->conf;
 
@@ -1538,20 +1539,16 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
-		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (params->rnr_ies) {
-			rnr = params->rnr_ies;
-			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
-		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
-							mbssid->cnt);
+		rnr = params->rnr_ies;
 	} else if (old && old->mbssid_ies) {
 		mbssid = old->mbssid_ies;
+		rnr = old->rnr_ies;
+	}
+
+	if (mbssid) {
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old->rnr_ies) {
-			rnr = old->rnr_ies;
+		if (rnr)
 			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
 	}
@@ -1563,26 +1560,38 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	/* start filling the new info now */
 
 	/*
-	 * pointers go into the block we allocated,
-	 * memory is | beacon_data | head | tail | mbssid_ies | rnr_ies
+	 * pointers go into the block we allocated, the order in memory is
+	 *  - struct beacon_data
+	 *  - struct mbssid_ies (including variable array)
+	 *  - struct rnr_ies (including variable array)
+	 *  - beacon head
+	 *  - beacon tail
+	 *  - mbssid/rnr elements
+	 * so that the structs (which contain pointers) are all aligned
 	 */
-	new->head = ((u8 *) new) + sizeof(*new);
-	new->tail = new->head + new_head_len;
-	new->head_len = new_head_len;
-	new->tail_len = new_tail_len;
-	/* copy in optional mbssid_ies */
+	pos = (u8 *)(new + 1);
 	if (mbssid) {
-		u8 *pos = new->tail + new->tail_len;
-
 		new->mbssid_ies = (void *)pos;
 		pos += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		pos += ieee80211_copy_mbssid_beacon(pos, new->mbssid_ies,
-						    mbssid);
 		if (rnr) {
 			new->rnr_ies = (void *)pos;
 			pos += struct_size(new->rnr_ies, elem, rnr->cnt);
-			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
 		}
+	}
+
+	new->head = pos;
+	new->head_len = new_head_len;
+	pos += new_head_len;
+	new->tail = pos;
+	new->tail_len = new_tail_len;
+	pos += new_tail_len;
+
+	/* copy in optional mbssid_ies */
+	if (mbssid) {
+		pos += ieee80211_copy_mbssid_beacon(pos, new->mbssid_ies,
+						    mbssid);
+		if (rnr)
+			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
 		/* update bssid_indicator */
 		if (new->mbssid_ies->cnt && new->mbssid_ies->elem[0].len > 2)
 			link_conf->bssid_indicator =
-- 
2.55.0

