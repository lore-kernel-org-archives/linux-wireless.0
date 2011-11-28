Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:20089 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1K1QSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:18:10 -0500
Date: Mon, 28 Nov 2011 17:12:40 +0100
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: Daniel Golle <dgolle@allnet.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v1 1/3] support for antenna configuration profiles
Message-ID: <20111128161240.GA25454@localhost> (sfid-20111128_171813_665159_36F11CCF)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This adds support for antenna switch configuration profiles to nl80211.

Signed-off-by: Daniel Golle <dgolle@allnet.de>
---
 include/linux/nl80211.h |   47 +++++++++++++++++++++++++++++++
 include/net/cfg80211.h  |   26 +++++++++++++++++
 net/wireless/nl80211.c  |   71 +++++++++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 97bfebf..0653896 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1185,6 +1185,12 @@ enum nl80211_commands {
  *    abides to when initiating radiation on DFS channels. A country maps
  *    to one DFS region.
  *
+ * @NL80211_ATTR_WIPHY_EXTANT: External antenna switch profiles. This nest=
ed
+ *	structure contains a list of available profiles as well as the current
+ *	profile selection status.
+ *
+ * @NL80211_ATTR_WIPHY_EXTANT_SELECT: Select extant profile.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1428,6 +1434,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_DISABLE_HT,
 	NL80211_ATTR_HT_CAPABILITY_MASK,
=20
+	NL80211_ATTR_WIPHY_EXTANT,
+	NL80211_ATTR_WIPHY_EXTANT_SELECT,
+
 	/* add attributes here, update the policy in nl80211.c */
=20
 	__NL80211_ATTR_AFTER_LAST,
@@ -1720,6 +1729,44 @@ enum nl80211_mpath_info {
 	NL80211_MPATH_INFO_MAX =3D __NL80211_MPATH_INFO_AFTER_LAST - 1
 };
=20
+
+
+/**
+ * enum nl80211_extant_attr - external antenna switch
+ * @__NL80211_EXTANT_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_EXTANT_ATTR_STATE: currently selected profile
+ * @NL80211_EXTANT_ATTR_PROFILES: highest profile attribute currently defi=
ned
+ * @NL80211_EXTANT_ATTR_MAX: highest profile attribute currently defined
+ * @__NL80211_EXTANT_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_extant_attr {
+	__NL80211_EXTANT_ATTR_INVALID,
+	NL80211_EXTANT_ATTR_STATE,
+	NL80211_EXTANT_ATTR_PROFILES,
+	/* keep last */
+	__NL80211_EXTANT_ATTR_AFTER_LAST,
+	NL80211_EXTANT_ATTR_MAX =3D __NL80211_EXTANT_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_easp_attr - external antenna switch configuration profile
+ * @__NL80211_EASP_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_EASP_ATTR_ID: unique identifier
+ * @NL80211_EASP_ATTR_NAME: human-readable name of the configuration profi=
le
+ * @NL80211_EASP_ATTR_DESC: human-readable description of the configuratio=
n profile
+ * @NL80211_EASP_ATTR_MAX: highest profile attribute currently defined
+ * @__NL80211_EASP_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_easp_attr {
+	__NL80211_EASP_ATTR_INVALID,
+	NL80211_EASP_ATTR_ID,
+	NL80211_EASP_ATTR_NAME,
+	NL80211_EASP_ATTR_DESC,
+	/* keep last */
+	__NL80211_EASP_ATTR_AFTER_LAST,
+	NL80211_EASP_ATTR_MAX =3D __NL80211_EASP_ATTR_AFTER_LAST - 1
+};
+
 /**
  * enum nl80211_band_attr - band attributes
  * @__NL80211_BAND_ATTR_INVALID: attribute number 0 is reserved
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e1891..4896e7a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1456,6 +1456,9 @@ struct cfg80211_gtk_rekey_data {
  *
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx=
_ant).
  *
+ * @set_extant: Select the external antenna switch configuration profile.
+ * @get_extant: Get currently selected antenna switch profile.
+ *
  * @set_ringparam: Set tx and rx ring sizes.
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
@@ -1637,6 +1640,9 @@ struct cfg80211_ops {
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
 	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
=20
+	int	(*set_extant)(struct wiphy *wiphy, u32 extant);
+	int	(*get_extant)(struct wiphy *wiphy, u32 *extant);
+
 	int	(*set_ringparam)(struct wiphy *wiphy, u32 tx, u32 rx);
 	void	(*get_ringparam)(struct wiphy *wiphy,
 				 u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
@@ -1748,6 +1754,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	=3D BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			=3D BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	=3D BIT(21),
+	WIPHY_FLAG_HAS_EXTANT_SWITCH		=3D BIT(22),
 };
=20
 /**
@@ -1875,6 +1882,21 @@ struct wiphy_wowlan_support {
 };
=20
 /**
+ * struct wiphy_extant_profile - User-parsable external antenna switch info
+ *
+ * This structure is used to provide the available switch configurations.
+ * @id: unique identifier of the profile
+ * @name: profile name (a short string)
+ * @description: user-parsable description of the profile
+ */
+struct wiphy_extant_profile {
+	int id;
+	char *name;
+	char *desc;
+};
+
+
+/**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
  *	note that if your driver uses wiphy_apply_custom_regulatory()
@@ -1955,6 +1977,8 @@ struct wiphy_wowlan_support {
  *	configured as RX antennas. Antenna configuration commands will be
  *	rejected unless this or @available_antennas_tx is set.
  *
+ * @extant: struct holding the available antenna switch configuration prof=
iles.
+ *
  * @max_remain_on_channel_duration: Maximum time a remain-on-channel opera=
tion
  *	may request, if implemented.
  *
@@ -2025,6 +2049,8 @@ struct wiphy {
 	 */
 	u32 probe_resp_offload;
=20
+	struct wiphy_extant_profile *extant;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a1cabde..9c861ae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -204,6 +204,8 @@ static const struct nla_policy nl80211_policy[NL80211_A=
TTR_MAX+1] =3D {
 	[NL80211_ATTR_HT_CAPABILITY_MASK] =3D {
 		.len =3D NL80211_HT_CAPABILITY_LEN
 	},
+	[NL80211_ATTR_WIPHY_EXTANT] =3D { .type =3D NLA_NESTED },
+	[NL80211_ATTR_WIPHY_EXTANT_SELECT] =3D { .type =3D NLA_U32 },
 };
=20
 /* policy for the key attributes */
@@ -252,6 +254,17 @@ nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX=
 + 1] =3D {
 						 .len =3D IEEE80211_MAX_SSID_LEN },
 };
