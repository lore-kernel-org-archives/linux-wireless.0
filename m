Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:34564 "EHLO
	mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbcG2BF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 21:05:27 -0400
Received: by mail-ua0-f182.google.com with SMTP id 35so51851988uap.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2016 18:05:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <814ae6d0-2375-e8bd-f3e3-98ec5f69b376@broadcom.com>
References: <CAOMZO5Cu_UO6L9wYy6eJUJwEE25BN-qeBRAMbFveFrJKHtF=aw@mail.gmail.com>
 <57991EE9.30005@broadcom.com> <CAOMZO5CvuumYQZ92YFCjd7Vrmp4i1T1pdYAmGUvRgjNzVpMWyQ@mail.gmail.com>
 <814ae6d0-2375-e8bd-f3e3-98ec5f69b376@broadcom.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 28 Jul 2016 22:05:25 -0300
Message-ID: <CAOMZO5BHs1XOX=7Y8Ji7bv3J8LWxiGDqGgyzuEzb2vGroDCmVA@mail.gmail.com> (sfid-20160729_030530_516391_A3B0B733)
Subject: Re: brcm4330 fails to load on newer kernels
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Thu, Jul 28, 2016 at 3:37 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:

> Hi Fabio,
>
> So this is another fine example of firmware API not able to deliver. I
> think in all these kernels you have the same issue. The problem is that
> the order of events upon kernel boot is not predictable. In this case
> you have rootfs being mounted and brcmfmac getting probed as the two
> competing events. When rootfs is mounted before brcmfmac is being probed
> it works, but if brcmfmac is probed before rootfs is mounted the
> firmware request will fail. So the only reliable option for built-in
> drivers requiring firmware is to built-in the firmware into the kernel
> as well.

Thanks for your explanation.

Tried building brcmfmac as module and after doing 'modprobe brcmfmac'
the firmware is correctly loaded from the rootfs in all the kernels I
tested.

Now I just need it to load brcmfmac module automatically, but this is
a a separate issue I will investigate.

Thanks a lot for your help!

Fabio Estevam
