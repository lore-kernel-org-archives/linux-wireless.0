Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B094ACC9E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 09:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552143; cv=none; b=GVo2KOyLcfJwrEkRGKiVCG0FswTmUv9jAekH60+8EgzCuLn3ovuTuO0SZwDYAEYE79JOt40BT2rdonjbgq7qgJpGhxXFwSmDACmM1BzXZrvWFLAx+Dbk4SEpFBvq9VdShOki82Lhcc3jtN3p1KlHqCrrwAVd9PtXriTeSBjY6PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552143; c=relaxed/simple;
	bh=8Vz+SExZx+QtuLOLrFk9QJxt390VeIgrowWcY+Hj3wg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q1iw4MYiDuznzQyMmpyct2V5nRZE0IJdtU/okGZpg3sQM5UEUA58YBvGhJEPdNTqybxmbIKlbKU5KyNNXjkfL+VQ+7plm6lcOAIQWtWI4/9Y2eHqLckuQQSPUK9hSGnb0HSkF40/AKmACzufLpZYdR50TAuBFFfBLRviItw4bGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=mw+nUi/x; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="mw+nUi/x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J/BOtu4Ynqd1pknZt/+lDkyJ+xuMxdjHnnusmHP/Kb4=; b=mw+nUi/xWXRAd/JTi/sSOkjazm
	kvb3NUzpwDa9lpfBE7Jegd2teX9pXtek0GXHdmRM1fMa631EL3kD5sSj3i+9jlkiHT++UEGZ1OeN+
	FVWVpoarnja0PQ7ZPRbjcxCjz4+mHuSkhcPq5bejPO1Zr4FfXItPXmUFw5/OPqshf3X8=;
Received: from p200300cadf14d10000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df14:d100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x6mFo-004pbF-1C;
	Wed, 16 Sep 2026 11:48:36 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless] wifi: mac80211: prevent AP VLAN tx from other interfaces
Date: Wed, 16 Sep 2026 11:48:32 +0200
Message-ID: <20260916094833.164219-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the station lookup was factored out of ieee80211_build_hdr(),
ieee80211_lookup_ra_sta() uses sta_info_get_bss() for all AP and AP VLAN
frames, not only for control port frames. A unicast frame sent on one
interface thus matches a station of a different VLAN of the same BSS and
is transmitted to it.

Only match stations of the interface the frame is sent on, except for
control port frames, since those may be sent for VLAN stations directly
on the BSS interface.

Fixes: 97ffe75791b3 ("mac80211: factor out station lookup from ieee80211_build_hdr()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/tx.c          | 24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d05f59467399..9374c2942489 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2475,7 +2475,7 @@ static inline bool ieee80211_require_encrypted_assoc(__le16 fc,
 /* sta_out needs to be checked for ERR_PTR() before using */
 int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb,
-			    struct sta_info **sta_out);
+			    struct sta_info **sta_out, bool bss);
 
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 814399989b5e..c8217f6d146e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2532,7 +2532,7 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
 
 int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb,
-			    struct sta_info **sta_out)
+			    struct sta_info **sta_out, bool bss)
 {
 	struct sta_info *sta;
 
@@ -2553,7 +2553,10 @@ int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
 			*sta_out = ERR_PTR(-ENOENT);
 			return 0;
 		}
-		sta = sta_info_get_bss(sdata, skb->data);
+		if (bss)
+			sta = sta_info_get_bss(sdata, skb->data);
+		else
+			sta = sta_info_get(sdata, skb->data);
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
@@ -4419,7 +4422,8 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	    ieee80211_mesh_xmit_fast(sdata, skb, ctrl_flags))
 		goto out;
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta,
+				    skb->protocol == sdata->control_port_protocol))
 		goto out_free;
 
 	if (IS_ERR(sta))
@@ -4848,7 +4852,10 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+	if (unlikely(sdata->control_port_protocol == ehdr->h_proto))
+		goto skip_offload;
+
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta, false)) {
 		kfree_skb(skb);
 		goto out;
 	}
@@ -4869,8 +4876,7 @@ static void __ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
 		link = &sdata->deflink;
 		key = rcu_dereference(link->default_multicast_key);
 	} else if (unlikely(IS_ERR_OR_NULL(sta) || !sta->uploaded ||
-		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
-	    sdata->control_port_protocol == ehdr->h_proto)) {
+		   !test_sta_flag(sta, WLAN_STA_AUTHORIZED))) {
 		goto skip_offload;
 	} else {
 		key = rcu_dereference(sta->ptk[sta->ptk_idx]);
@@ -4931,7 +4937,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 
-	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta, false)) {
 		kfree_skb(skb);
 		skb = ERR_PTR(-EINVAL);
 		goto out;
@@ -5002,7 +5008,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		}
 		result = ieee80211_tx(sdata, NULL, skb, true);
 	} else if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) {
-		if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+		if (ieee80211_lookup_ra_sta(sdata, skb, &sta, true)) {
 			dev_kfree_skb(skb);
 			return true;
 		}
@@ -6639,7 +6645,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	 * AF_PACKET
 	 */
 	rcu_read_lock();
-	err = ieee80211_lookup_ra_sta(sdata, skb, &sta);
+	err = ieee80211_lookup_ra_sta(sdata, skb, &sta, true);
 	if (err) {
 		dev_kfree_skb(skb);
 		rcu_read_unlock();
-- 
2.47.3

