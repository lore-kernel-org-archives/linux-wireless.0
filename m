Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYAQPPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:15:10 -0500
Subject: [FYI] hostapd status
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Bas Hulsken <bhulsken@zonnet.nl>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sLuMSf93uz0Ln6a33H20"
Date: Wed, 16 Jan 2008 22:58:54 +0100
Message-Id: <1200520735.8007.20.camel@johannes.berg> (sfid-20080117_151537_434418_468FEC0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sLuMSf93uz0Ln6a33H20
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I just took the time to adjust hostapd to the new nl80211-based hardware
capabilities exporting (patch I recently posted) and it "works" again.

The todo list now pretty much is:

 * bring Michael Wu's "cooked" monitor patches to a suitable shape for
   merging and write iw(1) support for monitor flags; the cooked monitor
   hook shouldn't be in the RX handlers to allow seeing frames that
   other handlers dropped
 * remove 802.1X setting, 802.1X need never be disabled on an AP because
   it can be completely managed by hostapd
 * allow hostapd to set the 'basic' and 'supported' rate sets
 * allow hostapd to set QoS queue parameters
 * allow hostapd to set ERP parameters:
   - RTS/CTS protection
   - preamble
   - slot time
 * make kernel send events via nl80211 (TKIP MMIC, key threshold, ...)
 * make hostapd deal with such kernel events by using libnl properly
   with an ops list
 * implement regulatory domain control kernel/userspace API
 * make hostapd use that API, it wants to be in control of regulatory
   compliance rather than relying on an external daemon

I hope Luis will work on the last two items, and I personally want to
handle only the first two items. All others on the list are up for
grabs.

As usual, patches available from my website (ping me if I forget to push
them.)

I'm fairly confident now that my cfg80211 rate/channel API and the
corresponding nl80211 export code is usable now so I'll post that for
inclusion soon, I'll even rebase it on top of the iwlwifi changes if
they are merged soon enough.

johannes

--=-sLuMSf93uz0Ln6a33H20
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR45+HaVg1VMiehFYAQLufQ//SnBt/AC+z6BWYUAQYsjbLV6mQr14mh0T
hNLq11Zao7KswODoQNOXPMp+7GtooYsEYLIvancYEAiV6pim+DVN6vLyD9svGCda
bocGb2nO+gO4VlqYHR+PiMM2DZWsr5JEzhvEkhnKXDcsejJ4JuPCkdP5Qv2NVAFe
E+xdDB8LBZKjSfpk69ZvdWLuznUUaQjJKIq3aXdiMjdZ3Kxc6rINS4yY5DEg7ah5
9uFU/ujQKGHoKTobRL/+5G+VAyiqGFfwNuoQKSmiEqmf1ppc1Urqiv8VJTuVlIe5
7816DjjrAwU10NrJxF4ZQm8QVFw9EvVsrA2PEo8S47Uzn2nOZ7IaSif3+OHqU3tP
XBJL1JzcsACZyueJMiLMb89YDgQbsBqE2244c0HTASpCcC2djRMjkiW2Tt4ZEAYb
NTNLUF38JTbRvETe4zGzUOJOidEX5cLhOaykmTXTv7nIqiC2kNzS/xyEFfA7Kgf/
FVEGxUVCdSSQOZVFHH/NSgMAV1AvaEGOujr4llf+HJz4A0fnm7NDgel1hoMtRcOZ
rof51hFUTqO0C3oGgWFxTbaIe6DDmha4LQsoY+oGaaNlaHir9IZ/WCccQoyMcb/e
lERA1sjI62LmXtSf8edGVIvbGhXbtesUDvA47cQcDYk8x3/afIfbiVKYsQfKal5G
2rQGGI4A5YY=
=HMsf
-----END PGP SIGNATURE-----

--=-sLuMSf93uz0Ln6a33H20--

