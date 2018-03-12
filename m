Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:42862 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeCLLsR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 07:48:17 -0400
Date: Mon, 12 Mar 2018 12:48:15 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com
Subject: Re: Problem with bridge (mcast-to-ucast + hairpin) and Broadcom's
 802.11f in their FullMAC fw
Message-ID: <20180312114815.GN2470@otheros> (sfid-20180312_124821_319010_9E673A8C)
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <20180312110856.GL2470@otheros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180312110856.GL2470@otheros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 12, 2018 at 12:08:56PM +0100, Linus Lüssing wrote:
> On Tue, Feb 27, 2018 at 11:08:20AM +0100, Rafał Miłecki wrote:
> > I've problem when using OpenWrt/LEDE on a home router with Broadcom's
> > FullMAC WiFi chipset.
> 
> Hi Rafał,
> 
> Thanks for reporting this issue!
> 
> > Can you see any solution for this problem? Is that an option to stop
> > multicast-to-unicast from touching 802.11f packets? Some other ideas?
> > Obviously I can't modify Broadcom's firmware and drop that obsoleted
> > standard.
> 
> Just to avoid some potential confusion: This is more an issue of
> hairpinning than it is an issue of multicast-to-unicast per se,
> right?
> 
> That is, if you set this to 0 manually:
> /sys/class/net/<ap-iface>/brport/multicast_to_unicast
> Then the issue still occurs, right?

Btw., if in OpenWRT/LEDE you set 'option multicast_to_unicast 0'
in /etc/config/network for the bridge (and not bridge port)
then netifd should refrain from setting the bridge hairpinning and
AP isolation on wireless devices, too, if I remember correctly.

Can you confirm that the issue disappears for you then?
