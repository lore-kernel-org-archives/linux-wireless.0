Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48279 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2LKHim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 02:38:42 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so2570582qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 23:38:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355180983.3738.112.camel@cumari.coelho.fi>
References: <1354229283-7934-1-git-send-email-arik@wizery.com>
 <1355153582.3738.53.camel@cumari.coelho.fi> <CA+XVXffLuJuqQJ8Ju5XsipSdkuUBFOx=0ReQJe8Oc7J-5X+B6Q@mail.gmail.com>
 <1355176215.3738.102.camel@cumari.coelho.fi> <CA+XVXffZgF+rJfgrGbq0+D2Y1gx2VmZ1HziD18r9NNwqQ2BVjA@mail.gmail.com>
 <1355180983.3738.112.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 11 Dec 2012 09:38:24 +0200
Message-ID: <CA+XVXfe7BcG+8_9MTBzxovfoQF81uW-KoSMWdV8sPmY-Dj-mbw@mail.gmail.com> (sfid-20121211_083846_636151_97B56740)
Subject: Re: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 11, 2012 at 1:09 AM, Luciano Coelho <coelho@ti.com> wrote:
>
>> So for instance we want to stop all vifs during recovery, and mark all
>> with stop reasons. That's also the reason I used the mac80211 global
>> API for stopping/waking the queues.
>
> A "global" ieee80211_iterate_active_interfaces_atomic() would do the
> same thing. ;)
>
> But I agree that it's simpler to set all possible vifs as stopped here.

Actually your suggestion acts differently in some corner cases.
Namely, if we stop all vifs and suddenly mac80211 decides to add a
vif, then the new vif will not be stopped, and we will clear all stop
reasons for it.
Then with my version, we will trigger the the WARN_ON when waking the
queues. But this corner case is so strange that I would like a WARN_ON
there to detect it. If we do stumble across it, we can discuss various
solutions, including changing mac80211..

TLDR: Let's keep it the way it is today :)
