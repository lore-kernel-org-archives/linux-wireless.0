Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C9543CE7B
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790424150; cv=none; b=PPtjNFEbKG5wrhnD0er7pGyKBkBK/Ej8FGZeJUNWwHNxFUAoJNGX3nEKTJnGQVdXeH5KiKtEBx2YKcptVHAziYNLokocmcKTx1HDT1xePGt7DKE6gKNLILbCOrbOrPgqOjQO0tPEHzU/O4/sCJ0rOBIATkcSYHRjolp9jXjcJ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790424150; c=relaxed/simple;
	bh=v5g2lSZJOiHA6qG+q0NQxPN2jtikigg+d8gMTc43iHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHRncwIO0gAPgKmTczYuMz92a1UTGASVa3IedsSDxR7Y2BBiiF2LBj6Rh6FUvzBkU7cyGFh/7eDlFwCMFrM6QuoPyv0pPXkY6Y35uJMylVoz/c6FyvAC8ewMhmh70BTV3eb+6eDJBku4dDaN0eRMef7pYRIg7IPhk4aXvCCx5wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=YyxTvWOb; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="YyxTvWOb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Xh2bPMlYfOspXsjxu6z8DaPqFna+ilRw9lV8BcEjcqs=; b=YyxTvWObGROMsA+ZddRdnTpNgf
	YrcJSA1fieuLppex+ulFwPQYvbpLf/zTg745QxyV466PV1Nmp7g7sIIJ0qS55iZUDcqDyhb0wVdpJ
	QGukkP7Rwa7H4jaZYYeRJTKX0UPqZ4Ta5m4uh0qTBnMy00aW12IfO1mTzlsiY3YoMopg=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xAR6g-00AxZk-1t;
	Sat, 26 Sep 2026 14:02:18 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless] wifi: mac80211: set info->band for 802.3 encap offload frames
Date: Sat, 26 Sep 2026 14:02:16 +0200
Message-ID: <20260926120216.4054712-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unlike the 802.11 TX paths, ieee80211_8023_xmit() does not set
info->band from the channel context on non-MLD interfaces. It stays at
0, so ieee80211_get_tx_rates() uses the wrong band for these frames.

Set it the same way as ieee80211_build_hdr(): drop the frame if there is
no channel context, and leave the band at 0 on MLD interfaces.

Reported-by: Andrea Pesaresi <andreapesaresi82@gmail.com>
Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c8217f6d146e..b88acb18e04d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4735,6 +4735,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *seg, *next;
 	unsigned int skbs = 0, len = 0;
@@ -4784,6 +4785,16 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
 
+	/* MLD transmissions must not rely on the band */
+	if (!ieee80211_vif_is_mld(&sdata->vif)) {
+		chanctx_conf = rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
+		if (unlikely(!chanctx_conf)) {
+			kfree_skb_list(skb);
+			return;
+		}
+		info->band = chanctx_conf->def.chan->band;
+	}
+
 	info->flags |= IEEE80211_TX_CTL_HW_80211_ENCAP;
 	info->control.vif = &sdata->vif;
 
-- 
2.47.3

