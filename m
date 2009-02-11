Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:46277 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZBKV5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:57:11 -0500
Received: by gxk22 with SMTP id 22so28227gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 13:57:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49928965.5000800@impulze.org>
References: <49928231.3070405@impulze.org> <49928965.5000800@impulze.org>
Date: Wed, 11 Feb 2009 13:57:09 -0800
Message-ID: <43e72e890902111357q748a3664i39285598f397c9f3@mail.gmail.com> (sfid-20090211_225716_180635_2A83FC28)
Subject: Re: also use SBINDIR for the regulatory.rules
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Daniel Mierswa <impulze@impulze.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 12:16 AM, Daniel Mierswa <impulze@impulze.org> wrote:
> On 11.02.2009 08:45, Daniel Mierswa wrote:
>>> You supply the user with a chance to specify SBINDIR during make
>>> install, yet forgot to use it in one place at the install target. I
>>> attached a patch against trunk for crda.git which fixes that.
>>>
>>> Also choosing /sbin as default SBINDIR path is probably not a good idea,
>>> since you link against gcrypt and crypto which are both located in /usr
>>> which upstream won't change. So it's either thinking of another method
>>> to do db verification or to choose /usr/sbin as default binary location.
>>> Thanks for your time. Feedback welcomed.  :)
>>
>> Do the same with udev/regulatory.rules. Hope it fits.
>>
>>
> And of course that attached patch was all wrong. Sorry :( Here's a new one.
>
>
> --
> Mierswa, Daniel
>
> If you still don't like it, that's ok: that's why I'm boss. I simply
> know better than you do.
>               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22
>
>
> From 9d4b1b20bf02d4233b6323d85140385650a9dc09 Mon Sep 17 00:00:00 2001
> From: Daniel Mierswa <impulze@impulze.org>
> Date: Wed, 11 Feb 2009 08:39:55 +0100
> Subject: [PATCH] also replace the SBINDIR used in the rules file
>
> ---
>  Makefile              |    1 +
>  udev/regulatory.rules |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 106397d..4079bb0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,6 +119,7 @@ install: crda crda.8.gz regdbdump.8.gz
>        @# putting it in the right place.
>        $(Q)rm -f $(DESTDIR)/etc/udev/rules.d/regulatory.rules
>        $(Q)ln -sf regulatory.rules udev/$(UDEV_LEVEL)regulatory.rules
> +       $(Q)sed 's:$$(SBINDIR):$(SBINDIR):' -i udev/regulatory.rules
>        $(Q)$(INSTALL) -m 644 -t \
>                $(DESTDIR)/$(UDEV_RULE_DIR)/ \
>                udev/$(UDEV_LEVEL)regulatory.rules
> diff --git a/udev/regulatory.rules b/udev/regulatory.rules
> index e81d802..ef9b5f1 100644
> --- a/udev/regulatory.rules
> +++ b/udev/regulatory.rules
> @@ -2,4 +2,4 @@
>  # For more information see:
>  # http://wireless.kernel.org/en/developers/Regulatory/CRDA
>
> -KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform", RUN+="/sbin/crda"
> +KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform", RUN+="$(SBINDIR)"

How is it the udev rule will know what $(SBINDIR) is?

  Luis
