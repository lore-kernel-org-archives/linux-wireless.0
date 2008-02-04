Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYBDIq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 03:46:28 -0500
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <12020697053277-git-send-email-tomas.winkler@intel.com>
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8QpUW0HrEB6u+PW9AdN3"
Date: Mon, 04 Feb 2008 09:46:14 +0100
Message-Id: <1202114774.4188.127.camel@johannes.berg> (sfid-20080204_084633_650106_29C9C2E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8QpUW0HrEB6u+PW9AdN3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 460da54..a700ea6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -342,6 +342,7 @@ enum ieee80211_tx_status_flags {
>   *
>   * @control: a copy of the &struct ieee80211_tx_control passed to the dr=
iver
>   *	in the tx() callback.
> + * @rate: rate at which the packet was actually transmitted
>   * @flags: transmit status flags, defined above
>   * @retry_count: number of retries
>   * @excessive_retries: set to 1 if the frame was retried many times
> @@ -356,6 +357,7 @@ enum ieee80211_tx_status_flags {
>   */
>  struct ieee80211_tx_status {
>  	struct ieee80211_tx_control control;
> +	struct ieee80211_rate rate;

Shouldn't that rather be a rate pointer? Seems a bit odd to me to copy
that information. Felix, could this help you as well?

johannes

--=-8QpUW0HrEB6u+PW9AdN3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6bQ1aVg1VMiehFYAQLd4RAAlZsY8NYmKXc/YlsJY0XyTYF7MUdvpBEc
GPlgs3fTPCMSCyOsEX6Et0jtedyurrLeDSrMUh3CmNmU+byTnmvx/WHnH8/5pfxT
tQbXSq8aI2/UmtW5l7QkmRxQCFD3iwhaOcxZuqmcPRgEwZv588oo71/1IMmm9Agw
KilJjRsCOTqVH9pxHxbpuZkmulXHfv8ysOMR0+e/3jdSdFNjzYJdF7u8e1JuyOQS
l8NH5Dk7N19VYigi76acs0CgJpzOG7Z7xr0DCXVdf2zwaFJjFCDNirl7qD8J+iYm
l6ZMdv3ZDehLXXYCI0d1IGS6NV624R0DqhWOvqSnEQFog8uzxBgttX8jCNmy+bi6
TnJYIZ/gNx7zmpGdHrPlhYW3rPmqse2Lx3uyernRYsz7RCvSifcAP/CfaYERu6Tz
VaHApVoc5r/CXL2OIsP5aVXCADB7pSz+8lBlZM3Qkkwq+TUeK1ccBP76QpOQxvge
tNejT+qRPvjM/ba2oHoXZmCnzVl7adjf5Zpow8y2WWK+iF+Fuq71S9qnyjLc8DYd
SSMvKQfwlYF6pSX3zY5KaFOrMb0cn0hsndroQuTIVDLdA35wElcM40cYxL32Mv0e
8frD8mc0K9O5FRQONa1DEx+TP19areHrj4QaGOqNoDJAe6hqW1S8MC/gITzodDi9
SSB/MUN32kg=
=2cOt
-----END PGP SIGNATURE-----

--=-8QpUW0HrEB6u+PW9AdN3--

