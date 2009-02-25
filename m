Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34005 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759828AbZBYV4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 16:56:35 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 25 Feb 2009 22:56:31 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090225215631.289250@gmx.net> (sfid-20090225_225640_347262_7915CAB7)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Implement commit in wireless extensions
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements commit in wireless extensions for completeness and mayb=
e it could be useful for debugging to initiate a new rejoining process =
without changing the config.

I not so familiar with nl80211 at the moment, so I want add it to nl802=
11 in a second patch.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ecbc8e0..7f00c70 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -920,6 +920,7 @@ static inline int ieee80211_bssid_match(const u8 *r=
addr, const u8 *addr)
=20
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 chang=
ed);
+int ieee80211_commit(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sd=
ata,
 				      u32 changed);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f38db4d..1b2d598 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -294,6 +294,20 @@ int ieee80211_hw_config(struct ieee80211_local *lo=
cal, u32 changed)
 	return ret;
 }
=20
+void ieee80211_commit(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+		ieee80211_ibss_commit(sdata);
+		break;
+	case NL80211_IFTYPE_STATION:
+		ieee80211_sta_commit(sdata);
+		break;
+	default:
+		break;
+	}
+}
+
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sd=
ata,
 				      u32 changed)
 {
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index f6924fc..1ac0516 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -121,6 +121,15 @@ static int ieee80211_set_encryption(struct ieee802=
11_sub_if_data *sdata, u8 *sta
 	return err;
 }
=20
+static int ieee80211_ioctl_commit(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *extra)
+{
+	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	ieee80211_commit(sdata);
+	return 0;
+}
+
 static int ieee80211_ioctl_siwgenie(struct net_device *dev,
 				    struct iw_request_info *info,
 				    struct iw_point *data, char *extra)
@@ -1035,7 +1044,7 @@ static int ieee80211_ioctl_siwencodeext(struct ne=
t_device *dev,
=20
 static const iw_handler ieee80211_handler[] =3D
 {
-	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
+	(iw_handler) ieee80211_ioctl_commit,		/* SIOCSIWCOMMIT */
 	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
 	(iw_handler) NULL,				/* SIOCSIWNWID */
 	(iw_handler) NULL,				/* SIOCGIWNWID */

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
