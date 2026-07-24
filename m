Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72013AF65C
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897302; cv=none; b=HmO439uMUA6Rhq8yyysVM3LlQHqFYlHRu7agWTqyz46XTtwSbiRPMpladCPaokIvkbBxNe+79FPOVDbbs51vG/SnsVmgH7+lNN3y6b15L4fTdU5EpVaqvRbFG/4EzZVavIxjeytIeIW/T/lKvquCEcCtOMcFUWdlppJQqwKFb+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897302; c=relaxed/simple;
	bh=VFRTi5d0h4pt7T44FOx1N2+mXEDDPlotrwqV0XXhq/w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBnf8+pMSBTE/zgE4wHLe88ddE839RKe7dORrcUeLVQshvp3+ikc7tAZZKJLSJqDjGUj16Y9fLLwfmXnxvFVM1Dpb27i1UM6k6C4HUBOFv6m4a7eG6LoWq5IzM4ePra5VK3iW5Z8W2/BOgzQT9xMWlPIerS8n159dEznq5J/r0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=nEHBf5qa; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="nEHBf5qa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K5HcPg68W7MebFAzA68fo2hJvAEO7s1Mww6OQx9EcR4=; b=nEHBf5qaoqZAFsnnfsr43RLrNd
	Hmeyj9HnjoIFl8AzFre9ZsDOir2KSdH5rkOIsNSfSnd2Py5cQdmtW/Sow96HZwVpqFR/8WSVQjnKj
	rd5cfvG3WsinL6CF3XKM4q8IpPHehn9PojZMx9YXP4j0tK127c7h5eZky3SYbqdvQbtg=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK6-006LeO-2C
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:18 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 18/29] wifi: mt76: mt7996: skip key upload when adding an offchannel link
Date: Fri, 24 Jul 2026 12:48:02 +0000
Message-ID: <20260724124813.3961474-18-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No hw keys are ever uploaded for scanning/roc links and the link remove
path already skips the key iteration for them. The add path still runs
it, and since mt7996_set_hw_key() resolves the target through
mvif->link[link_id] rather than the offchannel link, starting a scan on
another band re-uploads the group keys of the link sharing the same
link_id, re-sending its BSS cipher info and, for BIGTK with beacon
protection on an AP link, toggling its beacons off and on.

Skip the key iteration for offchannel links, mirroring the remove path.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index b6717d4e4dda..f436109ac0a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -372,7 +372,8 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 				   CONN_STATE_PORT_SECURE, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], &msta_link->wcid);
 
-	ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
+	if (!mlink->wcid->offchannel)
+		ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
 
 	if (!mlink->wcid->offchannel) {
 		if (vif->txq &&
-- 
2.53.0

