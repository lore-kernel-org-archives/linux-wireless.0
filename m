Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93ED122538F
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 03:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784692324; cv=none; b=Xy9sORvX0KkXYmpcJyacymKZkSY9qgb6UtU3/NAh2w7bM7qUpbZKTdlP4SsqASeYiIi9FHkjq4ceLvWFgRj6lwNZe+DfNmb8ZRHqhCeJP++NoPfd+6NbHNGGXysOvjOreAri9ygtqnjxPl6WBNVu+L9941L8hF631U4ZRQL6cAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784692324; c=relaxed/simple;
	bh=vSxGFDlbEU1RRx3jUyUpS0gSdxx/H6VlavpluyUUsS4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=qzHmToS52BskLY6N3dzSzn5OA4uP96srB7ATVXhXs8OKrGWWGewDnhpxK9HmKCKEDiFHlmmNM5hqD3o7mX8H+K/tW5hIaPFCC4rRxQh9jp8HqwIrU9oH/ZhYbixIdgfFAJrI2GuQw9/H21CAoNHYtYhMNYDcjiSnKS61d/moEOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=narpR5eI; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="narpR5eI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1784692314; x=1784951514;
	bh=T9UUSEVoX23+teHyHVc4XnhVE7Bddxb84RHflEA9fy0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=narpR5eI5Dv7nRg39pOtG91KL4+Z/eaWBUeoCzoR5r0rRoFgA/4E2GItrEfmdKLF3
	 JAx6yzJdT2aswrUNP6GQ7b0I1h7AFjcwDDwXDS2DPt28CYyi4eRS+Ageu6lz3Q29Ok
	 xWw2hMYMWh961eHo5f83WjQJepZSZAmktjML6bvLl7edMoriJGWsY+F6gG6K7DfWw1
	 9FUuLR9Fe0i4U+aDpsLTMR0nB2iVb/TzwDJW6D2YTevx2O3vT2b1m8by5WdyNQwOl6
	 ZKzZZ6spVIOHGOTEWWKN9p3TrKMHxNu9Pltsk4sm33yofS+YdAVS1SMM2Stle5AKwb
	 s6EVEw234BUfA==
Date: Wed, 22 Jul 2026 03:51:50 +0000
To: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
From: Ryan Leung <untilscour@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Ryan Leung <untilscour@protonmail.com>
Subject: [PATCH] wifi: mt76: mt7996: add thermal zone device registration
Message-ID: <20260722-mt7996-thermal-zone-v1-1-88896e6e9985@protonmail.com>
Feedback-ID: 184418679:user:proton
X-Pm-Message-ID: 9e14f46cfdb4bf39a41e6629e5d0f893ba5c57c3
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

Signed-off-by: Ryan Leung <untilscour@protonmail.com>
---
This is essentially the same as the previous patch for mt7915 [1] but calls
mt7996_mcu_get_temperature without mutex, consistent with the existing hwmo=
n
mt7996_thermal_temp_show callback.

I don't know if mt7996 also needs mutex locks such as those in commit
e733647566ec ("wifi: mt76: mt7915: hold dev->mutex while interacting with t=
he thermal state") [2]

[1] https://patch.msgid.link/20260719-mt7915-thermal-zone-device-registrati=
on-v2-1-0eac68c2741e@protonmail.com
[2] https://patch.msgid.link/20241230194202.95065-10-nbd@nbd.name
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   | 28 ++++++++++++++++++=
++++
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net=
/wireless/mediatek/mt76/mt7996/init.c
index d6f9aa1ab52d..115145f993d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -236,6 +236,23 @@ static const struct thermal_cooling_device_ops mt7996_=
thermal_ops =3D {
 =09.set_cur_state =3D mt7996_thermal_set_cur_throttle_state,
 };
=20
+static int mt7996_thermal_get_temp(struct thermal_zone_device *tz, int *te=
mp)
+{
+=09struct mt7996_phy *phy =3D thermal_zone_device_priv(tz);
+=09int val;
+
+=09val =3D mt7996_mcu_get_temperature(phy);
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
@@ -277,6 +294,17 @@ static int mt7996_thermal_init(struct mt7996_phy *phy)
 =09phy->throttle_temp[MT7996_CRIT_TEMP_IDX] =3D MT7996_CRIT_TEMP;
 =09phy->throttle_temp[MT7996_MAX_TEMP_IDX] =3D MT7996_MAX_TEMP;
=20
+=09phy->tzone =3D devm_thermal_of_zone_register(phy->dev->mt76.dev,
+=09=09=09=09=09=09   phy->mt76->band_idx, phy,
+=09=09=09=09=09=09   &mt7996_tz_ops);
+=09if (IS_ERR(phy->tzone)) {
+=09=09if (PTR_ERR(phy->tzone) !=3D -ENODEV)
+=09=09=09dev_warn(phy->dev->mt76.dev,
+=09=09=09=09 "failed to register thermal zone%d: %ld\n",
+=09=09=09=09 phy->mt76->band_idx, PTR_ERR(phy->tzone));
+=09=09phy->tzone =3D NULL;
+=09}
+
 =09if (!IS_REACHABLE(CONFIG_HWMON))
 =09=09return 0;
=20
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/n=
et/wireless/mediatek/mt76/mt7996/mt7996.h
index 0d6488522ba7..1207b5c7e98b 100644
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
base-commit: 69bd85e933c617a84fa54fcc80e628e98afdc45d
change-id: 20260722-mt7996-thermal-zone-a1de7cb1d728

Best regards,
-- =20
Ryan Leung <untilscour@protonmail.com>


