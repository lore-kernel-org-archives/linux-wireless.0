Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A233321AA
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786438232; cv=none; b=Dx7ExjHJsiQgTdaQNFiSd3XjIowFe8iTVCrDxv7Ap+3jR+Uu85P5u336bKD+skRnB47g42ONCtW/pHkrk+BwWiH2aZFKmZdUd/FyHBcIrprRadYKAHdt3GPfVVxKUYg6E/+SyG4/n/MCfwiJG1n3b6TDNFwoduwCym6FoHfPJmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786438232; c=relaxed/simple;
	bh=u0j/Ab3YUM5nDQoYY0xmAfrEx6wwqUw9VX9jyKMNDHM=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=b88EEbz7wZ2YVVmC7QfrXnJxTJ4qW/5Ci2uBuxXCV1exNgMMdOju+0SFrHhIUuCZck2ZNpyaj/7WEkdNi6UfqKK0jF4wbTY+PDB8r32/oJr0CmueE3QEr52LJm3mhPMHp+I5NOY0htG5NAkTFVPhonvaALFK39XqZMZqW5HHEpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=mAVTQhOm; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="mAVTQhOm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1786438213; x=1786697413;
	bh=B/BWd9ahgdTSLtwMVSEXT4QdTD2JB0E70QdMnhGX31c=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=mAVTQhOmpGXHl9WFki5svzlo53v3pvIixXkQAM64zsqqQPFUFvC06Re/sbCVKoA9M
	 jwHipIYc+gVUAyiPTDJgyv85nO50+DZer/gYdXYDd6dmPuJMG08Vui7FBbfM75Z8M4
	 KnZunRuQILdMjtvN2Mz4vxbeNJ4AnF2T7S/mcLp701m+8zDMYeaUJevSHNwLPcIebX
	 MbzJ0AFmp5mHI7wkCBMxzC0i3ZO9Ikzs+pK85r5qktEUORIyeQvAX7nBd+tpQVAiMx
	 y1H11bQYerWgCFUlu/WiCnEQkct14mCsc2bECkGHgMfg4aEYWoYVY5ue9n/8lb0O4N
	 x6DzmwhUdnF5A==
Date: Tue, 11 Aug 2026 08:50:03 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH v4] wifi: mt76: mt7996: add thermal zone device registration
Message-ID: <20260811-mt7996-thermal-zone-v4-1-9ca715a8ae1f@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 7ecc38f1bebdc3774029a95f1e69a3493d063ea2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Register the mt7996 phy as a thermal zone sensor using
devm_thermal_of_zone_register() so that device tree thermal-zones
nodes can reference the Wi-Fi chip as a temperature source. This
allows the kernel thermal governor to control external cooling
devices such as PWM fans based on Wi-Fi chip temperature.

Registration is non-fatal: -ENODEV is returned when no
thermal-sensors DT property references this device, which is the
expected case on platforms without a thermal zone configured.

Unregister the thermal zone together with the existing cooling device
when the phy is torn down, and on the hwmon registration failure path
in the same init routine, so neither is left registered against a phy
that is about to be freed. Clear both pointers after unregistering,
since this init-time failure path can now run before the normal
teardown path also unregisters the same phy, and without clearing them,
that second call would unregister already-freed objects.

Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
Changes in v4:
- Clear phy->tzone/phy->cdev in mt7996_unregister_thermal() after
  unregistering, making it idempotent.
- Link to v3: https://patch.msgid.link/20260810-mt7996-thermal-zone-v3-1-ae=
9d7cd6cde1@protonmail.com

Changes in v3:
- Unwind cdev/tzone registration in mt7996_thermal_init() on hwmon registra=
tion failure.
- Link to v2: https://patch.msgid.link/20260810-mt7996-thermal-zone-v2-1-56=
3dfbbf9175@protonmail.com

