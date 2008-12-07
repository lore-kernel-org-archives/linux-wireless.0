Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:2288 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYLGSVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 13:21:48 -0500
Received: by nf-out-0910.google.com with SMTP id d3so380216nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 10:21:46 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/2] Add signal strength and bandwith to nl80211station info
Date: Sun, 7 Dec 2008 19:20:18 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812071832.20533.hrogge@googlemail.com> <1228671578.22164.48.camel@johannes.berg>
In-Reply-To: <1228671578.22164.48.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200812071920.30283.hrogge@googlemail.com> (sfid-20081207_192158_601189_7B6D19C9)
Content-Type: multipart/signed;
  boundary="nextPart3337057.Oq5VcLtHsj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3337057.Oq5VcLtHsj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 07 December 2008 18:39:38 Johannes Berg wrote:
> Can you rename those too to NL80211_RATE_INFO_*? That way we can use
> them for other things later.
>
> But this looks good to me now.

I have splitted the patch into two parts so a better review is possible=20
without deciding if we put the total bandwith into nl80211 or not.

Changes since v1:
=2D removed noise and quality from station info in NL80211
=2D added bandwith to station info in NL80211
=2D changed name of patch file to nl80211ext_v2.patch
=A0=A0
Changes since v2:
=2D added kernel comment lines for new fields/enums
=2D changed name of "bandwith" field to tx_bitrate

Changes since v3:
=2D added rx_bitrate to station info and sta_info
=2D remember bitrate of last received unicast packet to this station
=2D decode 802.11n MCS index for nl80211
=A0 (maybe this should be ported to WEXT too ?)

Changes since v4:
=2D added tx_bitrate_flags adn tx_bitrate_mcs field to station info
=2D added flags for 40Mhz and small guard interval to NL80211 station info
=2D added mcs field to NL80211 station info

Changes since v5:
=2D remove rx_bitrate from patch until we get a sane way to learn the detai=
ls of=20
=A0
received 802.11n packages
=2Dreplace 802.11n bitrate arrays with calculation based on basic rates
=2D pushed txrate nl80211 stationinfo into nested attribute
=2D created station_info_rate_flags enum to save bitrate flags in station_i=
nfo
=2D cleanup of kerneldoc

Changes since v6:
=2D removed mcs index to bitrate conversion
=2D push station info bitrate into substructure
=2D renamed "total" bitrate into "legacy"
=2D some code cleanup

Changes since v7:
=2D corrected a small type in nl80211 mcs representation
=2D splitted patch into two parts

TODO:
=2D tests with real 802.11n hardware
=2D more tests with 802.11abg hardware

Henning


--nextPart3337057.Oq5VcLtHsj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk8E+4ACgkQcenvcwAcHWf9rwCgkqYBm9lC7Ylv7IqZsFeWqP4f
4JQAnjr2NYj65xo3VHLqGZ0OUTVU/JVI
=P/Zk
-----END PGP SIGNATURE-----

--nextPart3337057.Oq5VcLtHsj--
