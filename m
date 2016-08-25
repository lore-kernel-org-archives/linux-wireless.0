Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933987AbcHYNhy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 09:37:54 -0400
Date: Thu, 25 Aug 2016 15:19:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: add support for mac addr from device tree
Message-ID: <20160825131907.GA7834@redhat.com> (sfid-20160825_153758_992519_4468CD35)
References: <1472113162-26915-1-git-send-email-dev@kresin.me>
 <20160825093330.GA2827@redhat.com>
 <CABwW5nkxpX_SsCorU0kuuOVDcNP5QARdyTbP=AWM5=QTZOW=eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABwW5nkxpX_SsCorU0kuuOVDcNP5QARdyTbP=AWM5=QTZOW=eA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2016 at 01:12:22PM +0200, Mathias Kresin wrote:
> 2016-08-25 11:33 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> >
> > On Thu, Aug 25, 2016 at 10:19:22AM +0200, Mathias Kresin wrote:
> > > The EEPROM used on some CPEs has for every device the same generic
> > > ralink mac in EEPROM and needs to be overridden.
> >
> > I don't know what is CPE, but even if I would know that, I most likely
> > sill will not understand that description.
> 
> Well, seams to me the commit message can be improved. If a v2 is
> required or a v2 is required because of the commit message, I'll take
> care of it.

Please do.

> CPE = Customer Premises Equipment or the small plastic box from your
> ISP at home. The whole point of the patch is that the MAC stored in
> the wifi EEPROM might not be unique and need to be overridden. I'm
> aware of three different "home router", where each model has the same
> generic ralink MAC address stored in the wifi EEPROM. This can cause
> nasty issues.

I think we still want MAC from EEPROM instead of random one on systems
without OF. Otherwise we could just use random MAC every time, but this
does not seems lika a good idea.

Can we check against that particular MAC that repeats on those CPEs and
if it match use random one ? Or use some other identification to find
out that EEPROM MAC is not good ?

> > Shouldn't use dev_of_node(&rt2x00dev->dev) and check against NULL ?
> 
> Not sure if dev_of_node() is meant to be used by every driver. Or at
> least the function is only used by base stuff and not by any driver.
> 
> The NULL check doesn't seam to me required. The of_node is finally
> passed to __of_find_property which does the NULL check before using
> of_node.

Ok.

Thanks
Stanislaw
