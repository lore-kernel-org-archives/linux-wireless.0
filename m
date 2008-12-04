Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961AbYLDReh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 12:34:37 -0500
Subject: Re: [RFC PATCH v4 5/5] mac80211: track master queue status
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081202200426.5507.44042.stgit@tikku> (sfid-20081202_210437_005505_E84F6109)
References: <20081202200219.5507.83250.stgit@tikku>
	 <20081202200426.5507.44042.stgit@tikku>
	 (sfid-20081202_210437_005505_E84F6109)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JNzxRF7HDJDJQS9pxvu6"
Date: Thu, 04 Dec 2008 18:34:35 +0100
Message-Id: <1228412076.5692.25.camel@johannes.berg> (sfid-20081204_183453_109147_266CE3E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JNzxRF7HDJDJQS9pxvu6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-02 at 22:04 +0200, Kalle Valo wrote:

> +void __ieee80211_stop_queues(struct ieee80211_hw *hw,
> +			     enum queue_stop_reason reason)
>  {
>  	int i;
> =20
>  	for (i =3D 0; i < ieee80211_num_queues(hw); i++)
> -		ieee80211_stop_queue(hw, i);
> +		__ieee80211_stop_queue(hw, i, reason);
> +}
> +
> +void ieee80211_stop_queues(struct ieee80211_hw *hw)
> +{
> +	__ieee80211_stop_queues(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
>  }
>  EXPORT_SYMBOL(ieee80211_stop_queues);
> =20
> @@ -367,12 +409,18 @@ int ieee80211_queue_stopped(struct ieee80211_hw *hw=
, int queue)
>  }
>  EXPORT_SYMBOL(ieee80211_queue_stopped);
> =20
> -void ieee80211_wake_queues(struct ieee80211_hw *hw)
> +void __ieee80211_wake_queues(struct ieee80211_hw *hw,
> +			     enum queue_stop_reason reason)
>  {
>  	int i;
> =20
>  	for (i =3D 0; i < hw->queues + hw->ampdu_queues; i++)
> -		ieee80211_wake_queue(hw, i);
> +		__ieee80211_wake_queue(hw, i, reason);
> +}
> +
> +void ieee80211_wake_queues(struct ieee80211_hw *hw)
> +{
> +	__ieee80211_wake_queues(hw, IEEE80211_QUEUE_STOP_REASON_DRIVER);
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queues);

I wonder if we should optimise the spinlock here?

Also, I'd prefer to first add this with just a single DRIVER reason
first, and then add the PS patches that add and use the second reason.
Other than that, it looks good to me, thanks!

johannes

--=-JNzxRF7HDJDJQS9pxvu6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOBSoAAoJEKVg1VMiehFYYXoP/RffVcfg7CXVwyjc42FsXmy1
Wi/37WQOjrTti30WumARGymeOXTujH+P60PLohWNTV6aZP7L0u2ajuzaz0CAsK3Y
pppgR7ZLf4A9wwjiqGx810XUd8KVpLwQxhK/uPTxgjbWVAPzkqtt+tS2k3zH4yIw
Gi5vFuKsN+CB1N3ipk1ekJFoItoRwMttL1+HMolB2fevqI7opN7g5J/gUm5TLJSe
XvO461Modk5QECNqCpH6+7y4A6CDX3bCDZGO0cYJO3NX2FHcGgOyDnW9nHXVFL0g
2V1BfWLAqBjMqlLocAg1ONNvOof2/XBruAxuWwB/kgOuDNTg9SgvtFgekdU+pd8r
QqxBO+pwcjFPdaSs58RB0bCoZL0q/nMf3d/eG4cP7T67PKbojINB7ZR+u2wlToV0
sU6qKvga2tgSNg9LHO2PUutqn/hfQVSXImjMlb01oisVdu58Ryyyc3e9BqPEUoY8
F/UYlTIDdT73MhKg80003VN/AVjqmfBOPPqHd1vRaTOWe2hYPXDyYrB+O+T8ov8i
aQ89YKgds/nq0K9LWiM7wQh+bO4iOpxJDNAZw2HZb4/As0XWCEa4yvaa75221NC7
Ftj6CPjT+Vib1XQd0oDMH9El/SxHyp3PAdXhoNxY13swcJmxhA3MoEUOIQxiRa+n
h/wjQvm879K7trLPIQbS
=7vtd
-----END PGP SIGNATURE-----

--=-JNzxRF7HDJDJQS9pxvu6--

