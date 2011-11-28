Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:20112 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1K1QSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:18:25 -0500
Date: Mon, 28 Nov 2011 17:13:59 +0100
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: Daniel Golle <dgolle@allnet.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v1 -1/3] support for antenna configuration profiles
Message-ID: <20111128161359.GA25519@localhost> (sfid-20111128_171827_712254_1485AEF3)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is a patch against the iw userspace tool.
Antenna switch configuration profiles are printed out in info.c, marking the
currently selected profile.
An operation to select the profile is added to phy.c.

Signed-off-by: Daniel Golle <dgolle@allnet.de>
---
--- a/info.c
+++ b/info.c
@@ -180,6 +180,58 @@ static int print_phy_handler(struct nl_m
 		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
 		       nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
=20
+	if (tb_msg[NL80211_ATTR_WIPHY_EXTANT]) {
+		static struct nla_policy extant_policy[NL80211_EXTANT_ATTR_MAX + 1] =3D {
+			[NL80211_EXTANT_ATTR_STATE] =3D { .type =3D NLA_U32 },
+			[NL80211_EXTANT_ATTR_PROFILES] =3D { .type =3D NLA_NESTED },
+		};
+		struct nlattr *tb_extant[NL80211_EXTANT_ATTR_MAX + 1];
+		struct nlattr *nl_easp, *tb_easp[NL80211_EASP_ATTR_MAX + 1];
+		int err, rem_easp;
+		int current_profile, num_profiles =3D 0;
+		int id;
+		int i;
+		static struct nla_policy easp_policy[NL80211_EASP_ATTR_MAX + 1] =3D {
+			[NL80211_EASP_ATTR_ID] =3D { .type =3D NLA_U32 },
+			[NL80211_EASP_ATTR_NAME] =3D { },
+			[NL80211_EASP_ATTR_DESC] =3D { },
+		};
+
+		printf("\tDevice supports antenna configuration profiles.\n");
+		err =3D nla_parse_nested(tb_extant, NL80211_EXTANT_ATTR_MAX, tb_msg[NL80=
211_ATTR_WIPHY_EXTANT], extant_policy);
+		if (err)
+			goto broken_extant;
+
+		if (tb_extant[NL80211_EXTANT_ATTR_STATE])
+			current_profile =3D nla_get_u32(tb_extant[NL80211_EXTANT_ATTR_STATE]);
+		else
+			current_profile =3D -1;
+
+		nla_for_each_nested(nl_easp, tb_extant[NL80211_EXTANT_ATTR_PROFILES], re=
m_easp) {
+			num_profiles++;
+		}
+
+		nla_for_each_nested(nl_easp, tb_extant[NL80211_EXTANT_ATTR_PROFILES], re=
m_easp)
+		{
+			err =3D nla_parse(tb_easp, NL80211_EASP_ATTR_MAX, nla_data(nl_easp), nl=
a_len(nl_easp), easp_policy);
+
+			if (err || !tb_easp[NL80211_EASP_ATTR_ID] || !tb_easp[NL80211_EASP_ATTR=
_NAME] || !tb_easp[NL80211_EASP_ATTR_DESC]) {
+				printf("cannot parse antenna switch profile, err %x\n", err);
+				goto broken_extant;
+			}
+			id =3D nla_get_u32(tb_easp[NL80211_EASP_ATTR_ID]);
+			if ( id =3D=3D current_profile )
+				printf("\t\t (*)");
+			else
+				printf("\t\t ( )");
+			printf(" %u\t%s\t(%s)", id, nla_get_string(tb_easp[NL80211_EASP_ATTR_NA=
ME]),
+				nla_get_string(tb_easp[NL80211_EASP_ATTR_DESC]));
+			printf("\n");
+		}
+broken_extant:
+		;
+	}
+
 	if (tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES]) {
 		printf("\tSupported interface modes:\n");
 		nla_for_each_nested(nl_mode, tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES], rem=
_mode)
@@ -219,6 +271,9 @@ static int print_phy_handler(struct nl_m
 				have_combinations =3D true;
 			}
=20
+
+
+
 			printf("\t\t * ");
=20
 			err =3D nla_parse_nested(tb_comb, MAX_NL80211_IFACE_COMB,
--- a/phy.c
+++ b/phy.c
@@ -333,3 +333,30 @@ COMMAND(set, antenna, "<bitmap> | all |
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_antenna,
 	"Set a bitmap of allowed antennas to use for TX and RX.\n"
 	"The driver may reject antenna configurations it cannot support.");
+
+static int handle_extant(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv)
+{
+	char *end;
+	__u32 extant;
+
+	if (argc =3D=3D 1) {
+		extant =3D strtoul(argv[0], &end, 0);
+		if (*end)
+			return 1;
+	} else
+		return 1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_EXTANT_SELECT, extant);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, extant, "<profile>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_extant,
+	"Select the external antenna switch configuration profile.\n"
+	"The driver accepts only profiles defined for the hardware.");

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO07NHAAoJEDy9cKN/1Et0mMoQAJsQ1PPGYYxGuYS7ypEonCTH
BGpcDUbobFG4fQ7pPcvz9qeXVAs8G977bIBMQ+SNZiaz7vaCey+sgb/lRruVGwMb
75bJmgCAskOHMpUScuNGiorSjgJdXUy6fGY5K4zFlUcY+FGtRobborOuaN9OlmOV
gmfVMiYKk2D3IN7a2ZhLto31MV2ffT+xcnze+jdB26a787m+DKC1vBVElTEBbQ3c
P4Pt0MPdRxHvmHCJ01xhLbFQaZ9Mljjn3FbWDW2JkgGT+1aK9rAtd+NMB9R+33xn
mUt+rGhk1TgB60PCHViQfdZYOWAKi65V229wRdlVIm4ymuulXQZBf8YD/6GZWikg
Uf5fBXMjQZMPcAx+3R6GoItolG6mLd6ISrxI7Ecl/Q1yk+lX/3yaB8VrerBn55Ff
8VOxpeneC2vP0SGQ6dwzhoEr5P19nweerxBUQJ+HPUQy+b4JNofkaqJqB0GWbrJM
P3sT/LwlFajZtAH12W7xqZqOtpK86WinR/V62jFW1wl578f0Hs7iNMq0IqljC7mH
RleyXWigXDTXqEM0Rje+RMTrJxfCzXju2eWoQLK7MI1vSpUQnBFeBdQ3dsvvmu4z
vs7d0SPP31J+cmcM7x8om70VINZwlusRIQ8FNpSjMNphLtYaNpBZDEuJnY3kMUQu
4b1d9PAIKvJe0Id82Fej
=F+h8
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
