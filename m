Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:40074 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbeCWHyF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 03:54:05 -0400
Received: by mail-wm0-f51.google.com with SMTP id t6so1820874wmt.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Mar 2018 00:54:05 -0700 (PDT)
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
References: <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain>
 <20180103113540.GA10306@redhat.com>
 <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com> <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com> <20180307122935.GB10584@redhat.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me> (sfid-20180323_085410_370883_AAD59889)
Date: Fri, 23 Mar 2018 08:51:40 +0100
MIME-Version: 1.0
In-Reply-To: <20180307122935.GB10584@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

07.03.2018 13:29, Stanislaw Gruszka:
> I forgot to attach the patches, do it now.
> 
> On Wed, Mar 07, 2018 at 01:27:01PM +0100, Stanislaw Gruszka wrote:
>> On Thu, Mar 01, 2018 at 04:30:10PM +0100, Daniel Golle wrote:
>>> [forwarding to all other involved players]
>>>
>>> On Thu, Mar 01, 2018 at 05:50:51PM +0300, Jamie Stuart wrote:
>>>> Hi Daniel,
>>>> The driver seems much improved after this fix.
>>>
>>> it's about those two
>>> [PATCH 1/2] rt2x00: pause almost full queue early
>>> [PATCH 2/2] rt2x00: do not pause queue unconditionally on error path
>>>
>>>> Under very heavy load (30 clients downloading multi-GB files from SD card on the server concurrently), wifi dies with errors:
>>
>> This is some testbed? Could you share how did you setup such
>> environment and what are client devices ?
>>
>>>> [ 7794.230376] ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010c, type=4
>>
>> This is indicator that HW/FW has a problem. There could be various
>> reasons for that. One possible I can also observe in my setup,is strange
>> mishmash of seq  on frames which were not acked in BlockACK and
>> had to be resent. This can happen when many frames are wrongly decoded
>> (i.e. when there is bad radio condition or we have not correct low level
>> RF/BBP setup for a Ralink device). To mitigate that problem we can
>> limit length of agreggeted AMPDU frame.
>>
>> I attached two patches which do that. One for RX side second for TX side.
>> Please check if they make a diffrent. You can also hardcode ba_size = 0
>> for those 30 clients setup.
>>
>> Note the patches can cause (possibly small) perfromance degradation on
>> good setups.
>>
>> Mathias, could you check them as well and see if they do not cause
>> performance regression on your device ? Lastly when I changed ba_size
>> setting, it was a problem on your setup.

Hey Stansilaw,

sorry for the delayed testing. I had to create a new test setup first, 
fought with buggy hardware and was busy with other stuff.

The two attached patches are causing a performance regression for me again:

OpenWrt head (forced HT40, 100Mbit wired interface)

wireless (iperf client) to wired (iperf server)
   Interval           Transfer     Bitrate         Retr
     0.00-60.00  sec   584 MBytes  81.6 Mbits/sec  666           sender
     0.00-60.00  sec   584 MBytes  81.6 Mbits/sec                receiver

wired (iperf client) to wireless (iperf server)
   Interval           Transfer     Bitrate         Retr
     0.00-60.00  sec   620 MBytes  86.7 Mbits/sec   33           sender
     0.00-60.00  sec   617 MBytes  86.2 Mbits/sec                receiver



OpenWrt head (forced HT40, 100Mbit wired interface)
   + rt2800_change_rx_ampdu_factor.patch
   + rt2800_change_ba_size.patch

wireless (iperf client) to wired (iperf server)
   Interval           Transfer     Bitrate         Retr
     0.00-60.00  sec   356 MBytes  49.8 Mbits/sec    6           sender
     0.00-60.00  sec   356 MBytes  49.7 Mbits/sec                receiver

wired (iperf client) to wireless (iperf server)
   Interval           Transfer     Bitrate         Retr
     0.00-60.00  sec   627 MBytes  87.7 Mbits/sec    5           sender
     0.00-60.00  sec   626 MBytes  87.5 Mbits/sec                receiver


Due to the regression I haven't tested your ampdu_density patch so far. 
Let me hear if you want to see more tests done.

Mathias
