Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:40476 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZBBBJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2009 20:09:32 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1057939fkf.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2009 17:09:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
	 <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
	 <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
	 <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
	 <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
Date: Mon, 2 Feb 2009 01:09:30 +0000
Message-ID: <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com> (sfid-20090202_020940_142442_C23D1DFC)
Subject: Re: rtl8187 wireless issues
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 10:04 PM, P.G. Richardson
<p.g.richardson@phantomjinx.co.uk> wrote:

> I am not that familiar with kernel makefiles but it would seem that the
> drivers/net/wireless line below is not recursive:
>
> obj-y := net/wireless/ net/mac80211/
> ifeq ($(ONLY_CORE),)
> obj-$(CONFIG_B44) += drivers/net/b44.o
> obj-y += drivers/ssb/ \
>        drivers/misc/eeprom/ \
>        drivers/net/usb/ \
>        drivers/net/wireless/
> endif

It is recursive - it runs Makefile in drivers/net/wireless/ . Your
list is very small - it should build and install 40+ kernel modules.
curious. some kernel config means the modules aren't built, but in
your case they are built but not installed... I wonder if it is
affected by blacklist.
