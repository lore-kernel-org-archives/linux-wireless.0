Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbZCWRWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 13:22:13 -0400
Subject: Re: [PATCH] Marvell CF8381 and CF8305
From: Dan Williams <dcbw@redhat.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200903231809.42587.marek.vasut@gmail.com>
References: <200903220127.21836.marek.vasut@gmail.com>
	 <200903231700.21627.marek.vasut@gmail.com>
	 <200903231706.16489.hs4233@mail.mn-solutions.de>
	 <200903231809.42587.marek.vasut@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 13:19:55 -0400
Message-Id: <1237828795.14758.51.camel@localhost.localdomain> (sfid-20090323_182216_288897_C44E782A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-23 at 18:09 +0100, Marek Vasut wrote:
> On Monday 23 of March 2009 17:06:16 Holger Schurig wrote:
> > > +#define CF8305_MANFID		0x02db
> > > +#define CF8305_CARDID		0x8103
> >
> > It's 8385, not 8305.
> it's 8305 ... that's even older card ;)

v4 firmware or v5?

Dan

> >
> > >  	/* Check if we have a current silicon */
> > > -	if (if_cs_read8(card, IF_CS_PRODUCT_ID) <
> > > IF_CS_CF8385_B1_REV) { -		lbs_pr_err("old chips like 8385 rev
> > > B1 aren't supported\n"); +	prod_id = if_cs_read8(card,
> > > IF_CS_PRODUCT_ID);
> > > +	if (!(if_cs_hw_is_cf8305(p_dev) ||
> > > +		(if_cs_hw_is_cf8381(p_dev) &&
> > > +		prod_id >= IF_CS_CF8381_B3_REV)) &&
> > > +		(prod_id < IF_CS_CF8385_B1_REV)) {
> > > +		lbs_pr_err("old chips like 8385 rev B1 or "
> > > +			"8381 rev B3 aren't supported\n");
> >
> > I still find this if hard to read. Why not something like this:
> >
> > if ((if_cs_is_8385() && prod_id < IF_CS_CF8385_B1_REV) ||
> >     (if_cs_Is_8381() && prod_id < IF_CS_CF8381_B3_REV)) {
> >       ....
> > }
> >
> > >  static struct pcmcia_device_id if_cs_ids[] = {
> > > +	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
> > > +	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
> > >  	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
> > >  	PCMCIA_DEVICE_NULL,
> > >  };
> >
> > Now we end with two entries of 0x02df, 0x8103 :-/
> 
> 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev

