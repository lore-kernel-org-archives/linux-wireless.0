Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44883 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3KNPLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:11:10 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so2154598pbc.29
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 07:11:09 -0800 (PST)
Date: Thu, 14 Nov 2013 07:21:50 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/5] cfg80211: pass the wdev on the country IE regulatory
 hint
Message-ID: <20131114152146.GA30653@garbanzo.do-not-panic.com> (sfid-20131114_161114_788944_66377B56)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-2-git-send-email-mcgrof@do-not-panic.com>
 <1384377637.28806.14.camel@jlt4.sipsolutions.net>
 <20131114140505.GA19070@garbanzo.do-not-panic.com>
 <1384437774.13941.25.camel@jlt4.sipsolutions.net>
 <20131114151159.GA29954@garbanzo.do-not-panic.com>
 <1384441523.13941.35.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384441523.13941.35.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 04:05:23PM +0100, Johannes Berg wrote:
> On Thu, 2013-11-14 at 07:12 -0800, Luis R. Rodriguez wrote:
> 
> > > But that's kinda unsafe. Might also be worth just making it a
> > > void* to avoid people trying to use it.
> > 
> > OK. I can see the cookie in theory race against the allocator
> > releasing and creating a new wdev and it magically being
> > the same pointer, but chances are really low of that.
> 
> Hmm, good point, maybe it'd be better to clean it up on netdev
> unregistration.

Ah, the block notifier?

  Luis
