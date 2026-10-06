Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACDC48E0F0
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320385; cv=none; b=Qe+zKGAxq7PIa/hcMb6C4VTjKvP+ou1Ivgp2XiFxzkQqKR4XhY+mEK0MfPT2hWM+DCYrta1v5nJJMfsrZ87cQRESSi9LSoBDj7VNvim+uRo1GugQqtYbNQITjrQaRGFMu/ohnD5oIYlyGKxgvBfLgyMONAb/gp09Pw68k4IhZxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320385; c=relaxed/simple;
	bh=aBa+cewcxfoBy5HJ3AM6KbdpNkApbNGmpNP1EDaGVJI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSgyZzif9N2JETUrsnE6jXlIj5z/70ED1FWGhsWyJBIGbjmYdT0KHDn5kJ4jKjiT6TbQOGPfyR5r4UoUmyYSiWayp0tFYeZ2JDiQtxClBlW/UdAeA7ao5JB4yIJDu6nMtsI4tb+FQiJmhx77IvLFFhxl5qZ0qfFgK66lCY8Cayw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=fDfiNvay; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="fDfiNvay"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uASOhccAAZU49SP1USGqoGECEpPJU0H+fNWhkbwkMiE=; b=fDfiNvayV2RbFH9W4rWZ+zLNEv
	hg6VCw69JuH1fHsSfKXJvTzg0K1wR1na954AcOwg9yncIksY82UuoU3R2qSMFe0EN2fWlM8FU3doL
	quMXsYJ92VclI6J3WpOTKOnBubfV1fuAt9iWFrzqNUpuaEvniZwfiDI3uq5gV1JaJm/I=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGD-00HAg3-2a
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 14/27] wifi: mt76: mt7996: do not reuse the deflink of a removed station link
Date: Tue,  6 Oct 2026 22:59:23 +0200
Message-ID: <20261006205936.669125-14-nbd@nbd.name>
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

mt7996_mac_sta_init_link() puts a new link in msta->deflink whenever
the station has no primary link. A removed link keeps its msta_link
until the station is removed, and the station has no primary link
after one mt7996_mac_sta_change_links() call removes all of its links
and adds others. If the removed
primary link was in msta->deflink, the new link then overwrites it:
both link slots point to the same msta_link, and the WTBL index of the
removed link is lost, so mt7996_mac_sta_remove() never returns it to
wcid_mask.

Use msta->deflink only if no link slot of the station points to it,
and allocate the msta_link otherwise. Choose the primary link as
before.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 8f483b1de852..8e70a4061ed6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1143,6 +1143,20 @@ mt7996_sta_deflink_set(struct ieee80211_sta *sta, unsigned int link_id,
 	mt7996_sta_init_txq_wcid(sta, idx);
 }
 
+static bool
+mt7996_sta_deflink_busy(struct mt7996_dev *dev, struct mt7996_sta *msta)
+{
+	unsigned int link_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		if (mt7996_sta_link_protected(dev, msta, link_id) ==
+		    &msta->deflink)
+			return true;
+	}
+
+	return false;
+}
+
 static void
 mt7996_sta_deflink_release(struct mt7996_dev *dev, struct ieee80211_sta *sta,
 			   unsigned int link_id)
@@ -1210,17 +1224,19 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	if (idx < 0)
 		return -ENOSPC;
 
-	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED) {
-		msta_link = &msta->deflink;
-		mt7996_sta_deflink_set(sta, link_id, idx);
-	} else {
+	if (mt7996_sta_deflink_busy(dev, msta)) {
 		msta_link = kzalloc_obj(*msta_link);
 		if (!msta_link) {
 			mt76_wcid_mask_clear(dev->mt76.wcid_mask, idx);
 			return -ENOMEM;
 		}
+	} else {
+		msta_link = &msta->deflink;
 	}
 
+	if (msta->deflink_id == IEEE80211_LINK_UNSPECIFIED)
+		mt7996_sta_deflink_set(sta, link_id, idx);
+
 	INIT_LIST_HEAD(&msta_link->rc_list);
 	INIT_LIST_HEAD(&msta_link->wcid.poll_list);
 	msta_link->sta = msta;
-- 
2.47.3

