Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:45211 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932339AbeCLVtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 17:49:52 -0400
MIME-Version: 1.0
In-Reply-To: <20180312110856.GL2470@otheros>
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <20180312110856.GL2470@otheros>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 12 Mar 2018 22:49:51 +0100
Message-ID: <CACna6rwHetzUN+SGD8SHa1V_O-MQDTQRKd_VUQn_iaHW6cdp=A@mail.gmail.com> (sfid-20180312_225000_654479_81C2F552)
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc: Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2018 at 12:08, Linus L=C3=BCssing <linus.luessing@c0d3.blue> wr=
ote:
> On Tue, Feb 27, 2018 at 11:08:20AM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> I've problem when using OpenWrt/LEDE on a home router with Broadcom's
>> FullMAC WiFi chipset.
>
> Hi Rafa=C5=82,
>
> Thanks for reporting this issue!
>
>> Can you see any solution for this problem? Is that an option to stop
>> multicast-to-unicast from touching 802.11f packets? Some other ideas?
>> Obviously I can't modify Broadcom's firmware and drop that obsoleted
>> standard.
>
> Just to avoid some potential confusion: This is more an issue of
> hairpinning than it is an issue of multicast-to-unicast per se,
> right?
>
> That is, if you set this to 0 manually:
> /sys/class/net/<ap-iface>/brport/multicast_to_unicast
> Then the issue still occurs, right?

I can't really tell, I didn't go into details on bridge +
mcast-to-unicast + hairpin.

By default OpenWrt/LEDE sets
/sys/class/net/<ap-iface>/brport/multicast_to_unicast
to 1. Changing it to 0 (with a simple echo) doesn't /fix/ the problem.

--=20
Rafa=C5=82
