Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52603 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZG3PkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 11:40:13 -0400
Received: by ewy10 with SMTP id 10so843751ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 08:40:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <939177.72004.qm@web15806.mail.cnb.yahoo.com>
References: <939177.72004.qm@web15806.mail.cnb.yahoo.com>
Date: Thu, 30 Jul 2009 16:40:13 +0100
Message-ID: <3ace41890907300840t1d018066yb586663d865fec49@mail.gmail.com>
Subject: Re: The problem of driver of rtl8187 wireless card
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: gu gu <guatsheng@yahoo.com.cn>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/30 gu gu <guatsheng@yahoo.com.cn>:
> Hi!
> Thank you for your reply.
>   Because I have an ARM board which run linux -v2.6.25.10,so I have to use  "compat-wireless-2.6-old.tar.bz2" packet to generate the "rtl8187.ko" .But the real problem is that I can't make it to get  "rtl8187.ko"(modules).And you say need other modules, So which modules I  needed?And how can I do?
>   The directory "compat-wireless-2.6-old/drivers/net/wireless" has no
>  driver of rtl8187,So I send the compiled packet for you in Accessory.I think something wrong in it ,I just set the values of KLIB & KLIB_BUILD in Makefile.How do that?
>
>  Could you tell me how to resolve it ,thank you!Looking forward
> from you .

Hmm,  you only have 18 modules, not the 50+ it should be. You also
make a mistake with your editing of the Makefile. (I think it is
common ettique to check for problems from self-inflicted issues like
that). I think compat-wireless won't build any modules your tree have
them built-in (because if you can't unload  the old one, there is no
point building new), so you *must* set your KBUILD/KLIB correctly, if
you choose to edit the makefile by hand. if you read the Makefile (as
you should, since you edited it), it mostly just do
        $(MAKE) -C $(KLIB_BUILD) M=$(PWD) modules
recursively down the directory. You could do "make -C <someplace>
M=<here> rtl8187.ko" inside drivers/net/wireless/ and see if a
rtl8187.ko .
but first, correct your editing of the Makefile.
