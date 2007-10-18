Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbXJRSBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 14:01:32 -0400
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <11926651061687-git-send-email-tomas.winkler@intel.com>
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eOJsgSb3U+w1jWEOmiQa"
Date: Thu, 18 Oct 2007 18:48:04 +0200
Message-Id: <1192726084.15285.31.camel@johannes.berg> (sfid-20071018_190135_069914_4249F969)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eOJsgSb3U+w1jWEOmiQa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-18 at 01:51 +0200, Tomas Winkler wrote:

> +/* next structs enable the mac80211 to send association notification
> + * to low-level driver, as well as data that may be changed through
> + * the lifetime of the BSS, after it was parsed to meaningful structs */
> +struct ieee80211_erp_info {
> +	u8 changes;
> +	int cts_protection;
> +	int preamble;
> +};
> +
> +struct ieee80211_wmm_info {
> +	int queue;
> +	struct ieee80211_tx_queue_params *params;
> +};

Please do kernel-doc style comments for both structures so I can
incorporate this information easily into the mac80211 book. Also, some
general guidelines in a DOC comment would be appreciated, like

/**
 * DOC: BSS Status changes
 *
 * Describe what is expected of driver here
 */

> +struct ieee80211_bss_data {
> +	u8 changed_map; /* use ASSOC_CHNAGED_.. to indicate changed element */
> +	u8 assoc; /* 0 not assoc, 1 assoc */
> +	u16 aid;
> +	struct ieee80211_erp_info erp_info;
> +	struct ieee80211_wmm_info wmm_info;
> +};

Again, kernel-doc; also why do we actually need the sub-structuring into
erp_info and wmm_info (and if you manage convince me that we do :), can
we please call them just 'erp' and 'wmm' to save typing)?

This seems pretty ad-hoc to me. I think it'd be better to have them all
in one structure and use just a single 'changed' parameter instead of
having an extra one in the erp info. I would also use a 'flags'
parameter instead of 'assoc' and then roll CTS protect and short
preamble into those flags.

Also, the ASSOC_CHANGED_* flags should be renamed to BSS_STATE_CHANGED_*
or so, they don't really affect just the association.

Hmm. And here's a thought: don't we need all this information within
mac80211 as well? Would it maybe make sense to embed it into the sta
sdata structure and have the 'changed_map' not be in the structure but
as a second parameter to the callback function? Then we could always use
a pointer to the embedded structure that keeps track of this information
and build the changed value dynamically. This saves having to initialise
the structure all the time when calling the function and makes sure that
even the unchanged parameters are always valid should the driver need
them. [also see at the very end of this mail]

