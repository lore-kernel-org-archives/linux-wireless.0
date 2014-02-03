Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49119 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaBCWJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 17:09:34 -0500
Received: by mail-we0-f174.google.com with SMTP id x55so3234578wes.5
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 14:09:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140202215141.GL30112@us.netrek.org>
References: <CAAUTuq83oJJ02tMpT6sK4krkwNFEVZYuzfvsTtRoUX=fVYT9-w@mail.gmail.com>
 <CAJwzM1=0xBkQ0cw-T+zMcAHSZVJsJ7vJmK6O9eisqttn_qGyMA@mail.gmail.com>
 <CAAUTuq--5EUYgKb1Bg9UWZnDAZRqcPZFd=GRVEo-YKictJJWwg@mail.gmail.com>
 <CAAUTuq-O1BFBmJfYe2xuRfLmNDNKY=V9CkMCM-QCq1iujE3n2w@mail.gmail.com> <20140202215141.GL30112@us.netrek.org>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Mon, 3 Feb 2014 16:09:13 -0600
Message-ID: <CAAUTuq-xXy2nfU55e=x5NDEGOB4dr=UbkJmHKgMHfrufXXP70g@mail.gmail.com> (sfid-20140203_230938_095795_526B4612)
Subject: Re: Fwd: mwifiex and SD8787: How to create AP interface?
To: James Cameron <quozl@laptop.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interesting.

I haven't seen any allocation failures in my kernel log, so I probably
have a different issue, but I'll keep an eye out.
My platform only has 512MB of RAM, so I suspect the only reason I'm
not seeing this is that I'm running an AP with no servers, so packets
are just forwarded through a layer-2 bridge rather than sent to
userspace applications.

On Sun, Feb 2, 2014 at 3:51 PM, James Cameron <quozl@laptop.org> wrote:
> On Sat, Feb 01, 2014 at 11:01:02PM -0600, Andrew Wiley wrote:
>> Hello Avinash,
>>
>> Thanks! That works for me. Would it be possible to add this to the
>> mwifiex page on wireless.kernel.org? As far as I know, this command is
>> completely undocumented within iw, and I know I'm not the only
>> Dreamplug owner experiencing this problem.
>>
>> As for other issues, I'm seeing a hang in the TX queue on the device
>> after running an AP for a while, but I'm still gathering information
>> on that. I'll follow up with another thread.
>
> I've also seen hangs, in both RX and TX, but mostly RX.
>
> The response to failing to alloc an skb is a bit weak in mwifiex, we
> noted this on OLPC XO-4 with the 8787.  You can see more about the
> problem and some local fixes in our private branch:
>
> http://dev.laptop.org/git/olpc-kernel/log/?h=arm-3.5
>
> http://dev.laptop.org/ticket/12694 (kernel 3.5)
>
> I did backport the latest mwifiex at the time, but it did not fix the
> issue, so I dug into it more.
>
> --
> James Cameron
> http://quozl.linux.org.au/
