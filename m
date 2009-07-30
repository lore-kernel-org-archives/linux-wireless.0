Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZG3Sh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:37:27 -0400
Subject: Re: [PATCH] iwlwifi: don't export symbols not needed in other
 modules
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248978482.1216.1087.camel@rc-desk>
References: <1248947897.8925.13.camel@johannes.local>
	 <1248978482.1216.1087.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kTFI4cnf+kD/RpRs5aBg"
Date: Thu, 30 Jul 2009 20:36:51 +0200
Message-Id: <1248979011.23496.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kTFI4cnf+kD/RpRs5aBg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 11:28 -0700, reinette chatre wrote:
> Hi Johannes,
>=20
> On Thu, 2009-07-30 at 02:58 -0700, Johannes Berg wrote:
> > Even with the split into iwlcore/agn/3945 not all symbols
> > that cross file boundaries are needed in other modules, a
> > few are only used within iwlcore, for example.
>=20
> I think in this case we need to be explicit when talking about "need"
> and "used". Yes, some of these exported symbols are only used within a
> module and this needs to be fixed. At the same time, some of these may
> be needed outside, but are just not currently used. Examples of the
> latter are: iwl_remove_station, iwl_rx_ant_restriction, and
> iwl_send_card_state. I think this is especially important for
> iwl_remove_station and iwl_rx_ant_restriction because their partners
> (iwl_add_station and iwl_tx_ant_restriction) are exported and used and I
> think it will be clean if they are also, even if they are not currently
> used.

But they can easily be exported when used. That's done even for
subsystem symbols, for instance some generic netlink stuff wasn't
exported until it was needed in wimax.

Is there a problem with adding the export back whenever it's needed?

johannes

--=-kTFI4cnf+kD/RpRs5aBg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKceg+AAoJEODzc/N7+QmaE+0P/1xEvxOX1s7BKAXdBLHf9j/R
4pkPxnAJEQoQ7s30qsZiK1wQ0H8qg6p1sxpi8ansDWlwvbgCKIQdrj6T3511Lg3n
A12Xe5lOTwZsmbhyCu4SEXI6t3Rb6uIEJQp+7bciscZ9tfi73AhwOAS7VvO673J1
O31qITrfXZfHxCRHrsQZrH4Zkq7aDxJ0ythN8WGruW+Jy6YyZjm7S5B+KJ7HwOq0
2TQBACder6mFFzaJJbHGccZ6FUEghYlHGS3Trl/M/zJUuF+d+1F5xJNHY8xXBccI
mFJsdtzxRSkws0F8fNiT3Fqwl6puB9l4wkgrN9wQGPwUqFNkgBK9jhwzuu2mcAuz
KW1j8dHJFHqqP6GrVN9ipoj9pZiJoDFqjVIrnTxbqjEl5JGq5Lu7wH8Q7NXlWipC
OBjD0i9eHVkjepWvzTLQVNh3Fbf3oDX3GaizAFLR7ZPzXp9O3S4KEjM/LKJGhPUh
OkbgMH5RmAzZKN736+CKS9VbwDIUp6qviquhD4MQUmxOXdj6EO2UY75JNTUKgk/+
xOEDXDgLYRxZ5xxZm3kkzU0GInV/De25iqUY4zJdATHiIJIISuM8JXlDpJcu+mNn
McaPZupuXb3dcUr4QZxA//ZaU6XF3V+zmqgFl6savQiGrOVHZDcBdyRGrqVBGhRJ
vIdcyuQ3h4sXoFR+nwtX
=qbEr
-----END PGP SIGNATURE-----

--=-kTFI4cnf+kD/RpRs5aBg--

