Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33630 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeB0KOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 05:14:30 -0500
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
To: =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
Cc: Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <88d080df-4cce-98d1-6482-0408a3dcb015@gmail.com> (sfid-20180227_111438_676335_0C24F3A8)
Date: Tue, 27 Feb 2018 11:14:26 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending with a fixed linux-wireless ML address. Please kindly send your
replies using linux-wireless@

On 02/27/2018 11:08 AM, Rafał Miłecki wrote:
> I've problem when using OpenWrt/LEDE on a home router with Broadcom's
> FullMAC WiFi chipset.
>
>
> First of all OpenWrt/LEDE uses bridge interface for LAN network with:
> 1) IFLA_BRPORT_MCAST_TO_UCAST
> 2) Clients isolation in hostapd
> 3) Hairpin mode enabled
>
> For more details please see Linus's patch description:
> https://patchwork.kernel.org/patch/9530669/
> and maybe hairpin mode patch:
> https://lwn.net/Articles/347344/
>
> Short version: in that setup packets received from a bridged wireless
> interface can be handled back to it for transmission.
>
>
> Now, Broadcom's firmware for their FullMAC chipsets in AP mode
> supports an obsoleted 802.11f AKA IAPP standard. It's a roaming
> standard that was replaced by 802.11r.
>
> Whenever a new station associates, firmware generates a packet like:
> ff ff ff ff  ff ff ec 10  7b 5f ?? ??  00 06 00 01  af 81 01 00
> (just masked 2 bytes of my MAC)
>
> For mode details you can see discussion in my brcmfmac patch thread:
> https://patchwork.kernel.org/patch/10191451/
>
>
> The problem is that bridge (in setup as above) handles such a packet
> back to the device.
>
> That makes Broadcom's FullMAC firmware believe that a given station
> just connected to another AP in a network (which doesn't even exist).
> As a result firmware immediately disassociates that station. It's
> simply impossible to connect to the router. Every association is
> followed by immediate disassociation.
>
>
> Can you see any solution for this problem? Is that an option to stop
> multicast-to-unicast from touching 802.11f packets? Some other ideas?
> Obviously I can't modify Broadcom's firmware and drop that obsoleted
> standard.
