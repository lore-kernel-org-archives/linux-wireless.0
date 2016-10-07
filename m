Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34726 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbcJGH3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 03:29:13 -0400
Received: by mail-it0-f66.google.com with SMTP id j69so608414itb.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2016 00:29:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1475823963.2015.24.camel@sipsolutions.net>
References: <20161007064923.GA3404@symbol-HP-ZBook-15> <1475823963.2015.24.camel@sipsolutions.net>
From: souptick joarder <souptick.joarder@gmail.com>
Date: Fri, 7 Oct 2016 12:59:11 +0530
Message-ID: <CABn1_9bG-VoogCAZGKfLp65gUTFRAwRBbg5hbbzWdvT=HFBiiA@mail.gmail.com> (sfid-20161007_092916_814013_8B5C3433)
Subject: Re: [PATCH] wl18xx: Handle kfree() in better way when kzalloc fails
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Souptick Joarder <jrdr.linux@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Julian Calaby <julian.calaby@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rameshwar Sahu <sahu.rameshwar73@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2016 at 12:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Fri, 2016-10-07 at 12:19 +0530, Souptick Joarder wrote:
> > This patch is added to handle kfree and return error in a better way
>
> What's "better" about this?
>
> kfree(NULL) is perfectly valid, adding another label makes the code
> harder to read,

I agree with you.

when kzalloc(sizeof(*cmd), GFP_KERNEL) fails, try to avoid extra
kfree(cmd_channel) function call,
cause anyway it will call kfree with NULL.

I thought from that point of view.

>
> > -     struct wl18xx_cmd_scan_params *cmd;
> > +     struct wl18xx_cmd_scan_params *cmd = NULL;
>
> that new initialization is actually *completely* pointless since it's
> overwritten immediately here:
>
> >       struct wlcore_scan_channels *cmd_channels = NULL;
> >       int ret;
> >
> >       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> >       if (!cmd) {
> > -             ret = -ENOMEM;
> > -             goto out;
> > +             return -ENOMEM;
> >       }
> >
> ...
>
> what gives?
>

> johannes

Ok, I will drop this patch.

-Souptick
