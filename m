Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966477Ab0BZWrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 17:47:46 -0500
Date: Fri, 26 Feb 2010 14:46:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA  errors
In-Reply-To: <69e28c911002261408j4f5fa5cdo6a69a43749d99f3f@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002261430430.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>  <4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>  <alpine.LFD.2.00.1002261205160.4513@localhost.localdomain>  <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
  <alpine.LFD.2.00.1002261246330.4513@localhost.localdomain>  <4B8836BF.7000403@lwfinger.net> <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain>  <alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
 <69e28c911002261408j4f5fa5cdo6a69a43749d99f3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Gábor Stefanik wrote:
> 
> Well, we have a report from someone with an Intel T7250, which is
> definitely neither a slow CPU nor a ULV. The machine has PhoenixBIOS
> (in the same rebranded form as yours). My Intel T7100 + InsydeH2O
> machine (almost the same CPU, but with Insyde EFI in BIOS emulation
> mode instead of PhoenixBIOS, or maybe TrustedCore) didn't reproduce
> the bug. The trigger still seems to be PhoenixBIOS.

Well, I'd love to give you a register dump. It _looks_ like it should be 
possible write some script to dump all the registers by accessing

	/sys/kernel/debug/b43/phy0/[mmio,shm][16,32]read

but that's a very odd interface and I don't know what the index ranges are 
for them (and which registers need 16-bit vs 32-bit accesses).

But if you give me a script to dump all the relevant registers, I could 
just dump them after a cold-boot, and _before_ loading the b43 driver fir 
the first time. Maybe you can compare it to your state with your BIOS, in 
the same situation, and see if there is some obvious difference that 
strikes you?

Of course, maybe there is some hidden state that doesn't show up there 
either?

		Linus
