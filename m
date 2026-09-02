Received: from mail-10627.protonmail.ch (mail-10627.protonmail.ch [79.135.106.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9680B486E45
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 12:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788352228; cv=none; b=huhg8XQQ795t8+YAcVDy4H3fjF3t/Y+xu0aR4x7qWxBMC8JsbWXGkLsW+vo+d+kS+rEHkAij4v4G2W6mFSt7CBHmnnt+9cQBSgxYsdFF6BVxnP9lS+6B8rD0agixFXeuZ45bN+KteEmOPGeq61+gzzIFlREnGm+n1q3qHYuVZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788352228; c=relaxed/simple;
	bh=sheNFg51uDipCBY4wKFeITLsLgXlIfb1LysQKMNaA+I=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=RXPRPyQPfVHOrj45WKScI+22V1hjdpzwa3MYZ6pJRCHdmRCWjfU6+1OU3ICu6n/4DaSrb2T9eK38HMxwV9047dZE+FaukClZdgyHwo8fKI+67NWpmWQ74eg9vMRdl4m9VzWIreBWRJwyEL0RdzYUIgnr2A3hkzgt2U5mpc6KQbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=empyreal.works; spf=pass smtp.mailfrom=empyreal.works; dkim=pass (2048-bit key) header.d=empyreal.works header.i=@empyreal.works header.b=Impi0/5b; arc=none smtp.client-ip=79.135.106.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=empyreal.works
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=empyreal.works
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=empyreal.works header.i=@empyreal.works header.b="Impi0/5b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=empyreal.works;
	s=protonmail2; t=1788352217; x=1788611417;
	bh=YU2mIB835mYw5//qKk+9pqJCWuqJD/Z0SnWodIvE8IM=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Impi0/5biADa5seEW73LvAATqy5IbbIYSehU5FFVfJGpOp9WnL5VIexSNJ6iKidop
	 QmL0/uLL1VLb+uBvaan668VUTnBwgvkgIUkPvH7yNq5nNjhbJK7xDYMGb7PsRuhcHc
	 OTlgeIF4yjdQgYUCsf/2eI4lBf+rU6EOLufPShH8OznB71YovU2lx7zi6yZbR4RtcW
	 cMoP308WgmzQKcc2w8g5cYHCk5lxAyyat5wvrKz0gjDXzNsZ9ZpI3VN8P/qql2/03n
	 uXL24965X0RjlGsG/+2gKbfuMQf3ekyHBXpm2TmxL4KUS8cudl5NB2KOxuXUIsL5RY
	 fgAS61XZMrVhw==
Date: Wed, 02 Sep 2026 12:30:11 +0000
To: linux-wireless@vger.kernel.org
From: Andrei Rusu de Castro <arc@empyreal.works>
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, shayne.chen@mediatek.com, sean.wang@mediatek.com, matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt7925: stabilize STA_REC_MLD link selection
Message-ID: <20260902-mt7925-0cbea623@empyreal.works>
Feedback-ID: 182420409:user:proton
X-Pm-Message-ID: 024b838ed21db538301af0a81238c1b4034d27bb
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mt7925_mcu_sta_mld_tlv() encodes the primary link and then, as the
secondary entry, whichever link the current station update happens to
be for.

STA_REC_MLD is a complete record rather than an incremental update:
every call rewrites primary_id, secondary_id, link_num and link[]. Since
mt7925_mcu_sta_update() is issued per link, the record left in firmware
depends on which link was updated last. For a two-link station an update
for the secondary link leaves both links, while a later update for the
primary leaves only the primary.

Fill the remaining firmware entries from the station's valid links.
Keep the primary in entry zero, walk secondary links in link ID order,
skip links without both station and BSS state, stop at the firmware
array size, and set link_num from the number of entries written.

A link added through .change_sta_links needs one ordering exception.
mt7925_mac_link_sta_add() sends the MCU command before publishing the
new link in msta->link[] and msta->valid_links. Fold that in-flight
caller link into the local valid-link snapshot and use its passed
station object when the published slot is still empty. The VIF link
state is already published and remains the BSS authority.

Commit ff643b81bc38 ("wifi: mt76: mt7925: pass mlink and mconf to
sta_mld_tlv()") removed the complete link lookups because the caller
already knew one link. Reintroduce them because that caller context
cannot otherwise describe the complete two-entry firmware record.

A source and call-graph audit identified the
trigger-dependent record and the link-add publication window. A
source-level harness issues the encoder across seven settled layouts
plus the in-flight add ordering, reproduces the old trigger dependence,
and passes 90 checks. The exact changed object builds with W=3D1.

Fixes: ff643b81bc38 ("wifi: mt76: mt7925: pass mlink and mconf to sta_mld_t=
lv()")

Signed-off-by: Andrei Rusu de Castro <arc@empyreal.works>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 49 +++++++++++++++++--
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/=
wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a455..d3e1ae4143cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2068,9 +2068,12 @@ mt7925_mcu_sta_mld_tlv(struct sk_buff *skb,
 =09struct mt792x_vif *mvif =3D (struct mt792x_vif *)vif->drv_priv;
 =09struct mt792x_sta *msta =3D (struct mt792x_sta *)sta->drv_priv;
 =09struct mt792x_dev *dev =3D mvif->phy->dev;
+=09unsigned long valid =3D msta->valid_links;
 =09struct mt792x_bss_conf *mconf_pri;
 =09struct sta_rec_mld *mld;
+=09unsigned int link_id;
 =09struct tlv *tlv;
+=09u8 max_links;
 =09u8 cnt =3D 0;
=20
 =09/* Primary link always uses driver's deflink WCID. */
@@ -2099,11 +2102,47 @@ mt7925_mcu_sta_mld_tlv(struct sk_buff *skb,
 =09mld->link[cnt].wlan_id =3D cpu_to_le16(msta->deflink.wcid.idx);
 =09mld->link[cnt++].bss_idx =3D mconf_pri->mt76.idx;
=20
-=09/* Optionally encode the currently-updated secondary link. */
-=09if (mlink && mlink !=3D &msta->deflink && mconf) {
-=09=09mld->secondary_id =3D cpu_to_le16(mlink->wcid.idx);
-=09=09mld->link[cnt].wlan_id =3D cpu_to_le16(mlink->wcid.idx);
-=09=09mld->link[cnt++].bss_idx =3D mconf->mt76.idx;
+=09/* Encode the remaining valid links of this station, not just the one
+=09 * this command happens to be updating. STA_REC_MLD is a complete
+=09 * record: every update rewrites link_num and link[], so selecting the
+=09 * secondary entry from the caller's link made the record firmware
+=09 * ends up holding depend on which link was updated last.
+=09 */
+=09max_links =3D ARRAY_SIZE(mld->link);
+
+=09/* mt7925_mac_link_sta_add() issues this command before publishing
+=09 * a new link in msta->link[] and msta->valid_links. Include that
+=09 * in-flight caller link in this record so it is not lost.
+=09 */
+=09if (mlink && mconf && mlink !=3D &msta->deflink)
+=09=09valid |=3D BIT(mlink->wcid.link_id);
+
+=09for_each_set_bit(link_id, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
+=09=09struct mt792x_link_sta *mlink_sec;
+=09=09struct mt792x_bss_conf *mconf_sec;
+
+=09=09if (cnt =3D=3D max_links)
+=09=09=09break;
+
+=09=09if (link_id =3D=3D msta->deflink_id)
+=09=09=09continue;
+
+=09=09mlink_sec =3D mt792x_sta_to_link(msta, link_id);
+=09=09if (!mlink_sec && mlink && link_id =3D=3D mlink->wcid.link_id)
+=09=09=09mlink_sec =3D mlink;
+=09=09if (!mlink_sec || mlink_sec =3D=3D &msta->deflink)
+=09=09=09continue;
+
+=09=09mconf_sec =3D rcu_dereference_protected(mvif->link_conf[link_id],
+=09=09=09=09=09=09      lockdep_is_held(&dev->mt76.mutex));
+=09=09if (!mconf_sec)
+=09=09=09continue;
+
+=09=09if (cnt =3D=3D 1)
+=09=09=09mld->secondary_id =3D cpu_to_le16(mlink_sec->wcid.idx);
+
+=09=09mld->link[cnt].wlan_id =3D cpu_to_le16(mlink_sec->wcid.idx);
+=09=09mld->link[cnt++].bss_idx =3D mconf_sec->mt76.idx;
 =09}
=20
 =09mld->link_num =3D cnt;

