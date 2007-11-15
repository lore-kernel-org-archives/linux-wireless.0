Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763730AbXKOQxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 11:53:31 -0500
Subject: Re: [PATCH 02/15] mac80211: adding 802.11n definitions in
	ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11950630581850-git-send-email-ron.rindjunsky@intel.com>
References: <11950630581850-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xpFVQZnZw5RdeCVrZ74n"
Date: Thu, 15 Nov 2007 17:50:58 +0100
Message-Id: <1195145458.13846.75.camel@johannes.berg> (sfid-20071115_165338_252513_577BBC41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xpFVQZnZw5RdeCVrZ74n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-11-14 at 19:57 +0200, Ron Rindjunsky wrote:
> This patch adds several structs and definitions to ieee80211.h
> to support 802.11n draft specifications.
> As 802.11n depends on and extends the 802.11e standard in several issues,
> there are also several definitions that belong to 802.11e.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Thanks, looks good.

I think we can merge this one if only to reduce the working set. Still
discussing about deaggregation though, see other mail in reply to Guy.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/linux/ieee80211.h |  117 +++++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 117 insertions(+), 0 deletions(-)
>=20
> Index: wl2_6_24_HT/include/linux/ieee80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wl2_6_24_HT.orig/include/linux/ieee80211.h
> +++ wl2_6_24_HT/include/linux/ieee80211.h
> @@ -54,6 +54,8 @@
>  #define IEEE80211_STYPE_ACTION		0x00D0
> =20
>  /* control */
> +#define IEEE80211_STYPE_BACK_REQ	0x0080
> +#define IEEE80211_STYPE_BACK		0x0090
>  #define IEEE80211_STYPE_PSPOLL		0x00A0
>  #define IEEE80211_STYPE_RTS		0x00B0
>  #define IEEE80211_STYPE_CTS		0x00C0
> @@ -185,6 +187,25 @@ struct ieee80211_mgmt {
>  					u8 new_chan;
>  					u8 switch_count;
>  				} __attribute__((packed)) chan_switch;
> +				struct{
> +					u8 action_code;
> +					u8 dialog_token;
> +					__le16 capab;
> +					__le16 timeout;
> +					__le16 start_seq_num;
> +				} __attribute__((packed)) addba_req;
> +				struct{
> +					u8 action_code;
> +					u8 dialog_token;
> +					__le16 status;
> +					__le16 capab;
> +					__le16 timeout;
> +				} __attribute__((packed)) addba_resp;
> +				struct{
> +					u8 action_code;
> +					__le16 params;
> +					__le16 reason_code;
> +				} __attribute__((packed)) delba;
>  			} u;
>  		} __attribute__ ((packed)) action;
>  	} u;
> @@ -205,6 +226,66 @@ struct ieee80211_cts {
>  	u8 ra[6];
>  } __attribute__ ((packed));
> =20
> +/**
> + * struct ieee80211_bar - HT Block Ack Request
> + *
> + * This structure refers to "HT BlockAckReq" as=20
> + * described in 802.11n draft section 7.2.1.7.1
> + */
> +struct ieee80211_bar {
> +	__le16 frame_control;
> +	__le16 duration;
> +	__u8 ra[6];
> +	__u8 ta[6];
> +	__u16 control;
> +	__u16 start_seq_num;
> +} __attribute__((packed));
> +
> +/**
> + * struct ieee80211_ht_cap - HT capabilities
> + *
> + * This structure refers to "HT capabilities element" as=20
> + * described in 802.11n draft section 7.3.2.52
> + */
> +struct ieee80211_ht_cap {
> +	__le16 cap_info;
> +	u8 ampdu_params_info;
> +	u8 supp_mcs_set[16];
> +	__le16 extended_ht_cap_info;
> +	__le32 tx_BF_cap_info;
> +	u8 antenna_selection_info;
> +} __attribute__ ((packed));
> +
> +/**
> + * struct ieee80211_ht_cap - HT additional information
> + *
> + * This structure refers to "HT information element" as=20
> + * described in 802.11n draft section 7.3.2.53
> + */
> +struct ieee80211_ht_addt_info {
> +	u8 control_chan;
> +	u8 ht_param;
> +	__le16 operation_mode;
> +	__le16 stbc_param;
> +	u8 basic_set[16];
> +} __attribute__ ((packed));
> +
> +/* 802.11n HT capabilities masks */
> +#define IEEE80211_HT_CAP_SUP_WIDTH		0x0002
> +#define IEEE80211_HT_CAP_MIMO_PS		0x000C
> +#define IEEE80211_HT_CAP_GRN_FLD		0x0010
> +#define IEEE80211_HT_CAP_SGI_20			0x0020
> +#define IEEE80211_HT_CAP_SGI_40			0x0040
> +#define IEEE80211_HT_CAP_DELAY_BA		0x0400
> +#define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
> +#define IEEE80211_HT_CAP_AMPDU_FACTOR		0x03
> +#define IEEE80211_HT_CAP_AMPDU_DENSITY		0x1C
> +/* 802.11n HT IE masks */
> +#define IEEE80211_HT_IE_CHA_SEC_OFFSET		0x03
> +#define IEEE80211_HT_IE_CHA_WIDTH		0x04
> +#define IEEE80211_HT_IE_HT_PROTECTION		0x0003
> +#define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
> +#define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
> =20
>  /* Authentication algorithms */
>  #define WLAN_AUTH_OPEN 0
> @@ -271,6 +352,18 @@ enum ieee80211_statuscode {
>  	WLAN_STATUS_UNSUPP_RSN_VERSION =3D 44,
>  	WLAN_STATUS_INVALID_RSN_IE_CAP =3D 45,
>  	WLAN_STATUS_CIPHER_SUITE_REJECTED =3D 46,
> +	/* 802.11e */
> +	WLAN_STATUS_UNSPECIFIED_QOS =3D 32,
> +	WLAN_STATUS_ASSOC_DENIED_NOBANDWIDTH =3D 33,
> +	WLAN_STATUS_ASSOC_DENIED_LOWACK =3D 34,
> +	WLAN_STATUS_ASSOC_DENIED_UNSUPP_QOS =3D 35,
> +	WLAN_STATUS_REQUEST_DECLINED =3D 37,
> +	WLAN_STATUS_INVALID_QOS_PARAM =3D 38,
> +	WLAN_STATUS_CHANGE_TSPEC =3D 39,
> +	WLAN_STATUS_WAIT_TS_DELAY =3D 47,
> +	WLAN_STATUS_NO_DIRECT_LINK =3D 48,
> +	WLAN_STATUS_STA_NOT_PRESENT =3D 49,
> +	WLAN_STATUS_STA_NOT_QSTA =3D 50,
>  };
> =20
>=20
> @@ -301,6 +394,16 @@ enum ieee80211_reasoncode {
>  	WLAN_REASON_INVALID_RSN_IE_CAP =3D 22,
>  	WLAN_REASON_IEEE8021X_FAILED =3D 23,
>  	WLAN_REASON_CIPHER_SUITE_REJECTED =3D 24,
> +	/* 802.11e */
> +	WLAN_REASON_DISASSOC_UNSPECIFIED_QOS =3D 32,
> +	WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH =3D 33,
> +	WLAN_REASON_DISASSOC_LOW_ACK =3D 34,
> +	WLAN_REASON_DISASSOC_QAP_EXCEED_TXOP =3D 35,
> +	WLAN_REASON_QSTA_LEAVE_QBSS =3D 36,
> +	WLAN_REASON_QSTA_NOT_USE =3D 37,
> +	WLAN_REASON_QSTA_REQUIRE_SETUP =3D 38,
> +	WLAN_REASON_QSTA_TIMEOUT =3D 39,
> +	WLAN_REASON_QSTA_CIPHER_NOT_SUPP =3D 45,
>  };
> =20
>=20
> @@ -319,6 +422,15 @@ enum ieee80211_eid {
>  	WLAN_EID_HP_PARAMS =3D 8,
>  	WLAN_EID_HP_TABLE =3D 9,
>  	WLAN_EID_REQUEST =3D 10,
> +	/* 802.11e */
> +	WLAN_EID_QBSS_LOAD =3D 11,
> +	WLAN_EID_EDCA_PARAM_SET =3D 12,
> +	WLAN_EID_TSPEC =3D 13,
> +	WLAN_EID_TCLAS =3D 14,
> +	WLAN_EID_SCHEDULE =3D 15,
> +	WLAN_EID_TS_DELAY =3D 43,
> +	WLAN_EID_TCLAS_PROCESSING =3D 44,
> +	WLAN_EID_QOS_CAPA =3D 46,
>  	/* 802.11h */
>  	WLAN_EID_PWR_CONSTRAINT =3D 32,
>  	WLAN_EID_PWR_CAPABILITY =3D 33,
> @@ -333,6 +445,9 @@ enum ieee80211_eid {
>  	/* 802.11g */
>  	WLAN_EID_ERP_INFO =3D 42,
>  	WLAN_EID_EXT_SUPP_RATES =3D 50,
> +	/* 802.11n */
> +	WLAN_EID_HT_CAPABILITY =3D 45,
> +	WLAN_EID_HT_EXTRA_INFO =3D 61,
>  	/* 802.11i */
>  	WLAN_EID_RSN =3D 48,
>  	WLAN_EID_WPA =3D 221,
> @@ -341,6 +456,25 @@ enum ieee80211_eid {
>  	WLAN_EID_QOS_PARAMETER =3D 222
>  };
> =20
> +/* Action category code */
> +enum ieee80211_category {
> +	WLAN_CATEGORY_SPECTRUM_MGMT =3D 0,
> +	WLAN_CATEGORY_QOS =3D 1,
> +	WLAN_CATEGORY_DLS =3D 2,
> +	WLAN_CATEGORY_BACK =3D 3,
> +	WLAN_CATEGORY_WMM =3D 17,
> +};
> +
> +/* BACK action code */
> +enum ieee80211_back_actioncode {
> +	WLAN_ACTION_ADDBA_REQ =3D 0,
> +	WLAN_ACTION_ADDBA_RESP =3D 1,
> +	WLAN_ACTION_DELBA =3D 2,
> +};
> +
> +/* A-MSDU 802.11n */
> +#define IEEE80211_QOS_CONTROL_A_MSDU_PRESENT 0x0080
> +
>  /* cipher suite selectors */
>  #define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
>  #define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>=20
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>=20

--=-xpFVQZnZw5RdeCVrZ74n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzx48aVg1VMiehFYAQLO4w//fFuQjkodA8t1St9ZguKjAUvOj9AA+bQD
r0Jj2rta9XuJ3Dr2PLv9aciK6fTSi1IFBDusHM4xSrXDOZMDy9It0X2gJtOfFhYU
HOC2ugYwenffvet7HcELUX0/ibKZQ++3QYlBdMJ3okWRgKGp68DlQ54uU5v9Jcuk
d28jptlCC8YO4ToFs0BVlGRtxk4TDxvSMtIycHkrpbJXymcK1LwVI1S9+jKcVo2h
PEhbeKCzf/kjRvoka7gvwQ5w+z4AT4guf94uFLFIyoeByT0UINnO6GdQGP9ihUG+
xI8ikZd5b51u4c6srAvD1ElrR286Bicmy16Q+2MH3ukuKdOExHR4929aKJer4jPs
UbXaoQ+OcUc2G7nKFfMPF9dvaxOTUHAhGlIYpA6BD/XYvVPedJNAQwaM/yeWOIuh
NhSKip9iiFQhDg/FlgtvKO6AerP8tqtZMwI6xYIbmBUzgHsz/n0vnllYAwvspQ7o
D9fxYLdgVweXzZfOQCOsNmtgwZl3FnT1f/p0um1/mtycq/GHzQbsBPkm/4DOA6N2
e/HTDOE2qVssfXuHzHDtF6drHFLNOaTJHwALSPnQnD4YVzIsZgfDOpNE75cxEDfL
gRB8NiDJz16nVGUOVw9JwfTmI7giEvZ6u/1EREyvfGlJ483m8FCIg0jX5QcEfeI/
44ClqPFPsmg=
=S6zL
-----END PGP SIGNATURE-----

--=-xpFVQZnZw5RdeCVrZ74n--

