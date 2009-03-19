Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZCSSrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 14:47:11 -0400
Subject: Re: [PATCH 3/4] nl80211: Event notifications for MLME events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <20090319114804.269481347@atheros.com>
References: <20090319113918.555693846@atheros.com>
	 <20090319114804.269481347@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FijWYFGyz3SU9z/vtD2i"
Date: Thu, 19 Mar 2009 19:47:02 +0100
Message-Id: <1237488422.5100.103.camel@johannes.local> (sfid-20090319_194722_033002_398AEE07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FijWYFGyz3SU9z/vtD2i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 13:39 +0200, Jouni Malinen wrote:
> plain text document attachment (nl80211-auth-assoc-event.patch)
> Add new nl80211 event notifications (and a new multicast group, "mlme")
> for informing user space about received and processed Authentication,
> (Re)Association Response, Deauthentication, and Disassociation frames in
> station and IBSS modes (i.e., MLME SAP interface primitives
> MLME-AUTHENTICATE.confirm, MLME-ASSOCIATE.confirm,
> MLME-REASSOCIATE.confirm, MLME-DEAUTHENTICATE.indicate, and
> MLME-DISASSOCIATE.indication). The event data is encapsulated as the 802.=
11
> management frame since we already have the frame in that format and it
> includes all the needed information.
>=20
> This is the initial step in providing MLME SAP interface for
> authentication and association with nl80211. In other words, kernel code
> will act as the MLME and a user space application can control it as the
> SME.
>=20
> Signed-off-by: Jouni Malinen <j@w1.fi>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/linux/nl80211.h |   36 +++++++++++++++++++++++-
>  include/net/cfg80211.h  |   46 ++++++++++++++++++++++++++++++
>  net/mac80211/mlme.c     |    9 ++++--
>  net/wireless/Makefile   |    2 -
>  net/wireless/mlme.c     |   46 ++++++++++++++++++++++++++++++
>  net/wireless/nl80211.c  |   72 +++++++++++++++++++++++++++++++++++++++++=
+++++++
>  net/wireless/nl80211.h  |   12 ++++++++
>  7 files changed, 219 insertions(+), 4 deletions(-)
>=20
> --- uml.orig/include/linux/nl80211.h	2009-03-19 00:18:28.000000000 +0200
> +++ uml/include/linux/nl80211.h	2009-03-19 12:01:16.000000000 +0200
> @@ -161,6 +161,25 @@
>   * 	%NL80211_REG_TYPE_COUNTRY the alpha2 to which we have moved on
>   * 	to (%NL80211_ATTR_REG_ALPHA2).
>   *
> + * @NL80211_CMD_AUTHENTICATE: authentication notification (on the "mlme"
> + *	multicast group). This event reports reception of an Authentication
> + *	frame in station and IBSS modes when the local MLME processed the
> + *	frame, i.e., it was for the local STA and was received in correct
> + *	state. This is similar to MLME-AUTHENTICATE.confirm primitive in the
> + *	MLME SAP interface (kernel providing MLME, userspace SME). The
> + *	included NL80211_ATTR_FRAME attribute contains the management frame
> + *	(including both the header and frame body, but not FCS).
> + * @NL80211_CMD_ASSOCIATE: association notification; like
> + *	NL80211_CMD_AUTHENTICATE but for Association Response and Reassociati=
on
> + *	Response frames (similar to MLME-ASSOCIATE.confirm or
> + *	MLME-REASSOCIATE.confirm primitives).
> + * @NL80211_CMD_DEAUTHENTICATE: deauthentication notification; like
> + *	NL80211_CMD_AUTHENTICATE but for Deauthentication frames (similar to
> + *	MLME-DEAUTHENTICATE.indication primitive).
> + * @NL80211_CMD_DISASSOCIATE: disassociation notification; like
> + *	NL80211_CMD_AUTHENTICATE but for Disassociation frames (similar to
> + *	MLME-DISASSOCIATE.indication primitive).
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -217,6 +236,11 @@ enum nl80211_commands {
> =20
>  	NL80211_CMD_REG_CHANGE,
> =20
> +	NL80211_CMD_AUTHENTICATE,
> +	NL80211_CMD_ASSOCIATE,
> +	NL80211_CMD_DEAUTHENTICATE,
> +	NL80211_CMD_DISASSOCIATE,
> +
>  	/* add new commands above here */
> =20
>  	/* used to define NL80211_CMD_MAX below */
> @@ -230,8 +254,11 @@ enum nl80211_commands {
>   */
>  #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
>  #define NL80211_CMD_SET_MGMT_EXTRA_IE NL80211_CMD_SET_MGMT_EXTRA_IE
> -
>  #define NL80211_CMD_REG_CHANGE NL80211_CMD_REG_CHANGE
> +#define NL80211_CMD_AUTHENTICATE NL80211_CMD_AUTHENTICATE
> +#define NL80211_CMD_ASSOCIATE NL80211_CMD_ASSOCIATE
> +#define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
> +#define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
> =20
>  /**
>   * enum nl80211_attrs - nl80211 netlink attributes
> @@ -353,6 +380,10 @@ enum nl80211_commands {
>   *	an array of command numbers (i.e. a mapping index to command number)
>   *	that the driver for the given wiphy supports.
>   *
> + * @NL80211_ATTR_FRAME: frame data (binary attribute), including frame h=
eader
> + *	and body, but not FCS; used, e.g., with NL80211_CMD_AUTHENTICATE and
> + *	NL80211_CMD_ASSOCIATE events
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -432,6 +463,8 @@ enum nl80211_attrs {
> =20
>  	NL80211_ATTR_SUPPORTED_COMMANDS,
> =20
> +	NL80211_ATTR_FRAME,
> +
>  	/* add attributes here, update the policy in nl80211.c */
> =20
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -451,6 +484,7 @@ enum nl80211_attrs {
>  #define NL80211_ATTR_IE NL80211_ATTR_IE
>  #define NL80211_ATTR_REG_INITIATOR NL80211_ATTR_REG_INITIATOR
>  #define NL80211_ATTR_REG_TYPE NL80211_ATTR_REG_TYPE
> +#define NL80211_ATTR_FRAME NL80211_ATTR_FRAME
> =20
>  #define NL80211_MAX_SUPP_RATES			32
>  #define NL80211_MAX_SUPP_REG_RULES		32
> --- uml.orig/include/net/cfg80211.h	2009-03-19 00:18:28.000000000 +0200
> +++ uml/include/net/cfg80211.h	2009-03-19 12:01:16.000000000 +0200
> @@ -807,4 +807,50 @@ void cfg80211_put_bss(struct cfg80211_bs
>   */
>  void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *bss);
> =20
> +/**
> + * cfg80211_send_rx_auth - notification of processed authentication
> + * @dev: network device
> + * @buf: authentication frame (header + body)
> + * @len: length of the frame data
> + *
> + * This function is called whenever an authentication has been processed=
 in
> + * station mode.
> + */
> +void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t=
 len);
> +
> +/**
> + * cfg80211_send_rx_assoc - notification of processed association
> + * @dev: network device
> + * @buf: (re)association response frame (header + body)
> + * @len: length of the frame data
> + *
> + * This function is called whenever a (re)association response has been
> + * processed in station mode.
> + */
> +void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_=
t len);
> +
> +/**
> + * cfg80211_send_rx_deauth - notification of processed deauthentication
> + * @dev: network device
> + * @buf: deauthentication frame (header + body)
> + * @len: length of the frame data
> + *
> + * This function is called whenever deauthentication has been processed =
in
> + * station mode.
> + */
> +void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf,
> +			     size_t len);
> +
> +/**
> + * cfg80211_send_rx_disassoc - notification of processed disassociation
> + * @dev: network device
> + * @buf: disassociation response frame (header + body)
> + * @len: length of the frame data
> + *
> + * This function is called whenever disassociation has been processed in
> + * station mode.
> + */
> +void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
> +			       size_t len);
> +
>  #endif /* __NET_CFG80211_H */
> --- uml.orig/net/mac80211/mlme.c	2009-03-19 00:20:52.000000000 +0200
> +++ uml/net/mac80211/mlme.c	2009-03-19 12:01:42.000000000 +0200
> @@ -1085,11 +1085,13 @@ static void ieee80211_rx_mgmt_auth(struc
>  	case WLAN_AUTH_OPEN:
>  	case WLAN_AUTH_LEAP:
>  		ieee80211_auth_completed(sdata);
> +		cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
>  		break;
>  	case WLAN_AUTH_SHARED_KEY:
> -		if (ifmgd->auth_transaction =3D=3D 4)
> +		if (ifmgd->auth_transaction =3D=3D 4) {
>  			ieee80211_auth_completed(sdata);
> -		else
> +			cfg80211_send_rx_auth(sdata->dev, (u8 *) mgmt, len);
> +		} else
>  			ieee80211_auth_challenge(sdata, mgmt, len);
>  		break;
>  	}
> @@ -1125,6 +1127,7 @@ static void ieee80211_rx_mgmt_deauth(str
> =20
>  	ieee80211_set_disassoc(sdata, true, false, 0);
>  	ifmgd->flags &=3D ~IEEE80211_STA_AUTHENTICATED;
> +	cfg80211_send_rx_deauth(sdata->dev, (u8 *) mgmt, len);
>  }
> =20
>=20
> @@ -1154,6 +1157,7 @@ static void ieee80211_rx_mgmt_disassoc(s
>  	}
> =20
>  	ieee80211_set_disassoc(sdata, false, false, reason_code);
> +	cfg80211_send_rx_disassoc(sdata->dev, (u8 *) mgmt, len);
>  }
> =20
>=20
> @@ -1370,6 +1374,7 @@ static void ieee80211_rx_mgmt_assoc_resp
>  	ieee80211_set_associated(sdata, changed);
> =20
>  	ieee80211_associated(sdata);
> +	cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
>  }
> =20
>=20
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ uml/net/wireless/mlme.c	2009-03-19 00:20:59.000000000 +0200
> @@ -0,0 +1,46 @@
> +/*
> + * cfg80211 MLME SAP interface
> + *
> + * Copyright (c) 2009, Jouni Malinen <j@w1.fi>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/nl80211.h>
> +#include <net/cfg80211.h>
> +#include "core.h"
> +#include "nl80211.h"
> +
> +void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t=
 len)
> +{
> +	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +	nl80211_send_rx_auth(rdev, dev, buf, len);
> +}
> +EXPORT_SYMBOL(cfg80211_send_rx_auth);
> +
> +void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_=
t len)
> +{
> +	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +	nl80211_send_rx_assoc(rdev, dev, buf, len);
> +}
> +EXPORT_SYMBOL(cfg80211_send_rx_assoc);
> +
> +void cfg80211_send_rx_deauth(struct net_device *dev, const u8 *buf, size=
_t len)
> +{
> +	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +	nl80211_send_rx_deauth(rdev, dev, buf, len);
> +}
> +EXPORT_SYMBOL(cfg80211_send_rx_deauth);
> +
> +void cfg80211_send_rx_disassoc(struct net_device *dev, const u8 *buf,
> +			       size_t len)
> +{
> +	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +	nl80211_send_rx_disassoc(rdev, dev, buf, len);
> +}
> +EXPORT_SYMBOL(cfg80211_send_rx_disassoc);
> --- uml.orig/net/wireless/nl80211.c	2009-03-19 00:18:28.000000000 +0200
> +++ uml/net/wireless/nl80211.c	2009-03-19 12:01:16.000000000 +0200
> @@ -2819,6 +2819,9 @@ static struct genl_ops nl80211_ops[] =3D {
>  		.dumpit =3D nl80211_dump_scan,
>  	},
>  };
> +static struct genl_multicast_group nl80211_mlme_mcgrp =3D {
> +	.name =3D "mlme",
> +};
> =20
>  /* multicast groups */
>  static struct genl_multicast_group nl80211_config_mcgrp =3D {
> @@ -2964,6 +2967,71 @@ nla_put_failure:
>  	nlmsg_free(msg);
>  }
> =20
> +static void nl80211_send_mlme_event(struct cfg80211_registered_device *r=
dev,
> +				    struct net_device *netdev,
> +				    const u8 *buf, size_t len,
> +				    enum nl80211_commands cmd)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!msg)
> +		return;
> +
> +	hdr =3D nl80211hdr_put(msg, 0, 0, 0, cmd);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
> +	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
> +	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
> +
> +	if (genlmsg_end(msg, hdr) < 0) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
> +	return;
> +
> + nla_put_failure:
> +	genlmsg_cancel(msg, hdr);
> +	nlmsg_free(msg);
> +}
> +
> +void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
> +			  struct net_device *netdev, const u8 *buf, size_t len)
> +{
> +	nl80211_send_mlme_event(rdev, netdev, buf, len,
> +				NL80211_CMD_AUTHENTICATE);
> +}
> +
> +void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
> +			   struct net_device *netdev, const u8 *buf,
> +			   size_t len)
> +{
> +	nl80211_send_mlme_event(rdev, netdev, buf, len, NL80211_CMD_ASSOCIATE);
> +}
> +
> +void nl80211_send_rx_deauth(struct cfg80211_registered_device *rdev,
> +			    struct net_device *netdev, const u8 *buf,
> +			    size_t len)
> +{
> +	nl80211_send_mlme_event(rdev, netdev, buf, len,
> +				NL80211_CMD_DEAUTHENTICATE);
> +}
> +
> +void nl80211_send_rx_disassoc(struct cfg80211_registered_device *rdev,
> +			      struct net_device *netdev, const u8 *buf,
> +			      size_t len)
> +{
> +	nl80211_send_mlme_event(rdev, netdev, buf, len,
> +				NL80211_CMD_DISASSOCIATE);
> +}
> +
>  /* initialisation/exit functions */
> =20
>  int nl80211_init(void)
> @@ -2992,6 +3060,10 @@ int nl80211_init(void)
>  	if (err)
>  		goto err_out;
> =20
> +	err =3D genl_register_mc_group(&nl80211_fam, &nl80211_mlme_mcgrp);
> +	if (err)
> +		goto err_out;
> +
>  	return 0;
>   err_out:
>  	genl_unregister_family(&nl80211_fam);
> --- uml.orig/net/wireless/Makefile	2009-03-19 00:18:28.000000000 +0200
> +++ uml/net/wireless/Makefile	2009-03-19 00:20:59.000000000 +0200
> @@ -5,7 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) +=3D lib8
>  obj-$(CONFIG_LIB80211_CRYPT_CCMP) +=3D lib80211_crypt_ccmp.o
>  obj-$(CONFIG_LIB80211_CRYPT_TKIP) +=3D lib80211_crypt_tkip.o
> =20
> -cfg80211-y +=3D core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
> +cfg80211-y +=3D core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o =
mlme.o
>  cfg80211-$(CONFIG_WIRELESS_EXT) +=3D wext-compat.o
> =20
>  ccflags-y +=3D -D__CHECK_ENDIAN__
> --- uml.orig/net/wireless/nl80211.h	2009-03-19 00:18:28.000000000 +0200
> +++ uml/net/wireless/nl80211.h	2009-03-19 00:20:59.000000000 +0200
> @@ -11,5 +11,17 @@ extern void nl80211_send_scan_done(struc
>  extern void nl80211_send_scan_aborted(struct cfg80211_registered_device =
*rdev,
>  				      struct net_device *netdev);
>  extern void nl80211_send_reg_change_event(struct regulatory_request *req=
uest);
> +extern void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev=
,
> +				 struct net_device *netdev,
> +				 const u8 *buf, size_t len);
> +extern void nl80211_send_rx_assoc(struct cfg80211_registered_device *rde=
v,
> +				  struct net_device *netdev,
> +				  const u8 *buf, size_t len);
> +extern void nl80211_send_rx_deauth(struct cfg80211_registered_device *rd=
ev,
> +				   struct net_device *netdev,
> +				   const u8 *buf, size_t len);
> +extern void nl80211_send_rx_disassoc(struct cfg80211_registered_device *=
rdev,
> +				     struct net_device *netdev,
> +				     const u8 *buf, size_t len);
> =20
>  #endif /* __NET_WIRELESS_NL80211_H */
>=20
> --=20
>=20

