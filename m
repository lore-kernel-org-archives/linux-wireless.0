Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4304218A4
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320383; cv=none; b=enZP7xnz/rPlZeKjjYA/eeRWHzL15iKJF3omu37GvHzmfDc0DIVfsG1uaMNUh/I1olKiaW68n9cGU9MRvq0hN98scGDQfPEHVp8JOUUSGqtkq6S0I9jch+R7WeaWnVcdIUN8R5Wxr1UAFPfq1vTZdUizJwCLkOaJCIpgD4cnO38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320383; c=relaxed/simple;
	bh=y1xIB+efnEz5VE6lbDUh02dTlY+CiNdMfhcQPjfUllk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lgcsx+Idli7uWu+/+fSj4KcNSnKzhuzwm+eSRCDI1+iDV2E+7pYHka9qmHfoVbg1uiideMbGQ+InsiJFBG3If7dNFsIUlyqsI1YFOSrB0Cijjvw0pKDSL/KKJSX6xq3JXkvohBVdRaLWj7aaR2C8N/7Le/2ModfiF8/Lp9SYM8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=hgVXyeDQ; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hgVXyeDQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RHCm3u1ZuxF9Xsm7JMw4U//md+oZmxu3X0N1EwvFrnc=; b=hgVXyeDQ/ZT5GxWCqhJMU20d96
	uz38YQPG6PKOdcEfc2Q/fG8Fa/FwDQCodspR5iRbUt/WkXIwzP/zZPqTmjYJDiuCzljxxOD4wwEJ/
	MHVtrPfqNFTzyz7g4PHpnVnA6Mwk7iRGXTP7aIfhMfOtNWnHjUH6TRsbfojpGdLR7w7k=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGC-00HAg3-0P
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:40 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 04/27] wifi: mt76: mt7996: update the address of an AP link that is added again
Date: Tue,  6 Oct 2026 22:59:13 +0200
Message-ID: <20261006205936.669125-4-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_vif_link_remove() only stops an AP link and keeps its BSS, so a
link that is added again takes the early branch of mt7996_vif_link_add().
For other interface types that branch sends DEV_INFO with the new link
address. For an AP it only restarts the link, and the firmware keeps
the own MAC address the link had when it was first created.

The hardware takes A2 of an encapsulation offload frame from that
address. A reload that gives an AP MLD link a new address therefore
makes every data frame on that link carry the old address as TA. The
receiver acknowledges the frame by its RA but cannot find a key for the
TA and drops it, so the AP counts no failure. The BSS_INFO update on
BSS_CHANGED_BEACON_ENABLED restores the BSSID, but nothing sends
DEV_INFO again.

Send DEV_INFO for an AP link as well, before the link is restarted.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d013a472c28d..621e1337dec2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -312,15 +312,15 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	if ((mvif->mt76.valid_links & BIT(link_conf->link_id)) &&
 	    !mlink->offchannel) {
-		if (vif->type == NL80211_IFTYPE_AP)
-			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
-							true);
-
 		/* update the link address */
 		ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
 		if (ret)
 			return ret;
 
+		if (vif->type == NL80211_IFTYPE_AP)
+			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
+							true);
+
 		return mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink,
 					       msta_link, true);
 	}
-- 
2.47.3

