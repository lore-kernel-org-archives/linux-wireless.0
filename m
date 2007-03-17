Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:48280 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751149AbXCQVbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 17:31:23 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Sat, 17 Mar 2007 17:30:28 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070317105800.659633351@warmcat.com> <20070317110751.352850972@warmcat.com>
In-Reply-To: <20070317110751.352850972@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1564202.JS19W853hE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703171730.33349.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1564202.JS19W853hE
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 March 2007 06:58, andy@warmcat.com wrote:
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index fb33b90..3873262 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -35,6 +35,7 @@
>  #include "ieee80211_led.h"
>  #include "ieee80211_cfg.h"
>  #include "ieee80211_sysfs.h"
> +#include <net/ieee80211_radiotap.h>
>
Already included by my patch.

> +	int tap_index =3D 0;
> +	u8 *tap_arg =3D skb->data + sizeof(struct ieee80211_radiotap_header);
> +	u32 *curr_arg_bitmap =3D &rthdr->it_present;
> +	u32 arg_bitmap=3Dle32_to_cpu(*curr_arg_bitmap);
Space before and after the =3D.=20

> +
> +	if(rthdr->it_version) return TXRX_DROP; /* version byte used as magic */
Space after the if.

> +
> +		/* sanity check for skb length and radiotap length field */
Keep comments indented the same as everything else.

> +	if (skb->len < (le16_to_cpu(rthdr->it_len) +
> +		sizeof(struct ieee80211_hdr)))
Using some spaces to align the start of the second line with the parenthesi=
s=20
often looks better.

> +		/* process and remove the injection radiotap header */
> +
> +	if(control->flags & IEEE80211_TXCTL_INJECTED_PACKET) {
dev points to the virtual interface that the frame originally came in on. Y=
ou=20
can get sdata from that and figure out if the interface was a monitor=20
interface.

Thanks,
=2DMichael Wu

--nextPart1564202.JS19W853hE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/F35T3Oqt9AH4aERAhsdAJ90tyV7BAO5qWZc+LpvyTdSZlggLQCgma9p
A4dqUT8yzJ4nSby/m1nFtrQ=
=TxDj
-----END PGP SIGNATURE-----

--nextPart1564202.JS19W853hE--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
