Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D74299A87
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897300; cv=none; b=AjeXv8tt4YDVwK7pQ9skKRuHiP7cjaZUol7gXdl0y98UXUhvoLxm8c6DQLMDF6He+OJ4IH/oGCxswY5/elxKEDq+/oFVfRDxmlh/+oiPn+mlqzVVEcrg+ljZITyNGoEuOflDxEEwdMmFWUY9mO6aRSNX8AYH2UZVrbM3abyJCO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897300; c=relaxed/simple;
	bh=jlhEzwef4Dpf3PdOGON6NI3qoGjHdLsUjWX1meYxdiA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWK+sPzldC04UYPz+wRpsrQXWi3eMheResAEhMFYwzoPzvD0D6rq5aLP42nhaUQ7M5k56tWCVBi3lrAOg+BEwb7TxbvwOxO8DiBU0Z95Ilrcm2kB6QmX/7V9YdWyTJKw/Fib3k6uZ/QDjYZbA0lpsvGoGp9LqMWtvc976kLcNiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=IIIiQ/Xu; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="IIIiQ/Xu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sjT8pNlL0SW+0mcmdgxoBi7EtS1jkkA9NU9mTfwUquY=; b=IIIiQ/Xu7fQc53IhVSvBRw6eWi
	Ww8Z6cEGBlKUgRkmrliAh/emk0e8g6EBcVXMsPJ0Ic9pnqLSq/O/Yzn+jSBYBJK+EeMvi5Jfu4o+5
	TH2Wwg8lqwtRRO9l1jrFxoZNuJU7J/Rhrx+/mWaBpW+0ntDaR3Pi0HORiXScFT7f9Rm4=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK5-006LeO-0D
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 09/29] wifi: mt76: mt7996: don't leak MLD group index on remap alloc failure
Date: Fri, 24 Jul 2026 12:47:53 +0000
Message-ID: <20260724124813.3961474-9-nbd@nbd.name>
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

mt7996_change_vif_links() sets the mld_idx_mask group bit before
allocating the remap index. If the remap allocation fails it jumped to
the exit without clearing that bit, permanently consuming one of the 16
MLD group slots. Release the group bit on the error path.

Fixes: 4fb3b4e7d1ca ("wifi: mt76: mt7996: fix MLD group index assignment")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 2487b00c3790..57afe4e81666 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2458,6 +2458,7 @@ mt7996_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 		idx = get_free_idx(dev->mld_remap_idx_mask, 0, 15) - 1;
 		if (idx < 0) {
+			dev->mld_idx_mask &= ~BIT_ULL(mvif->mld_group_idx);
 			ret = -ENOSPC;
 			goto out;
 		}
-- 
2.53.0

