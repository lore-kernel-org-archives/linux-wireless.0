Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37253 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757081AbcJXLkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 07:40:05 -0400
Received: by mail-wm0-f48.google.com with SMTP id f193so113130679wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 04:40:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <emfd19c3e4-1b17-443b-b80a-e6b60a49f9dc@nb-mak>
References: <emfd19c3e4-1b17-443b-b80a-e6b60a49f9dc@nb-mak>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 24 Oct 2016 13:40:03 +0200
Message-ID: <CA+BoTQkXtEcL9yk8_rYb3Z=CBkzs5R1LyMZfVCbGrsH_3Lx7eg@mail.gmail.com> (sfid-20161024_134009_512740_82945787)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Matthias Klein <matthias.klein@optimeas.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 October 2016 at 12:18, Matthias Klein <matthias.klein@optimeas.de> wr=
ote:
> I also try to get a pcie wifi card (Compex WLE600VX) running in the clear=
fog
> pro board with kernel 4.4.
>
> As I read in this thread the "irg.mode=3D1" shoud help:
> https://www.spinics.net/lists/linux-wireless/msg155685.html
>
> But it is not working for me:
>
[...]
> [ 97.899370] ath10k_pci 0000:01:00.0: Refused to change power state,
> currently in D3
> [ 97.938045] ath10k_pci 0000:01:00.0: failed to wake up device : -110
> [ 97.944973] ath10k_pci: probe of 0000:01:00.0 failed with error -110
[...]
> 01:00.0 Network controller: Qualcomm Atheros QCA988x 802.11ac Wireless
> Network Adapter (rev ff) (prog-if ff)
>         !!! Unknown header type 7f

The device looks completely unresponsive.

I don't think this is MSI problem. This error happens before
interrupts are even set up.

I suspect platform/PCI/PM specific problem. I would suggest bisecting
the kernel and seeing which patch is making the difference.

I (naively) went through pci/pm git log and found the following was
applied on 4.7-rc2 (i.e. prior to 4.7 release):

 commit 006d44e49a259b39947366728d65a873a19aadc0
 Author: Mika Westerberg <mika.westerberg@linux.intel.com>
 Date:   Thu Jun 2 11:17:15 2016 +0300

     PCI: Add runtime PM support for PCIe ports

>From reading the commit log it seems to me like it could be it.

ath10k tries to wake up the device during probing before it starts
talking to it and it does so through MMIO/PCI config space. If it's
not mapped properly then driver will not be able to wake it up and
will timeout waiting for it.

Can you try cherry-picking it into your 4.4.24 and see if it helps?


Micha=C5=82