--=-FijWYFGyz3SU9z/vtD2i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwpMkAAoJEKVg1VMiehFYEzQP/2fZaO0KB2wOEw/3NjYvKzbJ
Gy95HK4BOghXzTb5p0QU0crWCd+hA1QSRhO+34Dalo/cZ66r+8MQmoL90gVoi3Pi
RS0lB/zwzObcpQa6K5NsjJWrMWNOXSE/eGT9wjC3+DVM0QgyUtrUJi4u8mI6+dlD
d5zSg+nnSmJC+sPhH1BrUCnBtlZJ+42G/z2Dzur60a7nhyQKsdiGHOLlmunptaE7
RYShaGLwycHSu+mQ/ozAEF3Olnk76iQeRZU4BIRV7LmCSjKM4EVxqXYvru2BMSR5
GL4BA4dH39Q7MfdH2v+veLj1j563x8Cj85JXjseHI7U1WoOu0yeCv5rRgKiIwUK6
mI8nXI0BUSAkV2WWsOvnvD2QThcCphgjuzFLoTOiNxdue8+3i8kzU/Fn0+8/z9NO
QLhMZhOc6tEDDBNnPHVPdenqKgkq4xTEuISlhUkkxbnyGnVj7JamxDRw96N+IcVz
bZEe8QXSX8WVGjw95zZJWLfn2VK/7w+R6E+1/vLHluto6rzFq6OAtuGnjjNP3pWm
/IbGXt9SAkllHkes4naseGAB1Ox4jwY/40/fIDNORirff/oC9ADhglRCva8i9juD
ujNtkxxFz5H7s04qVNcb0swjm+UYUq0Z5OS+e6a5fa7yiroprNSMBg6CSqCvPlv6
gqL2q0HXXPSAd+pRZKHr
=tUsJ
-----END PGP SIGNATURE-----

--=-FijWYFGyz3SU9z/vtD2i--

