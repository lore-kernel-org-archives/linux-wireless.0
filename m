Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37492 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbcC0WnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2016 18:43:12 -0400
Received: by mail-ig0-f181.google.com with SMTP id l20so44970609igf.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2016 15:43:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1860079637.618245.1459097009016.JavaMail.yahoo@mail.yahoo.com>
References: <1860079637.618245.1459097009016.JavaMail.yahoo.ref@mail.yahoo.com>
	<1860079637.618245.1459097009016.JavaMail.yahoo@mail.yahoo.com>
Date: Sun, 27 Mar 2016 15:43:10 -0700
Message-ID: <CAJ-VmokSovVud9yiUoHcCwp+fQv4rVMyAHLOVMau4Egpk3PGUQ@mail.gmail.com> (sfid-20160328_004316_081078_A03E43D7)
Subject: Re: Bonjour mDNS broacast can be lost during BT-WLAN coexistence schemes?
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 March 2016 at 09:43, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Dear Experts,
>
> WiFi-BT Coexistence:
> To let wireless LAN systems coexist with Bluetooth system, a hardware Packet
> Traffic Arbiter (PTA) scheme is used. Here PTA is based on 2-wire
> coexistence , BT_ACTIVE and WL_ACTIVE. When BT wants to use the medium, it
> will assert the BT_ACTIVE line, during which WLAN cannot perform any
> transactions. When WLAN is in client mode, during this assertion period
> waiting for a packet from WLAN router (AP) to be received , WLAN packet will
> be lost !!! Let us call this window during which WiFi being stomped  by BT
> as stomping window. WLAN device in client mode considered here is based on
> AR9287 chipset and let us call this as Apple accessory
>
> Bonjour discovery:
> Apple devices connect to the same WiFi router to which the Apple accessory
> is also connected. Apple device is also connected in WiFi client mode.  In
> order to determine other clients (Apple compatible) in the same network, it
> performs Bonjour discovery which is based on mDNS broadcast.
>
> Concern/Query:-
> The mDNS query is a broadcast query received from Apple device and sent by
> the WiFi AP to the WiFi network (to which the apple accessory is also
> connected) only once. The period of reception of this broadcast query can
> coincide with the stomping window. Hence the broadcast query can be lost by
> Apple accessory. This might result in discovery, pair verify (later) from
> apple devices to fail. Apple devices implement a back-off strategy and as
> per this the next discovery will be after 10s of minutes. During this long
> period the WiFi client based apple accessory will be offline!!!!

> Is the understanding and concern correct? If so, how can this be solved via
> ath9k drivers and/or settings in WiFi AP?

Well, sure. I mean, the bluetooth coexistence code is just designed to
ensure that they stomp predictably and can be controlled. I didn't
think the pair/discovery would take so long though, so I'd go and
figure out what's going on there.

You can set up the weights and stomping preference for controlling
bluetooth and wifi. I think at the moment ath9k (and freebsd) just use
a static weight matrix and prefer bt? I forget.

There's some extensions to 802.11 (802.11aa, at least) which allows
for reliable multicast. That means it gets replicated to each device
that asks for it, and it gets ACKed/retransmitted/etc. I don't know of
anything open source that implements all of that.



-adrian
