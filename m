Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42084 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3BGJ1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 04:27:32 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <robertbasic.com@gmail.com>
Subject: Re: [PATCH v2] wireless-regdb: add regulatory rule for ETSI members on 60gHz band
Date: Thu, 7 Feb 2013 11:27:28 +0200
Message-ID: <4125342.NcrOy0nJDp@lx-vladimir> (sfid-20130207_102737_575250_C3760C06)
In-Reply-To: <20130206183940.GG2148@tuxdriver.com>
References: <8774585.BvFN3Opv12@lx-vladimir> <2028055.RB8DPWJWyd@lx-vladimir> <20130206183940.GG2148@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, February 06, 2013 01:39:41 PM John W. Linville wrote:
> On Mon, Dec 10, 2012 at 05:48:24PM +0200, Vladimir Kondratiev wrote:
> > 
> > For the 60GHz band, regulation defined in the "Etsi En 302 567"
> > http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html
> > 
> > It defines for the frequency range 57 GHz to 66 GHz,
> > Max. power level (EIRP) for
> > indoor only: 40 dBm, and indoor/outdoor: 25 dBm
> > Also, there is spectral power density limit
> > 13 dBm/MHz for indoor and -2 dBm/MHz indoor/outdoor
> > 
> > Only indoor part specified, as kernel can't use multiple
> > rules per frequency at the moment. Also, standard do not set bandwidth limitation;
> > for purpose of 802.11ad this patch specifies bandwidth 2160 MHz,
> > in this case gross EIRP limit applies. Frequency limits also set accordingly
> > to the 802.11ad channel allocation.
> > 
> > This patch apply this to the full ETSI member countries:
> > 
> > The EU member states:
> > Austria, Belgium, Bulgaria, Cyprus, Czech Republic, Denmark,
> > Estonia, Finland, France, Germany, Greece, Hungary, Ireland,
> > Italy, Latvia, Lithuania, Luxembourg, Malta, Netherlands,
> > Poland, Portugal, Romania, Slovakia, Slovenia, Spain, Sweden,
> > United Kingdom
> > 
> > plus:
> > Andorra, Iceland, Norway, Switzerland, Croatia,
> > Bosnia and Herzegovina, Serbia, Macedonia,
> > Ukraine, Turkey, Georgia
> > 
<snip>
> > +
> > +country RS:
> > +        # 60 gHz band channels 1-4, ref: Etsi En 302 567
> > +        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> >  
> >  country RU:
> >  	(2402 - 2482 @ 40), (N/A, 20)
> 
> Is this really the correct rule for RS (Serbia)?  Only 60 GHz is allowed there?

Sure it is not! Problem is, entry for Serbia was not exist in original db.txt

I added 60G data as per regulatory document; but then missed data
for 2.4/5 bands leads to this problem...

By the way, same problem is for AD (Andorra)

Correct solution would be, as you mentioned below, to add data for Serbia.
I'm not sure what is correct rule set.
Most of ETSI countries (but not all!) have rule set like this:

country AT: DFS-ETSI
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 40), (N/A, 20)
	(5250 - 5330 @ 40), (N/A, 20), DFS
	(5490 - 5710 @ 40), (N/A, 27), DFS
        # 60 gHz band channels 1-4, ref: Etsi En 302 567
        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR

I am not sure we can apply this for Andorra and Serbia since I see exceptions -
some ETSI countries have different rules. See BG, CZ, DE, GE, NL, TR, UA.

> 
> The bug reporter here seems to disagree...
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=908267
> 
> What should the rules really be for Serbia?
> 
> John
> 
