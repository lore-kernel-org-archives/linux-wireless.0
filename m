Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34484 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2AIVbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 16:31:43 -0500
Received: by werm1 with SMTP id m1so3001239wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 13:31:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
References: <CAEWwF+bnM0bxbZR6B57H_nv3fkUdhP-ytAu30MLhUWq7QxB3GQ@mail.gmail.com>
Date: Mon, 9 Jan 2012 22:31:42 +0100
Message-ID: <CACna6rzA6ix2PrZDHXQLTDQuo942urtUAWYagDC0x9zANSVNKQ@mail.gmail.com> (sfid-20120109_223147_026814_2C71A6A0)
Subject: Re: BCM43231
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Abimanyu Gottumukkala <me@abimanyu.in>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[RESEND without attachment]

2011/12/30 Abimanyu Gottumukkala <me@abimanyu.in>:
> Does any one have status or any info on BCM43231 USB drivers?

I've received my WNA3100, 0846:9020 (maybe BCM43231, can't confirm).

 It works with ndiswrapper and bcmwlhigh6, I can scan and even connect
 to my WPA2 network.

 Unfortunately I've no idea what hardware is this. I've dumped
 ndiswrapper USB operations but they don't tell me a single thing.
 Initialization is represented by only ~1000 lines in dumps and I've
 connected in next ~1500 lines of USB dump. I've been using "usbmon" to
 dump traffic.

 The hardware seems to have:
 1) Configuration
 2) 3 endpoints (2*bulk, 1*interrupt)

 The attached dump doesn't contain:
 1) Anything EPROM specific (like 0x4BF... or 0x0000000F)
 2) Anything SPROM specific (like 0x5372 signature)
 3) Anything Broadcom specific (like 0x14e4)
 4) Anything BCMA specific (like 0x408 aka BCMA_IOCTL)

 I've no idea what to look for on this card. I started to believe it's
 some fullmac, but didn't find anything to prove this.


 Larry: is there any chance you will give some tips on this hardware? I
 know RE of x86 driver can be really ugly, but maybe you'll find
 something somewhere anyway? At least some minimal tip.


 The only thing I've recognized in USB dump is my MAC address
 (E0:46:9A:19:58:DB):
 ea7009c0 505509888 S Bo:2:010:3 -115 24 = 14000000 21000000 2b000000
 00000000 e0469a19 58db0000
 f3dbe340 505509949 S Bo:2:010:3 -115 28 = 18000000 22000000 31000000
 48000000 08000000 e0469a19 58db0000
 f0257d40 505510010 S Bo:2:010:3 -115 24 = 14000000 23000000 2b000000
 03000000 00000000 00000000

 eea80c40 512759339 S Bo:2:010:3 -115 24 = 14000000 66010000 2b000000
 00000000 e0469a19 58db0000
 eb48d740 512759348 S Bo:2:010:3 -115 28 = 18000000 67010000 31000000
 48000000 08000000 e0469a19 58db0000
 f6275240 512759354 S Bo:2:010:3 -115 24 = 14000000 68010000 2b000000
 03000000 00000000 00000000
 f0257f40 512759360 S Bo:2:010:3 -115 24 = 14000000 69010000 2e000000
 6c0d0000 00000000 60030000
 f0257ac0 512759366 S Bo:2:010:3 -115 20 = 10000000 6a010000 30000000
 d4050000 00000000
 eb48d2c0 512759372 S Bo:2:010:3 -115 20 = 10000000 6b010000 30000000
 d6050000 10000000
 f6275740 512759378 S Bo:2:010:3 -115 20 = 10000000 6c010000 30000000
 d8050000 20000000
 f62757c0 512759384 S Bo:2:010:3 -115 20 = 10000000 6d010000 30000000
 da050000 30000000
 f0257a40 512759390 S Bo:2:010:3 -115 20 = 10000000 6e010000 30000000
 dc050000 40000000
 f2c191c0 512759396 S Bo:2:010:3 -115 20 = 10000000 6f010000 30000000
 de050000 50000000
 eb48d540 512759402 S Bo:2:010:3 -115 20 = 10000000 70010000 30000000
 e0050000 60000000
 eb48d340 512759408 S Bo:2:010:3 -115 20 = 10000000 71010000 30000000
 e2050000 70000000
 ea700d40 512759414 S Bo:2:010:3 -115 20 = 10000000 72010000 30000000
 e4050000 80000000
 f2c19ec0 512759420 S Bo:2:010:3 -115 20 = 10000000 73010000 30000000
 e6050000 90000000

 f224fec0 505489563 C Ci:2:010:0 0 20 = 10000000 03000001 35000000
 e0469a19 58db0000

-- 
Rafał
