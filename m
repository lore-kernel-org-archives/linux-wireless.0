Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190262;
	b=JIX1+OobmDPdBFMdtLa8AcJKrblXFL9bdhz5QyZAI/p0ySnQLAblJXrlLXBdwQkURcv+
	 UdAyp+aScvEcLqtbjPnJJSh9KpWx4dHC37kVfrzAS07uXJVDs5pJgE+qTmHqKM7p8ofGq
	 /oewywzjzkavaCsbqf1cIpTcLOoKA0Sr49Lv2f8w1Iw8MxNqGHktHXJxZfxrxD6xELf9t
	 rp0MtAfxOX45OQa5bHFvLkLhq+j+CD2YcePj+Bu8n4aKWPgBwJvfd8OIviNEyG0lYa/kg
	 KaF2PVuJUWMmS5lRuwHCln2o1tdnSgjFy5iRqzMTaYcGgkWkXBYBVZSdwqGL0w6yK2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190262;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DsBwt+makV27kO/iJGk64DxlqR72V/xoRKp1y6a3q3g=;
	b=44r60rsrslZ/yF9ng/sp5g4MU2HYPhWR3Z3GLWpqdccZxGXVujmUJ3jyL2z/EO9u+TD1
	 7/P7JUuSN2GhxtuvWiCgUqLplmPM6HS9LFvk87+ePv/WcyZtROuhnnu85Gd3NqITUBvcf
	 a7xs5w95iYxoriita3O1GiSvL1ru8ifwYoP7NFOp/k6oE8Q/lFt768MmR2+Ux6l4CmPLX
	 JqqVSiki071WVRRuNjv5zQ5PS1bCi8xRsbThnNflqwUaL0UnHY0lWd39bJ7OmjyIF0tpj
	 fgo71Ql9vLZnx0xnlXyNJHG8CMeA0KrQPykVUx+34XBkzA+xJ77EeWaF2RRAUkTO9KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=CfH9+N7o;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D7D606A334
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17D7D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=CfH9+N7o
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DsBwt+makV27kO/iJGk64DxlqR72V/xoRKp1y6a3q3g=; b=CfH9+N7ouHWrjBXcq8VCQCJOeE
	RacRnVYl36/Ehrs3OqZvEqoBOCyusWmSWniTTByuKq8cixcfZ9mHTpIppnxvVfZb97Kfrqgzyywds
	iBNet/vIi2AVPVQaJbVv4d269edkNRF8kT+LG/t3nofeE+kyYoPABAY1VZpLrxf9DlEw=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hO-00C8Bw-0X
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:10 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 24/25] wifi: mt76: mt7996: send no MLD_SETUP when station links only go away
Date: Wed, 28 Oct 2026 13:24:02 +0100
Message-ID: <20261028122403.796394-24-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
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

Since links added after association are brought up in
mt7996_mac_sta_links_sync(), the remaining links of an MLO station also
get an MLD_SETUP when links are only removed, with a link list that no
longer holds the removed links. After that MLD_SETUP, the remaining
links pass no traffic in either direction, although TX completes
without failures. Traffic only resumes once a link is added again.

Send the MLD_SETUP to the other links only when a link joins. The
MediaTek driver also sends no firmware command when a link station
goes, and tears down all links with STA_REC_MLD_OFF at disassociation.
This also applies to the restore after a failed link add.

Fixes: 1aef01d3cbbe ("wifi: mt76: mt7996: bring up station links added after association")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 82143ade1cc0..5df5354beb50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1864,7 +1864,8 @@ mt7996_mac_sta_links_sync(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		mt7996_mac_sta_link_ps_leave(dev, link, msta_link);
 	}
 
-	updated = sta->mlo ? links & ~updated : 0;
+	/* a link list without a removed link stalls the remaining links */
+	updated = sta->mlo && joined ? links & ~updated : 0;
 	for_each_set_bit(link_id, &updated, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
-- 
2.47.3

