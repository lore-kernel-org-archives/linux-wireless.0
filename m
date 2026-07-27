Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF92F41E6D6
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168862; cv=none; b=uDcRErr7rYM0B45s/7osi4AXCRpZfmTvBw3ELvNGcD7yt0WVCbs7VWiUlsfFZE19ypDbwplS9hfz6sb2pILX8M1oRH/GwjKJlU/S9QEWiU9/6pFRyrd9Pf678Xo9oi33g0OE5eiiIu8zO2jvDWRlmMxK/60baGuXhomTm6t6Uvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168862; c=relaxed/simple;
	bh=vUMPLkxwyfVCU8FkBzrOvL+8SEpjHDt5XcrVGlOcLqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ey32DQqCSUIEXD7ZL3mwzjs4QKf83frtuxTg/k14/VYka75TTCYI2P7zQ6hRSxBeUuAgNcm8miPOsL6muarO4pz0eNEAwrGov4CFuYThaE3AmsbvTqOtAJQ0Ezhh46RSE8xazZ/R/jDWmI4tWIlG64mcAyo3+p5YqFYk4gqf4JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PU0erG01; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PU0erG01"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785168844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7ERsk4RonSTxH6y6u79b8fYU24WhTCDe99xKkRDKAHE=;
	b=PU0erG01/EdPfJ0s5nUxPNTkqTi4GKBypsHIVDqOd3xc1j1+bUGYKQckbmPuxB9w6IfnAw
	8WzR28K7BaQzFdu8JkmLQxPqxGrcLhH/GEa88SOfQ/M/VBi4XNo9o39RbHhkDm7i6LnF43
	B+v7dgoGuK+nc02ReTbduLTOJNZPZ5k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-oQIgAHlWNcKLYhR8fch28w-1; Mon,
 27 Jul 2026 12:14:01 -0400
X-MC-Unique: oQIgAHlWNcKLYhR8fch28w-1
X-Mimecast-MFC-AGG-ID: oQIgAHlWNcKLYhR8fch28w_1785168840
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C1CB1955DD8;
	Mon, 27 Jul 2026 16:13:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.58])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25DB4429;
	Mon, 27 Jul 2026 16:13:56 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: nbd@nbd.name,
	lorenzo@kernel.org
Cc: ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	linux-wireless@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH] wifi: mt76: mt7996: fix NULL pointer dereference in MLD AP recovery
Date: Mon, 27 Jul 2026 18:13:53 +0200
Message-ID: <20260727161353.962426-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

During full hardware reset, mt7996_mac_reset_vif_iter() frees non-default
VIF links and mt76_reset_device() clears all WCID entries, but
mvif->valid_links is not cleared.

When ieee80211_reconfig() runs after recovery, it calls
mt76_assign_vif_chanctx() which invokes mt7996_vif_link_add(). Since
valid_links still has the stale bits set, vif_link_add() takes the early
return path and skips WCID initialization (mlink->wcid assignment and
rcu_assign_pointer to the global WCID table). Later,
ieee80211_reconfig_ap_links() calls mt7996_link_info_changed() which
invokes mt7996_mcu_add_sta() with link->mt76.wcid == NULL, causing
a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 00000000000000b8
  RIP: 0010:mt7996_mcu_add_sta+0x2fd/0x630 [mt7996e]
  Call Trace:
   mt7996_link_info_changed+0x105/0x3f0 [mt7996e]
   ieee80211_reconfig_ap_links+0x107/0x1d0 [mac80211]
   ieee80211_reconfig+0x104a/0x1270 [mac80211]
   ieee80211_restart_work+0xf2/0x140 [mac80211]

Fix this by clearing valid_links and resetting deflink_id in
mt7996_mac_reset_vif_iter() so that vif_link_add() takes the full
initialization path during recovery. Also clear the per-device MLD
index masks (mld_idx_mask, mld_remap_idx_mask) in mt7996_mac_full_reset()
to prevent index leaks across resets.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
Note: I will have limited availability from mid-August to
mid-September. I will address any review feedback before then
or promptly after returning.

 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 0eebc8182ca9..463bec7ad732 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2384,6 +2384,9 @@ mt7996_mac_reset_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		kfree_rcu(mlink, rcu_head);
 	}
 	rcu_read_unlock();
+
+	mvif->valid_links = 0;
+	mvif->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 }
 
 static void
@@ -2423,6 +2426,9 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 						   mt7996_mac_reset_vif_iter, dev);
 	mt76_reset_device(&dev->mt76);
 
+	dev->mld_idx_mask = 0;
+	dev->mld_remap_idx_mask = 0;
+
 	INIT_LIST_HEAD(&dev->sta_rc_list);
 	INIT_LIST_HEAD(&dev->twt_list);
 
-- 
2.54.0

