Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbYJGQ5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:57:44 -0400
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Holt <holt@sgi.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20081006133045.GM8534@sgi.com>
References: <20081004103144.GI8534@sgi.com>
	 <1223165956.24551.76.camel@johannes.berg> <20081005023143.GJ8534@sgi.com>
	 <1223195921.24551.79.camel@johannes.berg> <20081006064509.GK8534@sgi.com>
	 <1223283470.24551.86.camel@johannes.berg>  <20081006133045.GM8534@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9177DH7NkmFT7KnQD0v2"
Date: Tue, 07 Oct 2008 00:09:36 +0200
Message-Id: <1223330976.3778.47.camel@johannes.berg> (sfid-20081007_185808_110013_A3DA614F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9177DH7NkmFT7KnQD0v2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 08:30 -0500, Robin Holt wrote:

> I didn't really need to do much for the printk's in
> ieee80211_sta_debugfs_add().  My printk's in sta_info_debugfs_add_work()
> already told me that sta->local->debugfs.stations is NULL. =20

Well yes, but I wanted to know why ieee80211_sta_debugfs_add() doesn't
set debugfs.stations to non-NULL.

> Again, this
> is iwl3945 only after a suspend of a few minutes followed by a resume.
> It happens about 1/3 of the time.

Ok, I have a new suspicion: there seems to be a race condition between
destroying a station (sta_info_destroy) which removes it from debugfs,
and creating a new one with the same MAC address which will ask the
workqueue to add it to debugfs. It clearly is actually possible to run
sta_info_insert(sta2) and consequently sta_info_debugfs_add_work before
sta_info_destroy(sta1), but when they both have the same MAC address
then ieee80211_sta_debugfs_add has to fail.

I don't see much we can do against this, the patch I posted is
definitely needed just in case debugfs gets a new failure mode any time
in the future so I'll post it for inclusion, and the race condition I
described just means that the sta2 won't be in debugfs at all...

johannes

--=-9177DH7NkmFT7KnQD0v2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6oycAAoJEKVg1VMiehFY3eAP/3fvB9M935zg05gWPcnRy246
NBINzNTypE6aUN8bXb/xRBnAamUshb9lGk815B+Pvupu5b4rLV3/hz8p1yPZ3TL/
K/99WQUjKF/DkrdPk7THSEESeKbBbtxZvimmJ3cvwxZ/sJtmhs/Q6ItNIHSZPjWh
RHp7iO4rWISbTeEqNLF0nWn/wR3/FkTUfPDKToo3myF1EtQZNU91aJ1RvlnzBR/G
oft7XWhfPe/KycJJiw4ocS/fJpUJpB61Jl3Y6b45ra4kL+MkNswSKxcY3TldMCLk
tdrvVff9iiawXlp1ZTraEc/FaceexQMscSh9iSoHYOsTPZ2/iPtHDz6JRmE5p2tI
PQY7f/6sHLy2A6YPZhYDsCey3jBKVuTPuodOKg3Vv4m8T1S/ZqsPPdukFeTcDDfB
5y0rM7kX29S0UKyeMllVLPxosvcLnXemtwFvGbw8CbbmLJmTiWCwux1tqSgTVA/c
qey5FlcnU4iDfzKeNG7ingVOv8nT6eFcG/hMREgRolVQpbHyT36E/nUqVV5FSPjM
1esFHwo1Gv9BAfD/xt6RVQ8mFDsa9gsuFZZ4X9MXjIGLtmzroAOvKPLR89tY2JBc
5Z30M+n4JA60iSlkzFMlG953qHppMZXi5ch6t5YO+pSqrWvV/cRMIsMUp8K08WFn
kv/Mv+3xzt6o0C6p/v2k
=kpgW
-----END PGP SIGNATURE-----

--=-9177DH7NkmFT7KnQD0v2--

