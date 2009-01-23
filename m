Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35208 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZAWT5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:57:15 -0500
Subject: Re: [PATCH] libertas: fix CF firmware loading for some cards
From: Dan Williams <dcbw@redhat.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Cyril HAENEL <chaenel@free.fr>,
	libertas-dev@lists.infradead.org
In-Reply-To: <497AD344.5080900@bluewatersys.com>
References: <1232729733.2577.13.camel@localhost.localdomain>
	 <497AD344.5080900@bluewatersys.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:54:22 -0500
Message-Id: <1232740462.2577.48.camel@localhost.localdomain> (sfid-20090123_205720_102258_0D103D15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-24 at 21:37 +1300, Ryan Mallon wrote:
> Dan Williams wrote:
> > if_cs_poll_while_fw_download() returned the number of iterations
> > remaining on success, which in turn got returned as the value from
> > if_cs_prog_real() and if_cs_prog_helper().  But since if_cs_probe()
> > interprets non-zero return values from firmware load functions as an
> > error, this sometimes caused spurious firmware load failures.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> > ---
> > 
> > diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
> > index 842a08d..8f8934a 100644
> > --- a/drivers/net/wireless/libertas/if_cs.c
> > +++ b/drivers/net/wireless/libertas/if_cs.c
> > @@ -151,7 +151,7 @@ static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint addr, u8 r
> >  	for (i = 0; i < 100000; i++) {
> >  		u8 val = if_cs_read8(card, addr);
> >  		if (val == reg)
> > -			return i;
> > +			return 0;
> >  		udelay(5);
> >  	}
> >  	return -ETIME;
> > 
> > 
> 
> Hmmm, I posted this same patch here a couple of months ago
> (http://lists.infradead.org/pipermail/libertas-dev/2008-October/002019.html),
> did I get something wrong in the submission process, or did it just get
> lost in the woodwork? Anyway:

Apparently I didn't read enough down that thread to find the second
patch; I only found the one that changed if_cs_prog_helper() and
if_cs_prog_real().  My mistake, this patch is yours.

John; when you apply, please credit Ryan.

Dan


