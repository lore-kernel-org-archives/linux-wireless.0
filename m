Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51958 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbYA1RsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 12:48:02 -0500
Message-ID: <479E14FA.2010206@lwfinger.net> (sfid-20080128_174807_735990_3D2F41F5)
Date: Mon, 28 Jan 2008 10:46:34 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, Tomas Winkler <tomasw@gmail.com>,
	stefano.brivio@polimi.it,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
References: <479D9B5F.5000304@lwfinger.net> <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com> <20080128151200.GC5835@tuxdriver.com> <200801281807.26267.mb@bu3sch.de>
In-Reply-To: <200801281807.26267.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 28 January 2008 16:12:00 John W. Linville wrote:
>> I'm going to hold it back from 2.6.25.  We can work on it for 2.6.26.
> 
> The new band API is really really needed. I already have dozens of FIXMEs
> in b43 that will automatically go away once the mac80211 API is changed.
> Lots of FIXMEs will be added if this is not merged.
> 
> Please apply this patch and apply fixes inside of the 2.6.25 development
> cycle. We are in a _development_ kernel. Kernels _do_ break in development
> stages. That is the whole reason why development kernels exist.
> 
> So if we push this patch to 2.6.26 another bug appears. Should we push
> it to 2.6.27 then instead of simply fixing it in the development cycle?
> 
> Besides that, _nobody_ will test the patch, if it's not applied to your
> tree. So the situation will not be better when you apply it in the
> next development cycle.
> 
> And for users complaining about a development kernel being unusable, well,
> what to say about them? I'd say the right answer would be: Go and use
> a stable kernel!
> 
> Please realize that delaying this patch means increasing the pain for
> driver developers that need this patch for another 80-100 days.
> 

John,

I agree with Michael on this issue. Due to the uncertainty of the quality of my Internet connection 
this winter, I no longer subscribe to linux-wireless, and I'm not sure of all the discussion that 
went into the API change. I have, however, seen the FIXME's in b43. In addition, getting the code 
into 2.6.25-rc1 will get a lot more testers.

One little anecdote about the bug in the subject may help convince you. I discovered this bug 
shortly after the API change was committed to wireless-2.6, but I did not try to fix it until I 
found that I could not apply Stefano's patch for rc80211_pid_algo() unless the API change was also 
in the code. For me, laziness rules and I only worked on this bug when it was less work to fix it 
than to modify Stefano's patch. With these two patches in place, the current development tree is 
working fine with b43.

Larry


