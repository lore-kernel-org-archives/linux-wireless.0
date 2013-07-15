Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49939 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3GOP1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 11:27:20 -0400
Received: by mail-oa0-f54.google.com with SMTP id o6so15910873oag.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jul 2013 08:27:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGLHXEnKS-Yz4uia=-KW7HLYUZ9nt_Pba_ZDyfEoehWGaHsUmg@mail.gmail.com>
References: <51BBF4F1.1050301@newportit.com>
	<51DCDD54.9090100@newportit.com>
	<0BA3FCBA62E2DC44AF3030971E174FB3019FFDDF@HASMSX103.ger.corp.intel.com>
	<51DCF4BF.5010900@newportit.com>
	<0BA3FCBA62E2DC44AF3030971E174FB3019FFE28@HASMSX103.ger.corp.intel.com>
	<CAGLHXEnKS-Yz4uia=-KW7HLYUZ9nt_Pba_ZDyfEoehWGaHsUmg@mail.gmail.com>
Date: Mon, 15 Jul 2013 18:27:19 +0300
Message-ID: <CANUX_P1e6h0Gv79P2njxRndyE8mCKy48tk62DD9QnrzCTrdp9g@mail.gmail.com> (sfid-20130715_172723_819543_AF4480D4)
Subject: Re: [Ilw] Re: Slow throughput on Ultimate-N 6300
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Mariano Aliaga <marianoaliaga@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Steve Freitas <steve@newportit.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mariano,

>    I've been also experiencing the "fail to flush tx fifo" bug for a
> long time, so I'll provide my environment and logs in case it's
> helpful:
>
>    - System: Thinkpad T410
>    - Chipset: Intel Corporation Centrino Advanced-N 6200 [8086:4239] (rev 35)
>    - Kernel: 3.10.0 x86_64 (tried 3.2, 3.5, 3.8 and 3.9 also. It got a
> lot better on 3.10 btw)
>    - Firmware: 9.221.4.1 build 25532
>    - AP: Linksys E1200 fw ver 1.0.00 build 11 (but happens also with
> other N AP's)
>    - Log on dmesg: this repeated 12 times when I booted and connected
> to my wifi network
>
> [   19.576029] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0
> [   19.576039] iwlwifi 0000:03:00.0: Current SW read_ptr 3 write_ptr 4
> [   19.576089] iwl data: 00000000: 08 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00  ................
> [   19.576125] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
> [   19.576183] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x80102004
> [   19.576196] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
> [   19.576209] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300003
> [   19.576222] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
> [   19.576235] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
> [   19.576248] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
> [   19.576261] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x00704040
> [   19.576317] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo
> 3 ra_tid 0x0000 [3,4]
> [   19.576373] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo
> 2 ra_tid 0x0000 [0,0]
> [   19.576429] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo
> 1 ra_tid 0x0000 [4,5]
> [   19.576484] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo
> 0 ra_tid 0x0000 [0,0]
> [   19.576540] iwlwifi 0000:03:00.0: Q 4 is active and mapped to fifo
> 7 ra_tid 0x0000 [65,65]
> [   19.576595] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576651] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576705] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576761] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576815] iwlwifi 0000:03:00.0: Q 9 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576871] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576928] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.576983] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577038] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577094] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577149] iwlwifi 0000:03:00.0: Q 15 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577204] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577261] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577317] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.577372] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to
> fifo 0 ra_tid 0x0000 [0,0]
> [   19.628329] cfg80211: Calling CRDA to update world regulatory domain
> [   19.632242] cfg80211: World regulatory domain updated:
> [   19.632245] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [   19.632247] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [   19.632249] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [   19.632250] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
> (300 mBi, 2000 mBm)
> [   19.632252] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [   19.632253] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
> (300 mBi, 2000 mBm)
> [   23.041735] wlan0: authenticate with 58:6d:8f:c3:47:2e
> [   23.068235] wlan0: send auth to 58:6d:8f:c3:47:2e (try 1/3)
> [   23.081353] wlan0: authenticated
> [   23.082190] wlan0: associate with 58:6d:8f:c3:47:2e (try 1/3)
> [   23.085720] wlan0: RX AssocResp from 58:6d:8f:c3:47:2e (capab=0x411
> status=0 aid=6)
> [   23.091628] wlan0: associated
>
>    This does not always happen, it's kind of random. I think it
> happens more frequently in places with a lot of wifi networks
> available.
>    I'll try with older firmwares as suggested and let you know. I can
> provide more info if you need.
>

Yes, we know about this. You are (really) not the first to complain.
Unfortunately, I can't point to any fix right now.
