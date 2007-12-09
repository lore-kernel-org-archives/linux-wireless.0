Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52942 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbXLJAXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 19:23:32 -0500
Received: from public by ciao.gmane.org with local (Exim 4.43)
	id 1J1WQT-0003da-IV
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2007 00:23:13 +0000
Subject: Re: [PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Dan Williams <public-dcbw-H+wXaHxf7aLQT0dZR+AlfA@ciao.gmane.org>,
	David Miller <public-davem-fT/PcQaiUtIeIZ0/mPfg9Q@ciao.gmane.org>,
	public-linville-2XuSBdqkA4R54TAoqtyWWQ@ciao.gmane.org,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@ciao.gmane.org,
	public-jt-sDzT885Ts8HQT0dZR+AlfA@ciao.gmane.org
In-Reply-To: <475C3538.1070501@gmail.com>
References: <1197073366.4563.15.camel@localhost.localdomain>
	 <20071207.181221.09900510.davem@davemloft.net>
	 <1197221467.9149.31.camel@localhost.localdomain>
	 <475C3538.1070501@gmail.com>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 13:35:00 -0500
Message-Id: <1197225300.9149.74.camel@localhost.localdomain> (sfid-20071210_002335_513389_B559D9A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




On Sun, 2007-12-09 at 18:34 +0000, Dave wrote:
> 
> Dan Williams wrote:
> > On Fri, 2007-12-07 at 18:12 -0800, David Miller wrote:
> >> From: Dan Williams <dcbw-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Date: Fri, 07 Dec 2007 19:22:46 -0500
> >>
> >>> @@ -1040,6 +1049,16 @@ struct	iw_range
> >>>  	 * because each entry contain its channel index */
> >>>  
> >>>  	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
> >>> +
> >>> +	/* Do *NOT* use those fields, they are just used as padding to get
> >>> +	 * proper alignement with user space */
> >>> +	__s32		reserved1;
> >>> +	__s32		reserved2;
> >>> +	__u16		reserved3;
> >>> +	__s32		reserved4;
> >>> +	__u32		reserved5;
> >>> +
> >>> +	__u32		scan_capa;	/* IW_SCAN_CAPA_* bit field */
> >>>  };
> >>>  
> >>>  /*
> >> Major NACK.  These datastructure usages are complete wrong, and
> >> we have to stop spreading this problem instead of continuing on
> >> with it as if it's OK.
> > 
> > There's not too much we can do here.  We need a better way to support
> > driver/card capabilities in WEXT right _now_, in parallel with
> > cfg80211/nl80211.  The other alternative here is to have a 64-bit
> > generic capabilities field-to-end-all-fields and add more bitfield
> > position constants to that without extending the structure any more.
> > 
> > Is there a better way you'd propose to do this _in_WEXT_?
> 
> Since iw_range is not packed, there are a few locations where there is some padding. You could quite easily shoehorn an 8 bit bitmask into the existing structure without impacting backward compatibility (unless userspace is using the padding for something). For example:
> 
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -1035,6 +1035,7 @@ struct    iw_range
>         /* Frequency */
>         __u16           num_channels;   /* Number of channels [0; num - 1] */
>         __u8            num_frequency;  /* Number of entry in the list */
> +       __u8            scan_capa;      /* scan capabilities */
>         struct iw_freq  freq[IW_MAX_FREQUENCIES];       /* list */
>         /* Note : this frequency list doesn't need to fit channel numbers,
>          * because each entry contain its channel index */
> 
> Other candidate blocks are Old Frequency, Rates, Encoder stuff, Transmit power.

Hmm; this could work as long as that part of the structure is guaranteed
to be 0 if it wasn't touched by the driver.  If it could be filled with
garbage bits at any point, then it's not going to work.  Interesting
thought.

Dan



