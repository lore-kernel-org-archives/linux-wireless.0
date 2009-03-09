Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZCITiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 15:38:21 -0400
Subject: Re: [RFC] nl80211: Add MLME primitives to support external SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <20090303144038.GA8435@jm.kir.nu>
References: <20090303144038.GA8435@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/tvYhT1hI/u+6MFtvL0a"
Date: Mon, 09 Mar 2009 20:03:30 +0100
Message-Id: <1236625410.9658.17.camel@johannes.local> (sfid-20090309_203823_461138_CB70C293)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/tvYhT1hI/u+6MFtvL0a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-03 at 16:40 +0200, Jouni Malinen wrote:
> Here's my current version of the nl80211 patch to allow authentication
> and association (in station mode) to be requested. This is able to
> complete authentication and association for open network, WPA, and FT
> initial association using a patches version of wpa_supplicant. The
> earlier change for kernel to enable auth/assoc events with nl80211 and a
> patch for wpa_supplicant is available at http://w1.fi/sme/
>=20
> I think the nl80211 commands are in a state that would be ready to be
> merged into wireless-testing and I would like to get this functionality
> in in pieces. There is obviously room for further improvements in
> cfg80211/mac80211, but that does not need to change the user space
> interface and can be done as a separate step.

Agreed. I'll take another look over both patches, the events too, and I
think we can probably merge it soon then.

> +/**
> + * enum nl80211_auth_type - AuthenticationType
> + *
> + * @NL80211_AUTHTYPE_OPEN_SYSTEM: Open System authentication
> + * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
> + * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
> + * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly=
 LEAP)
> + * @NL80211_AUTHTYPE_AUTO: Automatic selection (try Open System, Shared =
Key,
> + *	Network EAP and accept first one that goes through)

Do we really need or even want "auto"? Or is that for a future
"connect()" method that replaces auth/assoc for some hardware designs?

Quoting these structs in full for Samuel:

> +struct cfg80211_auth_request {
> +	struct ieee80211_channel *chan;
> +	u8 *peer_addr;
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	enum nl80211_auth_type auth_type;
> +	const u8 *ie;
> +	size_t ie_len;
> +};
> +
> +struct cfg80211_assoc_request {
> +	struct ieee80211_channel *chan;
> +	u8 *peer_addr;
> +	const u8 *ssid;
> +	size_t ssid_len;
> +	const u8 *ie;
> +	size_t ie_len;
> +};

I think that eventually this should contain the "cfg80211_bss" rather
than all the information like this. Once more of the MLME moves to
cfg80211, that is; and only when it can be supported, "connect()" would
be completely different.

As it is now, I don't think this interface is well-suited for
implementation by a full-mac chip, since it requires
 * implementing wext handlers separately, but compatibly
 * implementing an auth/assoc state machine for wext
 * manual lookup of the correct BSS etc.

As such, Samuel, I think you/we need to work on this before you can use
it. I'm willing to assist you with that.

> +static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
> +			   struct cfg80211_assoc_request *req)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	int ret;
> +
> +	if (!netif_running(dev))
> +		return -ENETDOWN;
> +
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +		return -EOPNOTSUPP;
> +
> +	if (req->peer_addr) {
> +		memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
> +		sdata->u.mgd.flags &=3D ~IEEE80211_STA_AUTO_BSSID_SEL;
> +		sdata->u.mgd.flags |=3D IEEE80211_STA_BSSID_SET;
> +	} else {
> +		sdata->u.mgd.flags |=3D IEEE80211_STA_AUTO_BSSID_SEL;
> +	}
> +
> +	/* TODO: req->chan */
> +	sdata->u.mgd.flags |=3D IEEE80211_STA_AUTO_CHANNEL_SEL;
> +
> +	if (req->ssid) {
> +		sdata->u.mgd.flags |=3D IEEE80211_STA_SSID_SET;
> +		memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
> +		sdata->u.mgd.ssid_len =3D req->ssid_len;
> +		sdata->u.mgd.flags &=3D ~IEEE80211_STA_AUTO_SSID_SEL;
> +	} else
> +		sdata->u.mgd.flags |=3D IEEE80211_STA_AUTO_SSID_SEL;
> +
> +	ret =3D ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
> +	if (ret)
> +		return ret;
> +
> +	sdata->u.mgd.flags |=3D IEEE80211_STA_EXT_SME;
> +	sdata->u.mgd.state =3D IEEE80211_STA_MLME_ASSOCIATE;
> +	ieee80211_sta_req_auth(sdata);
> +	return 0;
> +}

This function or cfg80211 should eventually reject any calls that don't
refer to a BSS we have already authenticated with, otherwise weird
things might happen, I think?

johannes

--=-/tvYhT1hI/u+6MFtvL0a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtWf/AAoJEKVg1VMiehFYk24P/A32BInNHrlGNfQNn18Vdwao
9vI8Cl52vY0RCtczSFlKytvaSpUfh5DnCUr3nNSZNS1Q+RTrI7jB1DenCznVpuOy
7g1g5LVKqsCeIQ5+5/TDnod5ZmzqLdC48JoMNPYsnjRULM5fC3zerwG7gytz8OlI
nBJUImn51EcXTYQQ0G+kZ+kJ/ye+jUadxUw5lz2RuTNhBXlMU3g/CSWfma96BH5g
zsveUSz1Xf//UvqGN1h/MWo5Hu6nXk5tPIGGocfw1aW7ajWZTz5mP1kF8j3Va2hM
8Dfj+uJvS9kclbc1OzOc+4TKmIucC3S3MkWpD8gi/phCl0DgthibkdC8lyZL5P14
apcpj3n/mT/EIE49r5A+ck5qQkLEKxxPGi7mEka4LoIYJYCh/STgHpEvXZL8BlZq
arPzDKXDprNLl7XUddNNYAdmpquMJd64P2yy5FnF2XOtwOHmrG431TsjClzGTz1A
1Ejk//sABuUtYyROq7TQzmvL6cTZD3Druskqux96b08Mw9bfvEM2KTBGRORsj9yf
foFBd+HRSN+1n3vzKCNWMqT2mfOFMTo917W6EvZSRFSd5HwMEW6pLK7HWQcYdP3m
eb6m1CZGWL9Xj6B5omuTjyLA6ArHW4tc9C5x7eBq663vdtRcpWJD98S0H5MFpRHB
73WbcxQpPPIxCppGHHfr
=EMjX
-----END PGP SIGNATURE-----

--=-/tvYhT1hI/u+6MFtvL0a--

