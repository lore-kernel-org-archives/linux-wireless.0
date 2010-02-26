Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35685 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab0BZWIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 17:08:54 -0500
Received: by fxm19 with SMTP id 19so598311fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 14:08:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>
	<4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002261205160.4513@localhost.localdomain>
	<69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
	<alpine.LFD.2.00.1002261246330.4513@localhost.localdomain>
	<4B8836BF.7000403@lwfinger.net> <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 26 Feb 2010 23:08:33 +0100
Message-ID: <69e28c911002261408j4f5fa5cdo6a69a43749d99f3f@mail.gmail.com>
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

On Fri, Feb 26, 2010 at 10:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 26 Feb 2010, Linus Torvalds wrote:
>>
>> so even if mmiotrace fixes it for others, it's not working for me.
>
> Side note: In case this is timing-related: the machine in question is a
> dual-core 1.3Ghz CPU (Core 2 Duo U1400). I think SMP has always been
> enabled, I don't think I ever tried UP.
>
> Also, in addition to the PIO fallback code, that particular mmiotrace test
> was done with the "udelay(10)" added to the b43_write*() functions. So it
> was even slower.
>
> Maybe the bug only happens on slow machines (and then the udelay obviously
> wouldn't help!), but that would not explain why mmiotrace might then
> _hide_ the bug for some people.
>
>                        Linus
>

Well, we have a report from someone with an Intel T7250, which is
definitely neither a slow CPU nor a ULV. The machine has PhoenixBIOS
(in the same rebranded form as yours). My Intel T7100 + InsydeH2O
machine (almost the same CPU, but with Insyde EFI in BIOS emulation
mode instead of PhoenixBIOS, or maybe TrustedCore) didn't reproduce
the bug. The trigger still seems to be PhoenixBIOS.

Peace,
Gábor

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
