Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751115AbeCZKf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 06:35:56 -0400
Date: Mon, 26 Mar 2018 12:35:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: Daniel Golle <daniel@makrotopia.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180326103551.GA2069@redhat.com> (sfid-20180326_123559_933503_8F2CBC08)
References: <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com>
 <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com>
 <20180307122935.GB10584@redhat.com>
 <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mathias 

> sorry for the delayed testing. I had to create a new test setup
> first, fought with buggy hardware and was busy with other stuff.

Thanks for doing it.

> The two attached patches are causing a performance regression for me again:
> 
> OpenWrt head (forced HT40, 100Mbit wired interface)
> 
> wireless (iperf client) to wired (iperf server)
>   Interval           Transfer     Bitrate         Retr
>     0.00-60.00  sec   584 MBytes  81.6 Mbits/sec  666           sender
>     0.00-60.00  sec   584 MBytes  81.6 Mbits/sec                receiver
> 
> wired (iperf client) to wireless (iperf server)
>   Interval           Transfer     Bitrate         Retr
>     0.00-60.00  sec   620 MBytes  86.7 Mbits/sec   33           sender
>     0.00-60.00  sec   617 MBytes  86.2 Mbits/sec                receiver
> 
> 
> 
> OpenWrt head (forced HT40, 100Mbit wired interface)
>   + rt2800_change_rx_ampdu_factor.patch
>   + rt2800_change_ba_size.patch
> 
> wireless (iperf client) to wired (iperf server)
>   Interval           Transfer     Bitrate         Retr
>     0.00-60.00  sec   356 MBytes  49.8 Mbits/sec    6           sender
>     0.00-60.00  sec   356 MBytes  49.7 Mbits/sec                receiver
> 
> wired (iperf client) to wireless (iperf server)
>   Interval           Transfer     Bitrate         Retr
>     0.00-60.00  sec   627 MBytes  87.7 Mbits/sec    5           sender
>     0.00-60.00  sec   626 MBytes  87.5 Mbits/sec                receiver
> 
> 
> Due to the regression I haven't tested your ampdu_density patch so
> far. Let me hear if you want to see more tests done.

Could you test just RX AMPDU patches, i.e.

rt2800_change_rx_ampdu_factor.patch
rt2800_change_rx_ampdu_density.patch

I have somewhat positive results on RX performance on some devices
with those. Perhaps you could confirm that :-)

Regards
Stanislaw
