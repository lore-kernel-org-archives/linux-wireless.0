Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190255;
	b=kqCDgXPv9RDgTKprf6htrGeWXEFjIH+a7KUcj1st3FPIvTdBUelAIvgaCR0cYwA/m54d
	 V45Ql4BOvivLOc8zT460w9Hv8II3jY9knKcAvmJsCuaInDcnkiMowp7oAYXcM+a61foQ0
	 zjx/NSH9K/Oj7GTlNkKRvsmaBxn+gbH1WJ71Hs/UTeF0CUNvPOiNoP9oDVYZoJ8cq42/Q
	 0ai/2CX7iaPrDCS1l4zaE9dUo5i2knqbBRxX6J5qBuFmv6+4p8ZlDGxGpCVDM7fWAqGIY
	 Cr/ChKYEmM+wGJ/f4m/zVCX1xUh/N8TA2c5SFBQGxrK/PJ/OS6rEw/Kmj2Nmx7qISQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190255;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=cabI/jOYX9SIfyBZt1Mb8swGfrKf65ifww50x5IFeIU=;
	b=RP4JmauxMMuq6VPD2rMCekxwKEZu1lpncklSzAJ2WpuUItS5QKskxHRey6agT94cyOxK
	 yOi1I8dhF1990SGBFGv++Tx9MkTtmc8MzZJlqt0FDFV5APc5d9+vrwQ02AFrto518z5/h
	 hCbIgFsEOp05mM8cmNL48YD9pTxZXJZSdOFa3sLTMgz0XD2/gm10+lvNleNd59SI43zi0
	 jfB4q8VhvRHh9+h6nGPf4G/5Uer53XNoCr4l0ZLoaEtuN0xWl0mdjD5Lhx/uPxkrXES1U
	 8ZlZFbLbkKNytQq6G0AmCuSc9XfP3747etJGsmYqdWAB++o3zLjeAxaaw0kkSd4JW1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=U3sBKTpm;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF82E606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF82E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=U3sBKTpm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cabI/jOYX9SIfyBZt1Mb8swGfrKf65ifww50x5IFeIU=; b=U3sBKTpmc86gSsu/Lshwf+zK9V
	SdlqHn3G6nR3/UPKtO4m+bgzUzbZLfVfNgfhTx5nP5sBdmOxMiMnGo1hErug8OW7cnwK7qgTdel4+
	+wJhtB/zKlWv5rs6aa8E7msl8U4irKBSwfjeC7gyJBS2Kx7uaCat9c1iURyy6h9Uh0PM=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hK-00C8Bw-0i
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:06 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 01/25] wifi: mt76: mt7996: take the link of an 802.3 frame from its station
Date: Wed, 28 Oct 2026 13:23:39 +0100
Message-ID: <20261028122403.796394-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
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

mt7996_tx_prepare_skb() takes the link of every frame other than the
QoS data of an MLO station from IEEE80211_TX_CTRL_MLO_LINK. mac80211
does not set that field for 802.3 frames, as include/net/mac80211.h
documents, so it reads 0.

Since commit 729c83a3330c ("wifi: mt76: mt7996: fix reading zeroed
info->control.flags after mt76_tx_status_skb_add()"),
mt7996_mac_write_txwi() uses that link instead of the link of the wcid.
When the host writes the TXD of an 802.3 frame to a non-MLO station on
a link other than 0, the TXD thus names the BSS and band of link 0, and
the frame is lost.

Treat an 802.3 frame like one with IEEE80211_LINK_UNSPECIFIED, so that
it takes the link of its wcid, as before that commit.

Fixes: 729c83a3330c ("wifi: mt76: mt7996: fix reading zeroed info->control.flags after mt76_tx_status_skb_add()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index f36da545045b..edff4e5a5dff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1062,6 +1062,9 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		u8 tid = tx_info->skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
 		link_id = (tid % 2) ? msta->seclink_id : msta->deflink_id;
+	} else if (is_8023) {
+		/* mac80211 does not set the MLO link of an 802.3 frame */
+		link_id = IEEE80211_LINK_UNSPECIFIED;
 	} else {
 		link_id = u32_get_bits(info->control.flags,
 				       IEEE80211_TX_CTRL_MLO_LINK);
-- 
2.47.3

