Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783A645FFAE
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758106; cv=none; b=YwHfYjAwOpWV9iGrBhoRvb6xNZUaH6RKfbVY51pxk2Vmaa8+NActxDi8ZXAEV2lw7l5SfdshU58qDly46P03wA0nLFSFB8cXm3xOp7K3LfEYo14ZCJmFnoPpkyYllMmXlDwW5k4y7mIXYxkJ+vGEH1BGQ0g4JVfpPI2CdBkiyH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758106; c=relaxed/simple;
	bh=5zXvDytPnbpAIadDFWL887AgRsOmqfsbq3/p0Y86z84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtOw9+9soNdw41ueuFFf2KUIYLWVGJZirgZpXDffRgyPa0hdJ55Lnczcdhl0yivxNOGRJE8CUaIZJ+trvQIyIL2Tvm9e/gV43qI2Sy3MHWjBw7DMAs+VaZk55vCy/jt52JHn6iHzz0lqzdjKA4j/GM2eBu9W7t2kBLUX1CbpOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=BLQ1lV+1; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="BLQ1lV+1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1SrsSpJ/kYnQzNXbYfx+NuvlgxzNfqyO9wgicZMWxMc=; b=BLQ1lV+1x7dNn4ZjMYL1NgOb8z
	RnaXORRfqbasW30DdeERvwR70AXZfE0plmt5p4CdZ5R7J0N6rM4Sdk/dnt9vVuTIp/XuZqJgFrQY/
	0kygxyX2pQn5Z38h9IAthjGidUn7EhFjFMwU0zRhidvAKT09F31j3IZ7QgkKdvhTyDFc=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xBpzC-00DQuD-2Q;
	Wed, 30 Sep 2026 10:48:22 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless 2/2] wifi: mac80211: use the AP address as RA for a 4-addr MLO station
Date: Wed, 30 Sep 2026 10:48:19 +0200
Message-ID: <20260930084819.3000572-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930084819.3000572-1-nbd@nbd.name>
References: <20260930084819.3000572-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 4-address mode, ieee80211_build_hdr() and ieee80211_check_fast_xmit()
set A1 to sdata->deflink.u.mgd.bssid, which is not valid for an MLO
connection.

Use sdata->vif.cfg.ap_addr instead, like the 3-address case does.

Fixes: 8a9be422f5ff ("wifi: mac80211: tx: use AP address in some places for MLO")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 072b1287066c..e764211edcf7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2896,7 +2896,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
 					  IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
-			memcpy(hdr.addr1, sdata->deflink.u.mgd.bssid, ETH_ALEN);
+			memcpy(hdr.addr1, sdata->vif.cfg.ap_addr, ETH_ALEN);
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
@@ -3247,7 +3247,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
 					  IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
-			memcpy(hdr->addr1, sdata->deflink.u.mgd.bssid, ETH_ALEN);
+			memcpy(hdr->addr1, sdata->vif.cfg.ap_addr, ETH_ALEN);
 			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
 			build.da_offs = offsetof(struct ieee80211_hdr, addr3);
 			build.sa_offs = offsetof(struct ieee80211_hdr, addr4);
-- 
2.47.3

