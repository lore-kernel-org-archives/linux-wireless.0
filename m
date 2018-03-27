Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:40301 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbeC0HtG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 03:49:06 -0400
Received: by mail-wm0-f48.google.com with SMTP id x4so7485993wmh.5
        for <linux-wireless@vger.kernel.org>; Tue, 27 Mar 2018 00:49:05 -0700 (PDT)
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
References: <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com> <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com> <20180307122935.GB10584@redhat.com>
 <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me>
 <20180326103551.GA2069@redhat.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <24f8f4a2-b355-a1b3-d07a-940fc1e50fcc@kresin.me> (sfid-20180327_094910_961454_8AB24B2E)
Date: Tue, 27 Mar 2018 09:46:36 +0200
MIME-Version: 1.0
In-Reply-To: <20180326103551.GA2069@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

26.03.2018 12:35, Stanislaw Gruszka:
> Hi Mathias
> 
>> sorry for the delayed testing. I had to create a new test setup
>> first, fought with buggy hardware and was busy with other stuff.
> 
> Thanks for doing it.
> 
>> The two attached patches are causing a performance regression for me again:
>>
>> OpenWrt head (forced HT40, 100Mbit wired interface)
>>
>> wireless (iperf client) to wired (iperf server)
>>    Interval           Transfer     Bitrate         Retr
>>      0.00-60.00  sec   584 MBytes  81.6 Mbits/sec  666           sender
>>      0.00-60.00  sec   584 MBytes  81.6 Mbits/sec                receiver
>>
>> wired (iperf client) to wireless (iperf server)
>>    Interval           Transfer     Bitrate         Retr
>>      0.00-60.00  sec   620 MBytes  86.7 Mbits/sec   33           sender
>>      0.00-60.00  sec   617 MBytes  86.2 Mbits/sec                receiver
>>
>>
>>
>> OpenWrt head (forced HT40, 100Mbit wired interface)
>>    + rt2800_change_rx_ampdu_factor.patch
>>    + rt2800_change_ba_size.patch
>>
>> wireless (iperf client) to wired (iperf server)
>>    Interval           Transfer     Bitrate         Retr
>>      0.00-60.00  sec   356 MBytes  49.8 Mbits/sec    6           sender
>>      0.00-60.00  sec   356 MBytes  49.7 Mbits/sec                receiver
>>
>> wired (iperf client) to wireless (iperf server)
>>    Interval           Transfer     Bitrate         Retr
>>      0.00-60.00  sec   627 MBytes  87.7 Mbits/sec    5           sender
>>      0.00-60.00  sec   626 MBytes  87.5 Mbits/sec                receiver
>>
>>
>> Due to the regression I haven't tested your ampdu_density patch so
>> far. Let me hear if you want to see more tests done.
> 
> Could you test just RX AMPDU patches, i.e.
> 
> rt2800_change_rx_ampdu_factor.patch
> rt2800_change_rx_ampdu_density.patch
> 
> I have somewhat positive results on RX performance on some devices
> with those. Perhaps you could confirm that :-)

This time I've done the test with HT20 only, to not annoy my neighbours.

The test setup is the following:

ath9k (STA) <=> (AP) o2 Box 6431 (RJ45) <=> desktop

With the patches applied the bandwidth is somewhat around 10 MBit/sec 
lower. Even if I was able to reliable reproduce it, I'm not sure if it 
is within the measuring tolerance.


OpenWrt head

   mkresin@desktop ~ $ iperf3 -c 192.168.1.156
   Connecting to host 192.168.1.156, port 5201
   Interval           Transfer     Bandwidth       Retr
     0.00-10.00  sec  89.5 MBytes  75.0 Mbits/sec    1           sender
     0.00-10.00  sec  88.2 MBytes  74.0 Mbits/sec                receiver

   mkresin@desktop ~ $ iperf3 -c 192.168.1.156 -R
   Connecting to host 192.168.1.156, port 5201
   Reverse mode, remote host 192.168.1.156 is sending
   Interval           Transfer     Bandwidth       Retr
     0.00-10.00  sec  70.8 MBytes  59.4 Mbits/sec    0           sender
     0.00-10.00  sec  70.5 MBytes  59.1 Mbits/sec                receiver

OpenWrt head
  + rt2800_change_rx_ampdu_factor.patch
  + rt2800_change_rx_ampdu_density.patch

mkresin@desktop ~ $ iperf3 -c 192.168.1.156
   Connecting to host 192.168.1.156, port 5201
   Interval           Transfer     Bandwidth       Retr
     0.00-10.00  sec  78.2 MBytes  65.6 Mbits/sec    0           sender
     0.00-10.00  sec  77.1 MBytes  64.7 Mbits/sec                receiver

mkresin@desktop ~ $ iperf3 -c 192.168.1.156 -R
   Connecting to host 192.168.1.156, port 5201
   Reverse mode, remote host 192.168.1.156 is sending
   Interval           Transfer     Bandwidth       Retr
     0.00-10.00  sec  51.8 MBytes  43.5 Mbits/sec    1           sender
     0.00-10.00  sec  51.7 MBytes  43.3 Mbits/sec                receiver

Mathias
