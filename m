Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313603BFE47;
	Sun, 18 Oct 2026 10:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320497; cv=none; b=CaB2+7EVVycfDU31WeVuzifrRW4St0lkxCWPJJfAVQU/5LxFktdXFLZ1fj/rde271V4gSviqOsCdRQNMC+jMGR4byovsUqcswEBl1rMbIsw+nabD+UQ6IA5ZtQbUSdzUPbXOtX5G5QoR2B0m3uwtH0bjQScEeEqO36FOlX0gYvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320497; c=relaxed/simple;
	bh=7hmjHucBXbwuTY4Sz7QSqIRdn3tgfpNf5tEbCA4rCvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rHItYoR9pz6GMbDiJxGpzcXDvZ9f593qgBDthzNrt6nErDBSqjnfCGp3xAObocb9JlV0tALUhW9X2CSMhQHIgZqm73IhdFcENz89klnkddXRy8DkfdbK464iBCiXOpIHlaVWhNPgBiVBUGcfsx7RFRA4vcorOj4O+fQyqV/CQtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Pbb2CIJF; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Pbb2CIJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=tv
	dWDrbzXQPcRArKbRRazwOwJZcvcz3zMV26SeCgv8E=; b=Pbb2CIJFMeGe5pl1yd
	UGALXvCC9SaN+QWa/2PfA1R43TKs3occoXYAwd1j4gOjahn64zTEE8KX7ZJ4N45S
	ZgTu5t3BI/e1gObSVJ23m60aHmQQWKGjBrJvA0SN60FzKAEIhqC8t1DmCBSpjPBM
	fEXI/H7lcJOFGazMNHfqMPYUU=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDXHyjOo9Rq9DXFAw--.17380S4;
	Sun, 18 Oct 2026 18:47:47 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 2/2] wifi: mt76: mt7996: clear all link WCIDs before RCU removal
Date: Sun, 18 Oct 2026 18:47:39 +0800
Message-Id: <20261018104740.865520-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261018104740.865520-1-yaojiale02@163.com>
References: <20261018104740.865520-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXHyjOo9Rq9DXFAw--.17380S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr1rKr15uF15Ary3JF1UWrg_yoW5Jw1rp3
	yDZas09ryUArs7X3W3Cr4jvF45Za1rKry3ArZ7Wwn5JFyIkF92qF18ZFZrZFy5CF93Cay3
	Xr1ktFnrGan0va7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR0_MsUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhPsJ2rUo9M0RgAA3q

mt7996 registers a separate WCID pointer for every link of an MLD
station. The generic mt76 sta_pre_rcu_remove callback only clears the
WCID embedded at the start of sta->drv_priv.

The remaining link WCIDs can therefore still be acquired by the RX path
after station removal starts and outlive the synchronization performed
by mac80211, resulting in a use-after-free.

Add an mt7996 callback that clears every allocated station link WCID
before mac80211 waits for network readers.

Fixes: a9eae65d97f3 ("wifi: mt76: mt7996: Export MLO AP capabilities to mac80211")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index dd7a01c02a7c..dc7401319ed5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1510,6 +1510,31 @@ mt7996_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return mt7996_mac_sta_event(dev, vif, sta, ev);
 }
 
+static void
+mt7996_sta_pre_rcu_remove(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	struct mt7996_sta_link *msta_link;
+	unsigned int link_id;
+
+	mutex_lock(&dev->mt76.mutex);
+	spin_lock_bh(&dev->mt76.status_lock);
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (!msta_link)
+			continue;
+
+		rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx], NULL);
+	}
+
+	spin_unlock_bh(&dev->mt76.status_lock);
+	mutex_unlock(&dev->mt76.mutex);
+}
+
 static void mt7996_tx(struct ieee80211_hw *hw,
 		      struct ieee80211_tx_control *control,
 		      struct sk_buff *skb)
@@ -2568,7 +2593,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.vif_cfg_changed = mt7996_vif_cfg_changed,
 	.link_info_changed = mt7996_link_info_changed,
 	.sta_state = mt7996_sta_state,
-	.sta_pre_rcu_remove = mt76_sta_pre_rcu_remove,
+	.sta_pre_rcu_remove = mt7996_sta_pre_rcu_remove,
 	.link_sta_rc_update = mt7996_link_sta_rc_update,
 	.set_key = mt7996_set_key,
 	.ampdu_action = mt7996_ampdu_action,
-- 
2.34.1

