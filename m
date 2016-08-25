Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35168 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757618AbcHYPEU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:04:20 -0400
Received: by mail-oi0-f66.google.com with SMTP id e80so4824404oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 08:03:08 -0700 (PDT)
Received: from mail-oi0-f52.google.com (mail-oi0-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id m74sm6698931oik.11.2016.08.25.08.03.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Aug 2016 08:03:07 -0700 (PDT)
Received: by mail-oi0-f52.google.com with SMTP id f189so70184608oig.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 08:03:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160825131907.GA7834@redhat.com>
References: <1472113162-26915-1-git-send-email-dev@kresin.me>
 <20160825093330.GA2827@redhat.com> <CABwW5nkxpX_SsCorU0kuuOVDcNP5QARdyTbP=AWM5=QTZOW=eA@mail.gmail.com>
 <20160825131907.GA7834@redhat.com>
From: Mathias Kresin <dev@kresin.me>
Date: Thu, 25 Aug 2016 17:03:06 +0200
Message-ID: <CABwW5n=Jomr+EO4dp3mzhV0HFxdfrAJuc=cZv8fdmRe31OS+3Q@mail.gmail.com> (sfid-20160825_170424_867757_6F69850F)
Subject: Re: [PATCH] rt2x00: add support for mac addr from device tree
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-08-25 15:19 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Thu, Aug 25, 2016 at 01:12:22PM +0200, Mathias Kresin wrote:
>> 2016-08-25 11:33 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
>> > On Thu, Aug 25, 2016 at 10:19:22AM +0200, Mathias Kresin wrote:

>> CPE = Customer Premises Equipment or the small plastic box from your
>> ISP at home. The whole point of the patch is that the MAC stored in
>> the wifi EEPROM might not be unique and need to be overridden. I'm
>> aware of three different "home router", where each model has the same
>> generic ralink MAC address stored in the wifi EEPROM. This can cause
>> nasty issues.
>
> I think we still want MAC from EEPROM instead of random one on systems
> without OF. Otherwise we could just use random MAC every time, but this
> does not seems lika a good idea.

Either I got you wrong, the code does something different than I
intended/tested or you misread the code.

The mac address stored in the EEPROM is only overridden in case:

a) a mac address is defined in the device tree.
b) invalid/no mac stored in EEPROM => random one

If none of the above is true, the EEPROM mac will be used. What I've
added is a). Everything else is the same as before.

> Can we check against that particular MAC that repeats on those CPEs and
> if it match use random one ? Or use some other identification to find
> out that EEPROM MAC is not good ?

IMHO this would be a wonky approach. I had a look at the EEPROM MACs
from two of the affected devices and spotted just now a coherence with
the used wifi chip:

VGV7510KW22 (RT3062F): 00:0C:43:30:62:00
ARV7506 (RT3060F): 00:0C:43:30:60:00

IMHO, it would be reckless to assume that it's the same for other
affected models. You know, ODMs doing silly things. Personally I
prefer to deal with the issue in device tree rather than forcing a
random MAC address. This way I can set the MAC used with the stock
firmware to fix the issue.

Mathias
