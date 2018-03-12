Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38833 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932231AbeCLJqq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 05:46:46 -0400
MIME-Version: 1.0
In-Reply-To: <20180227090556.02a24a0d@xeon-e3>
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <20180227090556.02a24a0d@xeon-e3>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 12 Mar 2018 10:46:45 +0100
Message-ID: <CACna6rxP4ATE2f6XJi7XKDLe2L_Z43aLreEHDCfGicksYTb0xg@mail.gmail.com> (sfid-20180312_104657_472878_63444DD3)
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 February 2018 at 18:05, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Tue, 27 Feb 2018 11:08:20 +0100
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
>
>> I've problem when using OpenWrt/LEDE on a home router with Broadcom's
>> FullMAC WiFi chipset.
>>
>>
>> First of all OpenWrt/LEDE uses bridge interface for LAN network with:
>> 1) IFLA_BRPORT_MCAST_TO_UCAST
>> 2) Clients isolation in hostapd
>> 3) Hairpin mode enabled
>>
>> For more details please see Linus's patch description:
>> https://patchwork.kernel.org/patch/9530669/
>> and maybe hairpin mode patch:
>> https://lwn.net/Articles/347344/
>>
>> Short version: in that setup packets received from a bridged wireless
>> interface can be handled back to it for transmission.
>>
>>
>> Now, Broadcom's firmware for their FullMAC chipsets in AP mode
>> supports an obsoleted 802.11f AKA IAPP standard. It's a roaming
>> standard that was replaced by 802.11r.
>>
>> Whenever a new station associates, firmware generates a packet like:
>> ff ff ff ff  ff ff ec 10  7b 5f ?? ??  00 06 00 01  af 81 01 00
>> (just masked 2 bytes of my MAC)
>>
>> For mode details you can see discussion in my brcmfmac patch thread:
>> https://patchwork.kernel.org/patch/10191451/
>>
>>
>> The problem is that bridge (in setup as above) handles such a packet
>> back to the device.
>>
>> That makes Broadcom's FullMAC firmware believe that a given station
>> just connected to another AP in a network (which doesn't even exist).
>> As a result firmware immediately disassociates that station. It's
>> simply impossible to connect to the router. Every association is
>> followed by immediate disassociation.
>>
>>
>> Can you see any solution for this problem? Is that an option to stop
>> multicast-to-unicast from touching 802.11f packets? Some other ideas?
>> Obviously I can't modify Broadcom's firmware and drop that obsoleted
>> standard.
>>
>
> ebtables is your friend in dealing with weird and broken devices.

It may be weird, not sure if actually broken. Anyway I'd like to have
some generic solution instead of telling every user to use ebtables to
workaround the problem.

--=20
Rafa=C5=82
