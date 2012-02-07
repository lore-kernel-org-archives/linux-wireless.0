Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gmmr5.centrum.cz ([46.255.225.250]:47821 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab2BGUsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 15:48:04 -0500
To: "Andreas Hartmann" <andihartmann@01019freenet.de>,
	"Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: connection interrupted for rt61pci in master mode
Date: Tue, 07 Feb 2012 21:48:01 +0100
From: <trencan@centrum.cz>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <20120128154544.70E060CD@centrum.cz>, <4F30BEED.4010905@01019freenet.de>, <20120207071444.8C823024@centrum.cz> <4F30D3EE.2010501@01019freenet.de>
In-Reply-To: <4F30D3EE.2010501@01019freenet.de>
MIME-Version: 1.0
Message-Id: <20120207214801.21BCB62B@centrum.cz> (sfid-20120207_214809_098831_FAF43AD8)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I tried maxcpus=0 and verified that really only one cpu core is used but didn't help (so not smp problem). I realized that sometimes when I see connection interrupted, then after few seconds it recovers and network is again functional. 802.11n is disabled. One more thing, when i do "ifup wlan0" I get following output:
NETLINK: Packet too small or truncated! 56!=16!=996
is it OK?

Regards.
Michal

______________________________________________________________
> Od: "Andreas Hartmann" <andihartmann@01019freenet.de>
> Komu: Helmut Schaa <helmut.schaa@googlemail.com>
> Datum: 07.02.2012 08:37
> Předmět: Re: connection interrupted for rt61pci in master mode
>
> CC: "linux-wireless" <linux-wireless@vger.kernel.org>
>Hello Helmut,
>
>could it be potentially a problem with smp or does the fix you provided
>for rt2860 based wlan devices applies too for rt61pci?
>
>I'm thinking about that, because I saw the same problems here some time
>ago. And probably I can see it too with rt2800usb [1].
>
>
>@Michal:
>Just to verify (or falsify) this hypothesis: Could you please reboot the
>machine with the additional kernel option maxcpus=0 (you can enter it in
>the grub console) to just use cpu 0 (please verify with "cat
>/proc/cpuinfo"). If the problem disappears, it's most probably smp related.
>
>Another question: you didn't activate 802.11n. Is this correct?
>
>
>Regards,
>Andreas
>
>trencan@centrum.cz schrieb:
>> 
>> Machine has "Intel Core i5-2500K" with 4 cores without Hyper-Threading.
>> 
>> Regards.
>> Michal
>
>
>Regards,
>Andreas
>
>
>[1]
>http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-February/004556.html
>
