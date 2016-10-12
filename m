Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36450 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933938AbcJLTIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 15:08:44 -0400
Received: by mail-lf0-f46.google.com with SMTP id b75so90085925lfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2016 12:08:43 -0700 (PDT)
Subject: Re: TCP data throughput for BCM43362
To: =?UTF-8?Q?J=c3=b6rg_Krause?= <joerg.krause@embedded.rocks>
References: <1470429980.29489.10.camel@embedded.rocks>
 <CAF7Mx6o+WuQqtzuApMWQ8YAkLSX7xQ_H06xmO--RxFdwHwzLdQ@mail.gmail.com>
 <1BCE83A1-AA47-438D-BC47-05AE53D40121@embedded.rocks>
 <CA+8PC_f7VQMwBfQmZZ_vUtYtNJKVYzmFmxziAwoG8-iRUeW9Jw@mail.gmail.com>
 <1470492734.2120.0.camel@embedded.rocks>
 <6cdbbae7-8a56-6778-e886-68eeea7add15@broadcom.com>
 <1471873052.1683.27.camel@embedded.rocks>
 <40d15186-6ddf-a210-03de-2bbe21957f1d@broadcom.com>
 <1472505309.21429.3.camel@embedded.rocks>
 <1473860503.19492.19.camel@embedded.rocks>
 <27e007ed-57f6-4082-2f65-a11ba3b7f548@broadcom.com>
 <1474266984.7448.1.camel@embedded.rocks>
 <64180601-8d99-09fe-2db5-06c4ed7dd5d6@broadcom.com>
 <1474548738.11992.2.camel@embedded.rocks>
 <CAF7Mx6q+B4RoURNF5XxewjF9aVGCXg==XU0aDD6w+354yXZ70Q@mail.gmail.com>
 <F306F99A-DCEC-4C28-8805-AE0BA50D485F@embedded.rocks>
 <01642203-65dc-3b44-bbd4-2585bfdab15e@broadcom.com>
 <1476282457.1492.8.camel@embedded.rocks>
