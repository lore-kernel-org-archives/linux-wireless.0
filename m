Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36042 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758232AbcHYL3c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 07:29:32 -0400
Received: by mail-oi0-f68.google.com with SMTP id b22so4284123oii.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 04:29:31 -0700 (PDT)
Received: from mail-oi0-f53.google.com (mail-oi0-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id v41sm6319032otd.3.2016.08.25.04.12.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Aug 2016 04:12:23 -0700 (PDT)
Received: by mail-oi0-f53.google.com with SMTP id f189so61695438oig.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 04:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160825093330.GA2827@redhat.com>
References: <1472113162-26915-1-git-send-email-dev@kresin.me> <20160825093330.GA2827@redhat.com>
From: Mathias Kresin <dev@kresin.me>
Date: Thu, 25 Aug 2016 13:12:22 +0200
Message-ID: <CABwW5nkxpX_SsCorU0kuuOVDcNP5QARdyTbP=AWM5=QTZOW=eA@mail.gmail.com> (sfid-20160825_132936_368520_05FAAC30)
Subject: Re: [PATCH] rt2x00: add support for mac addr from device tree
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-08-25 11:33 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
>
> On Thu, Aug 25, 2016 at 10:19:22AM +0200, Mathias Kresin wrote:
> > The EEPROM used on some CPEs has for every device the same generic
> > ralink mac in EEPROM and needs to be overridden.
>
> I don't know what is CPE, but even if I would know that, I most likely
> sill will not understand that description.

Well, seams to me the commit message can be improved. If a v2 is
required or a v2 is required because of the commit message, I'll take
care of it.

CPE = Customer Premises Equipment or the small plastic box from your
ISP at home. The whole point of the patch is that the MAC stored in
the wifi EEPROM might not be unique and need to be overridden. I'm
aware of three different "home router", where each model has the same
generic ralink MAC address stored in the wifi EEPROM. This can cause
nasty issues.

> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> > @@ -1459,10 +1459,7 @@ static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
> >        * Start validation of the data that has been read.
> >        */
> >       mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
> > -     if (!is_valid_ether_addr(mac)) {
> > -             eth_random_addr(mac);
> > -             rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
> > -     }
> > +     rt2x00lib_set_mac_address(rt2x00dev, mac);
> <snip>
> > +#include <linux/of.h>
> > +#include <linux/of_net.h>
> >
> >  #include "rt2x00.h"
> >  #include "rt2x00lib.h"
> > @@ -931,6 +933,21 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
> >               entry->flags |= IEEE80211_RATE_SHORT_PREAMBLE;
> >  }
> >
> > +void rt2x00lib_set_mac_address(struct rt2x00_dev *rt2x00dev, u8 *eeprom_mac_addr)
> > +{
> > +     const char *mac_addr;
> > +
> > +     mac_addr = of_get_mac_address(rt2x00dev->dev->of_node);
>
> Shouldn't use dev_of_node(&rt2x00dev->dev) and check against NULL ?

Not sure if dev_of_node() is meant to be used by every driver. Or at
least the function is only used by base stuff and not by any driver.

The NULL check doesn't seam to me required. The of_node is finally
passed to __of_find_property which does the NULL check before using
of_node.

Mathias
