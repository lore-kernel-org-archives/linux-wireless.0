Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbXIRKI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 06:08:28 -0400
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1190036530108-git-send-email-tomas.winkler@intel.com>
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-klZQQAG/PZpF6xCTfmpr"
Date: Mon, 17 Sep 2007 20:44:40 +0200
Message-Id: <1190054680.23521.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-klZQQAG/PZpF6xCTfmpr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-17 at 15:42 +0200, Tomas Winkler wrote:

> +	void (*sta_notify)(struct ieee80211_hw *hw,
> +				sta_notify_cmd cmd, const u8 *addr);

I have plans to make the sta_info structs per-netdev so that we can
support having the same station associate to multiple virtual APs and
not hurting WDS links etc. This is not too hard, but needs some thought.

However, for this callback to be correct when the same sta_info struct
can be present for multiple virtual interfaces, we need to be able to
distinguish somehow, so this callback should probably get an if_idx that
allows a driver to map to the right interface because in add_interface
it was given the same if_idx.

I know this doesn't matter for iwlwifi because it only supports a single
local MAC address and currently not even WDS/AP mode at the same time
(nor AP mode at all? haven't checked). And I wonder if there will ever
be any hardware that cares and supports the configuration that would
require it. Should we just leave it and add a comment that when the
driver supports multiple interfaces this callback is unusable?

Thoughts? Do you have plans to, say, support combined WDS/AP modes? If
so, would the firmware be able to distinguish between the same STA
sending WDS frames and trying to associate? I don't know if any current
software supports that but I see nothing precluding it either. Or say
you have a WDS interface and also associate with a client interface to
the same AP; we could easily do that with b43 by allowing WDS interfaces
with the same MAC address in parallel all the time.

johannes

--=-klZQQAG/PZpF6xCTfmpr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG7ssY/ETPhpq3jKURAiSrAKChg1ahNrXEQyoz7XTlOVUaZPtSUgCgn6WS
59pja+Mzq81+5a2khELclr0=
=zhLR
-----END PGP SIGNATURE-----

--=-klZQQAG/PZpF6xCTfmpr--

