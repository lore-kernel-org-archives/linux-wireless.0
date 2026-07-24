Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AE74334CC
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897305; cv=none; b=t9gzmAf4vx92zyAGIqspi1TPVQne+o7m6Z/O7kIojL0lEm7EL9CGjmu+FIJte6XBz+p2o0QgLQuj0XPkArRcqfm6W3N+F0W9T2HMqovUTxrkyHv9qTwh76olO0QGBJujYPQZNtd8HErt6wgTFZdgJtOmySJ6PCBh8U/xXLq8qr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897305; c=relaxed/simple;
	bh=gaMbrGtdPKUqhZboEN8HMoDoI8eFa82Ygxy16n5Vmlw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/0uSkM2Rd2/4GvHpAs7vjyP7AL692dxvpwpPB9xuCUuA+zb9zqJtPJristLddJEzEJ+RHF213BbhOEKhBbyhb5SqkrYG6fgEeExjd3CLoktzH1Hk4/35YeI7cGuncx48mwzw3Yy3wg4MosSqSxsq+YjgJisu790OxzyWjOudzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=RAE7wB3n; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="RAE7wB3n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5go9WEnCwjyrq2+jdjqZzqpw9Bytf0la5PjjEC36T+Y=; b=RAE7wB3nGLX2gmQdW+IA6i2Di6
	qriEKFU+Ddb6b2PbTBGY4R+EkIA3K4dFzONsT/Q184+zsbYKNUAsTkbEoX9DOXKrxrn1k758xAWjx
	77EfLobLWs/dHiApMJHK4yBN60FJr91pMSM5O0ePF9TWgHTELmKaRsOTDEVNAV/+DrFI=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK8-006LeO-3A
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:21 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 29/29] wifi: mt76: mt7996: hold dev->mutex in remove_interface teardown
Date: Fri, 24 Jul 2026 12:48:13 +0000
Message-ID: <20260724124813.3961474-29-nbd@nbd.name>
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

From: Chad Monroe <chad@monroe.io>

mt7996_remove_interface() destroys the remaining vif links, clearing
omac_mask, vif_mask and mld_idx_mask, with only the wiphy mutex held.
Those masks are modified under dev->mutex everywhere else, so the
unlocked clears can race the scan-link teardown and the reset work
and lose updates.

Take dev->mutex around the link destroy loop, matching
mt7996_add_interface() and mt7915_remove_interface(). The mutex is
released before mt76_vif_cleanup(), which aborts a pending scan and
takes the mutex itself.

Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index ce7aede6201e..97be70c23753 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -606,6 +606,8 @@ static void mt7996_remove_interface(struct ieee80211_hw *hw,
 	unsigned int link_id;
 	int i;
 
+	mutex_lock(&dev->mt76.mutex);
+
 	/* Remove all active links */
 	for_each_set_bit(link_id, &rem_links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_vif_link *link;
@@ -622,6 +624,8 @@ static void mt7996_remove_interface(struct ieee80211_hw *hw,
 		mt7996_vif_link_destroy(phy, link, vif, NULL);
 	}
 
+	mutex_unlock(&dev->mt76.mutex);
+
 	ieee80211_iterate_active_interfaces_mtx(hw, 0, mt7996_remove_iter,
 						&rdata);
 	mt76_vif_cleanup(&dev->mt76, vif);
-- 
2.53.0

