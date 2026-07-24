Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500834334A8
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897305; cv=none; b=EbhzRgMrLxM9xi3dnN11TZp1tuu2ooeZfwv9bUpwwpDxfJ39stRf2C2oGQB525VmLCp/AyjzX/7Ydc//deveX2lYCLacUI/on8683ogFJf6YMmBzFDm3TxbC25g850OdVBgopPbUa9Asyj/aXPyjHohbwIkZAXhrRSxiwiIWw5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897305; c=relaxed/simple;
	bh=cPMJgyqFjz2W4k4+dvq02fyY1kbL1fWYvyU5MKdFhXs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxEmTfmdHoWf++Ww9XPPhNJ+XnlQtlSINNqjCDuvgZIot4NrL6qBhs86GF9bAbSzGMNOf7u4c7QrTyBvk6+G9B87bCov7+DO83KQxYmo3ZmDx0QFcBDVASlyL4wtOL8V173QfuWlsWKf8bTh3z0KU/D0MU1L0Fyxsbb6Qzo5dzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=oMHUpVf4; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oMHUpVf4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Sdoe+b70ZEAzkysu7mAcgHN0BiRzqtBd851gY98Xxss=; b=oMHUpVf4MSBaQbtQjn9KVZbwqN
	pjMNv4fHowSumA9RJzT/vAvP5jXC5j+iD8/+2+AOJIMwUWxJL2Au+mvc2760bn3IkfIBOWWO/ta4l
	y3PBoObpAcN11yWpMw8LK5Hkkwc67K/swVYX1UoH7qAuLVsjS6q/ItUe1lsgXZJIdfNE=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK8-006LeO-1Y
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:20 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 26/29] wifi: mt76: mt7996: clear stale link state on full reset
Date: Fri, 24 Jul 2026 12:48:10 +0000
Message-ID: <20260724124813.3961474-26-nbd@nbd.name>
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

After a full chip reset, mac80211 reconfig replays interface, link and
channel context setup. mt7996_vif_link_add() short-circuits when the
link_id is still marked in mvif->valid_links, a state introduced for
postponing link teardown to interface removal. The reset path frees the
link structures without clearing those bits, so the replayed setup never
re-creates dev_info/bss_info/STA records in the restarted firmware and
never re-registers the link wcid, leaving the device inoperative.

The reset path also leaks every allocated MLD index: per-link indices
and the per-vif group/remap indices are re-allocated from scratch during
reconfig, but the old bits stay set in the masks, so repeated full
resets exhaust the index space.

Clear valid_links in the reset vif iterator and reset the MLD index
masks alongside the existing omac_mask clearing.

Fixes: ace5d3b6b49e ("wifi: mt76: mt7996: improve hardware restart reliability")
Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index ce8c5a5ea8cc..4794dacb3756 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2449,6 +2449,7 @@ mt7996_mac_reset_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		rcu_assign_pointer(mvif->link[i], NULL);
 		kfree_rcu(mlink, rcu_head);
 	}
+	mvif->valid_links = 0;
 	rcu_read_unlock();
 }
 
@@ -2483,6 +2484,8 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	mt7996_for_each_phy(dev, phy)
 		phy->omac_mask = 0;
+	dev->mld_idx_mask = 0;
+	dev->mld_remap_idx_mask = 0;
 
 	ieee80211_iterate_stations_atomic(hw, mt7996_mac_reset_sta_iter, dev);
 	mt76_reset_device(&dev->mt76);
-- 
2.53.0

