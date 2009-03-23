Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59229 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbZCWRJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 13:09:36 -0400
Received: by fxm2 with SMTP id 2so1896486fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 10:09:32 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] Marvell CF8381 and CF8305
Date: Mon, 23 Mar 2009 18:09:42 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231700.21627.marek.vasut@gmail.com> <200903231706.16489.hs4233@mail.mn-solutions.de>
In-Reply-To: <200903231706.16489.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903231809.42587.marek.vasut@gmail.com> (sfid-20090323_180938_980331_5CD658DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 of March 2009 17:06:16 Holger Schurig wrote:
> > +#define CF8305_MANFID		0x02db
> > +#define CF8305_CARDID		0x8103
>
> It's 8385, not 8305.
it's 8305 ... that's even older card ;)
>
> >  	/* Check if we have a current silicon */
> > -	if (if_cs_read8(card, IF_CS_PRODUCT_ID) <
> > IF_CS_CF8385_B1_REV) { -		lbs_pr_err("old chips like 8385 rev
> > B1 aren't supported\n"); +	prod_id = if_cs_read8(card,
> > IF_CS_PRODUCT_ID);
> > +	if (!(if_cs_hw_is_cf8305(p_dev) ||
> > +		(if_cs_hw_is_cf8381(p_dev) &&
> > +		prod_id >= IF_CS_CF8381_B3_REV)) &&
> > +		(prod_id < IF_CS_CF8385_B1_REV)) {
> > +		lbs_pr_err("old chips like 8385 rev B1 or "
> > +			"8381 rev B3 aren't supported\n");
>
> I still find this if hard to read. Why not something like this:
>
> if ((if_cs_is_8385() && prod_id < IF_CS_CF8385_B1_REV) ||
>     (if_cs_Is_8381() && prod_id < IF_CS_CF8381_B3_REV)) {
>       ....
> }
>
> >  static struct pcmcia_device_id if_cs_ids[] = {
> > +	PCMCIA_DEVICE_MANF_CARD(CF8305_MANFID, CF8305_CARDID),
> > +	PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
> >  	PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
> >  	PCMCIA_DEVICE_NULL,
> >  };
>
> Now we end with two entries of 0x02df, 0x8103 :-/


