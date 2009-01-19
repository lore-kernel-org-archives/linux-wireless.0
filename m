Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53465 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZASJD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 04:03:27 -0500
Received: by bwz14 with SMTP id 14so7896822bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 01:03:24 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] iwl3945: Remove unused variables
Date: Mon, 19 Jan 2009 09:55:32 +0100
MIME-Version: 1.0
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Message-Id: <200901190955.32818.helmut.schaa@gmail.com> (sfid-20090119_100331_412357_F9FD8A41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46ix the following warnings in iwl-3945-rs.c by removing unused variab=
les.

drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_rate_scale_flush_windows=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:186: warning: unused variabl=
e =E2=80=98priv=E2=80=99
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_bg_rate_scale_flush=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:219: warning: unused variabl=
e =E2=80=98priv=E2=80=99
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_collect_tx_data=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: warning: unused variabl=
e =E2=80=98priv=E2=80=99
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98rs_fre=
e_sta=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: warning: unused variabl=
e =E2=80=98priv=E2=80=99
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_get_adjacent_rate=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:559: warning: unused variabl=
e =E2=80=98priv=E2=80=99

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/w=
ireless/iwlwifi/iwl-3945-rs.c
index ba64034..2af45f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -183,7 +183,6 @@ static int iwl3945_rate_scale_flush_windows(struct =
iwl3945_rs_sta *rs_sta)
 	int unflushed =3D 0;
 	int i;
 	unsigned long flags;
-	struct iwl_priv *priv =3D rs_sta->priv;
=20
 	/*
 	 * For each rate, if we have collected data on that rate
@@ -216,7 +215,6 @@ static int iwl3945_rate_scale_flush_windows(struct =
iwl3945_rs_sta *rs_sta)
 static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
 	struct iwl3945_rs_sta *rs_sta =3D (void *)data;
-	struct iwl_priv *priv =3D rs_sta->priv;
 	int unflushed =3D 0;
 	unsigned long flags;
 	u32 packet_count, duration, pps;
@@ -290,7 +288,6 @@ static void iwl3945_collect_tx_data(struct iwl3945_=
rs_sta *rs_sta,
 {
 	unsigned long flags;
 	s32 fail_count;
-	struct iwl_priv *priv =3D rs_sta->priv;
=20
 	if (!retries) {
 		IWL_DEBUG_RATE("leave: retries =3D=3D 0 -- should be at least 1\n");
@@ -438,7 +435,6 @@ static void rs_free_sta(void *iwl_priv, struct ieee=
80211_sta *sta,
 {
 	struct iwl3945_sta_priv *psta =3D (void *) sta->drv_priv;
 	struct iwl3945_rs_sta *rs_sta =3D priv_sta;
-	struct iwl_priv *priv =3D rs_sta->priv;
=20
 	psta->rs_sta =3D NULL;
=20
@@ -556,7 +552,6 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945=
_rs_sta *rs_sta,
 {
 	u8 high =3D IWL_RATE_INVALID;
 	u8 low =3D IWL_RATE_INVALID;
-	struct iwl_priv *priv =3D rs_sta->priv;
=20
 	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
