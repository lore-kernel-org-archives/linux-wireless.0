Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:40169 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaBRTHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 14:07:12 -0500
Received: by mail-ve0-f174.google.com with SMTP id pa12so14039898veb.33
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 11:07:11 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140218182714.GO26776@mwanda>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
 <20140218093135.GJ26776@mwanda> <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com>
 <20140218182714.GO26776@mwanda>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Tue, 18 Feb 2014 20:06:51 +0100
Message-ID: <CAN8YU5P1-7TxvDFifEWPhGh3MbLP_DMJWS9Sbzte+TDcuELKLg@mail.gmail.com> (sfid-20140218_200736_792601_04A382BB)
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

Thank for pointing out this. Yes, I probably exaggerated trying hard
to allocate memory.

If your point is about if pci_map_single may or not ever fail in real
life (that is was I thought you meant in your first mail), then I
think that it's worth to keep the  check anyway (I think it could
happen).

If your point is that it can be not so much useful to try and retry
hard the allocation (I must admit I'm not even sure that after freeing
the skb the kernel will not likely re-allocate the same one at the
next try), then I will keep the error check, but I can remove code
that retries allocation (failing at the first error as you suggested).

BTW consider that the allocation is done in ieee80211 start callback,
that is called every time the interface is brought down/up, and not
once at the begining.

On one hand I cared avoiding wasting memory when the interface is not up.
On the other hand I had thought also to move memory allocation in
initialization, exactly to increase success probability as you pointed
out..

I chosen the first option because after the interface is brought up,
the RX ant TX processes will start to perform a lot of other skb
allocations and dma maps.
If we assume, as you pointed out, they will likely ALL fail or
succeeds, not just few of them, then probably even if we allocated
some memory at init time, we have gained not advantage.

Do you agree ?

Thank you
Andrea

On Tue, Feb 18, 2014 at 7:27 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I guess what I was going to suggest is that you are overthinking the
> error handling.  Your code tries very hard to allocate 32 buffers.  But
> I bet it's just a matter of allocating the buffers and if it doesn't
> work then clean up and return an error.  Probably it alocates 32 buffers
> successfully or it doesn't allocate any, it's less likely that we will
> allocate a partial number of buffers.
>
> If this were in the receive path or something like that then maybe we
> would worry about situations like that.  Although even in that case
> probably the right approach would be to drop everything and let the
> protocol handle the error...  Offtopic.  What I mean is that this is in
> the init path so everything will likely work except in manufactured
> situations.
>
> regards,
> dan carpenter
>
