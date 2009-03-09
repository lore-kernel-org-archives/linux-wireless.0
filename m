Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51403 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752324AbZCIXtt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 19:49:49 -0400
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 10 Mar 2009 00:49:46 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090309234946.99940@gmx.net> (sfid-20090310_004959_479397_69FBF9DA)
MIME-Version: 1.0
Subject: [PATCH] mac80211: ieee80211_ibss_commit() cleanup
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't call ieee80211_sta_find_ibss() directly, like it's done in STA mo=
de, so that the commit() call is more harmless respectively has less si=
te-effects.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f4becc1..3201e1f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -812,8 +812,9 @@ int ieee80211_ibss_commit(struct ieee80211_sub_if_d=
ata *sdata)
=20
 	ifibss->ibss_join_req =3D jiffies;
 	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
+	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
=20
-	return ieee80211_sta_find_ibss(sdata);
+	return 0;
 }
=20
 int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char =
*ssid, size_t len)

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
