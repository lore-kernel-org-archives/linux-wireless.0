Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47725 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbZCUMuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 08:50:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
Date: Sat, 21 Mar 2009 13:49:02 +0100
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903170410.20261.chunkeey@web.de> <200903211220.29991.mb@bu3sch.de> <1237635266.5100.174.camel@johannes.local>
In-Reply-To: <1237635266.5100.174.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903211349.02761.mb@bu3sch.de> (sfid-20090321_135022_252826_D510E503)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 March 2009 12:34:26 Johannes Berg wrote:
> On Sat, 2009-03-21 at 12:20 +0100, Michael Buesch wrote:
> 
> > > > > +#if 0
> > > > > +#include <linux/mutex.h>
> > > > > +#define mutex_lock(m) do { mutex_lock(m); __acquire(m); } while (0)
> > > > > +#define mutex_unlock(m) do { mutex_unlock(m); __release(m); } while (0)
> > > > > +#endif
> > > > > +
> > > > > +#endif /* __USB_H */
> > > > 
> > > > Whoops, debugging code? :)
> > > 
> > > sparse, for some reason mutex operations aren't annotated... Probably
> > > because Ingo wrote the code...
> > 
> > Well I think it would currently generate lots of errors, because we have
> > code like this in the kernel:
> > 
> > if (x)
> > 	mutex_lock();
> > ...
> > if (x)
> > 	mutex_unlock();
> 
> That's sloppy code anyway. Not to be encouraged.

That's not true. Sometimes it is the cleanest way to do things.
Look at drivers/ssb/main.c. To make this mutex-sparse compliant, we'd
need to introduce quite a few sub-functions.

It simply is a limitation of sparse. Nothing else.

-- 
Greetings, Michael.
