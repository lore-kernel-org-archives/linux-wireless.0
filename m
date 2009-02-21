Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58688 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753575AbZBUXHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 18:07:31 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 22 Feb 2009 00:07:28 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090221230728.227290@gmx.net> (sfid-20090222_000755_305003_3581962C)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Don't merge with the same BSSID
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was not a good idea to do a TSF reset on strange IBSS merges to the =
same BSSID. For example it will break the TSF sync of ath9k completely =
and it is unnecessary as all hardware I have tested do a TSF sync to a =
higher value automatically and IBSS merges are only done to higher TSF =
values. It only need a TSF reset to accept a lower value, when the IBSS=
 network is changed manually.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1bbfc70..cf20575 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -291,6 +291,10 @@ static void ieee80211_rx_bss_info(struct ieee80211=
_sub_if_data *sdata,
 				sdata->u.ibss.ssid_len))
 		goto put_bss;
=20
+	/* same BSSID */
+	if (memcmp(bss->cbss.bssid, sdata->u.ibss.bssid, ETH_ALEN) =3D=3D 0)
+		goto put_bss;
+
 	if (rx_status->flag & RX_FLAG_TSFT) {
 		/*
 		 * For correct IBSS merging we need mactime; since mactime is

--=20
Jetzt 1 Monat kostenlos! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
