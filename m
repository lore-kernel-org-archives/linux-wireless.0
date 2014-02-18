Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42794 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBRURn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 15:17:43 -0500
Received: by mail-pa0-f48.google.com with SMTP id kx10so17158566pab.7
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 12:17:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <20140218192239.GP26776@mwanda>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
 <1392685846-10116-4-git-send-email-andrea.merello@gmail.com>
 <20140218093135.GJ26776@mwanda> <CAN8YU5N=_-9hVZc+6sW5xrwmybQ_aTLAMFODzyuGk0g97OV6Gg@mail.gmail.com>
 <20140218182714.GO26776@mwanda> <CAN8YU5P1-7TxvDFifEWPhGh3MbLP_DMJWS9Sbzte+TDcuELKLg@mail.gmail.com>
 <20140218192239.GP26776@mwanda>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Tue, 18 Feb 2014 21:17:22 +0100
Message-ID: <CAN8YU5PQSNZHmEG6o2-uRQMo1G14M7ot-_KiHT2u=-4LCaremA@mail.gmail.com> (sfid-20140218_211746_510945_181B535F)
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

Ok, I will fix my patch in this way.
I will resend it.
Should I also rebase following patches in the patch serie and resent them also?

Thanks
Andrea

On Tue, Feb 18, 2014 at 8:22 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Feb 18, 2014 at 08:06:51PM +0100, Andrea Merello wrote:
>> Thank for pointing out this. Yes, I probably exaggerated trying hard
>> to allocate memory.
>>
>> If your point is about if pci_map_single may or not ever fail in real
>> life (that is was I thought you meant in your first mail), then I
>> think that it's worth to keep the  check anyway (I think it could
>> happen).
>
> Please keep the check.
>
>>
>> If your point is that it can be not so much useful to try and retry
>> hard the allocation (I must admit I'm not even sure that after freeing
>> the skb the kernel will not likely re-allocate the same one at the
>> next try), then I will keep the error check, but I can remove code
>> that retries allocation (failing at the first error as you suggested).
>
> Yes.  Please remove the retry code unless there is some real life
> justification for it where you have seen partial allocations before.
>
>>
>> BTW consider that the allocation is done in ieee80211 start callback,
>> that is called every time the interface is brought down/up, and not
>> once at the begining.
>>
>
> You are right.  I didn't realize that.
>
>> On one hand I cared avoiding wasting memory when the interface is not up.
>> On the other hand I had thought also to move memory allocation in
>> initialization, exactly to increase success probability as you pointed
>> out..
>>
>> I chosen the first option because after the interface is brought up,
>> the RX ant TX processes will start to perform a lot of other skb
>> allocations and dma maps.
>> If we assume, as you pointed out, they will likely ALL fail or
>> succeeds, not just few of them, then probably even if we allocated
>> some memory at init time, we have gained not advantage.
>>
>> Do you agree ?
>
> Yes.
>
> regards,
> dan carpenter
>
>
