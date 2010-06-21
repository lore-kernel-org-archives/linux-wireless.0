Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25611 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab0FUOvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 10:51:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 07:51:54 -0700
From: Michael Green <Michael.Green@Atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@Atheros.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Date: Mon, 21 Jun 2010 07:51:56 -0700
Subject: wireless-regdb: Add A band in IL - And general point regarding tx
 power limits in the dbase
Message-ID: <93781E992CBA7843962D8B0E7D683F3C1172BD0B6D@SC1EXMB-MBCL.global.atheros.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<20100618184257.GB6282@tuxdriver.com>
 <AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
In-Reply-To: <AANLkTimN8oZ63m7cp2lE5MuFiEJ8iAGKswKIENTjIhMg@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are my comments on the proposed patch...

country IL:
> >       (2402 - 2482 @ 40), (N/A, 20)
> > +     (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> > +     (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS


a) I agree with channels above and enabling HT40 per above.

b) I think all entries in the dbase should be in dBm (not mW).   dBm vs. mW are absolutely equivalent. No reason to retain "mW" unit from the source docs.  I think this was agreed by all before, but wanted to reiterate. 

c) I don't understand why "Indoor/Outdoor" is stated in the table for any/all countries.   5150-5250 is globally allocated for indoor use.  So I am not reviewing/commenting on the indoor/outdoor comments in the dbase.


d) Reminder...Israel and most other countries state max tx power limit in 'EIRP' (ie takes into account actual antenna gain of the end device).  Therefore, the entire dbase must be clearly flagged so developers know the tx power limits in this dbase only apply when devices have 0dB (or negative) gain antennas.  

In other words, the software (or the hw/sw developer) must somehow reduce tx powers below the values in the dbase, dB-for-dB, when antenna+cable has positive gain.

The exception is FCC target power, where FCC (and the dBase) quotes "conducted power" rather than EIRP.

Issue d) is not a concern for manufacturers/developers who produce products that limit regulatory tx powers in the hw (factory set/limited). In that case they take into account actual antenna gains during original conformance testing and program in compliant tx powers into hw (and don't rely at all on the tx powers in the dbase).

But developers who don't have tx powers limited in hw, who actually use the tx power in the dbase, must take into account antenna gain as explained above, else the product may not comply with tx limits for most countries.  

Fine if you want to discuss point d) separately since it's a global issue (not limited to this particular IL patch).

tks,

Michael Green
Atheros Communications, Inc.
mgreen@atheros.com
Desk:   +1-781-400-1491
Mobile: +1-508-380-4921


-----Original Message-----
From: Emmanuel Grumbach [mailto:egrumbach@gmail.com] 
Sent: Sunday, June 20, 2010 1:41 AM
To: John W. Linville
Cc: Emmanuel Grumbach; linux-wireless@vger.kernel.org; Michael Green; David Quan
Subject: Re: [RFC] wireless-regdb: Add A band in IL

Emmanuel Grumbach
egrumbach@gmail.com


On Fri, Jun 18, 2010 at 21:42, John W. Linville <linville@tuxdriver.com> wrote:
>
> On Wed, May 26, 2010 at 09:49:29AM +0300, Emmanuel Grumbach wrote:
> > A band in allowed in IL, according to official document issued by the Ministry
> > of Communications: http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf.
> >
> > 5150 - 5250 200mW e.i.r.p. OUTDOOR forbidden
> > 5250 - 5350 200mW e.i.r.p. OUTDOOR forbidden DFS mandatory
> >
> > 40Mhz is allowed in A band for every WiFi-Alliance certified equipment.
> >
> > ***************************************************************
> > Not to be merged for the moment
> > ***************************************************************
> >
> > CC: Michael Green <Michael.Green@atheros.com>
> > CC: David Quan <David.Quan@atheros.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > ---
> >  db.txt |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/db.txt b/db.txt
> > index e63a43e..d49c397 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -319,6 +319,8 @@ country IE:
> >
> >  country IL:
> >       (2402 - 2482 @ 40), (N/A, 20)
> > +     (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> > +     (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
> >
> >  country IN:
> >       (2402 - 2482 @ 40), (N/A, 20)
>
> Is this issue now settled?

Yes, I think that Michael Green agreed for this patch. Once he will
reply to make sure, we will be able to move on to a real patch.
