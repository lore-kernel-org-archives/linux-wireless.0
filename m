Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190255;
	b=DaXz7owBiiwMsaJRoelQ8B+JuEbu+IxpFIXGgLsNrJwiT/9H02HR61frgOOK8lrOKw4V
	 MMvYtxUl6h79KWnMlMiZkBpcl7G/HkAq+LPbWs9nN5GgWwqi9QwAp2G8kutMIEKzIedGW
	 Q9s/aNcGEUbZKkX1A/Q/fGeCJoYuiC/VRM55cRpqiiE07htUnZinWrI5axWrxIUJayH3R
	 Stx2nS9LtZG1IXzi0fd0WqF5pDx3ZzXhmQEk1SuBWK/+yxEslO8rj0Phzbs9BjnhhN/kr
	 3VKpCMnGmPJNa2pAECHXgAJg8uAAL2aqxbIq1ZsF6yrr3k+VtNghVi6pIKDDCfUA/gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190255;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RU2gOoA88PKXhwIx9eiOQ9c7D7FVMCqwAeHiQGXlqCQ=;
	b=A0OdfID/X9Bab7UFWPH29i9gFh69oNMV5XhiWU1Qdz5zpcPuivtppqWb6XQDUi5WwX8e
	 KdSpEUah3zEQR64qsleQbJ1TWugdkh260U5mBOg8Dc9sVC8p6YbfTdDno+iWNwTCrSS7d
	 W5rsNR60imHcKz/ipY/UeBMj1ImxBavnSbTpN4qMi5/dchC5blrKi03c7l6khYvacq1Xu
	 lOHKmierfza1HdSr49ncZFwXd42my8cUTWBt5B05OktU61m6j6eMlRok4RCO2caRH1M7r
	 jSmOxEfT86gECN/ij5j7F571Z6Bs/8Ljtf73qg5/d2eWbzIBWMRZ0Ty08lDepO+ySEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=OBarglYa;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F6606A332
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D4F6606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=OBarglYa
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RU2gOoA88PKXhwIx9eiOQ9c7D7FVMCqwAeHiQGXlqCQ=; b=OBarglYaXCnehtUE9ATlTGS4pW
	t5xnHU5cV3vrYhe2gSeMlFsWyaoe7MfnJMrv/FMtmsM6tyRzGy0nxBOc/ikAVcGrKJIATxlaFIQ59
	fT3d7Y7FpsaBK9pk20qwOvNhPL8ZFZAW4UZvkdv+ZJSYwUVJfyuIU02NKlJGRm8P/Ybo=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hL-00C8Bw-3A
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:08 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 11/25] wifi: mt76: mt7996: send MLD link operations for an AP MLD only
Date: Wed, 28 Oct 2026 13:23:49 +0100
Message-ID: <20261028122403.796394-11-nbd@nbd.name>
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

mt7996_vif_link_remove() sends the MLD reconfiguration stop and the MLD
link removal for every AP link, and mt7996_vif_link_add() sends the MLD
link add for every AP link it holds already. A non-MLD AP has no MLD
group in the firmware: its BSS carries group_mld_id 0xff. The firmware
refuses both removal commands at each teardown of a non-MLD AP:

  mt7996e 0000:01:00.0: Message 00120082 (seq 1) cid 0082 failed: firmware status 0xc0000001
  mt7996e 0000:01:00.0: Message 001a0002 (seq 2) cid 0002 failed: firmware status 0xc0000001

The add sends the group_mld_id and remap_idx of the vif, which a vif
that never was an MLD holds at 0, the first index that an AP MLD gets.

Send the MLD link operations only for an AP MLD, matching the MLD tag
of mt7996_mcu_add_bss_info(). A non-MLD AP link that is added again
programs its BSS as a station link does.

Fixes: e7ec71d9f8fa ("wifi: mt76: mt7996: Add mcu APIs to enable/disable vif links.")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 1ca4d9e099fe..d22abbd543b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -328,7 +328,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		if (ret)
 			return ret;
 
-		if (vif->type == NL80211_IFTYPE_AP)
+		if (vif->type == NL80211_IFTYPE_AP && ieee80211_vif_is_mld(vif))
 			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
 							true);
 
@@ -514,7 +514,7 @@ void mt7996_vif_link_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	if (mlink->wcid->offchannel) {
 		mt7996_vif_link_destroy(phy, link, vif, link_conf);
 	} else {
-		if (vif->type == NL80211_IFTYPE_AP) {
+		if (vif->type == NL80211_IFTYPE_AP && ieee80211_vif_is_mld(vif)) {
 			mt7996_mcu_mld_reconf_stop_link(phy->dev, vif,
 							BIT(link_id));
 			mt7996_mcu_mld_link_oper(phy->dev, link_conf, link,
-- 
2.47.3

