Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53849 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZCULVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 07:21:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
Date: Sat, 21 Mar 2009 12:20:29 +0100
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903170410.20261.chunkeey@web.de> <200903202058.34420.mb@bu3sch.de> <1237633835.5100.173.camel@johannes.local>
In-Reply-To: <1237633835.5100.173.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903211220.29991.mb@bu3sch.de> (sfid-20090321_122201_685111_53B0597A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 March 2009 12:10:35 Johannes Berg wrote:
> On Fri, 2009-03-20 at 20:58 +0100, Michael Buesch wrote:
> > On Friday 20 March 2009 20:36:42 Christian Lamparter wrote:
> > > USB frontend driver code for Atheros AR9170.
> > 
> > It seems lots of patches didn't make it through the list. :(
> > 
> > > +#if 0
> > > +#include <linux/mutex.h>
> > > +#define mutex_lock(m) do { mutex_lock(m); __acquire(m); } while (0)
> > > +#define mutex_unlock(m) do { mutex_unlock(m); __release(m); } while (0)
> > > +#endif
> > > +
> > > +#endif /* __USB_H */
> > 
> > Whoops, debugging code? :)
> 
> sparse, for some reason mutex operations aren't annotated... Probably
> because Ingo wrote the code...

Well I think it would currently generate lots of errors, because we have
code like this in the kernel:

if (x)
	mutex_lock();
...
if (x)
	mutex_unlock();

-- 
Greetings, Michael.
