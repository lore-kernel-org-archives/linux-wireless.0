Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34019 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbeB1Lbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 06:31:35 -0500
Received: by mail-qk0-f173.google.com with SMTP id l206so2508398qke.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 03:31:35 -0800 (PST)
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <88d080df-4cce-98d1-6482-0408a3dcb015@gmail.com>
Cc: Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A969313.5050501@broadcom.com> (sfid-20180228_123144_060953_551CD6DA)
Date: Wed, 28 Feb 2018 12:31:31 +0100
MIME-Version: 1.0
In-Reply-To: <88d080df-4cce-98d1-6482-0408a3dcb015@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/27/2018 11:14 AM, Rafał Miłecki wrote:
> Sending with a fixed linux-wireless ML address. Please kindly send your
> replies using linux-wireless@
>
> On 02/27/2018 11:08 AM, Rafał Miłecki wrote:
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

 From reading the referenced links I understand the hairpin mode is 
causing the packet to be sent back to the device, and the hairpin mode 
is required for MCAST_TO_UCAST, right?

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

As far as I can tell you are correct that the 802.11f amendment was 
never adopted into the 802.11 standard. I will ask internally if we 
still have a reason for carrying it in our firmware.

Regards,
Arend
