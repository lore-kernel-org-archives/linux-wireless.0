Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:62826 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYGWRzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:55:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so924760nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 10:54:59 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: detect bogus double-registering
Date: Wed, 23 Jul 2008 20:12:13 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216830607.13587.20.camel@johannes.berg> <20080723174129.GB11009@khazad-dum.debian.net>
In-Reply-To: <20080723174129.GB11009@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807232012.13985.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 23 Jul 2008, Johannes Berg wrote:
> > On Wed, 2008-07-23 at 12:27 -0300, Henrique de Moraes Holschuh wrote:
> > > On Wed, 23 Jul 2008, Johannes Berg wrote:
> > > > > +	list_for_each_entry(p, &rfkill_list, node) {
> > > > > +		if (p == rfkill)
> > > > > +			return -EEXIST;
> > > > > +		set_bit(p->type, &seen);
> > > > 
> > > > You should WARN_ON so it can get fixed.
> > > 
> > > I'd rather make rfkill_register __must_check, actually.  With or without
> > > WARN_ON.
> > > 
> > > In fact, lots of stuff in rfkill should be __must_check.  Ivo, what do you
> > > think?  Add __must_check?  Add WARN_ON?  Add both?
> > 
> > Do both then. __must_check annotations get ignored regularly, or
> > "handled" like this:
> > 
> > if (...)
> > 	// nothing we can do.
> 
> Ah, that gives you heavy spiked LART rights to the head of whomever does it
> if he is wrong about it.  You should fail to load the module or something
> like that if you are going to run half-broken without rfkill support.
> 
> I will add the WARN_ON.  __must_check will wait for Ivo's reply, as you
> said, it is often ignored.

I usually dislike WARN_ON, but like Johannes said, this one is a bug in the driver
which must be fixed. When you submit the final version of the patch having
the WARN_ON would be best.

I am however a fan on sparse annotation and using __must_check, but since you
already stated that more functions might need it, it doesn't have to be in this patch
and could wait for a later patch. (But it is fine if you want to add it in this patch as well,
off course. ;) )

Ivo
