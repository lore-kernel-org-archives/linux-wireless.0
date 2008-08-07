Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59823 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbYHGQeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 12:34:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Chr <chunkeey@web.de>
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
Date: Thu, 7 Aug 2008 18:34:00 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> <1218122834.3630.6.camel@johannes.berg> <200808071800.58356.chunkeey@web.de>
In-Reply-To: <200808071800.58356.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808071834.00645.mb@bu3sch.de> (sfid-20080807_183426_966212_15C30C9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 August 2008 18:00:57 Chr wrote:
> On Thursday 07 August 2008 17:27:14 Johannes Berg wrote:
> > On Thu, 2008-08-07 at 17:27 +0200, Chr wrote:
> > > +       u32:24;
> > > +       u32:32;
> > > +       u16:16;
> >
> > That piece looks just wrong though. Bitfields, and in a hw struct?
> well, this is a crude way to silence gcc... without the ":32"
> it complains "warning: declaration does not declare anything".
> 
> Of course we/I can make lot's of u8 paddingZ[X] arrays,
> but we'll run out of Z and X in the long run ;-).


You can use this magic macro:

#define P4D_BYT3S(magic, nr_bytes)	u8 __p4dding##magic[nr_bytes]
#define P4D_BYTES(line, nr_bytes)	P4D_BYT3S(line, nr_bytes)
/* Magic helper macro to pad structures. Ignore those above. It's magic. */
#define PAD_BYTES(nr_bytes)		P4D_BYTES( __LINE__ , (nr_bytes))


struct xyz {
	//foo
	PAD_BYTES(4); /* Pad 4 bytes */
	//bar
};

-- 
Greetings Michael.
