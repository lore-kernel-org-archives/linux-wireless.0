Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25507 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755910AbXD0Pgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:36:38 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Date: Fri, 27 Apr 2007 11:32:15 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704262023.52833.flamingice@sourmilk.net> <46317888.9040909@linux.intel.com>
In-Reply-To: <46317888.9040909@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5356628.tuBiNt8dzm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704271132.22346.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5356628.tuBiNt8dzm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 27 April 2007 00:14, James Ketrenos wrote:
> If done right, the stack would set up the list of channels to scan, wheth=
er
> to scan the channel active or passive, and the template for the probe
> request to use.
>
> For sw based scans, the stack would then have a mechanism for executing
> that scan through a series of tunes, transmits, etc.  For hw scans, it
> would pass that structure to the driver which would package it for the
> hardware and pass it down.
>
> Upon completion of the scan (sw or hw) the notification would come back to
> the stack to let it know scanning is complete.
>
Yes, this addresses many of the deficiencies in the current hw_scan api, bu=
t=20
that wasn't what I was concerned about.

> > What's the big bottleneck that justifies moving this to
> > hardware?
>
> With the 3945 its mainly power consumption.
>
Ok. Since you did not provide any numbers to back up that assertion, let's =
try=20
to find the upper bound for the cost of using software scanning.

With NetworkManager, userspace requests a scan about every 2 minutes when=20
connected. Assume that each scan takes 3 seconds. Assume that things are=20
ridiculously inefficient and software scanning keeps the cpu on for an=20
additional 20% of the scanning time. This keeps the CPU on unnecessarily fo=
r=20
18 seconds every hour, assuming nothing else is running. With an additional=
=20
assumption that all the additional CPU time that goes into software scan=20
directly subtracts from the battery life, this results in a loss of about 2=
=20
minutes and a half of battery life.. for a laptop that can last 8 hours.

An upper bound of 18 seconds of battery life lost per hour sounds okay to m=
e=20
especially when it assumes the user is just letting the laptop idle. In=20
practice, I think that the difference is going to be negligible.. but what =
I=20
think is going to happen and my guess at the upper bound doesn't matter muc=
h.=20
If you can provide numbers, this discussion becomes significantly more=20
productive.

=2DMichael Wu

--nextPart5356628.tuBiNt8dzm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMheGT3Oqt9AH4aERAk4/AJ0bKHrb70sbKD7By5RueE0d6c25owCeMM8f
Il5wv0wAl9/ltLM19vQMuhE=
=08+J
-----END PGP SIGNATURE-----

--nextPart5356628.tuBiNt8dzm--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
