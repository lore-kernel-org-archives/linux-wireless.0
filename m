Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZDTWeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 18:34:23 -0400
Subject: Re: [PATCH] mac80211: do not print WARN if config interface fails
 during reconfigure
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1240266979-9254-1-git-send-email-reinette.chatre@intel.com>
References: <1240266979-9254-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bxLXpwhWLu3W1dQPHRPs"
Date: Tue, 21 Apr 2009 00:33:48 +0200
Message-Id: <1240266828.17388.1.camel@johannes.local> (sfid-20090421_003426_968292_292E2D97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bxLXpwhWLu3W1dQPHRPs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 15:36 -0700, Reinette Chatre wrote:
> It is expected that config interface will always succeed as mac80211
> will only request what driver supports. The exception here is when a
> device has rfkill enabled. At this time the rfkill state is unknown to
> mac80211 and config interface can fail. When this happens we deal with
> this error instead of printing a WARN.

Thanks. Just to make sure -- this really is just papering over the
warning, not actually fixing it. I hope we can fix it soon by making
mac80211 aware of rfkill.

johannes

> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  net/mac80211/util.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 52ef8d4..0ee74e8 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1047,8 +1047,19 @@ int ieee80211_reconfig(struct ieee80211_local *loc=
al)
>  		case NL80211_IFTYPE_ADHOC:
>  		case NL80211_IFTYPE_AP:
>  		case NL80211_IFTYPE_MESH_POINT:
> -			WARN_ON(ieee80211_if_config(sdata, changed));
> -			ieee80211_bss_info_change_notify(sdata, ~0);
> +			/*
> +			 * Driver's config_interface can fail if rfkill is
> +			 * enabled. Accommodate this return code.
> +			 * FIXME: When mac80211 has knowledge of rfkill
> +			 * state the code below can change back to:
> +			 *   WARN(ieee80211_if_config(sdata, changed));
> +			 *   ieee80211_bss_info_change_notify(sdata, ~0);
> +			 */
> +			if (ieee80211_if_config(sdata, changed))
> +				printk(KERN_DEBUG "%s: failed to reconfigure interface\n",
> +				       sdata->dev->name);
> +			else
> +				ieee80211_bss_info_change_notify(sdata, ~0);
>  			break;
>  		case NL80211_IFTYPE_WDS:
>  			break;

--=-bxLXpwhWLu3W1dQPHRPs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7PhIAAoJEKVg1VMiehFY0JkQAI9cRCe63kvsVXm+dSdt/0yM
8u8cZTiwsdvHnIv9Z6hDn8DysJschRJ2g10C282AdC6+CYZ2FuSuX7jc5El6UJSP
g02t6lcfVtmRQDWCqmQ/7kChiNijdSaq5/dYmapTg6SfyGQ4K6g2ZRHnxPDw+1MZ
bz0PEdJb0lwq3mLD7prgRW7J85ReiLa1A2q0De0s/27vOuIjrYjS0nBTENd5B3zf
jlvVB3+ieMlL4a8WDKehK/ZQlbe47a9DrSKu8vQEmnYc4EOS2YTCNOSwOdm31NqW
MLTVY1kH7LtJoumWNEJ9OoFwBcRbgQjzXDiGoIEVqw9EaoRSqo5rqm9Sip+H3pK/
VekAgdhg0QfwrKuLXWvbIZYQMKrTc4B/43Jm2sfjUGdCtX1YZmRSYGdwpjB3bxmO
d8bbHW2R1nrFlyAzscVWmCcS2AVa7eaBN4/7/VJNhqNIl9qQJuxjFE1Sbu88qh9Z
j7nQxptJSZlFWDUhvxC4yJDHgvitUZB3slUnvfZqBlonK9LbPNuBlOD6YKtfqLqC
Xe7fVGg/F9CGHk1u0z1AUZFcpus7zZfJsmsbaPs4aiiTBhsExHynjr6Ut9szHxQw
fdQwlt697tanJ+lwiL+URx9dUQlsMHDGs8eBNSVQBGVSiF4qnM6ppd/YXrKUyVKt
x2UAiOsUCLVxqAuTrRf3
=Bgt8
-----END PGP SIGNATURE-----

--=-bxLXpwhWLu3W1dQPHRPs--