Changes in v2:
- Take phy->dev->mt76.mutex around mt7996_mcu_get_temperature()
- Unregister phy->tzone explicitly in mt7996_unregister_thermal() before th=
e phy is freed
- Link to v1: https://patch.msgid.link/20260722-mt7996-thermal-zone-v1-1-88=
896e6e9985@protonmail.com
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   | 40 ++++++++++++++++++=
+++-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  1 +
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net=
/wireless/mediatek/mt76/mt7996/init.c
index fb635a092584..0ac8424a7d99 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -234,17 +234,42 @@ static const struct thermal_cooling_device_ops mt7996=
_thermal_ops =3D {
 =09.set_cur_state =3D mt7996_thermal_set_cur_throttle_state,
 };
=20
+static int mt7996_thermal_get_temp(struct thermal_zone_device *tz, int *te=
mp)
+{
+=09struct mt7996_phy *phy =3D thermal_zone_device_priv(tz);
+=09int val;
+
+=09mutex_lock(&phy->dev->mt76.mutex);
+=09val =3D mt7996_mcu_get_temperature(phy);
+=09mutex_unlock(&phy->dev->mt76.mutex);
+=09if (val < 0)
+=09=09return val;
+
+=09*temp =3D val * 1000;
+=09return 0;
+}
+
+static const struct thermal_zone_device_ops mt7996_tz_ops =3D {
+=09.get_temp =3D mt7996_thermal_get_temp,
+};
+
 static void mt7996_unregister_thermal(struct mt7996_phy *phy)
 {
 =09struct wiphy *wiphy =3D phy->mt76->hw->wiphy;
 =09char name[sizeof("cooling_deviceXXX")];
=20
+=09if (phy->tzone) {
+=09=09devm_thermal_of_zone_unregister(phy->dev->mt76.dev, phy->tzone);
+=09=09phy->tzone =3D NULL;
+=09}
+
 =09if (!phy->cdev)
 =09=09return;
=20
 =09snprintf(name, sizeof(name), "cooling_device%d", phy->mt76->band_idx);
 =09sysfs_remove_link(&wiphy->dev.kobj, name);
 =09thermal_cooling_device_unregister(phy->cdev);
+=09phy->cdev =3D NULL;
 }
=20
 static int mt7996_thermal_init(struct mt7996_phy *phy)
@@ -275,14 +300,27 @@ static int mt7996_thermal_init(struct mt7996_phy *phy=
)
 =09phy->throttle_temp[MT7996_CRIT_TEMP_IDX] =3D MT7996_CRIT_TEMP;
 =09phy->throttle_temp[MT7996_MAX_TEMP_IDX] =3D MT7996_MAX_TEMP;
=20
+=09phy->tzone =3D devm_thermal_of_zone_register(phy->dev->mt76.dev,
+=09=09=09=09=09=09   phy->mt76->band_idx, phy,
+=09=09=09=09=09=09   &mt7996_tz_ops);
+=09if (IS_ERR(phy->tzone)) {
+=09=09if (PTR_ERR(phy->tzone) !=3D -ENODEV)
+=09=09=09dev_warn(phy->dev->mt76.dev,
+=09=09=09=09 "failed to register thermal zone %d: %ld\n",
+=09=09=09=09 phy->mt76->band_idx, PTR_ERR(phy->tzone));
+=09=09phy->tzone =3D NULL;
+=09}
+
 =09if (!IS_REACHABLE(CONFIG_HWMON))
 =09=09return 0;
=20
 =09hwmon =3D devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy=
,
 =09=09=09=09=09=09       mt7996_hwmon_groups);
=20
-=09if (IS_ERR(hwmon))
+=09if (IS_ERR(hwmon)) {
+=09=09mt7996_unregister_thermal(phy);
 =09=09return PTR_ERR(hwmon);
+=09}
=20
 =09return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/n=
et/wireless/mediatek/mt76/mt7996/mt7996.h
index 2a0cdb56f822..39fa25a562e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -372,6 +372,7 @@ struct mt7996_phy {
=20
 =09struct ieee80211_sband_iftype_data iftype[NUM_NL80211_BANDS][NUM_NL8021=
1_IFTYPES];
=20
+=09struct thermal_zone_device *tzone;
 =09struct thermal_cooling_device *cdev;
 =09u8 cdev_state;
 =09u8 throttle_state;

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260722-mt7996-thermal-zone-a1de7cb1d728

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


