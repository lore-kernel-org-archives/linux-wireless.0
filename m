Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58084 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcHLF6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 01:58:04 -0400
Message-ID: <1470981481.26902.4.camel@sipsolutions.net> (sfid-20160812_075807_622268_3F3515CE)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 12 Aug 2016 07:58:01 +0200
In-Reply-To: <57ACC1F8.6070908@gmail.com> (sfid-20160811_202044_055484_513A0779)
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
	 <1470919643.12075.7.camel@sipsolutions.net> <57ACA9E9.4020507@gmail.com>
	 <1470938627.12075.25.camel@sipsolutions.net> <57ACC1F8.6070908@gmail.com>
	 (sfid-20160811_202044_055484_513A0779)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-11 at 13:20 -0500, Denis Kenzior wrote:
> Hi Johannes,
> 
>  >> Speaking of indentation, can you point me to a doc of the rules I
> > 
> > > 
> > > should follow?
> > 
> > You've seen Documentation/CodingStyle?
> 
> Of course.  But that one doesn't discuss that you want your function 
> parameters to be aligned to the opening '('.  Is there a dialect 
> document specific to linux-wireless?

Sorry. I don't think this is specific to our part of the tree, and I'm
surprised it's not in there. But I see Arend also pointed you to
checkpatch.pl, which, I might add, you shouldn't always take as
authoritative since sometimes "fixing" things for it makes the code
look worse.

> The initial conditions are that:
> cb->args[0..2] == 0.
> 
> So on the first iteration we set filter_wiphy == -1 and check the
> filter attributes.  If set, we modify filter_wiphy accordingly.
> 
> Even if filter_wiphy is set to 0, the if statement should still never
> be entered afterwards since wp_start and if_start are incremented.
> 
> Is this what you're worried about? Do you see a fault in my logic?

No, I don't see a fault in the logic. I just think it's misleading. You
make the code look like it relies on filter_wiphy != 0, but then you go
and treat filter_wiphy==0 as a valid case.

In other places, like nl80211_prepare_wdev_dump(), we add 1 to the
wiphy and subtract it again later to avoid exactly this. Perhaps you
could do the same, and rely only on filter_wiphy instead of really
relying only on wp_start/if_start.

johannes
