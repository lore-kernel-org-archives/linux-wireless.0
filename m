Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:42808 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbeCLLkU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 07:40:20 -0400
Date: Mon, 12 Mar 2018 12:40:17 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
Message-ID: <20180312114017.GM2470@otheros> (sfid-20180312_124028_539327_3EB4183B)
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <20180227090556.02a24a0d@xeon-e3>
 <CACna6rxP4ATE2f6XJi7XKDLe2L_Z43aLreEHDCfGicksYTb0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxP4ATE2f6XJi7XKDLe2L_Z43aLreEHDCfGicksYTb0xg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2018 at 10:46:45AM +0100, Rafał Miłecki wrote:
> On 27 February 2018 at 18:05, Stephen Hemminger
[...]
> > ebtables is your friend in dealing with weird and broken devices.
> 
> It may be weird, not sure if actually broken. Anyway I'd like to have
> some generic solution instead of telling every user to use ebtables to
> workaround the problem.

I agree that a "broken by default" in OpenWRT/LEDE for a variety
of Broadcom devices is not really acceptable.

Technically we could teach netifd in OpenWRT/LEDE to configure
ebtables accordingly, at least for a list of affected devices,
so that users would not have to. However, as ebtables is not
managed by the fw3 in OpenWRT/LEDE, that would probably interfer
with user provided ebtables rules and scripts...


> That said I think we still should look for a solution for existing
> firmwares. I guess it may takes months to years to never to release
> new firmwares for all supported chipsets.

Hm, we could change the default in OpenWRT/LEDE for
multicast-to-unicast (or more precisely bridge hairpinning) to
disabled again for now.
