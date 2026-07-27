Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815F33806C4
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=N8lzNL9eZTQrArKLTJUSrx8ZBjuhDwvWTstWxU6GScNcIkBahlIZHdUTgGdHDqIGVx5osZg5jmxvitJN8sbj9Rw6aSdPmEU5cemv+dw6GKd95RsB2hsCkS005nJLoyz6e2141Jos+bXoHNoUs53UtiawHZebE01CQNC8hk7loKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=TdJLFOZEsVrPC+Uh2zArxczIF+rsq3TbYWQJwZ+3sJ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgLNQnZLWymwcg7SGCAYyXSOKNGy7tqfBDe+pGt0ccTJddutUcQDdR2eqe8yZDpHD+nRVjlCUO79ZXykS3dpm8VkbJd5pQOVwaxxbn7qL5M46oIJIX7Kcjlpv7RjgcbcPxVcS1oIjn8yM+0dtr7dhqGrsrasqPsF9La535cZovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=MRZKRT32; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="MRZKRT32"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7Gv2fraQXMqZ4zP6seihiYgZ9yoA1JoMoQ9UCOG2DK0=; b=MRZKRT32fXzchjV6NtqzsC1s5K
	WhEeMelbQt7uO84xD6GbGbziVnR+S2mQ9/DFsBZl/8DOEj54/sgsVGy+Wz3DvNUfj2pMa/zFZPKrf
	3HZPzUIHyZMLSrHRoAvgNi96Y8WihZeUC1pQ8kh4Ohqkhr5/IkPyc7fvoqn9eI7eDQTw=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsj-008KN0-2b
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 03/15] wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
Date: Mon, 27 Jul 2026 15:04:22 +0000
Message-ID: <20260727150434.1778520-3-nbd@nbd.name>
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

After mt7915_register_ext_phy() succeeded, a failure of the main PHY
mt7915_init_debugfs() or mt7915_coredump_register() unwound through
free_phy2, which called ieee80211_free_hw() on the ext PHY hw while it
was still registered with mac80211, since mt76_unregister_device() only
unregisters the main hw. Unregister the ext PHY (thermal + phy + hw)
first and skip the redundant free.

Fixes: 7b8e1ae886e4 ("mt76: mt7915: rework hardware/phy initialization")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 0f6346731308..ca46a203aa48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1302,14 +1302,19 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 	ret = mt7915_init_debugfs(&dev->phy);
 	if (ret)
-		goto unreg_thermal;
+		goto unreg_ext_phy;
 
 	ret = mt7915_coredump_register(dev);
 	if (ret)
-		goto unreg_thermal;
+		goto unreg_ext_phy;
 
 	return 0;
 
+unreg_ext_phy:
+	if (phy2) {
+		mt7915_unregister_ext_phy(dev);
+		phy2 = NULL;
+	}
 unreg_thermal:
 	mt7915_unregister_thermal(&dev->phy);
 unreg_dev:
-- 
2.53.0

