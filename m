Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753404AbZB0SZY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 13:25:24 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 19:25:20 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090227171618.254890@gmx.net>
Message-ID: <20090227182520.97260@gmx.net> (sfid-20090227_192527_989669_286BD396)
MIME-Version: 1.0
References: <20090226234307.51520@gmx.net> <200902271503.13308.mb@bu3sch.de>
 <20090227153418.254900@gmx.net> <200902271714.54181.mb@bu3sch.de>
 <20090227171618.254890@gmx.net>
Subject: [PATCH v3] mac80211: Call commit() on channel setting
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This calls commit() on all logical interfaces of a physical interface, =
if the channel of it is changed. Before it works as it should, I must f=
ix the joining process of STA and IBSS a little, which I will make tomo=
rrow.

This version call it only in the wireless extensions, because the handl=
ing in nl80211 must discussed more, but I think in the case of wext it =
is the right way.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 1ac0516..dce1618 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -157,7 +157,10 @@ static int ieee80211_ioctl_siwfreq(struct net_devi=
ce *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)
 {
+	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *nsdata;
+	int ret;
=20
 	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
 		sdata->u.ibss.flags &=3D ~IEEE80211_IBSS_AUTO_CHANNEL_SEL;
@@ -173,19 +176,25 @@ static int ieee80211_ioctl_siwfreq(struct net_dev=
ice *dev,
 			else if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION)
 				sdata->u.mgd.flags |=3D
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
-			return 0;
+			ret =3D 0;
 		} else
-			return ieee80211_set_freq(sdata,
+			ret =3D ieee80211_set_freq(sdata,
 				ieee80211_channel_to_frequency(freq->m));
 	} else {
 		int i, div =3D 1000000;
 		for (i =3D 0; i < freq->e; i++)
 			div /=3D 10;
 		if (div > 0)
-			return ieee80211_set_freq(sdata, freq->m / div);
+			ret =3D ieee80211_set_freq(sdata, freq->m / div);
 		else
-			return -EINVAL;
+			ret =3D -EINVAL;
 	}
+
+	list_for_each_entry(nsdata, &local->interfaces, list) {
+		ieee80211_commit(nsdata);
+	}
+
+	return ret;
 }
=20
=20

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
