Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64953 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbaDJChs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 22:37:48 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so3250040pdi.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 19:37:47 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/8] cfg80211: remove unnecessary include clauses
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
	<c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com>
	<1397029770.4964.2.camel@jlt4.sipsolutions.net>
	<87d2gqg05o.fsf@gmail.com>
	<1397047019.4964.8.camel@jlt4.sipsolutions.net>
	<1397047400.4964.13.camel@jlt4.sipsolutions.net>
Date: Thu, 10 Apr 2014 10:37:35 +0800
In-Reply-To: <1397047400.4964.13.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 09 Apr 2014 14:43:20 +0200")
Message-ID: <87txa1ewpc.fsf@gmail.com> (sfid-20140410_043753_727065_5B0382D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 14:43:20 +0200, Johannes Berg wrote:
> On Wed, 2014-04-09 at 14:36 +0200, Johannes Berg wrote:
>
>> At the current point in time. If some of the headers that you rely on
>> including something no longer does in the future because it no longer
>> needs that, then you just broke everything.
>
> Take the first of those patches for example. You say
>
> <linux/bug.h> and <linux/net.h> is included by <linux/skbuff.h>.
>
> However, this is a side effect of some implementation detail in
> skbuff.h. If, in the future, some function in skbuff.h is no longer
> inlined, then skbuff.h will no longer have to include bug.h and can
> remove it. That change would break the build due to your patches.
>
> The way you should think about this isn't the mechanic include chain,
> it's the API that each file defines. skbuff.h includes bug.h due to an
> implementation detail, but it doesn't intentionally re-export all the
> bug.h API, that's not the purpose of skbuff.h. The purpose of skbuff.h
> is to capture the SKB related APIs and structures, so that's the only
> thing you should rely on getting from it.
>
> Similarly, you should include bug.h if you need the APIs from that,
> rather than relying on it being included more or less accidentally
> through something else.
>
> Obviously, the lack of namespaces etc. in the compiler makes it
> impossible to actually enforce this, and as a result we often *miss*
> includes that should be there, which sometimes gets found later when
> things change or on different platforms if the recursive include was
> platform specific, but we shouldn't exacerbate this problem by actively
> removing correct includes.
>
> Now, of course, if you find includes that aren't actually *needed* (e.g.
> bug.h in a file that doesn't use BUG() or WARN() variants) then those
> should be removed.

I just want to reduce the possibility that duplicate including could
hide some warnings which I explained in anoother thread. The current way
I use may be too aggressive as you said. I will try to use your
suggestion to remove duplicate including, so the last four patches can
be dropped.

BTW, after I explained why I changed the parameter type in the first
patch, do you still think that is not appropriate ?

>
> johannes
