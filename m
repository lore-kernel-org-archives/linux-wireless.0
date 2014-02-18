Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42663 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaBRSFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 13:05:36 -0500
Received: by mail-pb0-f46.google.com with SMTP id um1so16923197pbc.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 10:05:36 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140218093135.GJ26776@mwanda>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com> <20140218093135.GJ26776@mwanda>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Tue, 18 Feb 2014 19:05:16 +0100
Message-ID: <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com> (sfid-20140218_190542_394409_EA5A4053)
Subject: Re: [PATCH 3/7] rtl818x: check for pci_map_single() success when
 initializing RX ring
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Linville <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Honestly I'm not so expert in deep on this subject me too (and I would
like to learn more me too).
I have not a detailed example right now, but consider that this is
arch dependent thing, and we should think to wide plethora of archs..
even future ones...

AFAIK on x86 the dma error checking function will do nothing (this
arch uses nommu_dma_ops function pointers collection for implementing
those kind of DMA operations, and that structure does not even assigns
the dma error checking function pointer), but on other archs it may do
something.

Maybe in some cases for example a bounce-buffer may be needed (give a
look to /lib/swiotlb.c), and I suppose it can't be guaranteed it can
be successfully allocated.
Looking at the kernel source it seems that, for example, ARM64 may need this.

And, if I understood code right (and my flu does not help), it seems
that even on x64 arch, if our board is the "sta2x11" (that I doesn't
know what exactly is) then the dma operations are changed to the ones
in swiotlb.c ...

If someone more expert on that topic can give us better or more
complete explanation, I will appreciate it very much (in true I wrote
this mail with the purpose of trying to trigger some of them :) )

Andrea

On Tue, Feb 18, 2014 at 10:31 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Tue, Feb 18, 2014 at 02:10:42AM +0100, Andrea Merello wrote:
>> From: andrea merello <andrea.merello@gmail.com>
>>
>> During initialization a number of RX skbs are allocated and mapped
>> for DMA.
>> Currently if pci_map_single() fails, it will result in passing to the
>> HW a wrong DMA address (to write to!).
>>
>> This patch detects this condition, eventually it tries to get a more
>> luky skb, and if it finally fails to get things right, it makes the
>> driver not to initialize, avoiding at least dangerous DMAs.
>>
>
> In normal life then why would pci_map_single() fail even once?  (I am
> a newbie with this code so it is an honest question and not a rhetorical
> one).
>
> regards,
> dan carpenter
>
