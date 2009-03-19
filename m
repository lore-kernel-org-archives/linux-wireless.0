Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZCSTkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:40:53 -0400
Subject: Re: [PATCH v2 0/6] Use the regulatory bandwidth and export HT40
 stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+D0Njl2gV8ViEQsxFF25"
Date: Thu, 19 Mar 2009 20:40:47 +0100
Message-Id: <1237491647.5100.114.camel@johannes.local> (sfid-20090319_204055_830228_684D75C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+D0Njl2gV8ViEQsxFF25
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

John,

please back out this series, I'm not sure I agree with the concept and
I'm sure there are potential bugs that can make it segfault.

johannes

On Thu, 2009-03-19 at 01:54 -0400, Luis R. Rodriguez wrote:
> This took a little more consideration than I thought. This is a redesign
> of the bandwidth regulatory stuff, it also keeps in mind preferences in
> the future to use alternative bandwidths like 10 MHz and 5 MHz for things
> like 802.11p.
>=20
> Ultimately you'll now get proper interpretation of the regulatory
> bandwidth supported, we'll export the bandwidth allowed per channel,
> and we'll also export the channel HT40-/+ capabilities -- if they are
> allowed or not.
>=20
> This should also help considerably with testing regulatory settings.
> And for users planning to use HT40 it'll give you a direct guide which
> channels to pick on your AP.
>=20
> This second series completely abandons our old strategy to use the channe=
l
> bandwidth to determine whether or not we support HT40, instead we use it =
for
> to determine the supported actual bandwidth _per_channel_, not per channe=
l
> set (the pair of channels on an HT40 configuration).
>=20
> Luis R. Rodriguez (6):
>   cfg80211: Process regulatory max bandwidth checks for HT40
>   wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
>   mac80211: check if HT40+/- is allowed before sending assoc
>   cfg80211: check allowed channel type upon userspace requests
>   cfg80211: send channel max bandwidth to userspace
>   cfg80211: send to userspace if HT40-/+ is allowed on each channel
>=20
>  drivers/net/wireless/ath9k/regd.c         |   10 +-
>  drivers/net/wireless/iwlwifi/iwl-core.c   |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-eeprom.c |    8 +-
>  include/linux/nl80211.h                   |   18 +++
>  include/net/wireless.h                    |   23 +++--
>  net/mac80211/ht.c                         |   11 ++-
>  net/mac80211/mlme.c                       |    4 +-
>  net/wireless/nl80211.c                    |   27 ++++-
>  net/wireless/reg.c                        |  194 ++++++++++++++++++++++-=
-----
>  9 files changed, 234 insertions(+), 65 deletions(-)
>=20
>=20

--=-+D0Njl2gV8ViEQsxFF25
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwp+8AAoJEKVg1VMiehFYXoYQAJ8ZETkTxNVuO+omy6l8E3w0
9x1cEvyrHNS9+0Unnk8mF+PPkuTQZPesG7Q3CJDSvRSi0/2JPv+fvJfQ8ZtG0wrg
0iVUYoJ6uO2nI+ZENMjS6QQRWkkj7H24Em17UJJdIv5RksNbbx2JtHF51892+aln
vGXKsOw7AElW8PbSJUDU9InIvoja8dQ1e4rRPNre2AX9usAJIMmMeLdqg4JBp49m
+wcM38T5ZuB6Q6WowLZvEhmJGi3MFJNFfUujWAoEHu/02d128wrll88FB96qqyS7
p7gsk4JYLsLAHnPQquIv+uwA8+pGanDaV/UHQmbqpX/fz96cVPBDiDrdpmoZVwnO
v0DQaETcPWlfQlFeAz58aBXOed0IV+1nRs7qpYL8iymwtC4en51nk6UiKbLiUcsZ
qQyp+ad4uxYL1VsC2jLurRaQwnIcruXtXw8xZXIwVE5bBOVUjT/WxszvIJJYD5QG
IQIRoptc11shE9GF3miQ/7Gchc2Epa4Lx/BEeJqoc6b+dtUQle0GzQHh5WIjiRsr
kqzRIqTYP6uz0qF2ufh4clm62HT9UmthPITERqbx/wq0LKOt9B/RC7/FCX4hHHRj
SrwPhFq0eskizTutR0flczaRj5yU2tFrTNsBga845teq+vlXdMoNK3Rj+2VHuWst
i/GkUpTfZCJXL51KRphB
=wmzs
-----END PGP SIGNATURE-----

--=-+D0Njl2gV8ViEQsxFF25--

