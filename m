Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61210 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965352AbXDKUd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 16:33:26 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: mabbas <mabbas@linux.intel.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Date: Wed, 11 Apr 2007 16:29:50 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jkm@devicescape.com>,
	"Simon Barber" <simon@devicescape.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <20070411194059.GA2436@tuxdriver.com> <461D3F48.70004@linux.intel.com>
In-Reply-To: <461D3F48.70004@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1730785.6ohWs9ZEik";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704111630.06160.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1730785.6ohWs9ZEik
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 11 April 2007 16:04, mabbas wrote:
> I am not familiar with userspace mlme what needed to be done?
mac80211 has a userspace mlme mode which defers all things dealing with=20
management frames to userspace (wpa_supplicant). It basically disables all=
=20
the code in ieee80211_sta.c and routes management frames to a special=20
interface where wpa_supplicant (or hostap) handles things. This is preferre=
d=20
and the ieee80211_sta.c code is there for backwards compatibility.

No major features should be added to the in-kernel MLME (ieee80211_sta.c) b=
ut=20
even more importantly, your patch series does not provide the appropriate=20
hooks for a userspace MLME to support a driver using this 802.11n API.

=2DMichael Wu

--nextPart1730785.6ohWs9ZEik
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGHUVOT3Oqt9AH4aERAoUpAJ9Jw1aXu/ARJdOJp98kmxwnerlhzQCgxlwE
+GVV8XB5z9BWTtpRVI0IoV4=
=mStM
-----END PGP SIGNATURE-----

--nextPart1730785.6ohWs9ZEik--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
