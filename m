Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966741AbZLHWd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:33:56 -0500
Subject: Re: [PATCH] wireless: correctly report signal value for
 IEEE80211_HW_SIGNAL_UNSPEC
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1260310548-18161-1-git-send-email-linville@tuxdriver.com>
References: <1260310548-18161-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NEX4DLj8T+YUVi6FOoXe"
Date: Tue, 08 Dec 2009 23:33:33 +0100
Message-ID: <1260311613.32227.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NEX4DLj8T+YUVi6FOoXe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-08 at 17:15 -0500, John W. Linville wrote:
> This part was missed in "cfg80211: implement get_wireless_stats",
> probably because sta_set_sinfo already existed and was only handling
> dBm signals.

Now I do have to wonder how you found this, but yeah, looks right to me.

johannes

> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/cfg.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 93ee1fd..6dc3579 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -354,7 +354,8 @@ static void sta_set_sinfo(struct sta_info *sta, struc=
t station_info *sinfo)
>  	sinfo->rx_packets =3D sta->rx_packets;
>  	sinfo->tx_packets =3D sta->tx_packets;
> =20
> -	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
> +	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
> +	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
>  		sinfo->filled |=3D STATION_INFO_SIGNAL;
>  		sinfo->signal =3D (s8)sta->last_signal;
>  	}


--=-NEX4DLj8T+YUVi6FOoXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHtQ3AAoJEODzc/N7+QmavUMQAIKLgdRmJv8eHR4pEIgbMHqK
geqn9AyGW1f52O72gihtaw1aXgUEjnZXV8clP9pt5eeg6koTjjmQapZWadg6NMpx
TulzwGGfinH3lgTNmv0MjFU1TSwzzEIuTSTTkYgWa8vgTGh08kzHYdbsqT3QZQEf
lb/2MWVulD6+1tPEpxhRu5z4H7JZbEGz0GgmEzItHmHhrsYimih1VyblqT4+YbdW
zra2u83LZHR7pvSZXwIsZHD9VNTVEQDARfPkCeITbXyP49SGRwfXiYHELEfJRBYE
CindPEL04f4zKxSs7iT/CfgKXE0z8+qmqFSMzFDqoiYELzS7SA8hkmJkVa3L16TD
ha17rVLKW9GGu9JVFLRa6QvIHuiTR8uLzJzrGgJ9bhgNL/KxuGmsE7EW0M0w05Hz
VWgBYfaNSWFMEUroe2pgZfC0rtf25NCjcH8op10gnSuZPTqRl/6gc79oEfAvz9gR
FPFwAGZYYd0myaghwDfOyKkMYc36XpnrE+FAF/jn8PpsPWfN8vcFVTt7UHEI3YvC
JzlWMhYuOm1VU88G3k3+iUO0gDnKShb29mmpVHKqx4su49+//+qaM5kI+ardXn7W
JPr1fVdXvP5xTuA9m/JVuY56YxUS4iG/L9q+J5RvWj946hLtwQ2sOzXEE+VUnzDy
L1O+laGVyAf3y7EDcwIg
=DOvu
-----END PGP SIGNATURE-----

--=-NEX4DLj8T+YUVi6FOoXe--

