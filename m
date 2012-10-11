Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61002 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2JKUbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 16:31:20 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so2124315pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 13:31:20 -0700 (PDT)
Date: Fri, 12 Oct 2012 05:31:12 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
Message-ID: <20121011203112.GB3317@kroah.com> (sfid-20121011_223123_828351_3B4B0AEC)
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 11, 2012 at 10:01:38PM +0200, Pontus Fuchs wrote:
> Some time ago I found an old USB wireless dongle in my drawer. I was
> surprised it wasn't supported in Linux. Google gave me an old
> unfinished driver created by Christoph Hellwig. Armed with some
> spare time and naivity I picked up where Christoph left in 2007 and
> now it's actually working pretty fine. It does not crash for me and
> throughput is decent.
> 
> It's based on the FreeBSD driver, which in turn is based on the
> reverse engineered Windows driver, hence a very limited feature set.
> Not even HW crypto offload is supported. But at least there is a
> firmware which has a suitable license:
> 
> http://www.freebsd.org/cgi/cvsweb.cgi/src/sys/contrib/dev/uath/ar5523.bin.uu
> 
> Pontus Fuchs (4):
>   ar5523: Add main driver file
>   ar5523: Add driver header file
>   ar5523: Add Firmware API header file
>   ar5523: Add Kconfig and Makefile
> 
>  drivers/staging/Kconfig            |    2 +
>  drivers/staging/Makefile           |    1 +
>  drivers/staging/ar5523/Kconfig     |    7 +
>  drivers/staging/ar5523/Makefile    |    1 +
>  drivers/staging/ar5523/ar5523.c    | 1824 ++++++++++++++++++++++++++++++++++++
>  drivers/staging/ar5523/ar5523.h    |  164 ++++
>  drivers/staging/ar5523/ar5523_hw.h |  447 +++++++++
>  7 files changed, 2446 insertions(+)
>  create mode 100644 drivers/staging/ar5523/Kconfig
>  create mode 100644 drivers/staging/ar5523/Makefile
>  create mode 100644 drivers/staging/ar5523/ar5523.c
>  create mode 100644 drivers/staging/ar5523/ar5523.h
>  create mode 100644 drivers/staging/ar5523/ar5523_hw.h

Very nice.

But what is keeping this driver from going to the "proper" place in the
kernel tree (i.e. drivers/net/...)?  I don't have a problem adding it to
the staging tree, but it would need a TODO file to list what is needed
to get it out of the staging tree.

thanks,

greg k-h
