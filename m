Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39462 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3BORTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 12:19:46 -0500
Date: Fri, 15 Feb 2013 18:19:38 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	antonio@open-mesh.com, marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130215171938.GA4140@pandem0nium> (sfid-20130215_181951_923317_BC05CF75)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello wireless folks,

Mathias Kretschmer and me would like to bring another new feature to the kernel:
Collecting information for (non-peer) stations. As far as I know, at least
Antonio and Thomas are interested in a similar feature as well, and it seems
Antonio has already prepared some code. I'd like to present our ideas and
requirements to this feature and would like to ask Antonio and Thomas, and everyone
else interested in this feature, to do the same. Then we can hopefully come up
with a design which is acceptable for upstream kernels and useful for everyone.

We would like to gather statistics for all peers, both connected and not connected
to our current IBSS. We do the same in userspace currently using a monitor interface,
but reading every packet from this monitor interface has a huge thoughput limitation
on our routers, and is therefore not acceptable for productive use. The statistics are
then used to evaluate link quality and make some higher level decisions.

The statistics we are interested in are, per station (identified by sender MAC address), for
both peer and non-peer stations:
 * RSSI (*)
 * sequence number gap size (*) - monitors the sequence number of a 80211 packet, per queue
 * bad frame count (badFCS and such)
 * total frame count
 * bytes received
 * last seen - timestamp

Fields marked with (*) should capture min, max, avg, count, sum, sum_square. Other
statistics (stddev, rms) can then be calculated in userspace using floating point numbers.
The other fields can be normal counters. Some of the fields are already accesible for connected
peers (like RSSI, last seen -> iw station dump), some of them are new, and none of them are currently
available for non-peer stations. We probably don't need all of them integrated
in mainline as they might be only interesting for us, but this is just to give you an idea.

Regarding the kernel interface, we don't have any requirements, from nl80211 to debugfs, everything
would be fine. We will access the data with a custom program.

Commands we would like to propose are:
 * start collecting - this feature should not run by default to avoid bloating memory for users who
   don't even need this
 * stop collecting
 * read - dumps the data for all stations
 * read + reset - dump the data and reset information for all stations. This should also clean up stations,
   at least those which are not connected to the BSS, to not bloat the station table.

I guess the right position to implement this is mac80211 receive path. Our intended platform
is ath9k/ath5k, but that feature should work with any mac80211 driver. We don't care if sta_info
structs are allocated or custom structures are used, as long as we can receive a list of stations
which includes peer and non-peer stations, along with their statistics.

We are looking forward to your thoughts. :)

Cheers,
        Simon

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEebioACgkQrzg/fFk7axZBvgCgxL3hYK/DFrQntsan24MxF2XR
OQMAnRQfufMTKmlZvgsLDP99YihP35cw
=mouK
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
