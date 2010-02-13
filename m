Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:34748 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0BMB3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 20:29:10 -0500
Received: by pzk35 with SMTP id 35so791287pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2010 17:29:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <25E8B46727291E4EB5A1CB88CBC4284E0100A872@zmy16exm21.fsl.freescale.net>
References: <1265467103-11474-1-git-send-email-tom.leiming@gmail.com>
	<25E8B46727291E4EB5A1CB88CBC4284E0100A711@zmy16exm21.fsl.freescale.net>
	<43e72e891002081001td19c48cjf193ab8503255ee3@mail.gmail.com>
	<02a001caa94e$87b9bb80$972d3280$@kaist.ac.kr> <25E8B46727291E4EB5A1CB88CBC4284E0100A779@zmy16exm21.fsl.freescale.net>
	<20100209171005.GB16748@tux> <25E8B46727291E4EB5A1CB88CBC4284E0100A872@zmy16exm21.fsl.freescale.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 12 Feb 2010 17:28:48 -0800
Message-ID: <43e72e891002121728k6f623d9egc2146b8ca09a9fd2@mail.gmail.com>
Subject: Re: [ath9k-devel] can ath9k run on linux 2.6.25
To: Zhang Yanfei-B21500 <B21500@freescale.com>
Cc: Jinsung Lee <ljs@netsys.kaist.ac.kr>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 10, 2010 at 7:03 PM, Zhang Yanfei-B21500
<B21500@freescale.com> wrote:
> Hi Luis
>
>    I am porting the compat-wireless-2.6.32-3 to my powerpc platform
> with 2.6.25 kernel.  After disable the LED marco in config.mk i have
> compile it sucess. but when i load it , it show below error messages,
> anyone can help on this?
> the kernel modules manually load order is below: am i right ?
>    1. rfkill_backport
>     2. cfg_802.11
>     3. mac80211
>         4. ath
>         5. ath9k
> #insmod rfkill_backport.ko
> rfkill_backport: Unknown symbol dev_set_name
> insmod: cannot insert 'rfkill_backport.ko': unknown symbol in module
> (-1): No such file or directory
>
>  i found that the compat-2.6.26 have the dev_set_name function, but
> compat-2.6.25 don't have this.

That is the point, so the way the compat-2.6.x files work is that say
you are on 2.6.25 it means you need backport work for 2.6.26, 2.6.27,
2.6.28, 2.6.29, 2.6.30, 2.6.31, 2.6.32 and 2.6.33.

So you get compiled the respective objects for each kernel and these
get linked into a compat module.

dev_set_name() was added as of the 2.6.26 kernel so having it defined
for kernels >= 2.6.25 is correct, and it is also exported.

Only thing I can think of is perhaps rfkill doesn't have the compat.h
header included? I'll check in a while.

>  In new kernel(2.6.29)  it's is device/base/core.c, then i try to copy
> the function into my 2.6.25 kernel.
> but it loss the 'kobject_set_name_vargs', here is the compile
> information.
> $drivers/base/core.c: In function 'dev_set_name':
> $drivers/base/core.c:880: error: implicit declaration of function
> 'kobject_set_name_vargs'

Senthil backported this on compat-2.6.26.c, there are two different
ways to backport this, one for kernels >= 2.6.25 which is at the top
and then for kernels older, at the bottom:

/* 2.6.24 does not have the struct kobject with a name */
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))

/**
 * kobject_set_name_vargs - Set the name of an kobject
 * @kobj: struct kobject to set the name of
 * @fmt: format string used to build the name
 * @vargs: vargs to format the string.
 */
static
int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
                                  va_list vargs)
{
        const char *old_name = kobj->name;
        char *s;

        if (kobj->name && !fmt)
                return 0;

        kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
        if (!kobj->name)
                return -ENOMEM;

        /* ewww... some of these buggers have '/' in the name ... */
        while ((s = strchr(kobj->name, '/')))
                s[0] = '!';

        kfree(old_name);
        return 0;
}
#else
static
int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
                                  va_list vargs)
{
        struct device *dev;
        unsigned int len;
        va_list aq;

        dev = container_of(kobj, struct device, kobj);

        va_copy(aq, vargs);
        len = vsnprintf(NULL, 0, fmt, aq);
        va_end(aq);

        len = len < BUS_ID_SIZE ? (len + 1) : BUS_ID_SIZE;

        vsnprintf(dev->bus_id, len, fmt, vargs);
        return 0;
}
#endif

  Luis
