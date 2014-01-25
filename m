Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:44421 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYBrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 20:47:42 -0500
Received: by mail-qa0-f52.google.com with SMTP id j15so4883390qaq.11
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 17:47:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADzE2xw0vpeOXxVLdvnfnX57+gRnthrrSnNy=S0HVhH19YS7bQ@mail.gmail.com>
References: <CADzE2xw0vpeOXxVLdvnfnX57+gRnthrrSnNy=S0HVhH19YS7bQ@mail.gmail.com>
Date: Fri, 24 Jan 2014 20:47:41 -0500
Message-ID: <CADzE2xzAaGUQ8XWCA4vjJPO5oxFq8VCiJKHWEd0-1FTvUFxxFw@mail.gmail.com> (sfid-20140125_024744_763844_251E04C9)
Subject: Re: I'm not sure which one of you to send this to, but I do have a
 bug to report.
From: Wyatt Ward <wyattfward@gmail.com>
To: stefano.brivio@polimi.it, m@bues.ch, zajec5@gmail.com,
	brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I forgot something: I think the config line in the kernel
compilation that fixed everything was `CONFIG_BCMA_BLOCKIO=y`. This
stops BCMA from interfacing with devices, correct? Anyway, with SSB
only, my card is working again at a normal speed.

On Fri, Jan 24, 2014 at 8:45 PM, Wyatt Ward <wyattfward@gmail.com> wrote:
> I have a bcm4311 chipset; it is identified in `lspci -vnn` as:
>     01:00.0 Network controller [0280]: Broadcom Corporation BCM4311
> 802.11a/b/g [14e4:4312] (rev 01)
>
> Without compiling the kernel with some of BCMA disabled, I cannot make
> my card work at a decent speed.
>
> This is in Linux Kernel 3.13, but I have had this problem with other
> recent kernel versions.
> My hardware is a late 2006, Intel Core 2 Duo iMac, and the linux
> distro  is Mint 16.
>
> The problem is that both  SSB  and BCMA are loading to support the b43
>  module, where I only want SSB to load. I had this issue in 3.11, and
> my custom build of 3.13 worked, but I don't see any changes to b43 or
> BCMA that would effect this. I think that it was my tweaking of the
> compile options for BCMA fixed this, but in any case
>
> I believe that the SSB and BCMA modules are  interfering with each
> other, killing my network speed seemingly at random.
> I think it's because my card (*'0x4312') is being recognized in bcma
> as a supported bcm4312 or 4313 chipset, when it actually can indicate
> a 4311 chipset, which, as far as i know, is not supported by these, or
> brcmsmac. I have to admit I am not clear on the differences between
> these chipsets, but I do know the 4312 is a PHY device, and as far as
> I know, the 4313 is an upgraded 4311.
>
> Attached are the `lspci` and `lsmod` outputs for when the 3.13 kernel
> is loaded and when the 3.11 kernel is loaded. I believe that without
> tweaking my compile settings, my system would still be behaving badly.
> The 3.13 kernel works, and lsmod shows that bcma is not loaded. 3.11
> doesn't and shows it as loaded. I am having a hard time finding my
> unmodified .config file for the kernel, but i have an intermediate
> step's config file which also exhibited the problems. The `lsmod` and
> `lspci` files also contain the outputs of `uname --all` so you can see
> details of the kernel being used when I performed each test.
>
> I apologize if I am giving too much information, but I have never
> reported a bug in the Linux Kernel before. I hope I did alright :)
> -Wyatt
