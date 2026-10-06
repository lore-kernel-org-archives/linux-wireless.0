Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72253F5BC5
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320383; cv=none; b=d0vtOgGBalZFV9cXWIA5RL4A5xhrhZUPqdYsAM/WAK9WYUCHERi0pUi5Fno4jI2Rcv74IM0Nw+Jz04j8uqJdCzbV4x8CT4qe6jGGrn19rJjgP70UFAjxo3w48EL6w1FmUhrwZp+o/4WI3iG5ZW/tCy39XYKrAif63wzUKRuCY38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320383; c=relaxed/simple;
	bh=HibkDfasY908/KSchC+BQIoS9K8lq2/soccK0QWBt3o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=R6dHmTOrkE+fNQTE+dSWD5qc7fc9HdnnkTFunkdUIunfMQ86R1BD8odHQxTl0MGLNSfc7lmAICeZAJOM3mCgxTrcf/DzH16EAyFE4ZP4jFdWDPIM2L69w3oF9j7jM7bpFDz0lNaWjGNHExXqi8Uu/9qlXRkqt4trE06gvtzTPmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=d9m5IibS; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="d9m5IibS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ulyjTaoBOhicvvFqCuiUFnUmH89cikNctshqKMbC2eU=; b=d9m5IibSRHQ/smp6RMx+r0UmMs
	z0lFZmNa/TL2+TZPwxptHjRcFOgaS//kaxo1ENZYzaELRbjVTXZfZ0KoIypjsWtA9/ja7/E9cP6dW
	4/PZyAOegRRyqNn4Oqh0Jp2evdM6vQpZH8MnJql0d60mY6HA4WCGal/+hnIVwmLaWpR0=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGB-00HAg3-20
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:39 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 01/27] wifi: mt76: abort a scan only for a link change on the scanning radio
Date: Tue,  6 Oct 2026 22:59:10 +0200
Message-ID: <20261006205936.669125-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_assign_vif_chanctx() and mt76_unassign_vif_chanctx() abort the
scan whenever the scanning vif gains or loses a link, on any radio. An
AP MLD that scans on one radio for ACS while its link on another radio
comes up therefore loses the whole scan, and hostapd gets an aborted
scan. mac80211 does not continue an aborted scan with the next band.

The scan uses the link of the vif that mt76_get_vif_phy_link() returns
for the scanning radio, so it needs to stop only for a channel context
on that radio: the new link would duplicate the offchannel link, or the
removed link is the one the scan uses. Abort only in that case, as
mt76_add_chanctx() does.

Fixes: e411b8190fe7 ("wifi: mt76: add multi-radio support to scanning code")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 903f3a420e4c..8d4daa76be54 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -114,7 +114,7 @@ int mt76_assign_vif_chanctx(struct ieee80211_hw *hw,
 	bool mlink_alloc = false;
 	int ret = 0;
 
-	if (dev->scan.vif == vif)
+	if (dev->scan.vif == vif && dev->scan.phy == phy)
 		mt76_abort_scan(dev);
 
 	mutex_lock(&dev->mutex);
@@ -161,7 +161,7 @@ void mt76_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt76_phy *phy = ctx->phy;
 	struct mt76_dev *dev = phy->dev;
 
-	if (dev->scan.vif == vif)
+	if (dev->scan.vif == vif && dev->scan.phy == phy)
 		mt76_abort_scan(dev);
 
 	mutex_lock(&dev->mutex);
-- 
2.47.3

