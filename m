Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:56448 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab3GLSCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 14:02:35 -0400
Received: by mail-qe0-f42.google.com with SMTP id s14so5292600qeb.29
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jul 2013 11:02:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3019FFE28@HASMSX103.ger.corp.intel.com>
References: <51BBF4F1.1050301@newportit.com> <51DCDD54.9090100@newportit.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3019FFDDF@HASMSX103.ger.corp.intel.com>
 <51DCF4BF.5010900@newportit.com> <0BA3FCBA62E2DC44AF3030971E174FB3019FFE28@HASMSX103.ger.corp.intel.com>
From: Mariano Aliaga <marianoaliaga@gmail.com>
Date: Fri, 12 Jul 2013 15:02:04 -0300
Message-ID: <CAGLHXEnKS-Yz4uia=-KW7HLYUZ9nt_Pba_ZDyfEoehWGaHsUmg@mail.gmail.com> (sfid-20130712_200238_338205_9AE6518A)
Subject: Re: [Ilw] Re: Slow throughput on Ultimate-N 6300
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Steve Freitas <steve@newportit.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

On Wed, Jul 10, 2013 at 2:55 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>>
>> Emmanuel,
>>
>> Thank you for your quick response!
>>
>> It is a regression. I regularly had 300 Mbps speeds on this very access point,
>> but it was years ago, in the 2.6 kernel series. However, I believe, from
>> extensive online searches, that Intel has disabled the N functionality in the
>> firmware on Linux, ostensibly until they (you? :-)
>> ) can fix whatever problem they were seeing. With the demise of the Intel
>> Linux Wireless bug tracker, though, public tracking of the bug has been
>> impossible. There are now-dead links to the defunct bug tracker over this
>> very issue.
>>
>
> 11n hasn't been disabled in firmware, but rather in driver.
> There is a bug we know about the "fail to flush tx fifo" thing that people reports (through mailing list or bugzilla of RedHat).
> Can you please send the output of the kerne log (dmesg)?
>

   I've been also experiencing the "fail to flush tx fifo" bug for a
long time, so I'll provide my environment and logs in case it's
helpful:

   - System: Thinkpad T410
   - Chipset: Intel Corporation Centrino Advanced-N 6200 [8086:4239] (rev 35)
   - Kernel: 3.10.0 x86_64 (tried 3.2, 3.5, 3.8 and 3.9 also. It got a
lot better on 3.10 btw)
   - Firmware: 9.221.4.1 build 25532
   - AP: Linksys E1200 fw ver 1.0.00 build 11 (but happens also with
other N AP's)
   - Log on dmesg: this repeated 12 times when I booted and connected
to my wifi network

[   19.576029] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0
[   19.576039] iwlwifi 0000:03:00.0: Current SW read_ptr 3 write_ptr 4
[   19.576089] iwl data: 00000000: 08 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00  ................
[   19.576125] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[   19.576183] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x80102004
[   19.576196] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[   19.576209] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300003
[   19.576222] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[   19.576235] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[   19.576248] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[   19.576261] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00704040
[   19.576317] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo
3 ra_tid 0x0000 [3,4]
[   19.576373] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo
2 ra_tid 0x0000 [0,0]
[   19.576429] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo
1 ra_tid 0x0000 [4,5]
[   19.576484] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo
0 ra_tid 0x0000 [0,0]
[   19.576540] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo
7 ra_tid 0x0000 [65,65]
[   19.576595] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576651] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576705] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576761] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576815] iwlwifi 0000:03:00.0: Q 9 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576871] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576928] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.576983] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577038] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577094] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577149] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577204] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577261] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577317] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.577372] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[   19.628329] cfg80211: Calling CRDA to update world regulatory domain
[   19.632242] cfg80211: World regulatory domain updated:
[   19.632245] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   19.632247] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   19.632249] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   19.632250] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[   19.632252] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   19.632253] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   23.041735] wlan0: authenticate with 58:6d:8f:c3:47:2e
[   23.068235] wlan0: send auth to 58:6d:8f:c3:47:2e (try 1/3)
[   23.081353] wlan0: authenticated
[   23.082190] wlan0: associate with 58:6d:8f:c3:47:2e (try 1/3)
[   23.085720] wlan0: RX AssocResp from 58:6d:8f:c3:47:2e (capab=0x411
status=0 aid=6)
[   23.091628] wlan0: associated

   This does not always happen, it's kind of random. I think it
happens more frequently in places with a lot of wifi networks
available.
   I'll try with older firmwares as suggested and let you know. I can
provide more info if you need.

TIA

Mariano
