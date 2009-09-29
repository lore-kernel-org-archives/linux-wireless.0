Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:57719 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZI2JAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 05:00:12 -0400
Received: by ewy7 with SMTP id 7so5200425ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 02:00:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909291050.54388.malte.gell@gmx.de>
References: <200909260457.21103.malte.gell@gmx.de>
	 <4ABDE7AC.1090409@hauke-m.de> <200909291050.54388.malte.gell@gmx.de>
Date: Tue, 29 Sep 2009 10:00:14 +0100
Message-ID: <3ace41890909290200h4dbefddah131851675dc06097@mail.gmail.com>
Subject: Re: cannot compile compate-wirless snapshots
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Malte Gell <malte.gell@gmx.de>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2009 at 9:50 AM, Malte Gell <malte.gell@gmx.de> wrote:
>
> Hauke Mehrtens <hauke@hauke-m.de> wrote
>
>
>> Does this file exists in your installation?
>> /lib/modules/`uname -r`/build/include/linux/tracepoint.h ?
>
> Yes, but, look:
>
> cd /usr/src/linux
>
> grep -i tracepoint .config
>
> # CONFIG_TRACEPOINTS is not set
>
> Do I need to set it to yes?
>
> Malte
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

No. You should not manually edit any kernel config file (the
compat-wireless module should be built against a config matching your
running kernel, not a massaged version of it) and what is in
/usr/src/linux is irrelevant , because that is not your running
kernel.

The relevant config is probably /boot/config-`uname -r`, but, please
do *not* modify it.

I already wrote - your best bet is simply deleting all the 'error
redefintion' parts from net/compat-2.6.28.h, since your kernel tree is
somewhere between 2.6.27 and 2.6.28 . (and also delete some part of
net/compat-2.6.28.c when possible later linker error arises).
