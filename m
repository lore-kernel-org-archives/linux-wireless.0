Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33251 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbeEPKm4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 06:42:56 -0400
Received: by mail-wr0-f196.google.com with SMTP id o4-v6so403077wrm.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 03:42:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5AFBEDD8.8030801@broadcom.com>
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com> <5AFBEDD8.8030801@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 16 May 2018 12:42:53 +0200
Message-ID: <CACna6rzyn=3EmWhcBXu0WGNv3rJ+KdMxvODkgQmVhbcdGRv1jw@mail.gmail.com> (sfid-20180516_124300_403609_BE339D34)
Subject: Re: Research + questions on brcmfmac and support for monitor mode
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 May 2018 at 10:37, Arend van Spriel <arend.vanspriel@broadcom.com> wr=
ote:
> On 5/15/2018 2:29 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>
>> I'm interested in adding support for monitor mode to the brcmfmac. I did
>> some early research on firmware capabilities & behavior using various
>> firmwares I could find for my devices: 43602a1, 4366b1, 4366c0 (BCM4366
>> and BCM4366E).
>
>
> I am interested too and already did some work in this respect.
>
>> I was doing my tests by starting monitor mode with SET_MONITOR ioctl +
>> value 3 and dumping msgbuf RX header + skb data.
>>
>> The good news is that almost every firmware has some minimal support for
>> monitor mode. Unfortunately implementing it may be (a big?) problem.
>>
>> The basic concept is simple. Once we set SET_MONITOR to 3, firmware
>> starts passing up monitor mode frames to the driver.
>
>
> The main issue is that monitor mode was historically made for what we cal=
l
> NIC drivers, ie. driver running on the host so without an active cpu on t=
he
> device. Also monitor functionality is used within the firmware itself by
> other features, which is why most firmwares you have include monitor
> functionality.

Nice to know.

Regarding NIC drivers: that's how I found out about WLC_SET_MONITOR
(by looking at wl_linux.c) and values 1/2/3 (by looking at
wl_monitor()).


> I implemented monitor mode for SDIO devices, but that required firmware
> changes so an explicit firmware target. Unfortunately, for PCIe things ar=
e
> quite different. On SDIO the entire packet is passed to the host, but for
> PCIe the 802.11 part is split from the 802.3 payload.
>
>> The first problem I see is identifying monitor mode frames in order to
>> make brcmfmac pass them to the monitor interface. Monitor frames have
>> msg.ifidx set to 0 which makes them indistinguishable from main
>> interface frames by simply looking at that index field. There is nothing
>> in the msg.rsvd0, compl_hdr.status, rx_status_0 or rx_status_1 fields.
>>
>> Now, some new firmwares have flags set to 0x0002 (instead of 0x0001) for
>> monitor frames. This is very helpful but it only applies to the really
>> recent images.
>>
>> My first question is: is there any reliable way of filtering monitor
>> frames for older firmwares? We could try to reserve ifidx 0 for monitor
>> mode purposes, but I'm afraid I'd require hacking quite some code. Is
>> there any better & simpler solution?
>
>
> Depends what you want. I wanted mainly a dedicated sniffer so only allowi=
ng
> changing the main interface to monitor mode. Not allowing adding a monito=
r
> mode interface.

Oh, then we have a pretty different use cases. I wanted to run AP
interfaces for all the time and periodically add monitor interface to
listen to the air traffic. That's why I need to distinguish monitor
packets from other ones.


>> The second problem is monitor frame format. Older firmwares were simply
>> passing 802.11 frames to the driver. It means passing frame control
>> field, duration, AP MAC, src MAC, dst MAC, sequence + data. There was no
>> info about signal, noise, etc. passed. New firmwares seem to be
>> including radiotap header which makes things much nicer.
>
>
> For the SDIO implementation mentioned I generated radiotap header in
> brcmfmac. I recall that was the intention for the PCIe implementation as
> well, but maybe things changed since then as you managed to get radiotap
> headers on recent firmwares.

The real problem introduced by that PCIe firmware change (adding
radiotap header) is inconsistency. It seems like a format change
introduced without adding a way of discovering which format is being
used.


>> The second question: is there a reliable way of telling what format uses
>> monitor packet passed by a firmware? Is it maybe strictly related to the
>> flags set to 0x0002 (instead of 0x0001)?
>
>
> This is the flags in the msgbuf RXHEADER? That is

struct brcmf_msgbuf *msgbuf;
rx_complete->flags


>> I was hoping that maybe looking at fw-reported capabilities will give me
>> any hint regarding that but I'm afraid I'm out of luck. Below is a list
>> of firmwares I tested and summary of each of them.
>>
>> Note: as every firmware reports following capabilities:
>> 802.11d 802.11h ampdu ampdu_rx ampdu_tx amsdurx amsdutx anqpo ap bcm_dcs
>> bsstrans cac cqa dfrts dwds led mfp p2po probresp_mac_filter pspretend
>> psr psta radio_pwrsave rm rxchain_pwrsave sta stbc-rx-1ss stbc-tx
>> traffic-mgmt traffic-mgmt-dwm vht-prop-rates wds wet wet_tunnel wme wnm
>> I omitted them below.
>
>
> Actually the capability iovar is tricky/broken. It can potentially trunca=
te
> the string so you don't get all the information on the host.
>
> So a question about monitor mode. In hostapd an attempt is made to create=
 a
> monitor interface. Is that no longer done because of you recent patch
> regarding the wiphy flag HAVE_AP_SME?

I didn't test that but that's what I'd expect. Now that hostapd sees
HAVE_AP_SME it shouldn't run into any fallback paths including monitor
mode hacks.

--=20
Rafa=C5=82
