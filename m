Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:40201 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYHCJnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 05:43:47 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2042585ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 02:43:46 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Date: Sun, 3 Aug 2008 12:07:08 +0200
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <200808031007.48877.IvDoorn@gmail.com> <1217753845.4721.1.camel@johannes.berg>
In-Reply-To: <1217753845.4721.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808031207.08446.IvDoorn@gmail.com> (sfid-20080803_114403_032767_9AFED691)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 03 August 2008, Johannes Berg wrote:
> On Sun, 2008-08-03 at 10:07 +0200, Ivo van Doorn wrote:
> 
> > > diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> > > index ea872e5..d5f95cb 100644
> > > --- a/net/rfkill/rfkill.c
> > > +++ b/net/rfkill/rfkill.c
> > > @@ -76,6 +76,7 @@ static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
> > >   */
> > >  int register_rfkill_notifier(struct notifier_block *nb)
> > >  {
> > > +	BUG_ON(!nb);
> > 
> > Probably better:
> > 
> > 	if (unlikely(!nb) {
> > 		BUG()
> > 		return -EINVAL;
> > 	}
> 
> Heh, not really, in fact, it will most likely not even compile to any
> different code. Did you mean
> 
> if (WARN_ON(!nb))
> 	return -EINVAL;
> 
> maybe?
> 
> BUG() never returns. Same for all the other places you pointed out.

Ah right, that doesn't sound too good. I don't think rfkill should
become a blocker like that. WARN_ON should be sufficient. :)

Ivo
