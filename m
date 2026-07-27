Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6F641DED1
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164693; cv=none; b=FcWow9l1FFkK6nhmRmKYuS8VuqTmvlPKEfxu+/YT0jaqORMh73VzFjmtY9JII6iJ12K1wcIT2/mVcd5kzNPXwIdJAw7aQhaPeCa5cBc5UVrESuP6KMYQlO8XgodfdIaw2iYBwBfyoxxoXTy1NdUR7cGFUlVPArsXCZf2+f1uH0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164693; c=relaxed/simple;
	bh=mqEoKnuFk7qT0HeQFcvdVud98aJ/nwTxsR1PDcJjTuc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxwc55Pq6kBu+0XP+wCxZCHHqlEKnLKn1fUhLVrOi9LRvn6jaS/wlf5hgR3hJkMylJoJlyJ0t8gELlVxNuWurfT7VuhOa8apGBe3p05wJ3jMMx17PMeFopli6e/PZ0i75xacbOOQblxJ5xbrRa7N5r8z/w3GQO/TmuYiDn+gGcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=pzvAdSpj; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="pzvAdSpj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aeVx8xrYO+Cd9h4ABsoJqsLcbZmTDKCmOlY8K+q4YKo=; b=pzvAdSpjvi1huEnuCdEYpmFeiH
	ExusrhJrEScuRHKGwh9XjAI1zTKvTYO0uQLchajqZFVLgZyMRUtsIEjwZOZw9oIv/8J25x4+mkNH0
	JvpQTGnwFZy8sJBDc+HCtQ23GkYXcef0D1Hqpf26GyPJfzntYLa3nDDKdNWcqwzUWgYs=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsl-008KN0-2F
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 14/15] wifi: mt76: mt7996: add scan dwell time hw cap
Date: Mon, 27 Jul 2026 15:04:33 +0000
Message-ID: <20260727150434.1778520-14-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

Add NL80211_EXT_FEATURE_SET_SCAN_DWELL support in driver.
This allows user to specify channel dwell time during scanning.

Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index ee1f7a9f4851..70902395bc96 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -527,6 +527,7 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER);
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 
 	if (mt7996_eeprom_has_background_radar(dev) &&
 	    (!mdev->dev->of_node ||
-- 
2.53.0

