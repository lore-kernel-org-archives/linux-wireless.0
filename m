Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51385 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbaFSJvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2014 05:51:49 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so9025278wib.17
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2014 02:51:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U=i7oeK7Ue=NH2YFhLrZOc359MzRYcj4Cv2dYUC0QwmQ@mail.gmail.com>
References: <1402778536-31305-1-git-send-email-mihirsht@gmail.com> <CAB=NE6U=i7oeK7Ue=NH2YFhLrZOc359MzRYcj4Cv2dYUC0QwmQ@mail.gmail.com>
From: Mihir Shete <mihirsht@gmail.com>
Date: Thu, 19 Jun 2014 15:21:27 +0530
Message-ID: <CAOHe==H=6zZ-CyZL0k1oyLAAD35gFwP-MBc7VDX=Xy=N8fmTEA@mail.gmail.com> (sfid-20140619_115153_225673_CF54284A)
Subject: Re: [PATCH] cfg80211: unblock user hint when cfg80211_regdom is intersected
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Let's keep this in mind:
>
> When processing requests on the queue get_last_request() will return
> the last requests which was accepted and already processed. When
> reg_update_last_request() is issued last_request becomes the newly
> accepted request that we are about to process. If this seems rather
> confusing we should split this up into two, but so far its not clear
> to me this is needed given we serialize processing requests and have a
> last_request->pending too.
>
> __reg_process_hint_user() is evaluating whether or not we should apply
> the passed hint. Given all this, when would lr->intersect be true but
> the set regdomain not be intersected? That would seem like an issue to
> me.
>
hmm, yea but there can be cases when last_request is not processed
and we have already called reg_update_last_request(). This happens because
reg_update_last_request() is called before reg_call_crda() and so I thought we
could ignore the user hints till we hear back from crda.


> Also note that your commit log seems to claim to want to make a change
> only for user type hints but the above folds all your desired changes
> to all the checks it was checking for.
>
> Lastly, we should be allowing through user changes if and only if a
> core or driver hint was not issued,
User hints are for enhancing the compliance and they should be allowed
even after the driver hints.
Say, a device is configured to be sold in the US, and a User travels with it
to some country where 5GHz operation is not allowed then the user
hint will help ensuring that we comply with the new regulatory rules.


>otherwise the intersection makes
> sense to upkeep, however I do see it making sense to allow a user
> regulatory if an intersection was done but *iff* we want to clear the
> old userspace setting,
Yes, agreed. and we have a check in  __reg_process_hint_user()
to override the intersection *iff* we have a *different* userspace setting.


> but note that to do that cleanly we'd have to
> assume an original state. We can do this without much overhead by
> resetting the regulatory core to the original state given that core
> and driver hints will be cached and be set once the reset is called.
> You have to consider when a reset makes sense though and be very very
> careful about this though otherwise you might end up in inconsistent
> states that make no sense at run time. Consider being allowed to do
> certain things, being associated, and then all of a sudden driving the
> regulatory core which would prohibit that current state.
>
> If you really want to enable this regardless of the state you may have
> to trigger disassoc, etc. Please think of all this.
User hints can come at any time and they are always processed irrespective
of the sme state, but I can see Arik is already working on taking care of this
stuff.



-- 
~Mihir~
