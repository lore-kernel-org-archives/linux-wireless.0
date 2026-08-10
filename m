Received: from mail-24430.protonmail.ch (mail-24430.protonmail.ch [109.224.244.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90213DCD9B;
	Mon, 10 Aug 2026 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368297; cv=none; b=IREyyXkMltqUuu3fxsustM4PRAWBb9tBvtzcS7F/j9kkFiYJbRemGW1fjEItgjKGkdcHWF73ICuoGx/L2CZBhesZWPBG5UuGgmikAE5oiM/69BG9Xqs7ai1Ap1wXFTey13kbrPbAYHsL3nzf2/W5Tzyv+/CW/L3MvboxX7iMJ4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368297; c=relaxed/simple;
	bh=o1vdF2nuD/3GDa9+wczeD5leoRApi+cZOQ4VCQtS3Zc=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=RKHxAK2UZGptOjjqXrkGFcwdeYs3YNf3O3XOI+4Vs/0h8IVuzrvX9U1Y7PqWR10SxUCYm0k2FN5myN2L0v2EbBGOwUlsJNKaX8as31c54ODQbbX1tjvpZvamXakwHY52a9c7Lr5c2MEr8ZYUlmyBCFc/trAzMeDjNqhpMeIihTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=I2mUCM0Y; arc=none smtp.client-ip=109.224.244.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="I2mUCM0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1786368292; x=1786627492;
	bh=6PSuPUTHGPXQfzteFQevhU5gdjP8B172N7g782zoe6Y=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=I2mUCM0Y2ozyG2X/+qN3njozMvjHwaKdPibwM6txaCtOs15tuQFbIFRumox2Xicx7
	 4PnfwAD4WRO1smUKQ22kQXy9IieZaDfT6GuAKXrJ7XPipMxjmOd6EJwLYkjDcbBpxc
	 es0yBVL8ujJ5R677sUPXqyVGaJ/kEyf0mLTgyxHUGgsnMm5t+R9UfB0i9GfdteU6EA
	 HohoQZY0ywso9cIBIbAJtRAOf+6r4MmcMv+RtXSbmaWlOdGGUOS2+mWR+Z9EqPSIDa
	 tta0s2zDIyWTzTCL2GrtMQY+DV1CAI/vHxTBlhFjjJ+OORYUsTv7aJgOhOb9I2rAen
	 1ct4BYkvCcnsA==
Date: Mon, 10 Aug 2026 13:24:46 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH v3] wifi: mt76: mt7996: add thermal zone device registration
Message-ID: <20260810-mt7996-thermal-zone-v3-1-ae9d7cd6cde1@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 57331f0c9e096ac1b2b5ea7fa04362caebdb9600
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

Unregister the thermal zone together with the existing cooling
device when the phy is torn down, and on the hwmon registration
failure path in the same init routine, so neither is left registered
against a phy that is about to be freed.

Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
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
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   | 37 ++++++++++++++++++=
+++-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  1 +
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net=
/wireless/mediatek/mt76/mt7996/init.c
index fb635a092584..525bb771f78a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -234,11 +234,33 @@ static const struct thermal_cooling_device_ops mt7996=
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
+=09if (phy->tzone)
+=09=09devm_thermal_of_zone_unregister(phy->dev->mt76.dev, phy->tzone);
+
 =09if (!phy->cdev)
 =09=09return;
=20
@@ -275,14 +297,27 @@ static int mt7996_thermal_init(struct mt7996_phy *phy=
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