=20
+/* policy for external antenna switch configuration profiles */
+static const struct nla_policy
+nl80211_easp_policy[NL80211_EASP_ATTR_MAX + 1] =3D {
+	[NL80211_EASP_ATTR_ID] =3D { .type =3D NLA_U32 },
+	[NL80211_EASP_ATTR_NAME] =3D { .type =3D NLA_STRING,
+					.len =3D IEEE80211_MAX_DATA_LEN },
+	[NL80211_EASP_ATTR_DESC] =3D { .type =3D NLA_STRING,
+					.len =3D IEEE80211_MAX_DATA_LEN },
+};
+
+
 /* ifidx get helper */
 static int nl80211_get_ifidx(struct netlink_callback *cb)
 {
@@ -699,6 +712,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 =
pid, u32 seq, int flags,
 	struct nlattr *nl_bands, *nl_band;
 	struct nlattr *nl_freqs, *nl_freq;
 	struct nlattr *nl_rates, *nl_rate;
+	struct nlattr *nl_easps, *nl_easp;
+	struct nlattr *nl_extant;
 	struct nlattr *nl_cmds;
 	enum ieee80211_band band;
 	struct ieee80211_channel *chan;
@@ -781,6 +796,48 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32=
 pid, u32 seq, int flags,
 		}
 	}
