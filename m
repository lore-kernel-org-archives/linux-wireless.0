Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:20060 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab1K1QRu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:17:50 -0500
Date: Mon, 28 Nov 2011 17:13:25 +0100
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: Daniel Golle <dgolle@allnet.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v1 2/3] support for antenna configuration profiles
Message-ID: <20111128161325.GA25474@localhost> (sfid-20111128_171753_461269_D87D5B77)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This adds {get,set}_extant operations to mac80211

Signed-off-by: Daniel Golle <dgolle@allnet.de>
---
 include/net/mac80211.h      |    3 ++
 net/mac80211/cfg.c          |   19 +++++++++++++++++
 net/mac80211/driver-ops.h   |   20 ++++++++++++++++++
 net/mac80211/driver-trace.h |   46 +++++++++++++++++++++++++++++++++++++++=
++++
 4 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b5c8a7..fe905ab 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2212,6 +2212,9 @@ struct ieee80211_ops {
 	int (*set_antenna)(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 	int (*get_antenna)(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
=20
+	int (*set_extant)(struct ieee80211_hw *hw, u32 extant);
+	int (*get_extant)(struct ieee80211_hw *hw, u32 *extant);
+
 	int (*remain_on_channel)(struct ieee80211_hw *hw,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2577c45..58fc272 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2208,6 +2208,23 @@ static int ieee80211_get_antenna(struct wiphy *wiphy=
, u32 *tx_ant, u32 *rx_ant)
 	return drv_get_antenna(local, tx_ant, rx_ant);
 }
=20
+static int ieee80211_set_extant(struct wiphy *wiphy, u32 extant)
+{
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+
+	if (local->started)
+		return -EOPNOTSUPP;
+
+	return drv_set_extant(local, extant);
+}
+
+static int ieee80211_get_extant(struct wiphy *wiphy, u32 *extant)
+{
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+
+	return drv_get_extant(local, extant);
+}
+
 static int ieee80211_set_ringparam(struct wiphy *wiphy, u32 tx, u32 rx)
 {
 	struct ieee80211_local *local =3D wiphy_priv(wiphy);
@@ -2691,6 +2708,8 @@ struct cfg80211_ops mac80211_config_ops =3D {
 	.mgmt_frame_register =3D ieee80211_mgmt_frame_register,
 	.set_antenna =3D ieee80211_set_antenna,
 	.get_antenna =3D ieee80211_get_antenna,
+	.set_extant =3D ieee80211_set_extant,
+	.get_extant =3D ieee80211_get_extant,
 	.set_ringparam =3D ieee80211_set_ringparam,
 	.get_ringparam =3D ieee80211_get_ringparam,
 	.set_rekey_data =3D ieee80211_set_rekey_data,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 49cc5e0..bd09553 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -626,6 +626,26 @@ static inline int drv_get_antenna(struct ieee80211_loc=
al *local,
 	return ret;
 }
=20
+static inline int drv_set_extant(struct ieee80211_local *local, u32 extant)
+{
+	int ret =3D -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->set_extant)
+		ret =3D local->ops->set_extant(&local->hw, extant);
+	trace_drv_set_extant(local, extant, ret);
+	return ret;
+}
+
+static inline int drv_get_extant(struct ieee80211_local *local, u32 *extan=
t)
+{
+	int ret =3D -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->get_extant)
+		ret =3D local->ops->get_extant(&local->hw, extant);
+	trace_drv_get_extant(local, *extant, ret);
+	return ret;
+}
+
 static inline int drv_remain_on_channel(struct ieee80211_local *local,
 					struct ieee80211_channel *chan,
 					enum nl80211_channel_type chantype,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 2af4fca..8593dba 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -931,6 +931,52 @@ TRACE_EVENT(drv_get_antenna,
 	)
 );
=20
+TRACE_EVENT(drv_set_extant,
+	TP_PROTO(struct ieee80211_local *local, u32 extant, int ret),
+
+	TP_ARGS(local, extant, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, extant)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->extant =3D extant;
+		__entry->ret =3D ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " extant:%d ret:%d",
+		LOCAL_PR_ARG, __entry->extant, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_get_extant,
+	TP_PROTO(struct ieee80211_local *local, u32 extant, int ret),
+
+	TP_ARGS(local, ext, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, extant)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->extant =3D extant;
+		__entry->ret =3D ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " extant:%d ret:%d",
+		LOCAL_PR_ARG, __entry->extant, __entry->ret
+	)
+);
+
 TRACE_EVENT(drv_remain_on_channel,
 	TP_PROTO(struct ieee80211_local *local, struct ieee80211_channel *chan,
 		 enum nl80211_channel_type chantype, unsigned int duration),
--=20
1.7.4.1


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO07MlAAoJEDy9cKN/1Et0MjQP/iAEGynW7Q3HPyS9KL45azwq
bpzF25nWVuHK0t9ZQ3+1GoynBEefGrgKtNAXVHodQyMQ7w0aJae0IUIrlR6VM5hf
lcCc9wFIPQqM9I3XzoIDP4X48MFORYu6frTp2en7V1uM3kEQO//s+Ytg6pwqC4/t
OOK6Mjb8eOm8/Vpmal8htmDiD+ypCgo27qzSIk0oG4j16/T69sC9LITvg76Q1LCk
uctLZOyWjaNK1/7lxhELGcqZQTKZgZHjaHvZxnBSaF+YkeU1vCw58gF/6HMH/Ifb
1a0wTuyEc3hbwJL+/kzpsmnbYz+xJKWdv2oo52qocZ1S1luRfNIT6u5DRI+e+PTJ
KOhav3rCFaYCsKMc1B466PaIVWAnCVbuRKImnLex0+w4iNhe/4tKBln82EBN4thb
KBT5fj03pgQfCmt1R4bSrTebIVPGwMx1JomfTzQL1CRypL3Cpn4u5QYoPb2keRWO
Dno4IvN2n5i3s3Wow3tp1EFAwCBjqEAKQzrNLPxw8X83Foe70Y8Lu6Nf7jH81394
IbxDCM4So5LUC140LHqW1ZdxQRtIGWPKch69pMW5dosIbry9O7020JJoimp50fJ6
qtYcW4KmaKYCgpFgkDl80FMHks/UTTaixc0b+8/C+qGnDr3CyeHt8Btuhe0+T5XQ
Xjw0/v+KxlrrHC2SKXAt
=vTHM
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
