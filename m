Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:45172 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993114AbXDYUi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 16:38:29 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Date: Wed, 25 Apr 2007 16:34:11 -0400
Cc: James Ketrenos <jketreno@linux.intel.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <462EE107.8040005@linux.intel.com> <20070425181656.GD5875@tuxdriver.com>
In-Reply-To: <20070425181656.GD5875@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12269472.om1oCSC6yl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704251634.16604.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart12269472.om1oCSC6yl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 25 April 2007 14:16, John W. Linville wrote:
> On Tue, Apr 24, 2007 at 10:03:03PM -0700, James Ketrenos wrote:
> > (I would like to see hw_scan remain since iwlwifi uses it -- which we
> > hope to submit as soon as the code restructuring is complete)
>
> I was going to mention this in response to Michael's patch, but then
> I checked your current iwlwifi git tree.  There your hw_scan routine
> is commented-out, so I figured you didn't want/need it anymore...?
>
It was never needed in the first place except as an iwlwifi specific hack t=
o=20
minimize any disruption to the current connection. (which often seems to be=
=20
commented out due to firmware issues) mac80211 now does its own PS mode=20
scanning trick along with some frame queuing as a generic means to minimize=
=20
disruptions to the current connection during scans. It still needs some=20
improvements in order to quickly empty the current hardware TX queue before=
=20
commencing a scan and possibly time/segment the scanning such that beacons=
=20
are not lost, but it can certainly be done.

Besides the fact that what hw_scan does can be done by mac80211 for all=20
drivers, the use of the hw_scan callback breaks the AP autoconfiguration co=
de=20
in ieee80211_sta.c due to its inadequate design. Calling hw_scan starts a=20
hardware scan, but there is no way to know when the scan is completed. This=
=20
means the code has no way of knowing when it should look through its scan=20
results and configure itself to connect to an AP if a scan was started by=20
mac80211 for the purpose of finding an AP to connect to.

Even if that problem were addressed, I still wouldn't like it as the design=
 of=20
the hw_scan callback is deficient in a number of other ways and is complete=
ly=20
inapplicable to all other hardware/firmware softmac designs that I know.

=2DMichael Wu

--nextPart12269472.om1oCSC6yl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGL7tIT3Oqt9AH4aERAp0xAJ9LzKgtEW9pdjsn99KPUc9GEhGluwCgxtTV
IcUw/NslV4VIKUckBPkypzM=
=IIcM
-----END PGP SIGNATURE-----

--nextPart12269472.om1oCSC6yl--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
