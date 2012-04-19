Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38525 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2DSFD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 01:03:28 -0400
Received: by wgbdr13 with SMTP id dr13so8226538wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 22:03:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B31F2BFC-F699-4EC5-92AD-194A4FBC1185@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<4F8DC25E.9090702@broadcom.com>
	<B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com>
	<4F8E0CBE.6010103@sipsolutions.net>
	<0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
	<CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
	<4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com>
	<CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com>
	<FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
	<CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com>
	<816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com>
	<CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com>
	<5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com>
	<CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com>
	<B31F2BFC-F699-4EC5-92AD-194A4FBC1185@gmail.com>
Date: Thu, 19 Apr 2012 08:03:27 +0300
Message-ID: <CANUX_P1YGF3Hcs8+AV7cthhERyqJiwa7_u+vfWiU_K+fv-7Onw@mail.gmail.com> (sfid-20120419_070331_839522_F9A8C210)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 19, 2012 at 00:17, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> One thing I just remembered: I had problems compiling the code and because of that commented some lines in the code out:
>
> # make
> ./scripts/gen-compat-autoconf.sh /root/compat-wireless-3.4-rc1-2/.config /root/compat-wireless-3.4-rc1-2/config.mk > include/linux/compat_autoconf.h
> make -C /lib/modules/2.6.32.12-0.7.1/build M=/root/compat-wireless-3.4-rc1-2 modules
> make[1]: Entering directory `/mnt/src/redhat/BUILD/kernel-2.6.32.120.7.1'
>  Updating /root/compat-wireless-3.4-rc1-2/Makefile.xen
>  CC [M]  /root/compat-wireless-3.4-rc1-2/compat/main.o
> In file included from include/net/dst.h:13,
>                 from include/net/sock.h:61,
>                 from /root/compat-wireless-3.4-rc1-2/include/linux/compat-2.6.35.h:8,
>                 from /root/compat-wireless-3.4-rc1-2/include/linux/compat-2.6.h:55,
>                 from <Kommandozeile>:1:
> include/linux/rtnetlink.h:785: Fehler: Redefinition von »rcu_read_lock_held«
> /root/compat-wireless-3.4-rc1-2/include/linux/compat-2.6.34.h:291: Fehler: Vorherige Definition von »rcu_read_lock_held« war hier
> make[3]: *** [/root/compat-wireless-3.4-rc1-2/compat/main.o] Fehler 1
> make[2]: *** [/root/compat-wireless-3.4-rc1-2/compat] Fehler 2
> make[1]: *** [_module_/root/compat-wireless-3.4-rc1-2] Fehler 2
> make[1]: Leaving directory `/mnt/src/redhat/BUILD/kernel-2.6.32.120.7.1'
> make: *** [modules] Fehler 2
>
> I made a change to the file /root/compat-wireless-3.4-rc1-2/include/linux/compat-2.6.34.h line 291 and commented the following lines out:
>
> before:
> static inline int rcu_read_lock_held(void)
> {
>        return 1;
> }
>
> after:
>
> /*
> static inline int rcu_read_lock_held(void)
> {
>        return 1;
> }
> */
>
> Might that cause the problem? How can I get rid of this error??
>

Nope. that can't cause the issue.
