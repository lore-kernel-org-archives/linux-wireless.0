Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49024 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C3Vaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:30:46 -0400
Received: by gwaa18 with SMTP id a18so4945039gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 14:30:45 -0700 (PDT)
Message-ID: <4BB26D82.6020805@lwfinger.net>
Date: Tue, 30 Mar 2010 16:30:42 -0500
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
> 
> Hth!

It has already. The clue was in the fragment I sent you earlier. Every other
BCM43XX card that we have seen had its SPROM starting at offset 0x1000 relative
to the start of the MMIO mapping. Yours is at 0x0800! I would have hoped for an
"incorrect CRC" message, but we got the hang instead. I now have to find the
hidden flag that lets us know about the different location. I wonder what else
has moved.

As a warning to users of wl. I tried to run it from the 2.6.34-rc3 on Linus's
tree. Broadcom (I really like the other variation of that name!) has not (yet)
discovered the change in the DMA API in 2.6.34. As a result, I got a few "tries
to free DMA memory it has not allocated" warnings followed by a lot of other
stuff concluding in a kernel panic - the first I've had for a long time. Note: I
will not be debugging this problem. I have enough to do already.

Larry
