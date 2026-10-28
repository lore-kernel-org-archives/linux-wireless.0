Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190262;
	b=qVS0m6fqnXB+FREk/KvLNwcJFEig5eZlGoVMe2oUdo9aTcAVgUva8U/btUustcIt5+4S
	 z43WL2T2yFvBznVN0KqbxscCcJwCJdyVx6Pxf5WUMiXIkjUGDEKIuz5F+5vr6aOh2DAbc
	 N5bS/eOKdNKypmfldXTjEzS5dXh+knIVHyBTPZuVeXp1W+5m4SDCjQAPJLgtFo41g6WLx
	 oK/3SYT7fu5WttEvE5gWi7F0mQsdZxHPBZzfsBMhSpSyxo0aIdNZAiz780HeS+nb3/Lfy
	 CSH2Ood6L8NZDX1eVIKksWtCN3AB5HizCdGRVHIvNgyCpuSJT9fBFyQ74YZCD/8IVYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190262;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=odGk1wC7QY0YzCQLcjDcvVitvwYABSnor0NBbYFDcxk=;
	b=yl7NXEOiMgCGZ5AJIthbpGu/eMp9Tv822MOhkgKQi4WFSIG9YUUxTRmhAQwXiCK6kn1H
	 rtHXALT3N4DEt7QG/AGY3UPPE10qu4pd49VT6YFsWLVT/SSPez9tdENoQutGXX39F0aE5
	 4bhLEfF2M8gMvcAcx7A7p4Zks7CLSxK9zQ6XzeI2gBKByevI2ssjxy6JUbZbLvV6JzqBl
	 Wl9fxDLtpOX1Ff78wzmSoHwuCzRMHJY4nl38RIdJhUngkROrMi0uRmZGxGBF2UpM47gEk
	 Glx8FXZg3JsmPsQSaS1yJliyBo5UvSKkYZy3jeHKpebAuqQndMTHmIbbiY7+6PSK8Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=nIN3SeZx;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D46606A326
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27D46606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=nIN3SeZx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=odGk1wC7QY0YzCQLcjDcvVitvwYABSnor0NBbYFDcxk=; b=nIN3SeZxqaN00w8OhciW9JJdT4
	N4TYiX/KoIa9LaPusKJ/Enjz95tvT+8JsbcxWdWA9V7Qh4eny3i4RUDXlSNHENHoJNP9TbGzZt1eu
	VKtYDCDRfVRyCSSzENHWhXEIR8D6LrjNqBsOv4rdwcn14PYbbBlfd8dk0FYIipKeEFZc=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hN-00C8Bw-2g
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:09 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 22/25] wifi: mt76: mt7996: apply monitor mode again after a full reset
Date: Wed, 28 Oct 2026 13:24:00 +0100
Message-ID: <20261028122403.796394-22-nbd@nbd.name>
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

mt7996_mac_full_reset() loads the firmware again in mt7996_mac_restart()
and then lets ieee80211_restart_hw() add every interface back. The reset
also clears the RXD group 5 bit in MT_DMA_DCR0 and sets the header
translation bit in MT_MDP_DCR0. phy->rxfilter still has
MT_WF_RFCR_DROP_OTHER_UC cleared on the radios of a monitor interface,
so mt7996_set_monitor() returns early on the re-add. The new firmware
never gets the sniffer mode command, and the monitor runs on with
header translation on and without RXD group 5.

Mark every radio as out of monitor mode before the interfaces are added
again, so that the re-add programs the monitor state from scratch.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 2e1b67ac2d11..a92536180dbe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2491,8 +2491,10 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 	if (i == 10)
 		dev_err(dev->mt76.dev, "chip full reset failed\n");
 
-	mt7996_for_each_phy(dev, phy)
+	mt7996_for_each_phy(dev, phy) {
 		phy->omac_mask = 0;
+		phy->rxfilter |= MT_WF_RFCR_DROP_OTHER_UC;
+	}
 	dev->mld_idx_mask = 0;
 	dev->mld_remap_idx_mask = 0;
 
-- 
2.47.3

