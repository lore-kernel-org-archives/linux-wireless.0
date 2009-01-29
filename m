Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33213 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751135AbZA2M4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 07:56:22 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Thu, 29 Jan 2009 13:56:20 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090129125620.278940@gmx.net> (sfid-20090129_135628_555264_6BD444E6)
MIME-Version: 1.0
Subject: [PATCH] mac80211: IBSS join rework
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I hold back this patch for around a week to avoid
confusion. This is the second step of
"mac80211: Fixed BSSID handling revisited".

With it, in the situation of a strange merge to the
same BSSID (e.g. caused by a TSF overflow) only
reset_tsf() is called.

And sta_info_flush_delayed() is only called if you
change the network manually, not on an automatic
BSSID merge.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/net/mac80211/mlme.c wireless-testing/ne=
t/mac80211/mlme.c
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-27 06:12:43.00000=
0000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-29 13:32:52.000000000 =
+0100
@@ -1503,13 +1503,22 @@
 				   struct ieee80211_bss *bss)
 {
 	struct ieee80211_local *local =3D sdata->local;
-	int res, rates, i, j;
+	int res =3D 0, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
 	union iwreq_data wrqu;
=20
+	if (local->ops->reset_tsf) {
+		/* Reset own TSF to allow time synchronization work. */
+		local->ops->reset_tsf(local_to_hw(local));
+	}
+
+	if ((ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) &&
+	   memcmp(ifsta->bssid, bss->bssid, ETH_ALEN) =3D=3D 0)
+		return res;
+
 	skb =3D dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
 			    sdata->u.sta.ie_proberesp_len);
 	if (!skb) {
@@ -1520,13 +1529,11 @@
=20
 	sband =3D local->hw.wiphy->bands[local->hw.conf.channel->band];
=20
-	/* Remove possible STA entries from other IBSS networks. */
-	sta_info_flush_delayed(sdata);
-
-	if (local->ops->reset_tsf) {
-		/* Reset own TSF to allow time synchronization work. */
-		local->ops->reset_tsf(local_to_hw(local));
+	if (!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) {
+		/* Remove possible STA entries from other IBSS networks. */
+		sta_info_flush_delayed(sdata);
 	}
+
 	memcpy(ifsta->bssid, bss->bssid, ETH_ALEN);
 	res =3D ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
 	if (res)

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
