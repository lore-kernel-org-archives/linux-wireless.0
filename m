Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41877 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYFZQWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 12:22:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [Q] ath5k : doesn't support AP mode?
Date: Thu, 26 Jun 2008 18:21:31 +0200
Cc: Stefanik =?iso-8859-1?q?G=E1bor?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3> <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com> <1214496086.30722.14.camel@dv>
In-Reply-To: <1214496086.30722.14.camel@dv>
MIME-Version: 1.0
Message-Id: <200806261821.31643.mb@bu3sch.de> (sfid-20080626_182219_925020_A474F813)
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 June 2008 18:01:26 Pavel Roskin wrote:
> On Thu, 2008-06-26 at 17:46 +0200, Stefanik G=E1bor wrote:
>=20
> > Maybe we had more people working on/debugging AP mode if we didn't
> > intentionally disable the existing limited support for it... Possib=
ly
> > print a big warning that "THIS IS NOT STANDARDS_COMPLIANT YET!", bu=
t
> > outright disabling it and requiring an external patch is IMHO stupi=
d.
> > Perhaps a Kconfig option with EXPERIMENTAL and default=3Dn would be
> > better.
>=20
> I agree.  More people would be looking into AP support for individual
> drivers if mac80211 didn't need a patch.

I'd also like to get something like the following merged:




Subject: mac80211: allow AP and VLAN modes

This patch is based on a patch by Johannes Berg.
It allows switching interfaces into AP/VLAN modes using
cfg80211 (nl80211). Don't allow doing it with wext because then
people will just attempt to do it manually (without hostapd) and
complain that it doesn't work.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/net/mac80211/cfg.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/net/mac80211/cfg.c	2008-06-10 13:58:23.000000=
000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2008-06-26 18:12:31.000000000 +=
0200
@@ -33,6 +33,12 @@ nl80211_type_to_mac80211_type(enum nl802
 	case NL80211_IFTYPE_MESH_POINT:
 		return IEEE80211_IF_TYPE_MESH_POINT;
 #endif
+#ifdef CONFIG_MAC80211_AP
+	case NL80211_IFTYPE_AP:
+		return IEEE80211_IF_TYPE_AP;
+	case NL80211_IFTYPE_AP_VLAN:
+		return IEEE80211_IF_TYPE_VLAN;
+#endif /* AP */
 	case NL80211_IFTYPE_WDS:
 		return IEEE80211_IF_TYPE_WDS;
 	default:
Index: wireless-testing/net/mac80211/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/net/mac80211/Kconfig	2008-06-10 13:58:23.0000=
00000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2008-06-26 18:19:13.000000000=
 +0200
@@ -92,6 +92,25 @@ config MAC80211_LEDS
 	  This option enables a few LED triggers for different
 	  packet receive/transmit events.
=20
+config MAC80211_AP
+	bool "AccessPoint and VLAN modes (read help text!)"
+	depends on MAC80211 && EXPERIMENTAL
+	---help---
+	  =3D=3D=3D> BIG FAT WARNING <=3D=3D=3D
+	  This is not IEEE 802.11 compliant, yet!
+	  You might disturb operation of other accesspoints and
+	  stations in your neighbourhood. Do only enable this, if
+	  you want to help out fixing this to make this warning disappear.
+	  If you enable this, expect that your neighbour will ring your
+	  door and yell at you for disturbing his network.
+
+	  This option enables AP/VLAN support in mac80211.
+	  Note that the latest GIT snapshot of the userspace hostapd
+	  daemon is required for this. It will not work without
+	  hostapd or with an old version of hostapd without nl80211 support.
+
+	  Say N.
+
 config MAC80211_DEBUGFS
 	bool "Export mac80211 internals in DebugFS"
 	depends on MAC80211 && DEBUG_FS



--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
