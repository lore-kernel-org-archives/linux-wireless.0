Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43889 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0GLRi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 13:38:59 -0400
Date: Mon, 12 Jul 2010 19:37:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] prism54: call BUG_ON() earlier
Message-ID: <20100712173714.GD5658@bicker>
References: <20100710085338.GQ19184@bicker> <AANLkTikJ9Ae2HRIwdcc8oVgAc2zoVHUL7ZY9k2QO2QpS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTikJ9Ae2HRIwdcc8oVgAc2zoVHUL7ZY9k2QO2QpS@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 12, 2010 at 10:06:55AM -0700, Luis R. Rodriguez wrote:
> On Sat, Jul 10, 2010 at 1:53 AM, Dan Carpenter <error27@gmail.com> wrote:
> > This test is off by one because strlen() doesn't include the NULL
> > terminator.
> >
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> >
> > diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> > index 8d1190c..1051268 100644
> > --- a/drivers/net/wireless/prism54/isl_ioctl.c
> > +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> > @@ -2067,7 +2067,7 @@ send_simple_event(islpci_private *priv, const char *str)
> >        memptr = kmalloc(IW_CUSTOM_MAX, GFP_KERNEL);
> >        if (!memptr)
> >                return;
> > -       BUG_ON(n > IW_CUSTOM_MAX);
> > +       BUG_ON(n >= IW_CUSTOM_MAX);
> >        wrqu.data.pointer = memptr;
> >        wrqu.data.length = n;
> >        strcpy(memptr, str);
> >
> 
> send_simple_event() never passes a NULL terminated string though. What
> does this fix today? If nothing then better leave as-is.
> 
>   Luis

It doesn't fix any bugs in the current code, but it's a necessary clean
up.

        memptr = kmalloc(IW_CUSTOM_MAX, GFP_KERNEL);
	                 ^^^^^^^^^^^^^
	This is the size of memptr.

        if (!memptr)
                return;
        BUG_ON(n > IW_CUSTOM_MAX);

	^^^^^^^^^^^^^^^^^^^^^^^^^^
	This is an off-by-one check.

        wrqu.data.pointer = memptr;
        wrqu.data.length = n;
        strcpy(memptr, str);
	^^^^^^^^^^^^^^^^^^^^

	This would be a silent memory corruption.

In the current code we only use short event strings so the check isn't
needed.  But we should either correct the check or remove it.

regards,
dan carpenter


