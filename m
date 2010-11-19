Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30515 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab0KSPOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 10:14:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 07:14:17 -0800
From: Michael Green <Michael.Green@Atheros.com>
To: Kurt Garloff <garloff@suse.de>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 19 Nov 2010 07:14:28 -0800
Subject: RE: [PATCH] wireless-regdb: update rules for DE
Message-ID: <93781E992CBA7843962D8B0E7D683F3C16334843DD@SC1EXMB-MBCL.global.atheros.com>
References: <20100525151429.GC6342@tpkurt2.garloff.de>
 <1290029817-711-1-git-send-email-linville@tuxdriver.com>
 <AANLkTimDkoqNbkFWDsU2HgFK3926gRpcBbokX_GL5sSc@mail.gmail.com>
 <93781E992CBA7843962D8B0E7D683F3C163340D5AE@SC1EXMB-MBCL.global.atheros.com>
 <20101119020414.GB2512@tuxdriver.com>
 <20101119091450.GD12228@tpkurt2.nue.garloff.de>
In-Reply-To: <20101119091450.GD12228@tpkurt2.nue.garloff.de>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is the issue that the regdb currently limits DK to 2.4GHz operation (5GHz is disabled)?

If I understand this email string, then clearly DK should be corrected to enable 5GHz operation.

I believe DK should be set to the same 5GHz channel and power settings per the Harmonized standard EN301 893. This is true of all countries that accept CE Marking.

If this patch/issue is about something else, then please let me know.

tks,

Michael Green
Atheros Communications, Inc.
mgreen@atheros.com
Desk:   +1-781-400-1491
Mobile: +1-508-380-4921

-----Original Message-----
From: Kurt Garloff [mailto:garloff@suse.de] 
Sent: Friday, November 19, 2010 4:15 AM
To: John W. Linville
Cc: Michael Green; Luis R. Rodriguez; wireless-regdb@lists.infradead.org; Johannes Berg; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: update rules for DE

John,

enjoy your birthday!

Michael,

enjoy vacation!

I submitted this change 6 months ago.
I was surprised that my ath9k device would not do anything in the 5GHz band unlike all neighour countries, found out that this is due to the regulatory DB and started studying the regulations to see whether it's justified.

A few days certainly don't make a difference here. Review carefully when you can get to it next week.

Best,
--
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.
SUSE: Supporting Linux since 1992.

On Thu, Nov 18, 2010 at 09:04:14PM -0500, John W. Linville wrote:
> FWIW, I'm out on Friday anyway -- it's my birthday! :-)
> 
> On Thu, Nov 18, 2010 at 01:23:42PM -0800, Michael Green wrote:
> > Hi guys,
> > 
> > I am on PTO until Monday. Do I need to read this now and respond or can it wait?  I am not asking you to hold anything up due to me. But if you want me to give feedback on something, pls let me know if it can wait until Mon.
> > 
> > Michael Green
> > Atheros Communications, Inc.
> > mgreen@atheros.com
> > Desk:   +1-781-400-1491
> > Mobile: +1-508-380-4921
> > -----Original Message-----
> > From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> > Sent: Thursday, November 18, 2010 1:29 PM
> > To: John W. Linville; Michael Green
> > Cc: wireless-regdb@lists.infradead.org; Johannes Berg; Kurt Garloff; 
> > linux-wireless@vger.kernel.org
> > Subject: Re: [PATCH] wireless-regdb: update rules for DE
> > 
> > On Wed, Nov 17, 2010 at 1:36 PM, John W. Linville 
> > <linville@tuxdriver.com> wrote:
> > > From: Kurt Garloff <garloff@suse.de>
> > >
> > > http://marc.info/?l=linux-wireless&m=127480075306482&w=2
> > >
> > > Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
> > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > ---
> > > Time to clear the logjam...
> > 
> > Michael, are you subscribed to wireless-regdb now? Did you get this e-mail? ACK?
> > 
> >   Luis
> > 
> > >  db.txt |   24 +++++++++++++++++-------
> > >  1 files changed, 17 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/db.txt b/db.txt
> > > index e63a43e..40a8bbc 100644
> > > --- a/db.txt
> > > +++ b/db.txt
> > > @@ -176,17 +176,27 @@ country CZ:
> > >        (5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> > >        (5470 - 5725 @ 40), (N/A, 1000 mW), DFS
> > >
> > > -# Data from "Frequenznutzungsplan" (as published in April 2008), 
> > > -# downloaded from 
> > > http://www.bundesnetzagentur.de/media/archive/13358.pdf
> > > -# Also applicable is 
> > > http://www.bundesnetzagentur.de/media/archive/5009.pdf
> > > -# On the 5 GHz ranges TX power can be doubled if TPC is implemented.
> > > +# Data from "Frequenznutzungsplan" (as published in April 2008), 
> > > +downloaded from # 
> > > +http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/pub
> > > +licationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
> > > +# For the 5GHz range also see
> > > +# 
> > > +http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/pub
> > > +licationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
> > > +# The values have been reduced by a factor of 2 (3db) for non TPC 
> > > +devices # (in other words: devices with TPC can use twice the tx power of this table).
> > > +# Note that the docs do not require TPC for 5150--5250; the 
> > > +reduction to # 100mW thus is not strictly required -- however the 
> > > +conservative 100mW # limit is used here as the non-interference 
> > > +with radar and satellite # apps relies on the attenuation by the 
> > > +building walls only in the # absence of DFS; the neighbour countries have 100mW limit here as well.
> > > +
> > >  country DE:
> > >        # entries 279004 and 280006
> > >        (2400 - 2483.5 @ 40), (N/A, 100 mW)
> > > -       # entries 303005, 304002 and 305002
> > > -       (5150 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> > > +       # entry 303005
> > > +       (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> > > +       # entries 304002 and 305002
> > > +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> > >        # entries 308002, 309001 and 310003
> > > -       (5470 - 5725 @ 40), (N/A, 500 mW), NO-OUTDOOR, DFS
> > > +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS
> > >
> > >  country DK:
> > >        (2402 - 2482 @ 40), (N/A, 20)
> > > --
> > > 1.7.3.2
> > >
> > >
> 
> --
> John W. Linville                Someday the world will need a hero, 
> and you linville@tuxdriver.com                  might be all we have.  Be ready.
> 


