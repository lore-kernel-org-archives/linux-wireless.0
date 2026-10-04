Received: from mail-106117.protonmail.ch (mail-106117.protonmail.ch [79.135.106.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91760353EC0
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 15:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791128958; cv=none; b=mtUzX3OFfp6cYnhOEpB6BdilgB4/O0g3q3/S0BWoi+SDzDGvNZwy7mYW33vtq0jTg3Mdw/+OAitU+Rwi+zaXNzL+DgAw2RsIq5Kz8CYjOFQPz2LYwzQJEsUINX+7Zm4rIPJHk9nF7YxwxIerq/9yzPFAGqH4rQJrXIydcX3Cl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791128958; c=relaxed/simple;
	bh=ZS3V/cbzF22rx6u0Atz3cuDNHwqxwGMiD0guO1ouTjE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nz+I5BpzN0xJWnURe/DCwabq8KpR9IPASfq1TfKvUvTL4GwOpp2dU5U0HdcPdUgbN6QU2ClH3cQiAkQF284cu8CMUU2vhzdMoGDUfMBKQgqnTeibpl2pr1m/ncHNvCB1Oui9FYZUehhFu+YcufyU9yJdXeDIeKPTSg2ieryDIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=empyreal.works; spf=pass smtp.mailfrom=empyreal.works; dkim=pass (2048-bit key) header.d=empyreal.works header.i=@empyreal.works header.b=JVukEPNs; arc=none smtp.client-ip=79.135.106.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=empyreal.works
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=empyreal.works
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=empyreal.works header.i=@empyreal.works header.b="JVukEPNs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=empyreal.works;
	s=protonmail2; t=1791128948; x=1791388148;
	bh=Pq5HNTDTVeqsjr77wNxYBJzQ+RTLgh8cB7pxfVi+KIQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=JVukEPNsoDR6zojr0eSejCIaO4gOf6u1YzbXf5oG5OSIY2htNHBQw+xrta43nYZgc
	 izI53l6A6I/WL0j9uu4GhZ5bXZEOV3LIl7Pg/1E8Ty7reACr+fNdTFkqhnw+hhw2bW
	 JJiPHRkb+8TMkfslxw2i3274V0ZC5vYf5dBreWi4kqByTfR8Cn/nKjWZaXtMZM33RC
	 NZxDpt4+6I3DYVRwbIFjyZR/sQZ6iGrRj/V6RB6xcHIjWqbj5NW1cIm5DD1s7SVTUl
	 fUrhuJupwrQIx9GfFVQMuppXom6As1nrzc+uukyr8P+N9NqgmhTs4rUQCOAEmo2WPg
	 z1innRPQ7JI+w==
Date: Sun, 04 Oct 2026 15:49:02 +0000
To: linux-wireless@vger.kernel.org, Devin Wittmayer <lucid_duck@justthetip.ca>, Jonas Hort <jonas.hort@posteo.de>
From: Andrei Rusu de Castro <arc@empyreal.works>
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Sean Wang <sean.wang@kernel.org>, Thorsten Leemhuis <regressions@leemhuis.info>, regressions@lists.linux.dev, linux-mediatek@lists.infradead.org
Subject: [PATCH v2] wifi: mt76: mt7925: keep MLD membership consistent during link add
Message-ID: <20261004-mt7925-mld-v2-248bb5e6404f@empyreal.works>
In-Reply-To: <20261004-mt7925-mld-v2-results-248bb5e6404f@empyreal.works>
References: <503eb10e-80cf-493e-95fd-04fc0f94ce01@posteo.de> <e4bc5ce3-9a6f-4365-9d36-f6440ded0865@posteo.de> <c64f5fa6-4c61-45b6-a513-b971e59d7723@posteo.de> <476e7721-580e-4a6b-86e5-5ed782a2c7ec@leemhuis.info> <c9f984c4-e3c4-4e41-a502-99db97ce724b@posteo.de> <20260829221319.25334-1-lucid_duck@justthetip.ca> <d245c4b1-dfba-4507-85a2-c6883f5eae64@posteo.de> <20261003180334.83575-1-lucid_duck@justthetip.ca> <20261004-mt7925-mld-v2-results-248bb5e6404f@empyreal.works>
Feedback-ID: 182420409:user:proton
X-Pm-Message-ID: f792a13a8036d7817e32579c09355c59e59ca69b
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

mt7925_mac_link_sta_add() sends an ASSOC update for the primary WCID
before sending the update for a new secondary WCID. The new link is
published in msta->link[] and msta->valid_links only after both commands
succeed.

Selecting the secondary entry from the subject of each command gives
the primary STA_REC_MLD one link and the secondary STA_REC_MLD two
links. Enumerating published links alone still omits the pending link
from the primary command. Firmware-bound command captures reproduce
this n=3D1/n=3D2 sequence during a secondary addition.

Build each MLD TLV from the station's published links and an explicit
pending link. Pass the initialized pending link through both add-time
station updates, including the update whose subject is the primary.
Keep the primary first, bound entries by the firmware array, and skip
links without station and BSS state. Other update callers have no
pending link.

This leaves msta->link[] publication after successful link setup and
preserves the existing add-failure cleanup. The pending pointer is used
synchronously to populate the command, not stored in shared state.

Fixes: ff643b81bc38 ("wifi: mt76: mt7925: pass mlink and mconf to sta_mld_t=
lv()")
Link: https://lore.kernel.org/linux-wireless/066b30cc-a9e6-4aeb-964d-71551e=
8ea3ef@posteo.de/
Signed-off-by: Andrei Rusu de Castro <arc@empyreal.works>
---
Changes since v1:
- Carry an explicit initialized pending link through both add-time updates,
  not just the update whose subject is the pending secondary.
- Preserve msta->link[] publication after successful setup.
- Describe consistency between per-WCID commands without assuming a
  shared firmware record overwritten by the last command.

V1: https://lore.kernel.org/all/20260902-mt7925-0cbea623@empyreal.works/

Tested on MT7925 PCIe, Linux 7.3-rc5, firmware 20260813113118, ASUS
GT-BE98 advertising three links with a 5+6 GHz active pair. The in-tree
MLD path stalled after 157 seconds, v1 after 289 and 150 seconds. V2
passed a 48-sample, 813-second scan/traffic run; full-band scans returned
to 6.3-7.1 seconds from about 27 seconds. A second clean boot did not
stall through 812 seconds and 760 seconds of bilateral 20 Mbit/s traffic.
One gateway ping timed out while same-sample IP/HTTPS passed, so that
second run did not pass the strict zero-failure gate.

The local deployment variant, with separate retained safety guards,
passed the same gate on two PCIe Z13 machines (813 and 810 seconds).
Both then passed ordinary default boots. The scheduled-scan withdrawal
and independent WM2 reset correction were retained throughout testing.
USB hardware and the reporter's FritzBox setup remain untested here.

W=3D1/-Werror builds of changed objects pass on both rc5 and the mt76 base
below. Source-extracted fixtures under ASan/UBSan cover pending-link
encoding and host cleanup at eight failed BSS/STA command positions;
they do not model firmware rollback. Direct partial-link switches and
reset aggregation warnings also fail on the old full-revert baseline
and are not claimed fixed by this patch.

 .../net/wireless/mediatek/mt76/mt7925/mac.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 16 ++---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 59 +++++++++++++++----
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  3 +-
 4 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/=
wireless/mediatek/mt76/mt7925/mac.c
index 101f571b027f..cbc18dbcbad9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1502,7 +1502,7 @@ mt7925_vif_connect_iter(void *priv, u8 *mac,
 =09=09=09=09=09    true, NULL);
 =09=09mt7925_mcu_sta_update(dev, NULL, vif,
 =09=09=09=09      &mvif->sta.deflink, true,
-=09=09=09=09      MT76_STA_INFO_STATE_NONE);
+=09=09=09=09      MT76_STA_INFO_STATE_NONE, NULL);
 =09=09mt7925_mcu_uni_add_beacon_offload(dev, hw, vif, true);
 =09}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net=
/wireless/mediatek/mt76/mt7925/main.c
index c882952f5df1..f536fffffa08 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1006,7 +1006,7 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *m=
dev,
 =09    link_sta =3D=3D mlink->pri_link) {
 =09=09ret =3D mt7925_mcu_sta_update(dev, link_sta, vif,
 =09=09=09=09=09    mlink, true,
-=09=09=09=09=09    MT76_STA_INFO_STATE_NONE);
+=09=09=09=09=09    MT76_STA_INFO_STATE_NONE, NULL);
 =09=09if (ret)
 =09=09=09goto out_pm;
 =09} else if (ieee80211_vif_is_mld(vif) &&
@@ -1028,19 +1028,19 @@ static int mt7925_mac_link_sta_add(struct mt76_dev =
*mdev,
=20
 =09=09ret =3D mt7925_mcu_sta_update(dev, mlink->pri_link, vif,
 =09=09=09=09=09    pri_mlink, true,
-=09=09=09=09=09    MT76_STA_INFO_STATE_ASSOC);
+=09=09=09=09=09    MT76_STA_INFO_STATE_ASSOC, mlink);
 =09=09if (ret)
 =09=09=09goto out_pm;
=20
 =09=09ret =3D mt7925_mcu_sta_update(dev, link_sta, vif,
 =09=09=09=09=09    mlink, true,
-=09=09=09=09=09    MT76_STA_INFO_STATE_ASSOC);
+=09=09=09=09=09    MT76_STA_INFO_STATE_ASSOC, mlink);
 =09=09if (ret)
 =09=09=09goto out_pm;
 =09} else {
 =09=09ret =3D mt7925_mcu_sta_update(dev, link_sta, vif,
 =09=09=09=09=09    mlink, true,
-=09=09=09=09=09    MT76_STA_INFO_STATE_NONE);
+=09=09=09=09=09    MT76_STA_INFO_STATE_NONE, NULL);
 =09=09if (ret)
 =09=09=09goto out_pm;
 =09}
