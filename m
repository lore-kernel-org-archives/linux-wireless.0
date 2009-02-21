Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38456 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752928AbZBUA1b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 19:27:31 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 21 Feb 2009 01:27:29 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090221002729.65900@gmx.net> (sfid-20090221_012736_059533_1C235702)
MIME-Version: 1.0
Subject: [PATCH v2] mac80211: Introduce a generic commit() to apply changes
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a generic commit() function which initiate a new =
network joining process. It should be called after some interface confi=
g changes, so that the changes get applied more cleanly. Currently set_=
ssid() and set_bssid() call it. Others can be added in future patches.

In version 1 the header files was forgotten, sorry.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1bbfc70..aa8937c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -788,6 +788,23 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_s=
ub_if_data *sdata)
 			IEEE80211_IBSS_AUTO_CHANNEL_SEL;
 }
=20
+int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss =3D &sdata->u.ibss;
+
+	ifibss->flags &=3D ~IEEE80211_IBSS_PREV_BSSID_SET;
+
+	if (ifibss->ssid_len)
+		ifibss->flags |=3D IEEE80211_IBSS_SSID_SET;
+	else
+		ifibss->flags &=3D ~IEEE80211_IBSS_SSID_SET;
+
+	ifibss->ibss_join_req =3D jiffies;
+	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
+
+	return ieee80211_sta_find_ibss(sdata);
+}
+
 int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char =
*ssid, size_t len)
 {
 	struct ieee80211_if_ibss *ifibss =3D &sdata->u.ibss;
@@ -801,16 +818,7 @@ int ieee80211_ibss_set_ssid(struct ieee80211_sub_i=
f_data *sdata, char *ssid, siz
 		ifibss->ssid_len =3D len;
 	}
=20
-	ifibss->flags &=3D ~IEEE80211_IBSS_PREV_BSSID_SET;
-
-	if (len)
-		ifibss->flags |=3D IEEE80211_IBSS_SSID_SET;
-	else
-		ifibss->flags &=3D ~IEEE80211_IBSS_SSID_SET;
-
-	ifibss->ibss_join_req =3D jiffies;
-	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
-	return ieee80211_sta_find_ibss(sdata);
+	return ieee80211_ibss_commit(sdata);
 }
=20
 int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char =
*ssid, size_t *len)
@@ -842,7 +850,7 @@ int ieee80211_ibss_set_bssid(struct ieee80211_sub_i=
f_data *sdata, u8 *bssid)
 		}
 	}
=20
-	return ieee80211_ibss_set_ssid(sdata, ifibss->ssid, ifibss->ssid_len)=
;
+	return ieee80211_ibss_commit(sdata);
 }
=20
 /* scan finished notification */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d06c757..ecbc8e0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -934,6 +934,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub=
_if_data *sdata);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data=
 *sdata,
 					  struct sk_buff *skb,
 					  struct ieee80211_rx_status *rx_status);
+int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata);
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *=
ssid, size_t len);
 int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *=
ssid, size_t *len);
 int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *b=
ssid);
@@ -944,6 +945,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *=
local,
 			   struct ieee80211_sub_if_data *sdata);
=20
 /* IBSS code */
+int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata);
 int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char =
*ssid, size_t len);
 int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char =
*ssid, size_t *len);
 int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *=
bssid);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5a49779..7f23858 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1855,6 +1855,20 @@ void ieee80211_sta_req_auth(struct ieee80211_sub=
_if_data *sdata)
 	}
 }
=20
+int ieee80211_sta_commit(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
+
+	ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
+
+	if (ifmgd->ssid_len)
+		ifmgd->flags |=3D IEEE80211_STA_SSID_SET;
+	else
+		ifmgd->flags &=3D ~IEEE80211_STA_SSID_SET;
+
+	return 0;
+}
+
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *=
ssid, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd;
@@ -1870,14 +1884,7 @@ int ieee80211_sta_set_ssid(struct ieee80211_sub_=
if_data *sdata, char *ssid, size
 		ifmgd->ssid_len =3D len;
 	}
=20
-	ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
-
-	if (len)
-		ifmgd->flags |=3D IEEE80211_STA_SSID_SET;
-	else
-		ifmgd->flags &=3D ~IEEE80211_STA_SSID_SET;
-
-	return 0;
+	return ieee80211_sta_commit(sdata);
 }
=20
 int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *=
ssid, size_t *len)
@@ -1907,7 +1914,7 @@ int ieee80211_sta_set_bssid(struct ieee80211_sub_=
if_data *sdata, u8 *bssid)
 		}
 	}
=20
-	return ieee80211_sta_set_ssid(sdata, ifmgd->ssid, ifmgd->ssid_len);
+	return ieee80211_sta_commit(sdata);
 }
=20
 int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, ch=
ar *ie, size_t len)

--=20
Jetzt 1 Monat kostenlos! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