Cc: brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c571ac91-ccd1-5e98-317f-eb3e56ad6b58@broadcom.com> (sfid-20161012_210848_431209_74C49FF1)
Date: Wed, 12 Oct 2016 21:08:38 +0200
MIME-Version: 1.0
In-Reply-To: <1476282457.1492.8.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-10-16 16:27, Jörg Krause wrote:
> On Mi, 2016-10-12 at 10:11 +0200, Arend Van Spriel wrote:
>> On 11-10-2016 8:14, Jörg Krause wrote:
>>>
>>>
>>>
>>> Hi Arend,
>>>
>>> Am 22. September 2016 16:00:36 MESZ, schrieb Arend Van Spriel <aren
>>> d.vanspriel@broadcom.com>:
>>>>
>>>> Op 22 sep. 2016 14:52 schreef "Jörg Krause"
>>>> <joerg.krause@embedded.rocks>:
>>>>>
>>>>>
>>>>> On Do, 2016-09-22 at 10:09 +0200, Arend Van Spriel wrote:
>>>>>>
>>>>>> On 19-9-2016 8:36, Jörg Krause wrote:
>>>>>>>
>>>>>>>
>>>>>>> Hi Arend,
>>>>>>>
>>>>>>> On Wed, 2016-09-14 at 20:13 +0200, Arend Van Spriel wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 14-9-2016 15:41, Jörg Krause wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> On Mon, 2016-08-29 at 23:15 +0200, Jörg Krause wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On Mi, 2016-08-24 at 20:35 +0200, Arend Van Spriel
>>>>>>>>>> wrote:
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> On 22-8-2016 15:37, Jörg Krause wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Hi all,
>>>>>>>>>>>>
>>>>>>>>>>>> I am back from vacation and I'd like to do more
>>>>>>>>>>>> investigations
>>>>>>>>>>>> about
>>>>>>>>>>>> this issue. Please see my comments below...
>>>>>>>>>>>>
>>>>>>>>>>>> On Sun, 2016-08-07 at 13:41 +0200, Arend van
>>>>>>>>>>>> Spriel
>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 06-08-16 16:12, Jörg Krause wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Hi all,
>>>>>>>>>>>>>
>>>>>>>>>>>>> A bit weird email format making it a bit hard
>>>>>>>>>>>>> to
>>>>>>>>>>>>> determine
>>>>>>>>>>>>> where
>>>>>>>>>>>>> your
>>>>>>>>>>>>> last reply starts...
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On Fr, 2016-08-05 at 17:56 -0700, Franky Lin
>>>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On Fri, Aug 5, 2016 at 2:29 PM, Jörg Krause
>>>>>>>>>>>>>> <joerg.krause
>>>>>>>>>>>>>> @emb
>>>>>>>>>>>>>> ed
>>>>>>>>>>>>>> ded.
>>>>>>>>>>>>>> ro
>>>>>>>>>>>>>> cks>
>>>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Am 5. August 2016 23:01:10 MESZ, schrieb
>>>>>>>>>>>>>> Arend Van
>>>>>>>>>>>>>> Spriel
>>>>>>>>>>>>>> <
>>>>>>>>>>>>>> arend.vanspriel@broadcom.com>:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Op 5 aug. 2016 22:46 schreef "Jörg Krause"
>>>>>>>>>>>>>> <joerg.krause@embedded.rocks>:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I'm using a custom ARM board with an BCM43362
>>>>>>>>>>>>>> wifi
>>>>>>>>>>>>>> chip
>>>>>>>>>>>>>> from
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Broadcom.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The wifi chip is attached via SDIO to the
>>>> controller
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> with
>>>>>>>>>>>>>> a
>>>>>>>>>>>>>> clock of
>>>>>>>>>>>>>> 48MHz. Linux kernel version is 4.7.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> When measuring the network bandwidth with
>>>>>>>>>>>>>> iperf3 I
>>>>>>>>>>>>>> get a
>>>>>>>>>>>>>> bandwith of
>>>>>>>>>>>>>> only around 5 Mbps. I found a similar thread
>>>>>>>>>>>>>> at the
>>>>>>>>>>>>>> Broadcom
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> community
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> [1] where the test was done with a M4 CPU +
>>>> BCM43362
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> and
>>>>>>>>>>>>>> an
>>>>>>>>>>>>>> average
>>>>>>>>>>>>>> result of 3.3 Mbps.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Interestingly, a BCM43362 Wi-Fi Dev Kit [2]
>>>>>>>>>>>>>> notes a
>>>>>>>>>>>>>> TCP
>>>>>>>>>>>>>> data
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> throughput
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> greater than 20 Mbps.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Why is the throughput I measured much lower?
>>>>>>>>>>>>>> Note
>>>>>>>>>>>>>> that I
>>>>>>>>>>>>>> measured
>>>>>>>>>>>>>> several times with almost no neighbor devices
>>>>>>>>>>>>>> or
>>>>>>>>>>>>>> networks.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> This is a test sample measured with iperf3:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>     $ iperf3 -c 192.168.2.1 -i 1 -t 10
>>>>>>>>>>>>>>     Connecting to host 192.168.2.1, port 5201
>>>>>>>>>>>>>>     [  4] local 192.168.2.155 port 36442
>>>>>>>>>>>>>> connected
>>>> to
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 192.168.2.1
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> port
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>     5201
>>>>>>>>>>>>>>     [ ID]
>>>>>>>>>>>>>> Interval           Transfer     Bandwidth    
>>>>>>>>>>>>>>   
>>>> Retr
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>  Cwn
>>>>>>>>>>>>>> d
>>>>>>>>>>>>>>     [  4]   0.00-1.00   sec   615
>>>>>>>>>>>>>> KBytes  5.04
>>>>>>>>>>>>>> Mbits/sec    0   56.6
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   1.00-2.00   sec   622
>>>>>>>>>>>>>> KBytes  5.10
>>>>>>>>>>>>>> Mbits/sec    0   84.8
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   2.00-3.00   sec   625
>>>>>>>>>>>>>> KBytes  5.12
>>>>>>>>>>>>>> Mbits/sec    0    113
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   3.00-4.00   sec   571
>>>>>>>>>>>>>> KBytes  4.68
>>>>>>>>>>>>>> Mbits/sec    0    140
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   4.00-5.00   sec   594
>>>>>>>>>>>>>> KBytes  4.87
>>>>>>>>>>>>>> Mbits/sec    0    167
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   5.00-6.00   sec   628
>>>>>>>>>>>>>> KBytes  5.14
>>>>>>>>>>>>>> Mbits/sec    0    195
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   6.00-7.00   sec   619
>>>>>>>>>>>>>> KBytes  5.07
>>>>>>>>>>>>>> Mbits/sec    0    202
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   7.00-8.00   sec   608
>>>>>>>>>>>>>> KBytes  4.98
>>>>>>>>>>>>>> Mbits/sec    0    202
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   8.00-9.00   sec   602
>>>>>>>>>>>>>> KBytes  4.93
>>>>>>>>>>>>>> Mbits/sec    0    202
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     [  4]   9.00-10.00  sec   537
>>>>>>>>>>>>>> KBytes  4.40
>>>>>>>>>>>>>> Mbits/sec    0    202
>>>>>>>>>>>>>>     KBytes
>>>>>>>>>>>>>>     - - - - - - - - - - - - - - - - - - - - -
>>>>>>>>>>>>>> - - -
>>>> -
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>     [ ID]
>>>>>>>>>>>>>> Interval           Transfer     Bandwidth    
>>>>>>>>>>>>>>   
>>>> Retr
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>     [  4]   0.00-10.00  sec  5.88
>>>>>>>>>>>>>> MBytes  4.93
>>>>>>>>>>>>>>     Mbits/sec    0             sender
>>>>>>>>>>>>>>     [  4]   0.00-10.00  sec  5.68
>>>>>>>>>>>>>> MBytes  4.76
>>>>>>>>>>>>>>     Mbits/sec                  receiver
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Not overly familiar with iperf3. Do these
>>>>>>>>>>>>>> lines
>>>> mean
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> you
>>>>>>>>>>>>>> are
>>>>>>>>>>>>>> doing
>>>>>>>>>>>>>> bidirectional test, ie. upstream and
>>>>>>>>>>>>>> downstream at
>>>>>>>>>>>>>> the
>>>>>>>>>>>>>> same
>>>>>>>>>>>>>> time.
>>>>>>>>>>>>>> Another
>>>>>>>>>>>>>> thing affecting tput could be power-save.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> No, iperf3 does not support bidrectional
>>>>>>>>>>>>>> test.
>>>> Power-
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> save
>>>>>>>>>>>>>> is
>>>>>>>>>>>>>> turned
>>>>>>>>>>>>>> off.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> What does iw link say?
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> but I guess it starts here!
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I compared the results with a Cubietruck I
>>>>>>>>>>>>>> have:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> # iperf3 -s
>>>>>>>>>>>>>> -------------------------------------------
>>>>>>>>>>>>>> --------
>>>>>>>>>>>>>> ----
>>>>>>>>>>>>>> ----
>>>>>>>>>>>>>> Server listening on 5201
>>>>>>>>>>>>>> -------------------------------------------
>>>>>>>>>>>>>> --------
>>>>>>>>>>>>>> ----
>>>>>>>>>>>>>> ----
>>>>>>>>>>>>>> Accepted connection from 192.168.178.46, port
>>>>>>>>>>>>>> 42906
>>>>>>>>>>>>>> [  5] local 192.168.178.38 port 5201
>>>>>>>>>>>>>> connected to
>>>>>>>>>>>>>> 192.168.178.46
>>>>>>>>>>>>>> port
>>>>>>>>>>>>>> 42908
>>>>>>>>>>>>>> [ ID]
>>>>>>>>>>>>>> Interval           Transfer     Bandwidth
>>>>>>>>>>>>>> [  5]   0.00-1.00   sec  2.29 MBytes  19.2
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   1.00-2.00   sec  2.21 MBytes  18.5
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   2.00-3.00   sec  2.17 MBytes  18.2
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   3.00-4.00   sec  2.09 MBytes  17.6
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   4.00-5.00   sec  2.20 MBytes  18.5
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   5.00-6.00   sec  2.64 MBytes  22.1
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   6.00-7.00   sec  2.67 MBytes  22.4
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   7.00-8.00   sec  2.62 MBytes  22.0
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   8.00-9.00   sec  2.35 MBytes  19.8
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]   9.00-10.00  sec  2.30 MBytes  19.3
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> [  5]  10.00-10.03  sec  83.4 KBytes  23.5
>>>>>>>>>>>>>> Mbits/sec
>>>>>>>>>>>>>> - - - - - - - - - - - - - - - - - - - - - - -
>>>>>>>>>>>>>> - -
>>>>>>>>>>>>>> [ ID]
>>>>>>>>>>>>>> Interval           Transfer     Bandwidth    
>>>>>>>>>>>>>>   
>>>> Retr
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> [  5]   0.00-10.03  sec  23.9 MBytes  20.0
>>>>>>>>>>>>>> Mbits/sec    0             sender
>>>>>>>>>>>>>> [  5]   0.00-10.03  sec  23.6 MBytes  19.8
>>>>>>>>>>>>>> Mbits/sec                  receiver
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> # iw dev wlan0 link
>>>>>>>>>>>>>> Connected to xx:xx:xx:xx:xx (on wlan0)
>>>>>>>>>>>>>>       SSID: xxx
>>>>>>>>>>>>>>       freq: 2437
>>>>>>>>>>>>>>       tx bitrate: 65.0 MBit/s
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>       bss flags:      short-preamble short-
>>>>>>>>>>>>>> slot-
>>>>>>>>>>>>>> time
>>>>>>>>>>>>>>       dtim period:    1
>>>>>>>>>>>>>>       beacon int:     100
>>>>>>>>>>>>>
>>>>>>>>>>>>> Too bad RSSI is not in the output above. That
>>>>>>>>>>>>> may be
>>>>>>>>>>>>> due to
>>>>>>>>>>>>> a
>>>>>>>>>>>>> regression
>>>>>>>>>>>>> in our driver which has been fixed by commit
>>>>>>>>>>>>> 94abd778a7bb
>>>>>>>>>>>>> ("brcmfmac:
>>>>>>>>>>>>> add fallback for devices that do not report
>>>>>>>>>>>>> per-chain
>>>>>>>>>>>>> values").
>>>>>>>>>>>>> However,
>>>>>>>>>>>>> the tx bitrate seems within the same range as
>>>>>>>>>>>>> the
>>>> other
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> platform.
>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The Cubietruck works also with the brcmfmac
>>>>>>>>>>>>>> driver.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> May it depend on the NVRAM file?
>>>>>>>>>>>>>
>>>>>>>>>>>>> Not sure. Can you tell me a bit more about the
>>>>>>>>>>>>> custom
>>>>>>>>>>>>> ARM
>>>>>>>>>>>>> board.
>>>>>>>>>>>>> Does
>>>>>>>>>>>>> it
>>>>>>>>>>>>> use the same wifi module as Cubietruck, ie. the
>>>>>>>>>>>>> AMPAK
>>>>>>>>>>>>> AP6210?
>>>>>>>>>>>>> If
>>>>>>>>>>>>> you
>>>>>>>>>>>>> can
>>>>>>>>>>>>> make a wireshark sniff we can check the actual
>>>> bitrate
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> and
>>>>>>>>>>>>> medium
>>>>>>>>>>>>> density in terms of packets. Another thing to
>>>>>>>>>>>>> look at
>>>>>>>>>>>>> is
>>>>>>>>>>>>> the
>>>>>>>>>>>>> SDIO
>>>>>>>>>>>>> host
>>>>>>>>>>>>> controller. In brcmf_sdiod_sgtable_alloc() some
>>>>>>>>>>>>> key
>>>>>>>>>>>>> values
>>>>>>>>>>>>> are
>>>>>>>>>>>>> used
>>>>>>>>>>>>> from
>>>>>>>>>>>>> the host controller. It only logs the number of
>>>> entries
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> of
>>>>>>>>>>>>> the
>>>>>>>>>>>>> scatter-gather table, but could you add the
>>>>>>>>>>>>> other
>>>>>>>>>>>>> values in
>>>>>>>>>>>>> this
>>>>>>>>>>>>> function that are used to determine the number
>>>>>>>>>>>>> of
>>>>>>>>>>>>> entries.
>>>>>>>>>>>>
>>>>>>>>>>>> My board uses the BCM43362 chip solely (no
>>>>>>>>>>>> Bluetooth)
>>>>>>>>>>>> attached to
>>>>>>>>>>>> the
>>>>>>>>>>>> SDIO interface of a NXP i.MX28 processor.
>>>>>>>>>>>>
>>>>>>>>>>>> I added some additional printk() to
>>>>>>>>>>>> brcmf_sdiod_sgtable_alloc().
>>>>>>>>>>>> These
>>>>>>>>>>>> are the values printed after modprobe brcmfmac:
>>>>>>>>>>>>
>>>>>>>>>>>> [    8.926657] sg_support=1
>>>>>>>>>>>> [    8.929440] max_blocks=511
>>>>>>>>>>>> [    8.932213] max_request_size=261632
>>>>>>>>>>>> [    8.935741] max_segment_count=52
>>>>>>>>>>>> [    8.939005] max_segment_size=65280
>>>>>>>>>>>> [    8.946095] nents=35
>>>>>>>>>>>
>>>>>>>>>>> Thanks. That looks good.
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Additionally I attached a xz compresses wireshark
>>>>>>>>>>>> sniff
>>>>>>>>>>>> while
>>>>>>>>>>>> running
>>>>>>>>>>>> iper3 between the BCM43362 running as in AP mode
>>>>>>>>>>>> with
>>>>>>>>>>>> iperf3
>>>>>>>>>>>> as a
>>>>>>>>>>>> server and a PC in station mode running iperf3 as
>>>>>>>>>>>> a
>>>>>>>>>>>> client.
>>>>>>>>>>>
>>>>>>>>>>> Looking at the sniff it seems you captured on the
>>>> ethernet
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> side.
>>>>>>>>>>> That
>>>>>>>>>>> does not give me any 802.11 specific info. Can you
>>>>>>>>>>> make a
>>>>>>>>>>> wireless
>>>>>>>>>>> capture preferably without encryption.
>>>>>>>>>>
>>>>>>>>>> You,re right! Sorry for this mistake. I did a re-
>>>>>>>>>> capture on
>>>>>>>>>> the
>>>>>>>>>> wireless side now.
>>>>>>>>>
>>>>>>>>> Anything new about this? Anything I can do to help?
>>>>>>>>
>>>>>>>> I missed your previous email. Was already wondering
>>>>>>>> whether to
>>>>>>>> ping
>>>>>>>> you.
>>>>>>>> Digging around in my email folders I found it so will
>>>>>>>> take a
>>>> look
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> at
>>>>>>>> it.
>>>>>>>
>>>>>>> Did you had some time to look at this?
>>>>>>
>>>>>> Ehm. I still only see TCP stuff. To capture 802.11 management
>>>> frames
>>>>>
>>>>>>
>>>>>> you
>>>>>> need preferably a dedicated device using monitor mode [1].
>>>>>
>>>>> Stupid me! Now I used a monitor interface on a desktop to
>>>>> monitor the
>>>>> traffic between the BCM43362 operating in soft-AP mode and a
>>>>> notebook
>>>>> operating in managed mode.
>>>>>
>>>>> The BCM43362 runs the iperf server, the notebook the iperf
>>>>> client.
>>>>
>>>> Thanks.
>>>>
>>>> Week almost through so might next week.
>>>
>>> Did you had some time to look at this?
>>
>> So the bcm43362 is your AP and running iperf server.
> 
> It is running the iperf server. It is running in station mode as well
> as in AP mode, depending on the use case. The wireshark dump was taken
> when the bcm43362 is operating in AP mode.
> 
>> What specs does the ARM on your custom board have?
> 
> Which specs do you mean?
> 
>> The trace shows that it does not do
>> aggregation. What it does not show is whether A-MPDU was setup, ie.
>> ADDBA message exchange. So could you create a similar capture
>> including
>> connection setup, ie. AUTH/ASSOC, etc.
> 
> Yes, I can do that. Note, that I am using wpa_supplicant 2.5 for AP
> mode operation (not hostapd).

ok. unchartered territory for me. In the beacon frame I see

.... ..01 = Maximum Rx A-MPDU Length: 0x1 (16383[Bytes])
...1 10.. = MPDU Density: 8 [usec] (0x6)

In the trace it is only ~1500 bytes so no A-MPDU. What device is in the
notebook? Can you use 'iw list' there to obtain info.

>> Just to confirm. You are using the firmware from linux-firmware,
>> right?
> 
> Right.
> 
>> Or are you using firmware from the wiced dev kit?
> 
> No. I guess you mean bcmdhd?

You referred to 20 Mbps claim on wiced dev kit page at mouser so I
assumed you were using that and it includes firmware. As you confirmed
using firmware from linux-firmware repo this question does not matter.

Regards,
Arend

> Best regards
> Jörg Krause
> 
