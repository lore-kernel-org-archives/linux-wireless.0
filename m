Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BAC64
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708781; cv=none; b=CviFbn3ygSWXWQavFBBiGwVyo5CyNM4HwMKem1JOygoiYcSjHVwwc+gbe84s0rXYeoQBnNbLBh2Qftc6F5vpJ5wxMWKIcGyTCLZQlekapyYyt9+jX/CtlM674MCuLnLK0cL9bbQuaXa8AEuZm308oVqAmWOXoIteMF8iBo7eTy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708781; c=relaxed/simple;
	bh=Gcnaep8btGjerFaOwBohSuCv5r5mw1OiOnYyl9+C6A4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVH96QLNIOIekdNjndi+yty4i6FBAlRASFc732Z4SBkvdn8tA9PraF5xP+1oWb1/NFhUfg2J3BM88JNnUROCPOzgShgjTAHQNb+607vT8TduITMYcblNyYtRyhtsa+cCxEZC/SHl5G6YuVssD1dW0ngBO+wzfjPI6zsGhhte1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=AZjXKf7J; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="AZjXKf7J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mCTK/5WNhKOLfHs5jyAjfmcIeCX5itIl3Z9TlXYYjiA=; b=AZjXKf7Jv9qCAROmiFdJ9VwNyx
	HidgPNphkmYJQCBCBJ81IWDNkCU1Pq3Kf30MnMCgx5o2JauvwTzaubwQPDKmp09wTk+LbwuIArgk4
	xOITLuEHht2/Z0Hx3InokQynhDwWcb/4BCm3m7gk+8ff7ZLHC/cLdHui7wKok8FHWkGc=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHQ-005AHx-1d
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 10/18] wifi: mt76: mt7996: don't report a zero TX bitrate
Date: Wed, 22 Jul 2026 08:26:02 +0000
Message-ID: <20260722082610.2699628-10-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_sta_statistics() set NL80211_STA_INFO_TX_BITRATE unconditionally
after the block that already sets it, so a station with no rate info yet
was reported to userspace with a valid-but-zero TX rate. Drop the
redundant unconditional assignments; the in-block ones are sufficient.

Fixes: b34f346b917e ("wifi: mt76: mt7996: drop return in mt7996_sta_statistics")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index ea5ad495664a..b6717d4e4dda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1883,8 +1883,6 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->txrate.flags = txrate->flags;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
-	sinfo->txrate.flags = txrate->flags;
-	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	sinfo->tx_failed = msta_link->wcid.stats.tx_failed;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
-- 
2.53.0