@@ -1248,7 +1248,7 @@ static void mt7925_mac_link_sta_assoc(struct mt76_dev=
 *mdev,
 =09memset(mlink->airtime_ac, 0, sizeof(mlink->airtime_ac));
=20
 =09mt7925_mcu_sta_update(dev, link_sta, vif, mlink, true,
-=09=09=09      MT76_STA_INFO_STATE_ASSOC);
+=09=09=09      MT76_STA_INFO_STATE_ASSOC, NULL);
=20
 =09mt792x_mutex_release(dev);
 }
@@ -1308,7 +1308,7 @@ static void mt7925_mac_link_sta_remove(struct mt76_de=
v *mdev,
 =09mt76_connac_pm_wake(&dev->mphy, &dev->pm);
=20
 =09mt7925_mcu_sta_update(dev, link_sta, vif, mlink, false,
-=09=09=09      MT76_STA_INFO_STATE_NONE);
+=09=09=09      MT76_STA_INFO_STATE_NONE, NULL);
 =09mt7925_mac_wtbl_update(dev, mlink->wcid.idx,
 =09=09=09       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
=20
@@ -1979,7 +1979,7 @@ mt7925_start_ap(struct ieee80211_hw *hw, struct ieee8=
0211_vif *vif,
=20
 =09err =3D mt7925_mcu_sta_update(dev, NULL, vif,
 =09=09=09=09    &mvif->sta.deflink, true,
-=09=09=09=09    MT76_STA_INFO_STATE_NONE);
+=09=09=09=09    MT76_STA_INFO_STATE_NONE, NULL);
 out:
 =09mt792x_mutex_release(dev);
=20
@@ -2123,7 +2123,7 @@ static void mt7925_vif_cfg_changed(struct ieee80211_h=
w *hw,
 =09if (changed & BSS_CHANGED_ASSOC) {
 =09=09mt7925_mcu_sta_update(dev, NULL, vif,
 =09=09=09=09      &mvif->sta.deflink, true,
-=09=09=09=09      MT76_STA_INFO_STATE_ASSOC);
+=09=09=09=09      MT76_STA_INFO_STATE_ASSOC, NULL);
 =09=09mt7925_mcu_set_beacon_filter(dev, vif, vif->cfg.assoc);
=20
 =09=09if (ieee80211_vif_is_mld(vif))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/=
wireless/mediatek/mt76/mt7925/mcu.c
index 2afd3f5e3266..634062730e65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2065,14 +2065,18 @@ mt7925_mcu_sta_mld_tlv(struct sk_buff *skb,
 =09=09       struct ieee80211_vif *vif,
 =09=09       struct ieee80211_sta *sta,
 =09=09       struct mt792x_bss_conf *mconf,
-=09=09       struct mt792x_link_sta *mlink)
+=09=09       struct mt792x_link_sta *mlink,
+=09=09       struct mt792x_link_sta *pending)
 {
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
@@ -2101,11 +2105,44 @@ mt7925_mcu_sta_mld_tlv(struct sk_buff *skb,
 =09mld->link[cnt].wlan_id =3D cpu_to_le16(msta->deflink.wcid.idx);
 =09mld->link[cnt++].bss_idx =3D mconf_pri->mt76.idx;
=20
-=09/* Optionally encode the currently-updated secondary link. */
-=09if (mlink && mlink !=3D &msta->deflink && mconf) {
-=09=09mld->secondary_id =3D cpu_to_le16(mlink->wcid.idx);
-=09=09mld->link[cnt].wlan_id =3D cpu_to_le16(mlink->wcid.idx);
-=09=09mld->link[cnt++].bss_idx =3D mconf->mt76.idx;
+=09/* Describe the same station links in each per-WCID STA_REC_MLD,
+=09 * rather than selecting the secondary from the current command.
+=09 */
+=09max_links =3D ARRAY_SIZE(mld->link);
+
+=09/* Adding a secondary link updates both primary and secondary STA
+=09 * records before publishing the new link in msta->link[]. Include it
+=09 * in both commands without moving that publication before success.
+=09 */
+=09if (pending && pending !=3D &msta->deflink)
+=09=09valid |=3D BIT(pending->wcid.link_id);
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
+=09=09if (!mlink_sec && pending && link_id =3D=3D pending->wcid.link_id)
+=09=09=09mlink_sec =3D pending;
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
@@ -2124,7 +2161,8 @@ mt7925_mcu_sta_remove_tlv(struct sk_buff *skb)
=20
 static int
 mt7925_mcu_sta_cmd(struct mt76_phy *phy,
-=09=09   struct mt76_sta_cmd_info *info)
+=09=09   struct mt76_sta_cmd_info *info,
+=09=09   struct mt792x_link_sta *pending)
 {
 =09struct mt792x_vif *mvif =3D (struct mt792x_vif *)info->vif->drv_priv;
 =09struct mt76_dev *dev =3D phy->dev;
@@ -2165,7 +2203,7 @@ mt7925_mcu_sta_cmd(struct mt76_phy *phy,
 =09=09if (info->state !=3D MT76_STA_INFO_STATE_NONE) {
 =09=09=09mt7925_mcu_sta_mld_tlv(skb, info->vif,
 =09=09=09=09=09       info->link_sta->sta,
-=09=09=09=09=09       mconf, mlink);
+=09=09=09=09=09       mconf, mlink, pending);
=20
 =09=09=09mt7925_mcu_sta_eht_mld_tlv(skb, info->vif, info->link_sta->sta);
 =09=09}
@@ -2190,7 +2228,8 @@ int mt7925_mcu_sta_update(struct mt792x_dev *dev,
 =09=09=09  struct ieee80211_vif *vif,
 =09=09=09  struct mt792x_link_sta *mlink,
 =09=09=09  bool enable,
-=09=09=09  enum mt76_sta_info_state state)
+=09=09=09  enum mt76_sta_info_state state,
+=09=09=09  struct mt792x_link_sta *pending)
 {
 =09struct mt792x_vif *mvif =3D (struct mt792x_vif *)vif->drv_priv;
 =09int rssi =3D -ewma_rssi_read(&mvif->bss_conf.rssi);
@@ -2208,7 +2247,7 @@ int mt7925_mcu_sta_update(struct mt792x_dev *dev,
 =09info.wcid =3D &mlink->wcid;
 =09info.newly =3D state !=3D MT76_STA_INFO_STATE_ASSOC;
=20
-=09return mt7925_mcu_sta_cmd(&dev->mphy, &info);
+=09return mt7925_mcu_sta_cmd(&dev->mphy, &info, pending);
 }
=20
 int mt7925_mcu_set_beacon_filter(struct mt792x_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/n=
et/wireless/mediatek/mt76/mt7925/mt7925.h
index 33782d9ba9ed..49fa94e5cfd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -286,7 +286,8 @@ int mt7925_mcu_sta_update(struct mt792x_dev *dev,
 =09=09=09  struct ieee80211_vif *vif,
 =09=09=09  struct mt792x_link_sta *mlink,
 =09=09=09  bool enable,
-=09=09=09  enum mt76_sta_info_state state);
+=09=09=09  enum mt76_sta_info_state state,
+=09=09=09  struct mt792x_link_sta *pending);
 int mt7925_mcu_set_chan_info(struct mt792x_phy *phy, u16 tag);
 int mt7925_mcu_set_tx(struct mt792x_dev *dev, struct ieee80211_bss_conf *b=
ss_conf);
 int mt7925_mcu_set_eeprom(struct mt792x_dev *dev);

base-commit: 0dbc9c9fa9b92767c2d556504f38b544cb57a96a
--=20
2.54.0


