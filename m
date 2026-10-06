Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70FD3D9549
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320383; cv=none; b=tI1+Wh1MpZ1QDHjKIAF5YzEuKJzmES/EMPUy3IPqP0pvy5jsCAU4Mppp7oj6oSRvpf9QGf/8aG0iQKtOLbyebYUmfuJNIKmiMdNG1CimZqel0NC88/V/1Io7vnpfE1MkODApAeJmtvj3drK0meJa11rSnguqDuRumMXOiaYS3Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320383; c=relaxed/simple;
	bh=mUIeP2bXxRgN5LDo78PRX36+dHPbNfraqPBkxFNlMgc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJhGj21iOF61B10j+Sw1l4d5TB9+ZczdWmpIv+mDZSVFiwneIBw5Fi7SgClh+1fxrjILJcgEbv2YVVyuGwRfmngXraOcOgaABl5Uesj2DfkJo+tGid/qdK1icgsGVgEkCZw+Bkl7twbelhThR/+se/5B4DC3rEYbnxSe4B26Igg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=I6fW0ASg; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="I6fW0ASg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qq1BdLHoiVJPX6OL7pW5V47DvrGOTHHbOigHjN7dUlQ=; b=I6fW0ASgZSbybtxb+ErsCFvhI8
	8u5FgjIGYV5GFBJo5N3CD9xvXrbBtF/j0ZJBXsQHTuEjnvPo37sJZwb6LdrkxWQb9EibJDO9M9JiD
	UyILUTTCztntAMGfGugAc0wDqzkBA4gTG6fBR42Izt63WocQr5CrGsjK8ad7512/YzZA=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGB-00HAg3-36
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:40 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 03/27] wifi: mt76: mt7996: set sniffer mode on a radio that is already running
Date: Tue,  6 Oct 2026 22:59:12 +0200
Message-ID: <20261006205936.669125-3-nbd@nbd.name>
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

mt7996_add_interface() skips a radio that has MT76_STATE_RUNNING set,
and the skip covers both the start of the radio and the call to
mt7996_set_monitor(). mt7996_init_wiphy_band() sets
MT_WF_RFCR_DROP_OTHER_UC in phy->rxfilter on every band, and
mt7996_configure_filter() does not clear it, so only
mt7996_set_monitor() does. A monitor interface that is added while an
AP runs on the same radio thus receives no unicast frame addressed to
another device.

Start only an idle radio, but put every radio of a monitor interface
into sniffer mode. mt7996_remove_interface() already clears sniffer
mode whether the radio runs or not.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index c04e980f6ee7..d013a472c28d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -570,13 +570,14 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 	for (i = 0; i < MT7996_MAX_RADIOS; i++) {
 		struct mt7996_phy *phy = dev->radio_phy[i];
 
-		if (!phy || !(wdev->radio_mask & BIT(i)) ||
-		    test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
+		if (!phy || !(wdev->radio_mask & BIT(i)))
 			continue;
 
-		err = mt7996_run(phy);
-		if (err)
-			goto out;
+		if (!test_bit(MT76_STATE_RUNNING, &phy->mt76->state)) {
+			err = mt7996_run(phy);
+			if (err)
+				goto out;
+		}
 
 		if (vif->type == NL80211_IFTYPE_MONITOR)
 			mt7996_set_monitor(phy, true);
-- 
2.47.3

