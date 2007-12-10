Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59348 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXLJSJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 13:09:03 -0500
Date: Mon, 10 Dec 2007 10:08:09 -0800
To: Dan Williams <dcbw@redhat.com>
Cc: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] introduce WEXT scan capabilities
Message-ID: <20071210180809.GA7168@bougret.hpl.hp.com> (sfid-20071210_180909_008759_F385B025)
Reply-To: jt@hpl.hp.com
References: <1197073366.4563.15.camel@localhost.localdomain> <20071207.181221.09900510.davem@davemloft.net> <1197221467.9149.31.camel@localhost.localdomain> <475C3538.1070501@gmail.com> <1197225300.9149.74.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197225300.9149.74.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 09, 2007 at 01:35:00PM -0500, Dan Williams wrote:
> 
> 
> 
> On Sun, 2007-12-09 at 18:34 +0000, Dave wrote:
> > 
> > Dan Williams wrote:
> > > On Fri, 2007-12-07 at 18:12 -0800, David Miller wrote:
> > >> From: Dan Williams <dcbw-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >> Date: Fri, 07 Dec 2007 19:22:46 -0500
> > >>
> > >>> @@ -1040,6 +1049,16 @@ struct	iw_range
> > >>>  	 * because each entry contain its channel index */
> > >>>  
> > >>>  	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
> > >>> +
> > >>> +	/* Do *NOT* use those fields, they are just used as padding to get
> > >>> +	 * proper alignement with user space */
> > >>> +	__s32		reserved1;
> > >>> +	__s32		reserved2;
> > >>> +	__u16		reserved3;
> > >>> +	__s32		reserved4;
> > >>> +	__u32		reserved5;
> > >>> +
> > >>> +	__u32		scan_capa;	/* IW_SCAN_CAPA_* bit field */
> > >>>  };
> > >>>  
> > >>>  /*
> > >> Major NACK.  These datastructure usages are complete wrong, and
> > >> we have to stop spreading this problem instead of continuing on
> > >> with it as if it's OK.
> > > 
> > > There's not too much we can do here.  We need a better way to support
> > > driver/card capabilities in WEXT right _now_, in parallel with
> > > cfg80211/nl80211.  The other alternative here is to have a 64-bit
> > > generic capabilities field-to-end-all-fields and add more bitfield
> > > position constants to that without extending the structure any more.
> > > 
> > > Is there a better way you'd propose to do this _in_WEXT_?
> > 
> > Since iw_range is not packed, there are a few locations where there is some padding. You could quite easily shoehorn an 8 bit bitmask into the existing structure without impacting backward compatibility (unless userspace is using the padding for something). For example:
> > 
> > --- a/include/linux/wireless.h
> > +++ b/include/linux/wireless.h
> > @@ -1035,6 +1035,7 @@ struct    iw_range
> >         /* Frequency */
> >         __u16           num_channels;   /* Number of channels [0; num - 1] */
> >         __u8            num_frequency;  /* Number of entry in the list */
> > +       __u8            scan_capa;      /* scan capabilities */
> >         struct iw_freq  freq[IW_MAX_FREQUENCIES];       /* list */
> >         /* Note : this frequency list doesn't need to fit channel numbers,
> >          * because each entry contain its channel index */
> > 
> > Other candidate blocks are Old Frequency, Rates, Encoder stuff, Transmit power.
> 
> Hmm; this could work as long as that part of the structure is guaranteed
> to be 0 if it wasn't touched by the driver.  If it could be filled with
> garbage bits at any point, then it's not going to work.  Interesting
> thought.

	You can count on zero being there in almost every case, for
this precise reason. The first thing a driver is supposed to do with
iwrange is :
----------------------------------------
	memset(range, 0, sizeof(struct iw_range));
----------------------------------------
	From what I remember, all drivers are doing it. If a driver
does not do it, it should be fixed ASAP as other things would break
(most driver only fill a few field of the struct and don't touch
others).

> Dan

	Regards,

	Jean

P.S. : What's up with all the bogus e-mail addresses in cc ?
