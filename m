Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60862 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbYFZSJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:09:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Q] ath5k : doesn't support AP mode?
Date: Thu, 26 Jun 2008 20:08:48 +0200
Cc: Pavel Roskin <proski@gnu.org>,
	Stefanik =?iso-8859-1?q?G=E1bor?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3> <200806261821.31643.mb@bu3sch.de> <20080626173645.GB22075@tuxdriver.com>
In-Reply-To: <20080626173645.GB22075@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200806262008.48682.mb@bu3sch.de> (sfid-20080626_200926_043784_DD7F0FD5)
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 June 2008 19:36:45 John W. Linville wrote:
> On Thu, Jun 26, 2008 at 06:21:31PM +0200, Michael Buesch wrote:
> > On Thursday 26 June 2008 18:01:26 Pavel Roskin wrote:
> > > On Thu, 2008-06-26 at 17:46 +0200, Stefanik G=E1bor wrote:
> > >=20
> > > > Maybe we had more people working on/debugging AP mode if we did=
n't
> > > > intentionally disable the existing limited support for it... Po=
ssibly
> > > > print a big warning that "THIS IS NOT STANDARDS_COMPLIANT YET!"=
, but
> > > > outright disabling it and requiring an external patch is IMHO s=
tupid.
> > > > Perhaps a Kconfig option with EXPERIMENTAL and default=3Dn woul=
d be
> > > > better.
> > >=20
> > > I agree.  More people would be looking into AP support for indivi=
dual
> > > drivers if mac80211 didn't need a patch.
> >=20
> > I'd also like to get something like the following merged:
>=20
> > Subject: mac80211: allow AP and VLAN modes
> >=20
> > This patch is based on a patch by Johannes Berg.
> > It allows switching interfaces into AP/VLAN modes using
> > cfg80211 (nl80211). Don't allow doing it with wext because then
> > people will just attempt to do it manually (without hostapd) and
> > complain that it doesn't work.
>=20
> I dunno...that last thing I want is to let this go in and then be
> locked-in to the current API no-matter-what like we now are with WEXT=
=2E

Well, I really do think that AP development is stuck due to nobody test=
ing it.
So, something like the following patch?
http://foobar would be some page on wireless.kernel.org
describing what additional patches are needed for the latest wireless-t=
esting kernel.

Additionally we might want to put this into wireless-testing only.
There's not a big need for pushing this upstream.
If somebody wants to test AP mode, he'll need to get wireless-testing a=
nyway.






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
+++ wireless-testing/net/mac80211/Kconfig	2008-06-26 20:05:26.000000000=
 +0200
@@ -92,6 +92,29 @@ config MAC80211_LEDS
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
+	  Also note that the AccessPoint userspace ABI is not stable, yet,
+	  and subject to change until this warning disappears.
+
+	  This option enables AP/VLAN support in mac80211.
+	  Note that the latest GIT snapshot of the userspace hostapd
+	  daemon is required for this. It will not work without
+	  hostapd or with an old version of hostapd without nl80211 support.
+	  You might need additional patches to hostapd to update it to
+	  the latest nl80211 ABI. See http://foobar for details.
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
