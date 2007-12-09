Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXLIRmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 12:42:08 -0500
Subject: Re: [PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com
In-Reply-To: <20071207.181221.09900510.davem@davemloft.net>
References: <1197073366.4563.15.camel@localhost.localdomain>
	 <20071207.181221.09900510.davem@davemloft.net>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 12:31:07 -0500
Message-Id: <1197221467.9149.31.camel@localhost.localdomain> (sfid-20071209_174216_087963_DD06254C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-07 at 18:12 -0800, David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Fri, 07 Dec 2007 19:22:46 -0500
> 
> > @@ -1040,6 +1049,16 @@ struct	iw_range
> >  	 * because each entry contain its channel index */
> >  
> >  	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
> > +
> > +	/* Do *NOT* use those fields, they are just used as padding to get
> > +	 * proper alignement with user space */
> > +	__s32		reserved1;
> > +	__s32		reserved2;
> > +	__u16		reserved3;
> > +	__s32		reserved4;
> > +	__u32		reserved5;
> > +
> > +	__u32		scan_capa;	/* IW_SCAN_CAPA_* bit field */
> >  };
> >  
> >  /*
> 
> Major NACK.  These datastructure usages are complete wrong, and
> we have to stop spreading this problem instead of continuing on
> with it as if it's OK.

There's not too much we can do here.  We need a better way to support
driver/card capabilities in WEXT right _now_, in parallel with
cfg80211/nl80211.  The other alternative here is to have a 64-bit
generic capabilities field-to-end-all-fields and add more bitfield
position constants to that without extending the structure any more.

Is there a better way you'd propose to do this _in_WEXT_?

I don't really forsee any more extending of this structure, since I
think scan capabilities are the last thing we really need to know about.

Dan


