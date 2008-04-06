Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11133 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYDFFMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 01:12:53 -0400
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de, Dan Williams <dcbw@redhat.com>
In-Reply-To: <1207386546.3860.5.camel@johannes.berg>
References: <200804041612.18840.mb@bu3sch.de>  <1207364787.2115.16.camel@dv>
	 (sfid-20080405_040635_154207_9EE40F90)  <1207386546.3860.5.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Apr 2008 01:12:50 -0400
Message-Id: <1207458770.7146.44.camel@dv> (sfid-20080406_061319_554146_C7B59008)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-04-05 at 11:09 +0200, Johannes Berg wrote:
> > Another unrelated bug (sorry, testing often finds unrelated bugs) i=
s
> > that scanning with specific ESSID was returning non-matching APs.  =
I
> > mean "iwlist wlan0 scan my_essid", which would still report many
> > different ESSIDs.  It's inconvenient when the driver can sense 22 A=
Ps at
> > once :)
>=20
> Heh. I'm not sure what the desired behaviour is, if you do that scan
> we'll give you everything we found but will scan actively for that
> particular SSID. The man page (sigh) only says:
>=20
> =EF=BB=BF              This command take optional arguments, however =
most drivers  will
>               ignore  those.  The  option essid is used to specify a =
scan on a
>               specific ESSID. The option last do not trigger a scan  =
and  read
>               left-over scan results.
>=20
> Which isn't quite clear, but seems to match what we do. Maybe iwlist
> should filter it?

I tried scanning for ESSID that no AP has.  Most time I only get
response from one AP, which is an old Linksys BEFW11S4 v4 (802.11b
only).  Sometimes one or two other APs appear.  But it some cases, all
22 or 23 APs in range appear in the list.

The easiest way to reproduce it is to scan without ESSID and then with
ESSID.  Then the second scan will return all APs found in the first
scan.  But run the scan with the ESSID several times, and at some point
the list goes down to that dumb Linksys.

I'm fine with scanning without filtering.  It's more important that we
let users control what probe requests are being sent.  But I think we
should be consistent and avoid returning results of scans with differen=
t
parameters.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
