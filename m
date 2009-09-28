Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:64590 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZI1VwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 17:52:18 -0400
Received: by ewy7 with SMTP id 7so4872406ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 14:52:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16D9C5FD-4A2A-4061-9C26-FF5C0B0CDFBA@w1an.in>
References: <16D9C5FD-4A2A-4061-9C26-FF5C0B0CDFBA@w1an.in>
Date: Mon, 28 Sep 2009 22:52:21 +0100
Message-ID: <3ace41890909281452x3170c8c6g5dc56cff85663099@mail.gmail.com>
Subject: Re: Question on general wireless testing tree compilation.
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Balaji Ravindran <b@w1an.in>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 6:21 AM, Balaji Ravindran <b@w1an.in> wrote:
> Hi Everyone,
>
> Sorry for a very amateur question. Could anyone just help me get started
> with compiling the linux kernel from the wireless-testing tree? I just
> pulled the local wireless-testing repo, trying to navigate through the code,
> and wanted to compile the kernel, and to boot up to it. Could anyone just
> help me get started?
>
> I followed the instructions from
> http://www.cyberciti.biz/tips/compiling-linux-kernel-26.html
> and ended up with a compile error in 'make', while trying to create the
> bzimage. (error is on make: initramfs_data.cpi.o failed)
>
> Is there any other easy way to compile the kernel/debug.
>
>
> Thanks
>
> Balaji R
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

As the other replier has already stated, including the last few lines
of the message before the error would be nice.

Also, if you haven't built your own kernel before, it is probably
better to start from a known configuration rather than from scratch.
While all the tutorial, etc tells you to do 'make mrproper ; make
menuconfig/xconfig; make' , there are occasionally some missing
dependencies which aren't explicitly hooked up, so it might be easier
to do, instead of make menuconfig/xconfig, in the middle, copy your
distro's config (or your current running kernel's config) from either
/boot/config-* (packaged from your distro) or /proc/config.gz (for a
kernel which remembers its own config - it is a kernel config opton),
to .config in your source tree, run make oldconfig (which only ask
your questions about *difference* between the tree and the running
kernel), before running make menuconfig/xconfig. This way, you are
starting from a valid and know-working configuration for your
hardware/archecture.

Also, compat-wireless (which just replaces the wireless-related kernel
modules) is sometimes a quicker/easier alternative to the whole
wireless-testing.
