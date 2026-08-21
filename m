Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4003C988E
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787302823; cv=none; b=HLN9uvqOJjpHNKYjEJdfnwPwcSblNi865ZYKPHMYWCDH4zXIWa04fd5WwyigTT5d3zbDG5H4uGazOwg7DrkeR0IQsNzu8kJ2GjZsFLfObv6CIPtaE90FoMey0KJ3UrcuL168grSXFwmLK8MpnhTjPTV0mXQDZPg3JeXRfV5+gYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787302823; c=relaxed/simple;
	bh=FKtzvitcBNgxzlYkDZveYm1MKKZixbY/DeQfWprquZ0=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=oIO1U3k9K47qdGnmmco2gYepnzipX5SI0tvGLwG4JUXQZDnh1z2Y6UEmYrmZ+qJ8w/ECb3on8fQv404sJ4oOF8Lw/5Stjxh9wPOiJoWOcl209UT7iXK8nRnIai2S+6hwnL6K7VrWNH6b9NX+DShKW2G2lIpRat6mwp8ea9+uM/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=tq+5clEr; arc=none smtp.client-ip=185.70.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="tq+5clEr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1787302805; x=1787562005;
	bh=xvQD6+MhAqrZHD+Spx/wMDCkvEy0KGRXaEdYaUDsVII=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=tq+5clErfQ6SBAbT+ljkuxv8fKbInx4wTP6ZB/qDNkN+SyukAV9CWY2+IgwjvvMRU
	 W78oaD95cBzScWSBbELl90K5+APT/p+tjOHx2z3k2d6egYXFvApqBawIhdJXKX7oX9
	 6nRNl/v3NQ5LU2dFH8KQmqqTINl0saEIu8x2GT82ArfoLbSGNAlJ22NOP1uHVlRiAV
	 7oVKuq9KNqFT4kBI3AWCpHp1FVEoAjvRo2uRlKMjTgbl982Roz9sXbTmtHChLzWQC/
	 47UsZDvH6dN2gpVVHK9EhlHdj4/UskR5c+KBQSvVH105E0FthAnWdiMrueWCy+9r+8
	 oCmtnCXtkgsLA==
Date: Fri, 21 Aug 2026 09:00:01 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Peter Chiu <chui-hao.chiu@mediatek.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH mt76 v2] wifi: mt76: mt7915: publish wcid before MCU add commands
Message-ID: <20260821-mt7915-wcid-publish-order-v2-1-acf0b7f32cbd@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 925f30d38a406df4b0ed3723747f01510db6bb67
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mt7915_add_interface() enables the BSS/STA in firmware via
mt7915_mcu_add_bss_info() and mt7915_mcu_add_sta() before publishing
dev->mt76.wcid[idx] with rcu_assign_pointer(). Firmware can start
generating tx-status/tx-free events referencing that wcid as soon as it
processes those MCU commands, but mt76's rx/tx-free handlers (e.g.
mt7915_mac_tx_free()) look up dev->mt76.wcid[idx] to service them, and
won't find it published yet. This can lead to memory corruption and
kernel crashes shortly after an AP interface is brought up.

This ordering was introduced by commit 8e3e7567b8c1 ("mt76: mt7915: add
sta_rec with EXTRA_INFO_NEW for the first time only"):
mt7915_mcu_add_sta() derived its "newly added" flag from
!rcu_access_pointer(dev->mt76.wcid[idx]), so the publish had to happen
after that call. Commit 33eb14f10290 ("wifi: mt76: mt7915: use mac80211
.sta_state op") later replaced that flag with a caller-supplied `newly`
argument to mt7915_mcu_add_sta(), now simply hardcoded to true, so the
ordering is no longer required.

Move the rcu_assign_pointer() before the MCU add_bss_info/add_sta
calls, so that the wcid is visible to lookups before firmware is told
it's live. This makes the ordering symmetric with
mt7915_remove_interface(), which keeps the pointer published until
after the MCU disable commands have been issued.

Closes: https://github.com/openwrt/openwrt/issues/24594
Fixes: 8e3e7567b8c1 ("mt76: mt7915: add sta_rec with EXTRA_INFO_NEW for the=
 first time only")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
Changes in v2:
- Reword the mt7915_remove_interface() comparison in the commit message
  to correctly state that the wcid stays published until after the MCU
  disable calls (not before).
- Link to v1: https://patch.msgid.link/20260820-mt7915-wcid-publish-order-v=
1-1-79d2bc981d8b@protonmail.com
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net=
/wireless/mediatek/mt76/mt7915/main.c
index a8286f8becf9..9c6c339f1b38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -273,9 +273,9 @@ static int mt7915_add_interface(struct ieee80211_hw *hw=
,
 =09mt7915_init_bitrate_mask(vif);
 =09memset(&mvif->cap, -1, sizeof(mvif->cap));
=20
+=09rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 =09mt7915_mcu_add_bss_info(phy, vif, true);
 =09mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_PORT_SECURE, true);
-=09rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
=20
 =09mutex_unlock(&dev->mt76.mutex);
=20

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260820-mt7915-wcid-publish-order-bebef551330c

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


