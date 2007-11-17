Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:15905 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271AbXKQAOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 19:14:00 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1054816fkz
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2007 16:13:58 -0800 (PST)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: add power management support -v2
Date: Sat, 17 Nov 2007 01:13:58 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	yi.zhu@intel.com
References: <200711170007.01676.mboton.lkml@gmail.com>
In-Reply-To: <200711170007.01676.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711170113.58396.mboton.lkml@gmail.com> (sfid-20071117_001406_559173_F461DAA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, the previous patch wasn't correct. This one is valid.

--

This patch adds power management support in mac80211.

This allows us to enable power management through the "iwconfig <device=
> power <off/on>" command.
The code is based on "mac80211-10.0.0" but it is a little bit modified.

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5fcc4c1..c82b6fa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -452,6 +452,8 @@ struct ieee80211_conf {
 	u8 antenna_max;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
+
+	u8 power_management_enable;     /* flag to enable/disable power manag=
ement */
 };
=20
 /**
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_io=
ctl.c
index 6caa3ec..f5eebec 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -674,6 +687,51 @@ static int ieee80211_ioctl_giwtxpower(struct net_d=
evice *dev,
 	return 0;
 }
=20
+static int ieee80211_ioctl_siwpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *wrqu,
+				    char *extra)
+{
+	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf =3D &local->hw.conf;
+
+	if (wrqu->power.disabled) {
+		conf->power_management_enable =3D 0;
+		if (ieee80211_hw_config(local))
+			return -EINVAL;
+		return 0;
+	}
+
+	switch (wrqu->power.flags & IW_POWER_MODE) {
+	case IW_POWER_ON:       /* If not specified */
+	case IW_POWER_MODE:     /* If set all mask */
+	case IW_POWER_ALL_R:    /* If explicitely state all */
+		break;
+	default:                /* Otherwise we don't support it */
+		return -EINVAL;
+	}
+
+	conf->power_management_enable =3D 1;
+
+	if (ieee80211_hw_config(local))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ieee80211_ioctl_giwpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *wrqu,
+				    char *extra)
+{
+	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf =3D &local->hw.conf;
+
+	wrqu->power.disabled =3D !conf->power_management_enable;
+
+	return 0;
+}
+
 static int ieee80211_ioctl_siwrts(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rts, char *extra)
@@ -1111,8 +1166,8 @@ static const iw_handler ieee80211_handler[] =3D
 	(iw_handler) ieee80211_ioctl_giwretry,		/* SIOCGIWRETRY */
 	(iw_handler) ieee80211_ioctl_siwencode,		/* SIOCSIWENCODE */
 	(iw_handler) ieee80211_ioctl_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) NULL,				/* SIOCSIWPOWER */
-	(iw_handler) NULL,				/* SIOCGIWPOWER */
+	(iw_handler) ieee80211_ioctl_siwpower,		/* SIOCSIWPOWER */
+	(iw_handler) ieee80211_ioctl_giwpower,		/* SIOCGIWPOWER */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) NULL,				/* -- hole -- */
 	(iw_handler) ieee80211_ioctl_siwgenie,		/* SIOCSIWGENIE */


--=20
	Miguel Bot=C3=B3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
