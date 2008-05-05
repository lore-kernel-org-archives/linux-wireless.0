Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbYEEHMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 03:12:05 -0400
Subject: Re: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1209954172-3092-21-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_821018_3824BECA)
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 (sfid-20080505_044417_821018_3824BECA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f6KadbRdkaAJAFGaHLmQ"
Date: Mon, 05 May 2008 09:11:43 +0200
Message-Id: <1209971503.3655.0.camel@johannes.berg> (sfid-20080505_091127_308985_ABBBB414)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f6KadbRdkaAJAFGaHLmQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	if (len > priv->hw_params.max_pkt_size || len < 16) {
> +	/* In monitor mode allow 802.11 ACk frames (10 bytes) */
> +	if (len > priv->hw_params.max_pkt_size ||
> +	    len < ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) ? 10 : 16)) {

> +
> +	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> +		iwl4965_handle_data_packet(priv, 1, include_phy,
> +						 rxb, &rx_status);
> +		return;
> +	}

Those conditions will never be true. In the case of the latter, that is
a good thing, in the case of the former that isn't.

johannes

--=-f6KadbRdkaAJAFGaHLmQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB6zLqVg1VMiehFYAQKDUBAAo805MLtP3zLbtgS7slbMUdmOYWb+22X7
599oFuo4/eRaI1C+BxHYxSO6iZS24f+gHlZTMKqZrNmarFK9wT32+7WkYLL5pSef
aBJvLQpQ7CPNy4ELVhwMXDw2cHAp0VOgxnXrO9K1MqoAJ2p19eCUFNne55L4YFnl
r/rQI3aI3WJslfKYQOHvVMnpOMd+h3EBRMT5f8+eTxbd1f28geNKOxJAk5Syluql
B5saOilPjpkYc7dSaupQ2eurEgqPXjns4Dit7aC9tJ6azBqVFcL1G27z8fqjXB6d
RJviFm5wzzpNnLCB4YFPDj/fc7BD2zzlq4mnRqgwrT2+6ESo2/07A8DvVsMm96P5
y8VSre6zjjn95Usvmh1N9tp9DlaBsB82lCeuqyVsAta0E041KGaA5vHzCPdqEdWZ
K6cedkyjjMUDlwCst813NUC/ipG3lslC1ecTqThRW5IZ6I7E2al8C7hOfCLnelEn
yiTefigBUyBFhwqy3hvogTzoRfm6V3l3Dzd+/gJHxL00O580LQcDnPNERKfSbGbp
hpCXdKK1iFmUedR1Y9rzanzklxditP3xPbikK6FdpcZk9OPuCLeYxfKMnH9PG0O4
hIndbKuifWOLP9Q8fUeRPrzkMUP0uGRmhUhb3p9ZdQ+W1ZISFRnE2Wz48tkofcf0
8fw+dIQMC2Y=
=4Bso
-----END PGP SIGNATURE-----

--=-f6KadbRdkaAJAFGaHLmQ--

