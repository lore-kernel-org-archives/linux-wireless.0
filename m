Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33584 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbYILSjo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 14:39:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] p54: Fix sparse warnings
Date: Fri, 12 Sep 2008 20:39:21 +0200
Cc: John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
References: <48cab1e3.m0lac7LoL3DFxIu6%Larry.Finger@lwfinger.net> <200809122036.03553.mb@bu3sch.de>
In-Reply-To: <200809122036.03553.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809122039.21179.mb@bu3sch.de> (sfid-20080912_203947_927627_0A97D082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 12 September 2008 20:36:03 Michael Buesch wrote:
> On Friday 12 September 2008 20:16:03 Larry Finger wrote:
> >  struct bootrec {
> >  	__le32 code;
> >  	__le32 len;
> > -	u32 data[0];
> > +	/* Most references to the data section that follows are for u32
> > +	 * quantities; however, one is for an le16 quantity. The union
> > +	 * below avoids a cast and makes the usage clearer. */
> > +	union {
> > +		u32 data[0];
> > +		__le16 data16[0];
> > +	};
> >  } __attribute__((packed));
> 
> I suggest you change
> 	u32 data[0];
> to
> 	__le32 data_le32[0];
> and also add
> 	__be32 data_be32[0];
> to the union. This avoids another few casts.
> (Maybe you don't even need the __le32 variant. I didn't check all the code).

Ah and I think you should also add packed attribute to the union
to tell the compiler to avoid any padding.

-- 
Greetings Michael.
