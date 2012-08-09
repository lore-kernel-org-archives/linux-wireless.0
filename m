Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35595 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2HIEie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 00:38:34 -0400
Received: by weyx8 with SMTP id x8so20933wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 21:38:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XfyQSjWHrr97L29hRzRx-H4wsPHMQ7mG4n9D_e7p46=A@mail.gmail.com>
References: <1344481126-15702-1-git-send-email-andy@greyhouse.net>
	<CAB=NE6XfyQSjWHrr97L29hRzRx-H4wsPHMQ7mG4n9D_e7p46=A@mail.gmail.com>
Date: Thu, 9 Aug 2012 00:38:32 -0400
Message-ID: <CAHashqAFi=hnwiJHaajjv=WWDnD0jzcpLxrda9F3C8zb-HNGLA@mail.gmail.com> (sfid-20120809_063837_480379_4DAEA98B)
Subject: Re: [PATCH] compat: support RHEL6.3 as a build target
From: Andy Gospodarek <andy@greyhouse.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Phil Perry <phil@elrepo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 8, 2012 at 11:37 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Wed, Aug 8, 2012 at 7:58 PM, Andy Gospodarek <andy@greyhouse.net> wrote:
>> This patch allows me to compile and load the latest compat modules on
>> RHEL6.3.  Users of compat on RHEL6 should note that you should set
>> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
>>
>> Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
>
> Thanks! Any chance you can git fetch; git rebase; (ensuring you have
> 42faf2dc8d8 at tip) and then try running:
>
> ./bin/get-compat-kernels
>
> This can take ~10 minutes
>
> And then test compile your changes with:
>
> ./bin/ckmake
>
> And provide that as part of your commit log message?

I just did this and will post a v2 patch right now.

> We can likely add
> the RHEL kernels to the ./bin/get-compat-kernels if you can figure out
> a way to unpack them for any user out there on any Linux distribution.
> This way I can gate future patches from being merged unless they also
> give me a good set of results from ckmake.
>
> Thoughts ?

I like it.  I'll look into the guts of these scripts a bit more and
see what we can get added.
