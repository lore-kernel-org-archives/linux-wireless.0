Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37180 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753091AbeC1UJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 16:09:21 -0400
Message-ID: <1522267758.3786.297.camel@coelho.fi> (sfid-20180328_220926_182438_D50C2FB8)
From: Luca Coelho <luca@coelho.fi>
To: Mohamed Khalfella <khalfella@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: linuxwifi@intel.com
Date: Wed, 28 Mar 2018 23:09:18 +0300
In-Reply-To: <CAMaOPvZCg0YMzhR2KR7dMTkuphV2T-mDtyageaJPr+cB5jGbCQ@mail.gmail.com>
References: <CAMaOPvZCg0YMzhR2KR7dMTkuphV2T-mDtyageaJPr+cB5jGbCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Intel Corporation Wireless 8260 [8086:24f3] (rev 3a) - Hardware
 error in PCI passthrough
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 19:43 -0600, Mohamed Khalfella wrote:
> Hi,

Hi Mohamed,

> I am working in pci passthrough for qemu under SmartOS. My test
> machine is Intel NUC Kit NUC6i3SYH BOXNUC6I3SYH which comes with
> Intel
> Wireless 8260 [8086:24f3]. So far the guest OS recognize the PCI
> device and the driver, iwlwifi reports an error when it tries to
> initialize the device.
> 
> Here is what I see in linux guest console https://pastebin.com/cCzEUg
> Gz.
> lspci from the guest OS https://pastebin.com/pPS7c1HT
> lspci from the host OS, running the same iso image
> https://pastebin.com/xLTpw9fz. Host OS regencies the device
> perfectly.
> 
> I did mmio tracing and here are the results
> https://docs.google.com/spreadsheets/d/1GFW1JTA9Q5OVh4CQMYYHSQ378j45n
> P078juewogBIp0/edit?usp=sharing.
> For some reason, which I don't know, the guest gets different result
> when it reads register 3C. I don't know why does that happen.
> 
> My implementation doesn't present PCI extended capabilities, I am not
> sure if this is stopping the device to work or not.
> 
> Unfortunately, I don't have the device specification to dig deeper
> into the issue. The code I am working on is accessible in upci branch
> in
> 
> upci driver https://github.com/khalfella/illumos-gate
> qemu https://github.com/khalfella/illumos-kvm-cmd
> 
> Appreciate any hints or ideas.

We use PCI passthrough in our test machines extensively, with KVM and
qemu.  It works fine, so this is most likely some issue in the
passthrough configuration you have.  Some of us also use PCI
passthrough with VirtualBox and it works fine as well.

Can you provide more info on how you are configuring the PCI
passthrough on your machine?

--
Cheers,
Luca.
