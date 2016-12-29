Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50458 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752311AbcL2PSK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 10:18:10 -0500
Message-ID: <1483024688.13037.1.camel@sipsolutions.net> (sfid-20161229_161814_314791_7BE8EA12)
Subject: Re: gpio outputs that disable wireless to PCI Express Mini Card and
 RFKILL
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Harvey <tharvey@gateworks.com>, linux-wireless@vger.kernel.org
Date: Thu, 29 Dec 2016 16:18:08 +0100
In-Reply-To: <CAJ+vNU33Z05DaQGER8KJoPX5g1w=HWjKFDbNs0S0gxKDcFV7bg@mail.gmail.com> (sfid-20161229_160911_547687_7AB8BEF3)
References: <CAJ+vNU33Z05DaQGER8KJoPX5g1w=HWjKFDbNs0S0gxKDcFV7bg@mail.gmail.com>
         (sfid-20161229_160911_547687_7AB8BEF3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-12-29 at 07:07 -0800, Tim Harvey wrote:
> Greetings,
> 
> The PCI Express Mini Card (aka Mini PCIe) spec calls out pin 20 as
> W_DISABLE# to allow a PCIe host to disable the add-in card's radio
> operation and we have run this to a GPIO on our boards for some time.
> The M.2 specs also provide such signals. Is there any support in the
> Linux RFKILL subsystem to define this?

Not directly, but that depends on what you mean by "support". This
whole thing is relatively simple - it's an input signal to the wireless
NIC, so that any reaction to the input originates there.

Typically (I know about Intel and ath9k devices) changes in this input
either trigger an interrupt (Intel) or are polled for (ath9k), and then
the already existing rfkill instance for the wireless NIC will reflect
a "hard block" when the driver notifies upper layers of the new state.

Or did you mean you want to use the CPU to *control* this GPIO? In this
case, I'm not sure that the rfkill subsystem is appropriate, but there
apparently are some such cases already where the platform rfkill's
software state essentially toggles the wireless NIC's hardware state.

I'd argue this is useless though since if you toggle the thing from
software then you might as well rely entirely on software rfkill.

johannes
