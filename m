Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:10401 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751316AbXINDuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 23:50:55 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 03/21] mac80211: revamp interface and filter configuration
Date: Thu, 13 Sep 2007 23:50:34 -0400
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	Li YanBo <dreamfly281@gmail.com>
References: <20070905234209.108005000@sipsolutions.net> <20070905234622.671760000@sipsolutions.net>
In-Reply-To: <20070905234622.671760000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2378041.xEszd5PALt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709132350.38488.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2378041.xEszd5PALt
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 05 September 2007 19:42, Johannes Berg wrote:
> +	/*
> +	 * Configure the device's RX filter.
> +	 *
> +	 * If get_mc_item is assigned, then the multicast address filter
> +	 * must be changed if the hardware flags indicate that one is
> +	 * present. The get_mc_item function should be called until it
> +	 * returns %NULL, it must be passed the @get_mc_data pointer
> +	 * each time.
> +	 *
> +	 * All unsupported flags in 'total_flags' must be cleared,
> +	 * clear all bits except those you honoured.
> +	 *
> +	 * The callback must be implemented and must be atomic.
> +	 */
> +	void (*configure_filter)(struct ieee80211_hw *hw,
> +				 struct dev_mc_list *(get_mc_item)(void *data),
Yuck. Preventing drivers from calling get_mc_item outside configure_filter =
or=20
when the filter hasn't changed isn't worth doing this to enforce it. ;)

> +				 void *get_mc_data,
> +				 unsigned int changed_flags,
> +				 unsigned int *total_flags);

--nextPart2378041.xEszd5PALt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG6gUOT3Oqt9AH4aERArI7AKDEO/xKHLW7zmULk+C7MwPffgXqUwCgmVlo
osvHo+4gpDPyk7xCSTUGAzQ=
=5Zba
-----END PGP SIGNATURE-----

--nextPart2378041.xEszd5PALt--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
