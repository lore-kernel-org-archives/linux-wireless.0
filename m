Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f195.google.com ([209.85.210.195]:38302 "EHLO
	mail-yx0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0C3Uu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 16:50:28 -0400
Received: by yxe33 with SMTP id 33so746607yxe.15
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 13:50:27 -0700 (PDT)
Message-ID: <4BB2640A.9030602@lwfinger.net>
Date: Tue, 30 Mar 2010 15:50:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Your netbook
References: <4BB21787.4040501@lwfinger.net> <20100330202848.GO13120@tuxdriver.com>
In-Reply-To: <20100330202848.GO13120@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2010 03:28 PM, John W. Linville wrote:
> On Tue, Mar 30, 2010 at 10:23:51AM -0500, Larry Finger wrote:
> 
>> If possible, I would like you to do one more test on that troublesome netbook.
>> Please build a kernel with CONFIG_MMIOTRACE=y and build the Broadcom wl driver
>> for it. Starting with wl unloaded, issue the following commands (as root):
>>
>> echo 10000 > /sys/kernel/debug/tracing/buffer_size_kb
>> echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
>> cat /sys/kernel/debug/tracing/trace_pipe > wl_dump.txt &
>> modprobe -v wl
>>
>> After the wireless network device gets created, etc., then
>>
>> echo nop > /sys/kernel/debug/tracing/current_tracer
>> sleep 1
>> killproc cat
>>
>> and send me the file wl_dump.txt. With it, I will be able to see if the Broadcom
>> driver is actually finding an SPROM that b43 is missing.
> 
> Done:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/ssb-debug/wl_dump.txt.gz

Thanks. After using the mmio reformatting tool on your data, I found the following:

read16 #1 block at  0xfeafc800 of 220 (0xdc) elements:
 0xfeafc800: 3801 0000 1507 103c  0078 6dbe 0000 2bc4  2a64 2964 2c64 3ce7
 0xfeafc818: 46ff 477f 0c00 7840  00a0 ffff 0000 ffff  ffff ffff ffff ffff
 0xfeafc830: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc848: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc860: 4315 8000 0002 0000  1800 1800 0000 0000  ffff ffff ffff ffff
 0xfeafc878: ffff ffff ffff ffff  5372 1306 0a01 0006  0000 0000 0025 5681
 0xfeafc890: 783e 5553 0000 03ff  ffff ffff 0003 ff02  ffff ff11 000f ffff
 0xfeafc8a8: 006c ffff fffa ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc8c0: 3e44 17ec fa34 fe73  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc8d8: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc8f0: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc908: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc920: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc938: ffff ffff ffff ffff  ffff 0008 ffff ffff  ffff ffff ffff ffff
 0xfeafc950: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc968: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc980: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc998: ffff ffff ffff ffff  ffff ffff ffff ffff  ffff ffff ffff ffff
 0xfeafc9b0: ffff ffff ffff ed08

That is the reading of a valid, rev. 8 SPROM. Your device does indeed have one.
Why we avoided the lockup by skipping the readout remains a question. Now to
build wl here and compare the differences.

Thanks,

Larry

