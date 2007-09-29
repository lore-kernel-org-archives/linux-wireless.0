Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:50000 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbXI2XUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 19:20:22 -0400
Date: Sat, 29 Sep 2007 19:20:06 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: misc minor updates
Message-ID: <20070929232006.GQ12844@drd1813.lan>
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dXvu6+ixFx2ZffE8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dXvu6+ixFx2ZffE8
Content-Type: multipart/mixed; boundary="OowMmFE4aK71mEhh"
Content-Disposition: inline


--OowMmFE4aK71mEhh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Miscellaneous minor updates:
	Fixed char *phydev init in main()
	Whitespace cleanups
	Minimal help
	Aliased 'master' to 'ap' in nl modes list

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"We're sorry, Susy won't be attending classes for the rest of this academic=
=20
year.  She caught the measles, and we had her shot."

--OowMmFE4aK71mEhh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iw-miscminor-mk.diff"
Content-Transfer-Encoding: quoted-printable

=46rom e86e4c5a5ff1bbe3a5e9c2fef7e28a8376646cb9 Mon Sep 17 00:00:00 2001
=46rom: Mike Kershaw <dragorn@kismetwireless.net>
Date: Sat, 29 Sep 2007 19:17:20 -0400
Subject: [PATCH] Minor whitespace updates
 Fixed char *phy initialization in main() preventing add from working
 Aliased 'master' to 'ap' for nl80211 mode definitions
 Added minimal help


Signed-off-by: Mike Kershaw <dragorn@kismetwireless.net>
---
 interface.c |   15 +++++++++------
 iw.c        |   14 ++++++++++++--
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/interface.c b/interface.c
index 580a952..ec81614 100644
--- a/interface.c
+++ b/interface.c
@@ -33,7 +33,7 @@ static int get_if_type(int *argc, char ***argv, enum nl80=
211_iftype *type)
 	} else if (strcmp(tpstr, "monitor") =3D=3D 0) {
 		*type =3D NL80211_IFTYPE_MONITOR;
 		return 1;
-	} else if (strcmp(tpstr, "ap") =3D=3D 0) {
+	} else if (strcmp(tpstr, "ap") =3D=3D 0 || strcmp(tpstr, "master") =3D=3D=
 0) {
 		*type =3D NL80211_IFTYPE_AP;
 		return 1;
 	} else if (strcmp(tpstr, "ap_vlan") =3D=3D 0) {
@@ -70,7 +70,7 @@ static int handle_interface_add(struct nl80211_state *sta=
te,
=20
 	if (argc) {
 		tpset =3D get_if_type(&argc, &argv, &type);
-		if (tpset < 0)
+		if (tpset < 0)=20
 			return -1;
 	}
=20
@@ -79,16 +79,19 @@ static int handle_interface_add(struct nl80211_state *s=
tate,
 		return -1;
 	}
=20
-        msg =3D nlmsg_alloc();
-	if (!msg)
-        	return -1;
+	msg =3D nlmsg_alloc();
+	if (!msg) {
+		fprintf(stderr, "failed to allocate netlink msg\n");
+		return -1;
+	}
=20
 	genlmsg_put(msg, 0, 0, genl_family_get_id(state->nl80211), 0,
 		    0, NL80211_CMD_NEW_INTERFACE, 0);
 	if (dev)
 		NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, if_nametoindex(dev));
-	if (phy)
+	if (phy) {
 		return -1; /* XXX TODO */
+	}
 	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, name);
 	if (tpset)
 		NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, type);
diff --git a/iw.c b/iw.c
index 1d04d58..ffbd691 100644
--- a/iw.c
+++ b/iw.c
@@ -90,11 +90,16 @@ static int get_phy_or_dev(int *argc, char ***argv, char=
 **name)
 	return 0;
 }
=20
+void usage(char *argv0) {
+	fprintf(stderr, "Usage: %s [options] {dev <phydev>} {interface <interface=
> } {COMMAND}\n"
+			"where COMMAND :=3D { add | del }\n", argv0);
+}
+
 int main(int argc, char **argv)
 {
 	struct nl80211_state nlstate;
 	int err =3D 0, pod;
-	char *ifname, *phyname, *type;
+	char *ifname =3D NULL, *phyname =3D NULL, *type, *argv0;
=20
 	err =3D nl80211_init(&nlstate);
 	if (err)
@@ -102,7 +107,12 @@ int main(int argc, char **argv)
=20
 	/* strip off self */
 	argc--;
-	argv++;
+	argv0 =3D *argv++;
+
+	if (argc =3D=3D 0 || (argc =3D=3D 1 && strcmp(*argv, "help") =3D=3D 0)) {
+		usage(argv0);
+		goto out;
+	}
=20
 	pod =3D get_phy_or_dev(&argc, &argv, &ifname);
 	if (pod =3D=3D 0) {
--=20
1.5.3.2


--OowMmFE4aK71mEhh--

--dXvu6+ixFx2ZffE8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFG/t2m17KIInOLvbERAgzlAKDlGUEVUxdbVzINJjbVKDyP8z/BvACfWOlL
CiWWdefwjiGum+SwwNxXGN0=
=MDM4
-----END PGP SIGNATURE-----

--dXvu6+ixFx2ZffE8--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
