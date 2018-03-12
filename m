Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:33352 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932265AbeCLVwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 17:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <20180312114815.GN2470@otheros>
References: <CACna6rz9L09g9oeHhvt209Tg1E3gKgmhGnYF653AdkXfZf=4kw@mail.gmail.com>
 <20180312110856.GL2470@otheros> <20180312114815.GN2470@otheros>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 12 Mar 2018 22:52:15 +0100
Message-ID: <CACna6ryTv0XOREodnERjA4irX0_XdoG95bjQVShqDC+BA3fRLQ@mail.gmail.com> (sfid-20180312_225224_180253_0F3B5A74)
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

On 12 March 2018 at 12:48, Linus L=C3=BCssing <linus.luessing@c0d3.blue> wr=
ote:
> On Mon, Mar 12, 2018 at 12:08:56PM +0100, Linus L=C3=BCssing wrote:
>> On Tue, Feb 27, 2018 at 11:08:20AM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> > I've problem when using OpenWrt/LEDE on a home router with Broadcom's
>> > FullMAC WiFi chipset.
>>
>> Hi Rafa=C5=82,
>>
>> Thanks for reporting this issue!
>>
>> > Can you see any solution for this problem? Is that an option to stop
>> > multicast-to-unicast from touching 802.11f packets? Some other ideas?
>> > Obviously I can't modify Broadcom's firmware and drop that obsoleted
>> > standard.
>>
>> Just to avoid some potential confusion: This is more an issue of
>> hairpinning than it is an issue of multicast-to-unicast per se,
>> right?
>>
>> That is, if you set this to 0 manually:
>> /sys/class/net/<ap-iface>/brport/multicast_to_unicast
>> Then the issue still occurs, right?
>
> Btw., if in OpenWRT/LEDE you set 'option multicast_to_unicast 0'
> in /etc/config/network for the bridge (and not bridge port)
> then netifd should refrain from setting the bridge hairpinning and
> AP isolation on wireless devices, too, if I remember correctly.
>
> Can you confirm that the issue disappears for you then?

Yes, absolutely. This reverts OpenWrt/LEDE to the old setup (no
mcast-to-ucast + hairpin) and it works. I was hoping we can make
mcast-to-ucast + hairpin work with Broadcom's 802.11f however instead
of moving OpenWrt/LEDE back to the old setup.

--=20
Rafa=C5=82
