Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57604 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751469AbeCMHUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 03:20:05 -0400
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Cc: Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
Message-ID: <c24304cf-7e0d-137a-94b1-d8f4e61a3b70@nbd.name> (sfid-20180313_082011_952633_BF47A69B)
Date: Tue, 13 Mar 2018 08:20:01 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resent with fixed typo in linux-wireless address]

On 2018-02-27 11:08, Rafał Miłecki wrote:
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
Let's look at it from a different angle: Since these packets are
forwarded as normal packets by the bridge, and the Broadcom firmware
reacts to them in this nasty way, that's basically local DoS security
issue. In my opinion that matters a lot more than having support for an
obsolete feature that almost nobody will ever want to use.

I think the right approach to deal with this issue is to drop these
garbage packets in both the receive and transmit path of brcmfmac.

- Felix
