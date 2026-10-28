Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190256;
	b=Nvhaw4ku17W5MEBi0t+qoq8+idw+qjQIc1AwoZlws3Ih7rKwSy+rvBzO0+oXSMjtEHxw
	 H9WskqVBRUYx10QcsrRg03HeyaWWz3LI8km2iI/Ldy/d9l0hJWYkTRsgIy1Cq4yVKFexj
	 nIeX85uKKvzUerGxq5TTiMO1TjcM8SIveQ2b3nvJ0dOJz8ECXNAL42k0vk0uWjQoANC09
	 LIRel9leWfY94GNWVd9tOSoaXzh1lk7ONFOagjW5FgXrQjUr900piHa6DLpiQTh/ODrec
	 ZXn8BgUZE+Elm/USw8WOFsOXIf1yvzgYiVxWTdRJLbxrgLP1K6Qwx6TaOm3KZi2M8XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190256;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f+dAzi2aYt1Xe4vI4OqRKoJJXsZgOmDhbJp5TNBpDO4=;
	b=rywkNrfW1zUhW7J4yrAwThxDJaseE1+RN4ueVlUSSL0DkwtZxXR9aZQslqCQSCOZwJTG
	 uVvXtj46lizVit7XHEYVWVmS6jlyNX8leHHAF9rWUH9XAl7SOnpny+5aZ2YWg6Zptgr5j
	 BvF+mYRYq89rfyNbsnLxhyDHpggCtcFbiR57xf8biTOWOFBchkmb0r5vfmoPavU4b88qB
	 0wiYlT9giMWUuJYrc3mzayK/tg989+umPa0XkuyX9//JGZF1JVYDgcgIqfyZwwS0zw9jU
	 4ITrYNhgsi5Rx6WAD+X7DtonDs25zmrOG6WA2Rw41R5gnFlCYJdMMpSwVQudTEICaKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=b7ZI8IFE;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1CE606A333
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E1CE606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=b7ZI8IFE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f+dAzi2aYt1Xe4vI4OqRKoJJXsZgOmDhbJp5TNBpDO4=; b=b7ZI8IFEa/PURuxgnTJ4UvdzjS
	dFydKXtP9MQaadjCdF+TZPu02i6J80vBcS026DRO6U5v9CmUJy6p0tuT1RLjRsUySJSyMY8UEDLdc
	+YpR7hReack5IX1IIdPJP4P8V9bjYNO3hjQuqwh4uZUN2EW/oCLTIyHYJW+puxgp9OUU=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hL-00C8Bw-0v;
	Wed, 28 Oct 2026 13:24:07 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>
Subject: [PATCH mt76-next 07/25] wifi: mt76: mt7996: advertise preamble puncturing support
Date: Wed, 28 Oct 2026 13:23:45 +0100
Message-ID: <20261028122403.796394-7-nbd@nbd.name>
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

nl80211 refuses a non-zero NL80211_ATTR_PUNCT_BITMAP for a driver
without NL80211_EXT_FEATURE_PUNCT, so an mt7996 AP cannot start or
switch to a punctured channel.

Advertise the feature. mt7996_set_channel() sends the puncturing bitmap
of every chanctx to the firmware, including after a puncturing-only
chanctx change.

Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index cc94eade9950..f44a3a8588d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -526,6 +526,7 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_SET_SCAN_DWELL);
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_PUNCT);
 
 	if (mt7996_eeprom_has_background_radar(dev) &&
 	    (!mdev->dev->of_node ||
-- 
2.47.3

