Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63829 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaKBWir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2014 17:38:47 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so10984564pab.18
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2014 14:38:46 -0800 (PST)
Message-ID: <1414967919.19819.1.camel@penski.harmic.moo.org> (sfid-20141102_233851_248376_F0A2BFBC)
Subject: Re: [PATCH 1/1] wireless-regdb: Update rules for Australia (AU) to
 align with class licence
From: Michael Harris <harmic@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Mon, 03 Nov 2014 09:38:39 +1100
In-Reply-To: <20141027173141.GB28300@tuxdriver.com>
References: <1413111411-29509-1-git-send-email-harmic@gmail.com>
	 <20141027173141.GB28300@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

My apologies if you get this twice. My first attempt was foiled by GMail
which promised to send it as plain text but then went ahead and included
some HTML content anyway!

On Mon, 2014-10-27 at 13:31 -0400, John W. Linville wrote:
> I'm always a bit cautious about merging regdb patches that loosen
> the rules.  Would anyone with more expertise on such regulations care
> to comment on this one?
> 
> 

Is there any more information I can provide to help you to accept this
patch?

My patch references the class license schedule items which apply to each
frequency range. 

It would probably help if someone else were to cross check my patch
against the class licence.

The links I provided originally are the best source - they are the
actual regulations that apply in Australia, enforced by ACMA, the
government body that plans and regulates spectrum here.

Here are a few less official but possibly more easily readable
resources:

http://www.radio-active.net.au/web3/80211/Regulations/Australian

http://nuke.freenet-antennas.com.au/modules.php?name=News&file=article&sid=33

http://www.qdg.org.au/qdgwire.htm

> On Sun, Oct 12, 2014 at 09:56:51PM +1100, Michael Harris wrote:
> > I am not sure where the existing regdb rules for Australia were derived from
> > (perhaps some default template?) but they are a lot more restrictive than the
> > actual class licence requirements.
> > 
> > I have updated to the best of my ability according to the "Radiocommunications
> > (Low Interference Potential Devices) Class Licence 2000" which can be found here:
> > 
> > http://www.acma.gov.au/Industry/Spectrum/Radiocomms-licensing/Class-licences/class-licences
> > 
> > There is also a useful FAQ for 2.4GHz WLANs here:
> > http://www.acma.gov.au/Citizen/Consumer-info/My-connected-home/Wireless-local-area-networks/wireless-lans-in-the-24-ghz-band-faqs
> > 
> > Signed-off-by: Michael Harris <harmic@gmail.com>
> > ---
> >  db.txt | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/db.txt b/db.txt
> > index f0e4312..94c7010 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -78,12 +78,22 @@ country AT: DFS-ETSI
> >  	# 60 gHz band channels 1-4, ref: Etsi En 302 567
> >  	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
> >  
> > +# Reference: Radiocommunications (Low Interference Potential Devices) Class Licence 2000
> > +# http://www.acma.gov.au/Industry/Spectrum/Radiocomms-licensing/Class-licences/class-licences
> >  country AU:
> > -	(2402 - 2482 @ 40), (20)
> > -	(5170 - 5250 @ 80), (17)
> > -	(5250 - 5330 @ 80), (24), DFS
> > -	(5490 - 5710 @ 80), (24), DFS
> > -	(5735 - 5835 @ 80), (30)
> > +	# Item 45A
> > +	(2400 - 2483 @ 40), (36)
> > +	# Item 44
> > +	(5150 - 5250 @ 80), (23), NO-OUTDOOR
> > +	# Item 44A (assuminging no TPC implemented).
> > +	# If TPC implemented then 23dBm allowed.
> > +	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS
> > +	# Item 46 (assuming no TPC implemented)
> > +	# If TPC implemented then 30dBm allowed
> > +	(5470 - 5600 @ 80), (27), DFS
> > +	(5650 - 5725 @ 40), (27), DFS
> > +	# Item 45B
> > +	(5725 - 5850 @ 80), (36)
> >  
> >  country AW: DFS-ETSI
> >  	(2402 - 2482 @ 40), (20)
> > -- 
> > 1.8.3.1
> > 
> > 
> 

Regards // Mike
harmic@gmail.com


