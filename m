Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0FB34D910
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774555683; cv=none; b=YVcGz68APO30wd/0sCj2JTGmDvaJQK0Tnpl+QqGAEBQsWj7dQgrPjn8FHjO02FH9mJNkLEDLgV7xRaWi8+3ykR4jPNCbD54G2uj/bDFm2sSFRtQ/rp4QkUSv3/3xe11imalrAdld4ocIo3xLVqL9vEOpCzp6GTLj7OC7kav3GaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774555683; c=relaxed/simple;
	bh=Ki03cfETuQQC/SsXxP87AraOT/QLYljp30z8tR3MGNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r68Hj+M7LBsH2JYrayyWhUeXhkAUQ7Gu/9hsHnID5RSrb8xmwDztrB781Ljh9cOMWqZZEjJvb7hG2GFXzRHumR14TQ9ZQoBZ464s2F47C5bcdAMvu+tzJdWHDqOKeviHe+UB/HeVOKKxRTxRXCIAApJz7q101JscHKM34Jv4WKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=WLqHqDcQ; arc=none smtp.client-ip=148.163.129.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="WLqHqDcQ"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 31BE62AE737
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 20:08:01 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 016871C008F;
	Thu, 26 Mar 2026 20:07:51 +0000 (UTC)
Received: from pk3.candelatech.com (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 49BB713C2B0;
	Thu, 26 Mar 2026 13:07:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 49BB713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1774555669;
	bh=Ki03cfETuQQC/SsXxP87AraOT/QLYljp30z8tR3MGNM=;
	h=From:To:Cc:Subject:Date:From;
	b=WLqHqDcQ4fQ8x/6PyyloNRMD3zH6NTeRh8DFb8+SXOEm4DocrerhQIaXM8R3I8WMo
	 hDeNIGDKbWQYMsXzAE/fZ71nxoMA5WPkxpXMC10hNRuUQc/z5AMobIITCQJ/oTaZ6Y
	 mbgk+9FAux/GXns7ynM1M5snYJIvx3NS98sCvAU8=
From: dylan.eskew@candelatech.com
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com
Cc: linux-wireless@vger.kernel.org,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	Dylan Eskew <dylan.eskew@candelatech.com>
Subject: [PATCH] wifi: mt76: mt7996: limit work in set_bitrate_mask
Date: Thu, 26 Mar 2026 13:07:38 -0700
Message-ID: <20260326200737.3736975-2-dylan.eskew@candelatech.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1774555673-W6umXQiqA__f
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1774555673;W6umXQiqA__f;<dylan.eskew@candelatech.com>;f49eb8a899f4a60c9b856bf22a60d609
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Dylan Eskew <dylan.eskew@candelatech.com>

Calls to mt7996_set_bitrate_mask() would propogate work for all stations
on the ieee80211_hw regardless of the vif specified in the call. To
prevent unnecessary work in FW, limit setting the sta_rate to only the
specified vif in mt7996_sta_rate_ctrl_update().

Fixes: afff4325548f0 ("wifi: mt76: mt7996: Use proper link_id in link_sta_rc_update callback")
Signed-off-by: Dylan Eskew <dylan.eskew@candelatech.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index a8a6552d49f6..26b8c91db0a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1959,7 +1959,11 @@ static void mt7996_sta_rate_ctrl_update(void *data, struct ieee80211_sta *sta)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	struct mt7996_sta_link *msta_link;
-	u32 *changed = data;
+	struct mt7996_vif *mvif = data;
+	u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
+
+	if (msta->vif != mvif)
+		return;
 
 	msta_link = rcu_dereference(msta->link[msta->deflink_id]);
 	if (msta_link)
@@ -1972,7 +1976,6 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-	u32 changed = IEEE80211_RC_SUPP_RATES_CHANGED;
 
 	mvif->deflink.bitrate_mask = *mask;
 
@@ -1985,7 +1988,7 @@ mt7996_set_bitrate_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 * then multiple MCS setting (MCS 4,5,6) is not supported.
 	 */
 	ieee80211_iterate_stations_atomic(hw, mt7996_sta_rate_ctrl_update,
-					  &changed);
+					  mvif);
 	ieee80211_queue_work(hw, &dev->rc_work);
 
 	return 0;
-- 
2.52.0

