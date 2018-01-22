Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:41406 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbeAVPEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 10:04:34 -0500
Received: by mail-pf0-f195.google.com with SMTP id c6so4219564pfi.8
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 07:04:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180122145759.GA18798@kroah.com>
References: <001a11c14bc837f9760560a03d51@google.com> <20171219090121.GA10221@kroah.com>
 <CACT4Y+ZggKsEjCRZsFPW5-7_ByBcz4G0uRdieLL==r4mLQjhFA@mail.gmail.com>
 <CACT4Y+ZOimZPrSfphPMiHKXA3=kOmaFfwdofrmuv_rpXmx+vgA@mail.gmail.com>
 <CACT4Y+YMMfsXb+X4ApcWW02Qe7FmARhHjg97H4J-369OEMnwhw@mail.gmail.com>
 <20180122140015.GA30036@kroah.com> <CACT4Y+bEG22Wa6hiBQ6YX7d=JrHKAXfwYm+tu6cWc7AiUZxYbw@mail.gmail.com>
 <20180122145759.GA18798@kroah.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 22 Jan 2018 16:04:12 +0100
Message-ID: <CACT4Y+YSHC-fUxiymRDTOGivK6OXp6JO1XsVqbLStJs9iaH_Cw@mail.gmail.com> (sfid-20180122_160454_604328_F7CF4848)
Subject: Re: [PATCH] sysfs: turn WARN() into pr_warn()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: syzbot
        <bot+1fdad4e2731bf0c1bc19953ccc5061237ec92783@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        jakub.kicinski@netronome.com,
        Willem de Bruijn <willemb@google.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        John Fastabend <john.fastabend@gmail.com>,
        "Tobin C. Harding" <me@tobin.cc>, netdev <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 3:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> It's not good to crash the machine if panic_on_warn() is set just
> because someone made a stupid mistake of trying to create a sysfs file
> with the same name of an existing one.  This makes the automated testing
> tools a lot harder to find the real bugs in the kernel.
>
> So just print a warning out and dump the stack to get the attention of
> the developer that they did something foolish.  Then keep on trucking,
> as this should not be a fatal error at all.
>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>
> Dmitry, does this look good to you?  If so, I'll queue it up for
> 4.16-rc1.

Perfect! Looks good. syzbot reacts on "WARNING:" string (+ if kernel
panic due to panic_on_warn that's also obviously a problem).

> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 2b67bda2021b..3a36a48a4b3f 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -10,6 +10,7 @@
>   * Please see Documentation/filesystems/sysfs.txt for more information.
>   */
>
> +#define pr_fmt(fmt)    "sysfs: " fmt
>  #undef DEBUG
>
>  #include <linux/fs.h>
> @@ -27,8 +28,8 @@ void sysfs_warn_dup(struct kernfs_node *parent, const char *name)
>         if (buf)
>                 kernfs_path(parent, buf, PATH_MAX);
>
> -       WARN(1, KERN_WARNING "sysfs: cannot create duplicate filename '%s/%s'\n",
> -            buf, name);
> +       pr_warn("cannot create duplicate filename '%s/%s'\n", buf, name);
> +       dump_stack();
>
>         kfree(buf);
>  }
