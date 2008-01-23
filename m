Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYAWRKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 12:10:20 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080118125252.6455.41047.stgit@one> (sfid-20080118_125251_383020_9A9C2A8A)
References: <20080118125252.6455.41047.stgit@one>
	 (sfid-20080118_125251_383020_9A9C2A8A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gRE9hqhKny7Tl0hSuGjQ"
Date: Wed, 23 Jan 2008 15:48:49 +0100
Message-Id: <1201099729.3454.17.camel@johannes.berg> (sfid-20080123_171025_414837_A7893438)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gRE9hqhKny7Tl0hSuGjQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> enable IBSS cell merging. if an IBSS beacon with the same ESSID and a TSF
> higher than the local TSF (mactime) is received, we have to join its BSSI=
D.

Can you back that up with standard references? I see no such requirement
in the standard text. I can see that under some circumstances this may
be desirable, but maybe not.

In fact, this seems to *break* standard behaviour, as per 11.1.3.1:
(emphasis mine)

        When a STA starts a BSS, that STA shall determine the BSSID of
        the BSS. If the BSSType indicates an infrastructure BSS, then
        the STA shall start an infrastructure BSS and the BSSID shall be
        equal to the STA=E2=80=99s dot11StationID. ***The value of the BSSI=
D
        shall remain unchanged***, even if the value of dot11StationID
        is changed after the completion of the MLME-START.request. If
        the BSSType indicates an IBSS, the STA shall start an IBSS, and
        the BSSID shall be an individual locally administered IEEE MAC
        address as defined in 5.2 of IEEE Std 802-1990. The remaining 46
        bits of that MAC address shall be a number selected in a manner
        that minimizes the probability of STAs generating the same
        number, even when those STAs are subjected to the same initial
        conditions.

Remember that BSSIDs, *not* SSIDs are used to identify BSSes uniquely.

Of course you could argue that "merging" is simply tearing down the own
and then joining the other IBSS.

Comments on the code now.

> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -80,6 +80,9 @@ static void ieee80211_rx_bss_put(struct net_device *dev=
,
>                                  struct ieee80211_sta_bss *bss);
>  static int ieee80211_sta_find_ibss(struct net_device *dev,
>                                    struct ieee80211_if_sta *ifsta);
> +static int ieee80211_sta_join_ibss(struct net_device *dev,
> +                                  struct ieee80211_if_sta *ifsta,
> +                                  struct ieee80211_sta_bss *bss);

No way, order the code properly, this mess needs to be cleaned up not
added to.
=20
> -	if (bss->probe_resp && beacon) {
> +	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
> +	    bss->probe_resp && beacon) {
>  		/* Do not allow beacon to override data from Probe Response. */

Ahem. Comment update required.

> +	/* check if we need to merge IBSS */

Could use a plural, but whatever.

> +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && beacon &&
> +	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
> +	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> +	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) =3D=3D=
 0) {

I think that needs a check "&& ssid_len" or something. Someone's bound
to try making an IBSS with a hidden SSID and we really don't want that
to work.

> +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> +		static unsigned long last_tsf_debug;
> +#endif

Let's just get rid of that, it's not usable with multiple devices.

> +		if (rx_status->flag & RX_FLAG_TSFT)
> +			mactime =3D rx_status->mactime;
> +		else {
> +			mactime =3D -1LLU;
> +			printk(KERN_WARNING "%s: IBSS mode needs mactime for "
> +				"beacons\n", dev->name);

Very bad, you'll be flooded by this when others send beacons. Also, I
doubt its truthfulness.

> +			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
> +				" -> IBSS merge with BSSID %s\n",
> +				dev->name, print_mac(mac, mgmt->bssid));

No way. At the very least you need to ratelimit this.

johannes

--=-gRE9hqhKny7Tl0hSuGjQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5dTz6Vg1VMiehFYAQI5Bw//XRVWHcg3Gysk90ast08JJ0NjPqeddytG
aLo2sgG8ByLKPEFFaNTipDLWyI5VOn8PF4wISnwDdp7DNzHSLBFGM+wCnGi3DUZK
6vR2eMHTtYXE93Ancq/hUwoAxtt3dClDftWRveFnu6cCnpVq9Ipn7/3gwXtqfdPF
OncmLcSQtYmd+rijsq2rKrQeD1QovGRL+3mMpHVL9Jm6kcVP9v2IK4FYEGuC9Dlm
3R2paDPVNKZEhZG/HndRwB0E3xbc56WqtH1ap6bLgCwz2ceqpq8NncAcGAa8MjIG
0rxfhyp3mJnlIAjOLLLAH3AW9DXPVXFM9mBCeXheVvixdcHPW06EtBuDF/eJpdHv
LNY287pjIGoSlK28LHW4spcu17su5XwacR1Virr0MT6BfFNGMdFn6bdDZtMf1emw
0Nm1OJ36AU21BmlJb7Q39xkbyoDUaQhWQLbuvWd4Jvj9XTsrwy+2QKyzxvFbjWWF
3OkUowylzf+F4hN2xxUxnp1W2tBYm2MmvbfxCMtBaFRWY7f7sITczdsvE2IFKkE0
W2Qz31X8B+zb2RcngASUFQdFRzGDi0KgT8CtgdNETwLxCtJGyC8Y2DmaPFZkKw+0
UqJM+5W9pPBrl3rajb7YyM/07AAXr1PT97LeTdKR7ykjHkDz4Bv7q9xHLyFaB79T
HJZ2jE53LFw=
=aaNL
-----END PGP SIGNATURE-----

--=-gRE9hqhKny7Tl0hSuGjQ--

