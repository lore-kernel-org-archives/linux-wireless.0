Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48120 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757161AbdACHBD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 02:01:03 -0500
Message-ID: <1483426858.15591.3.camel@sipsolutions.net> (sfid-20170103_080107_338084_45E1A6DE)
Subject: Re: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Tue, 03 Jan 2017 08:00:58 +0100
In-Reply-To: <e194b980-1048-8da6-624b-26f824ff655d@broadcom.com> (sfid-20170102_211210_491488_1DB64A4C)
References: <20170102163209.2445-1-zajec5@gmail.com>
         <20170102163209.2445-2-zajec5@gmail.com>
         <1483379548.15591.1.camel@sipsolutions.net>
         <e194b980-1048-8da6-624b-26f824ff655d@broadcom.com>
         (sfid-20170102_211210_491488_1DB64A4C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I suppose this then can also be done early in the wiphy_register()
> function itself, right?

No, because of the shared channel data issue. If this is
unconditionally in wiphy_register() then we can no longer guarantee
that sharing it is acceptable - which it is today under certain
circumstances the driver controls. This would move it out of driver
control, making it never possible to share any more.

> So does it mean the function can go in core.c again :-p If it is
> likely there will be other properties being added it might justify
> adding a new source file, eg. of.c, and only compile it when
> CONFIG_OF is set. Just a thought.

Yeah, whatever :)
We can figure that out once we have the mechanisms in place.

johannes
