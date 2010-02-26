Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49242 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966490Ab0BZWyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 17:54:49 -0500
Received: by fxm19 with SMTP id 19so629597fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 14:54:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002261430430.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002261205160.4513@localhost.localdomain>
	<69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
	<alpine.LFD.2.00.1002261246330.4513@localhost.localdomain>
	<4B8836BF.7000403@lwfinger.net> <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
	<69e28c911002261408j4f5fa5cdo6a69a43749d99f3f@mail.gmail.com>
	<alpine.LFD.2.00.1002261430430.4513@localhost.localdomain>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 26 Feb 2010 23:54:27 +0100
Message-ID: <69e28c911002261454u1d03f1eof98efc05404c1b87@mail.gmail.com>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA
	errors
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/26 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Fri, 26 Feb 2010, Gábor Stefanik wrote:
>>
>> Well, we have a report from someone with an Intel T7250, which is
>> definitely neither a slow CPU nor a ULV. The machine has PhoenixBIOS
>> (in the same rebranded form as yours). My Intel T7100 + InsydeH2O
>> machine (almost the same CPU, but with Insyde EFI in BIOS emulation
>> mode instead of PhoenixBIOS, or maybe TrustedCore) didn't reproduce
>> the bug. The trigger still seems to be PhoenixBIOS.
>
> Well, I'd love to give you a register dump. It _looks_ like it should be
> possible write some script to dump all the registers by accessing
>
>        /sys/kernel/debug/b43/phy0/[mmio,shm][16,32]read
>
> but that's a very odd interface and I don't know what the index ranges are
> for them (and which registers need 16-bit vs 32-bit accesses).
>
> But if you give me a script to dump all the relevant registers, I could
> just dump them after a cold-boot, and _before_ loading the b43 driver fir
> the first time. Maybe you can compare it to your state with your BIOS, in
> the same situation, and see if there is some obvious difference that
> strikes you?
>
> Of course, maybe there is some hidden state that doesn't show up there
> either?
>
>                Linus
>

Currently I am working on comparing mmiotraces from b43 and wl, and
there appear to be a few writes to the DMA control area of the card,
that are missing from b43. So, most likely no dump will be needed.

BTW I suspect that the difference between working & broken machines is
not in initial state - rather, the BIOS corrupts the state of the card
during startup. This would probably not show up in a register dump.

--Gábor

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
