Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:47157 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0D1NBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:01:11 -0400
Received: by mail-qy0-f179.google.com with SMTP id 9so21204917qyk.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 06:01:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100427131654.4ee04752.akpm@linux-foundation.org>
References: <g2t446ae9281004251430t89236181p8f3d056181fb8b49@mail.gmail.com>
	 <1272231646-67723-1-git-send-email-steve@cozybit.com>
	 <20100427131654.4ee04752.akpm@linux-foundation.org>
Date: Wed, 28 Apr 2010 06:00:32 -0700
Message-ID: <i2l446ae9281004280600vdc32123ew75d2b8b74c07dea3@mail.gmail.com>
Subject: Re: [PATCH] Added configurable debug messages to libertastf
From: Steve deRosier <steve@cozybit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com, joe@perches.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 27, 2010 at 1:16 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> I dunno what this pr_fmt() definition is doing here, but it has
> unpleasant effects with a x86_64 allmodconfig build:
>...
> so I cheerily deleted it.

Andrew,

I apologize for the pain.  I was trying to comply with a comment to my
original patch:

On Wed, Apr 21, 2010 at 3:50 PM, Joe Perches <joe@perches.com> wrote:
>> +#define lbtf_pr_info(format, args...) \
>> +     printk(KERN_INFO DRV_NAME": " format, ## args)
>> +#define lbtf_pr_err(format, args...) \
>> +     printk(KERN_ERR DRV_NAME": " format, ## args)
>> +#define lbtf_pr_alert(format, args...) \
>> +     printk(KERN_ALERT DRV_NAME": " format, ## args)
>
> I think it'd be better to add
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> and use the more standard pr_<level>s.

Unfortunately it turned into a mess, partly due to me wanting to keep
the definition in only one place (my .h file) for the module, and
partly to my lack of full understanding of the pr_fmt macro.

"cheerily" deleting it is fine.  I'll followup with a second (better)
patch for that part if I don't like the result.

Thanks,
- Steve
