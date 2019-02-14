Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8DEC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 23:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD4C021A80
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 23:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OOo5UqZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfBNXFq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 18:05:46 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:39608 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfBNXFq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 18:05:46 -0500
Received: by mail-it1-f193.google.com with SMTP id l15so6030291iti.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 15:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oowxwfE9iNWBlDuZOXdO0POI3oFNz+wzdPvE/IcdnRs=;
        b=OOo5UqZFG4Anx4JxBMDzxCc4hPZbSoqMlgxhHJDUJCDL0Xt5Mpg2+FCSUKoB5+U4uK
         ZkXiJUw33Cc984aciDmuTxdcRgyu1zHJJVLWVUoYOBq2vhvDZPQRjdqzG3fuC0E+VA8W
         MlCiluAG0q3tnML60B1PxUPp9JNGtyBEPCFXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oowxwfE9iNWBlDuZOXdO0POI3oFNz+wzdPvE/IcdnRs=;
        b=gH2vycWMnZEQuy5MxvCG/Gj/JWJ94HuYVHO8TpKVnTLM74DgX8lbWGNs7514vosf7t
         0zuZLZ5O57g9iInAGdoROlxNfIDkGk4zAM/rrfK19EbD4j1waTv1nhqSn/fh/U8we22D
         hhnOE05SerzWFhm+mncKlIAH2Pvvj5evv1JH5OS1CGuo+YhjySuWHGauZpR//u24ua+z
         83vEOw4h9hYqFs+Yo9WgFRgBBdL1xYpQxbc+k/nE2NDysAk9ZMrZroed6zRiokPePI8/
         EvnGJQpMxZhw1Y6w2cnV0UNmBEqQLPIi1bJfTVoUEfQJ2ZfEMSEliX/3wL1Ulm8dCuYR
         HgMw==
X-Gm-Message-State: AHQUAuYnbaljfDSOgMcj7tYKZ8ucsxVNFQCWc99+x895we9+B+am85jd
        MgKEkSyrPtHtmhE95lvtiS1qX3/1wC0R27ll5rMUlg==
X-Google-Smtp-Source: AHgI3IZk1Yc15BOJHIAm2fZjk87sLApXV76H6GH4ZYG/m0k5W7mYJHJVhR3cKgY2wUmv5/83YB3lgruQJmqBtv267dw=
X-Received: by 2002:a6b:c402:: with SMTP id y2mr4304432ioa.77.1550185544810;
 Thu, 14 Feb 2019 15:05:44 -0800 (PST)
MIME-Version: 1.0
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com> <20190131223609.GA191502@google.com>
In-Reply-To: <20190131223609.GA191502@google.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Thu, 14 Feb 2019 15:05:33 -0800
Message-ID: <CANEJEGt4xJ5pTXgqazTVV2MNZy9+SWa6uE+wbE_94aT+FvL-+A@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] rtw88: hci files
To:     Brian Norris <briannorris@chromium.org>
Cc:     yhchuang@realtek.com, Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian - thanks for the relatively thorough review. Well done!

Comments on two of the points you raised. Will trim out the rest.

On Thu, Jan 31, 2019 at 2:36 PM Brian Norris <briannorris@chromium.org> wrote:
...
> On Wed, Jan 30, 2019 at 12:02:10PM +0800, yhchuang@realtek.com wrote:
...
> > +err_out:
> > +     dev_kfree_skb_any(skb);
>
> Maybe I'm misreading but...shouldn't this line not be here? You properly
> iterate over the allocated SKBs below, and this looks like you're just
> going to be double-freeing (or, negative ref-counting).

Kernel will panic immediately? The branch to reach err_out only
happens when skb is NULL.

...
> > +static void rtw_pci_dma_check(struct rtw_dev *rtwdev,
> > +                           struct rtw_pci_rx_ring *rx_ring,
> > +                           u32 idx)
> > +{
> > +     struct rtw_chip_info *chip = rtwdev->chip;
> > +     struct rtw_pci_rx_buffer_desc *buf_desc;
> > +     u32 desc_sz = chip->rx_buf_desc_sz;
> > +     u16 total_pkt_size;
> > +     int i;
> > +
> > +     buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> > +                                                  idx * desc_sz);
> > +     for (i = 0; i < 20; i++) {
> > +             total_pkt_size = le16_to_cpu(buf_desc->total_pkt_size);
> > +             if (total_pkt_size)
> > +                     return;
> > +     }
>
>
> Umm, what are you trying to do here? This is a non-sensical loop. I
> *imagine* you're trying to do some kind of timeout loop here,

My guess is this is trying to mitigate a race between the CPU reading
memory and RTL88* device in updating this word of memory.  This is the
first function called in the packet processing loop in
rtw_pci_rx_isr(). This code suggests that the CPU is seeing the
interrupt before the RTL has finished updating memory via DMA and is
likely a "Bug" in the RTL device firmware.

I'm suggesting this is a bug for two reasons:
1) NIC vendors historically have tried to reduce packet handling
latency by sending the interrupt a few microseconds BEFORE the DMA is
actually completed. This has always failed in some weird way whenever
the PCI host controllers were a bit slower or perhaps even coalescing
DMA writes (or something like that).

2) PCI-Express interrupts are "In band" (MSI or not). This means once
the interrupt arrives, the corresponding device driver should be able
to assume all DMA from the device is complete.  This race is only
possible for "out of band" IRQ lines which are found on other busses
and historic PCI and PCI-X parallel busses.

"DMA is complete" doesn't necessarily means data is visible to CPU
though on Intel X86, it usually is.  The DMA API requires memory
allocated via pci_[z]alloc_consistent() be visible and cache coherent
though. So I don't expect CPU to perform any action to make the last
bits of DMA'd data visible in this case.  "Streaming Data" requires
pci_unmap* calls or respect dma_sync_to_cpu() (or whatever it's
called) to guarantee the data is visible - that's not what is being
accessed in this code though AFAICT.


> but since
> there's nothing telling the compiler that this is anything but normal
> memory, this loop gets flattened by the compiler into a single check of
> ->total_pkt_size (I checked; my compiler gets rid of the loop).

This is another bug in the code actually: the code accessing tx
descriptor rings should be declared volatile since they are updated by
the device which is not visible to the compiler.  Compiler won't
optimize (or reorder) volatile code (by "volatile code" I mean code
that is accessing data marked "volatile").

> So, at a minimum, you should just remove the loop. But I'm not sure if
> this "check" function has any value at all...

If Realtek can't fix what appears to be a bug in the firmware, I
suspect a polling loop will be required - but add a "udelay(1)" in the
loop.

>
> > +
> > +     if (i >= 20)
> > +             rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
>
> ...BTW, I'm seeing this get triggered quite a bit.
>
> Do you have some kind of memory mapping/ordering issue or something? I
> wouldn't think you should expect to just drop packets on the floor so
> often like this.

Based on the code above, I'm willing to bet you are correct the driver
has memory ordering issues. Since the descriptor rings aren't declared
volatile, the compiler is free to reorder accesses to those fields as
it sees fit. This is a real problem given the device may update the
fields in the different order than what the compiler emits as memory
accesses.

cheers,
grant