> @@ -1021,6 +1048,8 @@ struct ieee80211_ops {
>  	int (*config)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
>  	int (*config_interface)(struct ieee80211_hw *hw,
>  				int if_id, struct ieee80211_if_conf *conf);
> +	void (*bss_info_changed)(struct ieee80211_hw *hw,
> +				 struct ieee80211_bss_data *bss_data);

Missing doc updates, but see above. I'd prefer the docs in this struct
to just be a short note what the handler is and what the context is when
it is invoked (like "must be atomic" or "runs under XY lock") and then
for more details we refer to a DOC: section as I said above. That makes
it much easier to collate it into the mac80211 book.

> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 7c93f29..f38eb5a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -408,56 +408,66 @@ static void ieee80211_sta_send_associnfo(struct net=
_device *dev,
> =20
>  static void ieee80211_set_associated(struct net_device *dev,
>  				     struct ieee80211_if_sta *ifsta,
> -				     bool assoc)
> +				     struct ieee80211_bss_data *bss_data)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	union iwreq_data wrqu;
> =20
> -	if (!!(ifsta->flags & IEEE80211_STA_ASSOCIATED) =3D=3D assoc)
> +	if (!bss_data->changed_map)
>  		return;

If we did the embedding thing then all this would probably be simpler,
we could keep the 'bool assoc' parameter and have this function update
the [read on after the quote]
=20
> -	if (assoc) {
> -		struct ieee80211_sub_if_data *sdata;
> -		struct ieee80211_sta_bss *bss;
> +	if (bss_data->changed_map & ASSOC_CHNAGED_STATE) {
> +		if (bss_data->assoc) {
> +			struct ieee80211_sub_if_data *sdata;
> +			struct ieee80211_sta_bss *bss;
> =20
> -		ifsta->flags |=3D IEEE80211_STA_ASSOCIATED;
> +			ifsta->flags |=3D IEEE80211_STA_ASSOCIATED;

flag within the embedded struct instead of having another flag that
keeps track of the same information.
 =20
> -		bss =3D ieee80211_rx_bss_get(dev, ifsta->bssid);
> -		if (bss) {
> -			if (bss->has_erp_value)
> -				ieee80211_handle_erp_ie(dev, bss->erp_value);
> -			ieee80211_rx_bss_put(dev, bss);
> -		}
> +			bss =3D ieee80211_rx_bss_get(dev, ifsta->bssid);
> +			if (bss) {
> +				if (bss->has_erp_value)
> +				  ieee80211_handle_erp_ie(dev, bss->erp_value);

[bad indenting]

>  static void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb=
,
> @@ -1162,6 +1172,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net=
_device *dev,
>  	u32 rates;
>  	u16 capab_info, status_code, aid;
>  	struct ieee802_11_elems elems;
> +	struct ieee80211_bss_data bss_data;
>  	u8 *pos;
>  	int i, j;
> =20
> @@ -1249,7 +1260,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ne=
t_device *dev,
>  	if (ifsta->assocresp_ies)
>  		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
> =20
> -	ieee80211_set_associated(dev, ifsta, 1);
> +	bss_data.assoc =3D 1;
> +	bss_data.changed_map =3D ASSOC_CHNAGED_STATE;
> +	bss_data.aid =3D aid;
> +	bss_data.changed_map |=3D ASSOC_CHNAGED_AID;
> +	ieee80211_set_associated(dev, ifsta, &bss_data);

I think this is a bit dangerous. Above, you defined the structure member
'changed_map' which I personally would read as "take care, in this
structure the fields X, Y and Z changed over what I gave you last time".
However, the way it's used here is as a 'valid' bitmap, in "In this
struct, only the fields X, Y and Z are valid". This is a huge difference
if the driver happens to need multiple things at the same time, with the
approach you're doing here you'd need to keep track of everything in the
driver.

johannes

--=-eOJsgSb3U+w1jWEOmiQa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxeOQ6Vg1VMiehFYAQLjPBAArC4oxyU3iGiz3W/BJTSjEps0oK4DSLEk
cIBPRF3bY0YYbFggHeDLK8cYzZlXNFyfi0XUqZUEEIiRkOpoOgrGnSAYlo8OwHtI
M0TaNh4esIfxxhWLUQwsN4NAzRwX5il/CBl7VwWQhzyfMbrI0/ckG/dzogYFUpJ2
W3V+zGiSFPSutd+2uY5bAccFAmcaiKRccZpbInbhGeXng0i4Kw49pWtmYH6x4duc
IQpvxI50kNyPDbRdf7Sa8vKe4r69fJ0vLjmHYxKJ4ep2zgeGDNuLD2Yqo2lSxEx9
qFx2cDpDuia0w6Yc644Rw9t5P4DjZ7yYfCRWkEJ/5JPRoBByA9bzQo2Whlr+XH/v
y3ZzScBZHjqMFLF0tD7VI82EvrdBo0ya/dCY4vvEpUarj3gs1S2STKqOZQhgMjJo
nOCuwzuirQy3QJIFLPXJ/Wohg8wYtaQtq4aaC1Cip8v/G32hE6Xc/fJIoo8peclp
gZiutPMZBn43cBsk9t6FjBWduMpr2v1Dft/w7WfPjAFlr8qpYP/KxP3AufCnF7U+
y6zZxQSYKWhDcf8Y0HkVlFb015AO811y/SDaa6GFp69RLQtDCaH3BvPTWZrFcJ/v
kUZ0BsINNj/G+V21t5YaMPEgCG/zTnArHYRXWf0EDflP+0O58UaIyz0gyar2SBr/
73ev5swt208=
=I0L+
-----END PGP SIGNATURE-----

--=-eOJsgSb3U+w1jWEOmiQa--

