Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41082 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbeDELYk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 07:24:40 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Steve deRosier <derosier@gmail.com>,
        Sunil Dutt Undekari <usdutt@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Amarnath Hullur Subramanyam" <amarnath@qti.qualcomm.com>,
        Rajesh Chauhan <rajeshc@qti.qualcomm.com>
Subject: Re: Wi-Fi Disconnection on Suspend for no wowlan triggers
Date: Thu, 5 Apr 2018 11:24:32 +0000
Message-ID: <20180405112423.GA9248@jouni.qca.qualcomm.com> (sfid-20180405_132444_360054_EB2D10B4)
References: <0663e93cc5ca45e6b7191760414b1189@aphydexm01f.ap.qualcomm.com>
 <CALLGbRJgAtOdZ1puzfgpWxc_ZrDVmWXtmFrBu=-gA0C++WrLoA@mail.gmail.com>
 <5AC5D33F.4090100@broadcom.com> <1522915172.7140.1.camel@sipsolutions.net>
 <5AC5D928.6020505@broadcom.com>
In-Reply-To: <5AC5D928.6020505@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 05, 2018 at 10:07:04AM +0200, Arend van Spriel wrote:
> On 4/5/2018 9:59 AM, Johannes Berg wrote:
> >There's the "any" trigger that might be appropriate for that, or a
> >"disconnect" trigger.
> >
> >But I'm basically thinking the same as Steve - if you're never going to
> >wake up the host, there's not really much point in keeping the
> >connection, and if you only suspend briefly like e.g. on Android then
> >you probably *do* want to wake up the host for pretty much everything
> >that's going on (hence the "any" trigger).
>=20
> Agree, which is why I suggested to look at wowlan triggers. If we already
> have an appropriate "any" trigger even better ;-)

The "any" trigger sounds like a reasonable thing to use, so the question
really is on what the default behavior should be if the driver has
capability of doing this and there is no explicit configuration in user
space. Currently, the default behavior seems to be to force
disconnection. Would it make sense to allow drivers to indicate that
they rather use "any" trigger by default? Or make that the default
behavior is the driver supports "any"?

For example, wpa_supplicant does not currently set any trigger
configuration unless explicitly asked to do so. This in combination with
the kernel default (disconnect) does not seem to result in desired
behavior in number of Android cases.

And if the default behavior should be changed, should that behavior
change be done in the kernel or user space (wpa_supplicant)?

--=20
Jouni Malinen                                            PGP id EFC895FA=
