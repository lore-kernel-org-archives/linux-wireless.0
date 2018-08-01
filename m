Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0066.outbound.protection.outlook.com ([104.47.41.66]:44513
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387633AbeHAKHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:07:52 -0400
Date: Wed, 1 Aug 2018 11:23:01 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 5/6] qtnfmac: add support for PTA configuration
Message-ID: <20180801082300.sev7ag5wh4wj7fbb@bars> (sfid-20180801_103305_033560_E9F63B65)
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com>
 <87d0v4stqm.fsf@codeaurora.org>
 <5B604B14.8080607@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5B604B14.8080607@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > Implement support for PTA (Packet Traffic Arbitration) configuration.
> > > The PTA mechanism is used to coordinate sharing of the medium between
> > > WiFi and other 2.4 wireless networks, e.g. Bluetooth or ZigBee.
> > > 
> > > This patch implements core infrastructure and vendor specific commands
> > > to control PTA functionality in firmware.
> > 
> > And no description of the actual interface which would have helped with
> > the review.
> > 
> > Anyway, the vendor commands are pain and they just make me grumpy. The
> > original idea was that upstream drivers should not support them at all,
> > later we flexed the rules so that low level hardware specific interfaces
> > might be ok, for example we added one in wil6210.
> > 
> > If I would even consider applying a patch which adds a vendor command it
> > needs a really good commit log with a proper description of the actual
> > interface and good justifications why a generic nl80211 command won't
> > work. I don't see anything even remotely close here.
> > 
> > Sorry for being grumpy, I just hate these vendor commands. Especially
> > when I see that a generic nl80211 command has not even be consired at
> > all.
> 
> For what it is worth, looking at part of the patch:
> 
> +/**
> + * enum qlink_pta_mode - Packet Traffic Arbiter operating modes
> + *
> + * @QLINK_PTA_MODE_DISABLED: PTA is disabled
> + * @QLINK_PTA_MODE_2_WIRE: enable PTA 2-wire mode
> + */
> +enum qlink_pta_mode {
> +       QLINK_PTA_MODE_DISABLED = 0,
> +       QLINK_PTA_MODE_2_WIRE = 2
> +};
> +
> 
> it smells very much like low-level btcoex. The question is whether this
> needs to be conveyed from user-space or should these be device
> configuration, eg. like DT properties.

Hello Arend,

Yes, this is some kind of low-level BT coexistence mechanism, when WiFi and
BT cards coordinate access to wireless media in 2.4G using gpio lines.
Those lines connect WiFi and BT cards directly w/o host mediation.

As for DT properties, the qustion still remains the same: how to propagate
those settings to WiFi card. AFAIK there is no 'standard' interface for
this kind of things. So using vendor commands looked like the only option.

Regards,
Sergey
