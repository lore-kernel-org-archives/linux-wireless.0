Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYARMhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:37:36 -0500
Subject: Re: [RFC PATCH 09/12 v2] iwlwifi: A-MPDU Tx conform API to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12005088643404-git-send-email-ron.rindjunsky@intel.com>
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
	 <12005088643404-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BpNg+vE9AflZziBTfiU1"
Date: Fri, 18 Jan 2008 01:36:10 +0100
Message-Id: <1200616570.5716.8.camel@johannes.berg> (sfid-20080118_123739_403869_58664CA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BpNg+vE9AflZziBTfiU1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
>  			     enum ieee80211_ampdu_mlme_action action,
> -			     const u8 *addr, u16 tid, u16 ssn)
> +			     u8 *addr, u16 tid, u16 *ssn)
>  {
>  	struct iwl4965_priv *priv =3D hw->priv;
>  	int sta_id;
> @@ -4733,12 +4733,18 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw =
*hw,
>  	switch (action) {
>  	case IEEE80211_AMPDU_RX_START:
>  		IWL_DEBUG_HT("start Rx\n");
> -		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, ssn);
> +		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
>  		break;
>  	case IEEE80211_AMPDU_RX_STOP:
>  		IWL_DEBUG_HT("stop Rx\n");
>  		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
>  		break;


>  extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
>  				    enum ieee80211_ampdu_mlme_action action,
> -				    const u8 *addr, u16 tid, u16 ssn);
> +				    u8 *addr, u16 tid, u16 *ssn);
>  #ifdef CONFIG_IWL4965_HT_AGG

These changes need to be in patch 1 so that has a chance of compiling.

johannes

--=-BpNg+vE9AflZziBTfiU1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4/0eKVg1VMiehFYAQKGURAAvPRIbnBOCGa20fs47E0gVsVnsrfFllE6
V6NMWWABsEmP4pXc+eTF6Quw3x7KGhP0VMK6y4rdBmie7rILgGDCRDsdXAgHdkNN
V+M+3Pxf7H9Uft+58o4XjW61C8mYxtNsOMQVkN6Sf4lxfdKubt5d15V86JhzOGmP
itWKRnJzEWs6kAquVqLp9LF6neybiKlodwWJbL7Zt2PrUkuqffUT3cda4Wtjrf6H
xk+hE5aab76fOXTVzZxdbTo1rQ90jZteMsRSRorNW3z2THCC2iVyl5iAZakSQs80
Guihw/CBSwp9+RvbcKSaQeAXjforqRWcMuIJ9Ztz4pmNqCjkMqNtaPwXUP0yi+7I
1b02OkVe/S182QWTRRqYj7Zf7emEX+pEXVqNWV8spiXCbK0rZ3pLhoEhI1Xk5dXo
TvSAkecrWC7KK21LaubRISPBdK8O/yFBbbLPL8QcFwwpiihayhp3/JB2TyLsgxke
P//5jEG2ZYsced95KpKDP3aenuV/KD6Pi4VTjq30FLLcro/2Brbm6V90Tko3v/WJ
sLDUYHy4DKJ1Rvh/AlRAna21LXIxLr836v3/JqRP1XSg3ng7PkwZ4HFjuCJHX6xT
wCgnTAmdydzkTaV40eARNZk17IbsYDISADWWd1u1O6g0lUfqCAyHDSpCVKC/GjK6
xNREm5zjI2s=
=4NqK
-----END PGP SIGNATURE-----

--=-BpNg+vE9AflZziBTfiU1--

