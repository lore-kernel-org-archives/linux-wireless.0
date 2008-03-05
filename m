Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374AbYCEJmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:42:10 -0500
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags and
	HT flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1204682972-26004-6-git-send-email-reinette.chatre@intel.com> (sfid-20080305_021129_007196_3EDE4B3E)
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080305_021129_007196_3EDE4B3E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NWQzElo2LL4mNOjQviJQ"
Date: Wed, 05 Mar 2008 10:41:56 +0100
Message-Id: <1204710116.25502.48.camel@johannes.berg> (sfid-20080305_094215_689554_11546A0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NWQzElo2LL4mNOjQviJQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-04 at 18:09 -0800, Reinette Chatre wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>=20
> This patch makes enum from the defines previously dwelled inside
> ieee80211_tx_control for better readability.
> The patch also addes HT flags, for 802.11n drivers:
> - IEEE80211_TXCTL_OFDM_HT: request low-level driver to use HT OFDM rates
> - IEEE80211_TXCTL_GREEN_FIELD: use green field protection
> - IEEE80211_TXCTL_DUP_DATA: duplicate data on both 20 Mhz channels
> - IEEE80211_TXCTL_40_MHZ_WIDTH: send this frame in 40Mhz width
> - IEEE80211_TXCTL_SHORT_GI: send this frame with short guard interval
>=20
> Tx command can be a combination of any of these flags, along with
> bitrate represented by ieee80211_rate. this will allow legacy drivers to
> switch easily to any 11n rate representation.

Looks good, but I wonder if there's any chance we'll see a generic rate
control algorithm use these flags? I.e. one not tied to Intel HW and
hidden in the iwlwifi subdir.

johannes

--=-NWQzElo2LL4mNOjQviJQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR85q46Vg1VMiehFYAQJGjRAAhOQuYHT3jV47XoWkwNl5qiCFaucgfBBt
nICU+2Ayt+j9whhG9gB5Xl2ZViN7iupDTdbF6oB7HNl8SUH+l2Xo0eee4cjOfuiN
hbAxaHYgh1d8VOJ577aJ9IijdKZpP3WHZUeidOlM3xGmQPswdjFBdnFtEZY8MURY
bS5E9CUjAb4ujvbblWcf//7ox99JlsDNrmHFbIhfJ3V/2VzqrM3Cp6gLfC7OB5ve
ivgRZGL6z3NOXIWHHAip0n9fC8lIPYuUVtcK1jpTCzpQs1Y33zVAsLxOdTVFinan
OlyytsUzAbKG/fPO/ee5D+82M2DfADe3L/VCDm5VXaC16j/l4N9cDwpn2dex3MD4
f7uk78U6zW1UOHi/MwhQh6mmcnNJMhSPi7m5YKzixEseAu2QYJu897lUB1D7PWzc
Az0dMCJ8spVC5Pfy9KKx1gGK5X8o/2B7y8LfRzO3MtVwA1ZrIdAvq1Y7gaHsIeN3
S5tXVHYx8tqmrs/NGLKHpwYYB4lgx+/18vM8bnQq23AW6vHKyp2uK3lXMiNdM3Iu
MhC1UxacgxS5Sj2cfKV2KIAbDxqxJDjNzt9g610LTqFBbNkICxPzlHlJY7nBNT6/
EM7frT/46EzPRapWbZLlFcYt9im9vM5M1kLhggnzwFWZ1O+rWRXu9eXbdp6k1F9h
EC9ZuA0/FkE=
=lMca
-----END PGP SIGNATURE-----

--=-NWQzElo2LL4mNOjQviJQ--