=20
+	/*
+	 * antenna switch configuration profile support
+	 */
+	if (dev->wiphy.flags & WIPHY_FLAG_HAS_EXTANT_SWITCH) {
+		struct wiphy_extant_profile *weprof;
+		nl_extant =3D nla_nest_start(msg, NL80211_ATTR_WIPHY_EXTANT);
+		if (!nl_extant)
+			goto nla_put_failure;
+
+		/* currently selected configuration profile */
+		if (dev->ops->get_extant) {
+			u32 extant;
+			int res;
+			res =3D dev->ops->get_extant(&dev->wiphy, &extant);
+			if (!res)
+				NLA_PUT_U32(msg,
+					NL80211_EXTANT_ATTR_STATE,
+					extant);
+		}
+
+		/* available profiles */
+		i=3D0;
+		nl_easps =3D nla_nest_start(msg, NL80211_EXTANT_ATTR_PROFILES);
+		for (weprof =3D dev->wiphy.extant; weprof->id >=3D 0; weprof++) {
+			nl_easp =3D nla_nest_start(msg, i);
+			if (!nl_easp)
+				goto nla_put_failure;
+			NLA_PUT_U32(msg, NL80211_EASP_ATTR_ID,
+				weprof->id);
+			NLA_PUT(msg, NL80211_EASP_ATTR_NAME,
+				strlen(weprof->name),
+				weprof->name);
+			NLA_PUT(msg, NL80211_EASP_ATTR_DESC,
+				strlen(weprof->desc),
+				weprof->desc);
+			nla_nest_end(msg, nl_easp);
+			i++;
+		}
+		nla_nest_end(msg, nl_easps);
+		nla_nest_end(msg, nl_extant);
+	}
+
 	if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 				dev->wiphy.interface_modes))
 		goto nla_put_failure;
@@ -1374,6 +1431,20 @@ static int nl80211_set_wiphy(struct sk_buff *skb, st=
ruct genl_info *info)
 			goto bad_res;
 	}
=20
+	if (info->attrs[NL80211_ATTR_WIPHY_EXTANT_SELECT]) {
+		u32 extant;
+		if (!rdev->ops->set_extant) {
+			result =3D -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		extant =3D nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_EXTANT_SELECT]);
+
+		result =3D rdev->ops->set_extant(&rdev->wiphy, extant);
+		if (result)
+			goto bad_res;
+	}
+
 	changed =3D 0;
=20
 	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {
--=20
1.7.4.1


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO07L4AAoJEDy9cKN/1Et0dtEP/3FttBa/odP1545TAR3NlEBn
wH6YB53gBaWlbAKZNGyuDrI62p33eYjPsIciQJCoK1fbAjfjk+YFA09zAuIxgzTg
U2fvnx2Dmca9+VNSprw5iikNCS8JaQtx1xnA4bCRLDQnfgj7fIvuZZVYt9g+SNUZ
Ln0Cdq+4gaHJOJeUeRtHqs+wsLg0xg2kZG9kVQI+uOkVemaej8DjESMRAEV9AbTP
U0tTO/QgQLpoiuMa30eDx4IH7I7c/wmt8o+wEWMdGs2AUS5yuSRlSRUDyPREDurv
T807xiePV+shR4wusexuMK90rNaUkFMoeSDkcQHQWIu5CeOnls85grMGJpi3xNZJ
T55BGiKImeCaVXm/pQBsnajQBMaQ+gXyFwug6auNxowJd+mXqcPGG6yPg1VndESo
9olknRSSmfX5WbkwEIjKLoA69b/bR0h2Jfm0asjybE6T/ahqo54TKyx2rf3MO0rq
YhXV98OoRb9WCuV5dyT3T8YBZa2BCtbQi7gdOIJvMUds6xuHUtIXqQ7RbPGepN39
UXS9jdMEGbJBz5xNLQTYXFkPAfWDjx1m9ujaMQp8XDl0aCn8u7DWXuAgRMCkX3wC
8MJbJwXVDk3vw0B7S+C8/9XE0XHcVUom7yoZ53MPAEGEA3psKKwC/wTCw0Y4PWSa
DGN8cCD5ngKtNqMcVgqk
=UnQq
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
