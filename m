Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:62262 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaBDBSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 20:18:17 -0500
Received: by mail-we0-f179.google.com with SMTP id q58so3504015wes.10
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 17:18:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAUTuq9dcKvGk0PWhP16=yyK79mE-T-1gbGPpd5G__imimHvBQ@mail.gmail.com>
References: <CAAUTuq_bgXcfKquXR+ATumO7xkyTE_WLUvUOMZ7bPYCP0_XnuQ@mail.gmail.com>
 <CAJwzM1kzbvy7UnjJerJ8EmUxvp5GYPeKS-9988SgxfoQrv-Zjw@mail.gmail.com>
 <CAAUTuq_LnUCTBaHndBiLDk0ge+055YJJMY4Ni+bV7PrYq_KSHA@mail.gmail.com>
 <CAJwzM1kQJvfZwPi_suBSgCEquAHvYduwRWcM01==nT_TVd0d0g@mail.gmail.com>
 <CAAUTuq9oU7+=_sjcix0WuSUp5_5OVRXK1cJdtRDtR1obaJrV1Q@mail.gmail.com> <CAAUTuq9dcKvGk0PWhP16=yyK79mE-T-1gbGPpd5G__imimHvBQ@mail.gmail.com>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Mon, 3 Feb 2014 19:17:55 -0600
Message-ID: <CAAUTuq-WBMOLQE7FYFd32TrCN=3KwfFKgALs2pZGuBpKqkSDFg@mail.gmail.com> (sfid-20140204_021841_167380_327DD5E9)
Subject: Re: mwifiex and SD8787: TX queue timeout in AP mode
To: Avinash Patil <avinashapatil@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 3, 2014 at 4:16 PM, Andrew Wiley <wiley.andrew.j@gmail.com> wrote:
> On Mon, Feb 3, 2014 at 4:02 PM, Andrew Wiley <wiley.andrew.j@gmail.com> wrote:
>> On Mon, Feb 3, 2014 at 12:47 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
>>> Does this issue happens with station interface as well?
>>
>> I haven't really made use of station mode much, but I just tried it
>> and it seems stable. The first time I tried to connect, the driver had
>> a command timeout while scanning and the card dropped out, but the
>> second time, it connected and has stayed stable for 30 minutes or so.
>> The network I'm connected to uses WPA2. I'll continue to monitor the
>> box to see if the queue hangs.
>>
>
> A few minutes after I wrote this, the box hung. No kernel errors were
> logged in the serial console - it just stopped responding.
> I'll have to investigate this further.

There's a consistent but random hang in station mode. I've reproduced
it five times at this point - the serial console hangs and the
heartbeat LED gets stuck on. There aren't any errors leading up to the
hang.

Here's the last lines of dmesg that printed before the hang:

----
[ 5021.924439] mwifiex_sdio mmc0:0001:1: info: --- Rx: Data packet ---
[ 5021.924576] mwifiex_sdio mmc0:0001:1: data: 471285 BSS(0-0): Data <= kernel
[ 5021.924616] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000000
[ 5021.924627] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
[ 5021.924644] mwifiex_sdio mmc0:0001:1: data: tid=0
[ 5021.924658] mwifiex_sdio mmc0:0001:1: data: dequeuing the packet
ddfb1240 db063cc0
[ 5021.924674] mwifiex_sdio mmc0:0001:1: data: WMM: Pkt Delay: 0 ms, 0
ms sent to FW
[ 5021.924685] mwifiex_sdio mmc0:0001:1: data: mp_wr_bitmap=0x0000007f
[ 5021.924697] mwifiex_sdio mmc0:0001:1: data: port=1
mp_wr_bitmap=0x0000007f -> 0x0000007d
[ 5021.924708] mwifiex_sdio mmc0:0001:1: info:
mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
[ 5021.924719] mwifiex_sdio mmc0:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 1
[ 5021.979992] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
[ 5021.980014] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
[ 5021.980025] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x1
[ 5021.980034] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000001
[ 5021.980045] mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x00000000
[ 5021.980055] mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=10
[ 5021.980068] mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
[ 5021.980079] mwifiex_sdio mmc0:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
[ 5021.980089] mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
[ 5021.980137] mwifiex_sdio mmc0:0001:1: info: --- Rx: Event ---
[ 5021.980150] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000000
[ 5021.980159] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
[ 5021.980171] mwifiex_sdio mmc0:0001:1: info: EVENT: SLEEP
[ 5021.980183] mwifiex_sdio mmc0:0001:1: info:
mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[ 5021.980194] mwifiex_sdio mmc0:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 0
[ 5021.980326] mwifiex_sdio mmc0:0001:1: int: sdio_ireg = 0x1
[ 5021.980341] mwifiex_sdio mmc0:0001:1: info: cmd_sent=0 data_sent=0
[ 5021.980351] mwifiex_sdio mmc0:0001:1: int: UPLD: rd_bitmap=0x1
[ 5021.980361] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000001
[ 5021.980371] mwifiex_sdio mmc0:0001:1: data: port=0 mp_rd_bitmap=0x00000000
[ 5021.980380] mwifiex_sdio mmc0:0001:1: info: RX: port=0 rx_len=16
[ 5021.980392] mwifiex_sdio mmc0:0001:1: info: rx_len = 256 skb->len = 256
[ 5021.980403] mwifiex_sdio mmc0:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: no aggregation for cmd response
[ 5021.980413] mwifiex_sdio mmc0:0001:1: info: RX: port: 0, rx_len: 256
[ 5021.980456] mwifiex_sdio mmc0:0001:1: info: --- Rx: Cmd Response ---
[ 5021.980471] mwifiex_sdio mmc0:0001:1: data: mp_rd_bitmap=0x00000000
[ 5021.980480] mwifiex_sdio mmc0:0001:1: info: no more rd_port available
----

Unfortunately, this is from `dmesg -w` and not directly from the
serial console - I think I'll have to recompile the kernel again to
get these debug messages to show up on the serial console, and I'm not
sure what will happen when the message rate exceeds the speed of the
serial connection.

Is this likely a separate issue? Should I see if I can get GDB set up
over JTAG and dump the message buffers after the lockup?
