Return-path: <wireless-bounces@tuxdriver.com>
Received: from annwn14.rutgers.edu (smtp.rutgers.edu [128.6.72.243])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V2kcsw003795	for
 <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 21:47:03 -0500
Date: Tue, 30 Jan 2007 21:46:01 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
In-reply-to: <20070131013840.GB28076@tuxdriver.com>
Sender: wireless-bounces@tuxdriver.com
To: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <200701302146.05289.flamingice@sourmilk.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="===============0976697536=="
References: <20070131013717.GA28076@tuxdriver.com>
 <20070131013840.GB28076@tuxdriver.com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

--===============0976697536==
Content-Type: multipart/signed; boundary="nextPart1677388.704yaBO5tR";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1677388.704yaBO5tR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 January 2007 20:38, John W. Linville wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
>
> +	/* Inject a frame using NL80211_ATTR_FLAGS and NL80211_ATTR_FRAME.
> +	 * If kernel sends this, it's a status notification for the injected
> +	 * frame. */
> +	NL80211_CMD_INJECT,
> +
I think drivers that currently support frame injection do it by allowing TX=
 on=20
a monitor interface w/ AVS or radiotap header. I would rather have this tha=
n=20
requiring the use of NL80211 to inject frames since userspace won't have to=
=20
do as much to continue supporting frame injection. It also makes more sense=
=20
to me. Status notification can be done by a 802.11 ACK frame. Radiotap migh=
t=20
need to be extended to support toggling the ACK frame reporting for TX and=
=20
whatever else userspace wants to set.

[snip]
> +	/* configure device */
> +	NL80211_CMD_CONFIGURE,
> +
> +	/* request configuration */
> +	NL80211_CMD_GET_CONFIG,
> +
> +	/* configuration sent from kernel */
> +	NL80211_CMD_NEW_CONFIG,
> +
Why NEW?

[snip]
> +	/* currently set roaming BSSID */
> +	NL80211_CMD_FIXED_BSSID,
> +
Wasn't immediately obvious to me that this is from GET_FIXED_BSSID.

> +	/* get current association information, if not associated then
> +	 * the BSSID attribute is not present in response */
> +	NL80211_CMD_GET_ASSOCIATION,
> +
> +	/* association notification and response to GET_BSSID */
> +	NL80211_CMD_ASSOCIATION_CHANGED,
> +
I don't see a GET_BSSID. Did you mean GET_ASSOCIATION?

[snip]
> +	/* attributes used for configuration */
> +	/* network ID (pre 802.11 HW) */
> +	NL80211_ATTR_NETWORK_ID,
> +
We really want to support (and port) pre 802.11 drivers?

[snip]
> +	/* SSID of ESS to associate to */
BSS?

> +	NL80211_ATTR_SSID,
> +

[snip]
> + * @list_interfaces: for each interfaces belonging to the wiphy identifi=
ed
> + *		     by the priv pointer, call the one() function with the
> + *		     given data and the ifindex. This callback is required.
> + *
Do we really have to have this?

Thanks,
=2DMichael Wu

--nextPart1677388.704yaBO5tR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFwALtT3Oqt9AH4aERAtiHAKClMhMFSrGsksnEf2gTBNwEC8pYdACgstiL
nzBgqRbtNZOhmu3bFK0Lx2s=
=jFRX
-----END PGP SIGNATURE-----

--nextPart1677388.704yaBO5tR--

--===============0976697536==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============0976697536==--
