Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:10346 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZEQXA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:00:29 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1418493fkq.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:00:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A0FF4FE.1030304@tls-tautenburg.de>
References: <4A0FF4FE.1030304@tls-tautenburg.de>
Date: Mon, 18 May 2009 00:00:28 +0100
Message-ID: <3ace41890905171600i3308f799n2a643e61fd954d4f@mail.gmail.com>
Subject: Re: compile error compat-wireless
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2009 at 12:29 PM, Bringfried Stecklum
<stecklum@tls-tautenburg.de> wrote:
> When trying to compile the latest compat-wireless package on an Ubuntu 8.10
> 64bit system running linux kernel 2.6.27-12 I get the following error
>
> stecklum@extragalactix:~/System/src/compat-wireless-2009-05-17$ make
> ...

You have missed some important info here. - most likely you don't have
the kernel header package installed.

>  CC [M]
>  /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/tx.o
>  CC [M]
>  /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.o
> /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c: In
> function ‘ieee80211_key_alloc’:
> /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c:326:
> error: implicit declaration of function ‘get_unaligned_le32’
> /home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.c:328:
> error: implicit declaration of function ‘get_unaligned_le16’
> make[3]: ***
> [/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211/key.o]
> Error 1
> make[2]: ***
> [/home/stecklum/System/src/compat-wireless-2009-05-17/net/mac80211] Error 2
> make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-05-17]
> Error 2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
> make: *** [modules] Error 2
>
> Regards,
>
>        Bringfried


Those two are defined in
<kernel_source>/include/linux/unaligned/le_byteshift.h since about
2.6.26, I just checked.

make sure  /lib/modules/<kernel_ver>/source/ points to some kernel
source tree (you probably need to install some package called
kernel-dev or linux-dev).

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
