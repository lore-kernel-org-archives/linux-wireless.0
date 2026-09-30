Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F945D92C
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758106; cv=none; b=jQ/tnUoCRzTRRFxNvfuqyj2SZveAcFLCmEogu83IEyR7L8YKm17uw8rzH+F64XeNrYRVqooUu5EWNSX/A8VMAHHc/d6c2MfgnipJdbqodnmlBI7NhmzF80lXsNw5vNI8QYuHLVFg/Qjn7/69OlULnGA37kcT/CMJF1+lgjAcMII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758106; c=relaxed/simple;
	bh=irggZjQrStQhEQuzTF5tEU6YrGsKjA/w3AhR3eY3kmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HSwTekPJPIN/DYskpOsq8GWsqhMGl2SAnuxz/sLBkZWATlxUrUUKhhanE7Mk5K6tS72JhRHg0vkeKHII0NZP+N3S1U684jNbTrMurStR0ahUcz1Su9maOBFEZV1HzSP6OH7GcKvRIT6npWkpp+RpCrAzCSctfmDgn+NyvvJyMxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=RbiteXet; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="RbiteXet"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qXoP+pP9ojIhA4cKGpLPjG52oKxYpIKVw8jhLIsfI3k=; b=RbiteXetyUMdr9v0xX2d8UiPBz
	KV5zXG6P0F61QhtJDx+nfKC0SaJju8CuUiqB9KSTeC8qfnf07PC6M27hwI6MUh378JfXRyn4L6txi
	aHK2kjQQ1pGfk3zpsBg3TBn8kAcM7bXRfsQINurIme0ua0nSrlH3aljPedQdaXkjjC9Y=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xBpzC-00DQuD-1o;
	Wed, 30 Sep 2026 10:48:22 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless 1/2] wifi: mac80211: use link address as TA for non-MLO 4-addr station on MLD AP
Date: Wed, 30 Sep 2026 10:48:18 +0200
Message-ID: <20260930084819.3000572-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A 4-address AP_VLAN always sets A2 to sdata->vif.addr, which on an MLD
AP is the AP MLD address. For a non-MLO station, A2 must be the link
address it associated to.

Use the link address for a non-MLO station in the 4-address case as
well, like the AP case already does in ieee80211_build_hdr() and
ieee80211_check_fast_xmit(). Share the address selection between both
cases and both TX paths.

Fixes: 3e0278b717b0 ("wifi: mac80211: select link when transmitting to non-MLO stations")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 68 ++++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d51f810dd2c5..072b1287066c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2653,6 +2653,32 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
 	kfree_skb(ack_skb);
 }
 
+static int ieee80211_ap_tx_addr_get(struct ieee80211_sub_if_data *sdata,
+				    struct sta_info *sta, u8 *addr, u8 *link_id)
+{
+	struct ieee80211_link_data *link;
+	int ret = 0;
+
+	if (!ieee80211_vif_is_mld(&sdata->vif) || sta->sta.mlo) {
+		memcpy(addr, sdata->vif.addr, ETH_ALEN);
+		return 0;
+	}
+
+	rcu_read_lock();
+	link = rcu_dereference(sdata->link[sta->deflink.link_id]);
+	if (WARN_ON(!link)) {
+		ret = -ENOLINK;
+		goto out;
+	}
+
+	memcpy(addr, link->conf->addr, ETH_ALEN);
+	if (link_id)
+		*link_id = sta->deflink.link_id;
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 /**
  * ieee80211_build_hdr - build 802.11 header in the given frame
  * @sdata: virtual interface to build the header for
@@ -2721,7 +2747,10 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr.addr1, sta->sta.addr, ETH_ALEN);
-			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
+			ret = ieee80211_ap_tx_addr_get(sdata, sta, hdr.addr2,
+						       &link_id);
+			if (ret)
+				goto free;
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
@@ -2746,18 +2775,12 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 
-		if (ieee80211_vif_is_mld(&sdata->vif) && sta && !sta->sta.mlo) {
-			struct ieee80211_link_data *link;
-
-			link_id = sta->deflink.link_id;
-			link = rcu_dereference(sdata->link[link_id]);
-			if (WARN_ON(!link)) {
-				ret = -ENOLINK;
+		if (sta) {
+			ret = ieee80211_ap_tx_addr_get(sdata, sta, hdr.addr2,
+						       &link_id);
+			if (ret)
 				goto free;
-			}
-			memcpy(hdr.addr2, link->conf->addr, ETH_ALEN);
-		} else if (link_id == IEEE80211_LINK_UNSPECIFIED ||
-			   (sta && sta->sta.mlo)) {
+		} else if (link_id == IEEE80211_LINK_UNSPECIFIED) {
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 		} else {
 			struct ieee80211_bss_conf *conf;
@@ -3244,7 +3267,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 					  IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
-			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+			if (ieee80211_ap_tx_addr_get(sdata, sta, hdr->addr2,
+						     NULL))
+				goto out;
 			build.da_offs = offsetof(struct ieee80211_hdr, addr3);
 			build.sa_offs = offsetof(struct ieee80211_hdr, addr4);
 			build.hdr_len = 30;
@@ -3255,21 +3280,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		build.da_offs = offsetof(struct ieee80211_hdr, addr1);
-		if (sta->sta.mlo || !ieee80211_vif_is_mld(&sdata->vif)) {
-			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
-		} else {
-			unsigned int link_id = sta->deflink.link_id;
-			struct ieee80211_link_data *link;
-
-			rcu_read_lock();
-			link = rcu_dereference(sdata->link[link_id]);
-			if (WARN_ON(!link)) {
-				rcu_read_unlock();
-				goto out;
-			}
-			memcpy(hdr->addr2, link->conf->addr, ETH_ALEN);
-			rcu_read_unlock();
-		}
+		if (ieee80211_ap_tx_addr_get(sdata, sta, hdr->addr2, NULL))
+			goto out;
 		build.sa_offs = offsetof(struct ieee80211_hdr, addr3);
 		build.hdr_len = 24;
 		break;
-- 
2.47.3

