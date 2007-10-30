Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:41983 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbXJ3Prv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 11:47:51 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1913880rvb
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 08:47:50 -0700 (PDT)
Message-ID: <43e72e890710300847l25208498l5399953611d902c2@mail.gmail.com> (sfid-20071030_154757_915088_8E508843)
Date: Tue, 30 Oct 2007 11:47:47 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [ath5k-devel] MadWifi HAL register dumps - help reverse engineering
Cc: "bruno randolf" <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	madwifi-devel <madwifi-devel@lists.sourceforge.net>
In-Reply-To: <1193757169.29187.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890710191255k72c7176fx10592dcfc02cb287@mail.gmail.com>
	 <200710301749.32236.bruno@thinktube.com>
	 <1193757169.29187.19.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/07, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2007-10-30 at 17:49 +0900, bruno randolf wrote:
> > hi luis!
> >
> > adding the following patch lets us log the calling function names as well!
> > which makes it much easier to make sense to the traces :)
> >
> > and i added ALQ=1 MMIOTRACE=1 and the objdump command to the Makefile as well
> > to avoid forgetting that.
> >
> > cheers,
> > bruno
> >
> > this time the patch is included, sorry...
> >
> > diff -Nurb madwifi-trace.luis/ath_hal/ah_os.c madwifi-trace/ath_hal/ah_os.c
> > --- madwifi-trace.luis/ath_hal/ah_os.c        2007-10-30 17:44:48.000000000 +0900
> > +++ madwifi-trace/ath_hal/ah_os.c     2007-10-30 17:39:52.000000000 +0900
> > @@ -152,6 +152,7 @@
> >   * useful for debugging and figuring out, which hal function sets which
> >   * registers */
> >  char *ath_hal_func = NULL;
> > +EXPORT_SYMBOL(ath_hal_func);
>
> Any particular reason this is not EXPORT_SYMBOL_GPL?

Technically Dual GPL/3-clause BSD license code is functionally
equivalent to 3-clause-BSD.

  Luis
