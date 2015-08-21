Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39808 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbHUH5Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 03:57:24 -0400
Message-ID: <1440143840.2107.2.camel@sipsolutions.net> (sfid-20150821_095727_697670_EF5C7C23)
Subject: Re: mac80211: When adding a new station, notify driver before
 adding to hash
From: Johannes Berg <johannes@sipsolutions.net>
To: Marty Faltesek <mfaltesek@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 21 Aug 2015 09:57:20 +0200
In-Reply-To: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com> (sfid-20150820_233906_992240_4933DE3C)
References: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
	 (sfid-20150820_233906_992240_4933DE3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-20 at 17:39 -0400, Marty Faltesek wrote:
> 
> I believe the following race occurs:
> 
> 1. mac80211 is processing a new station that just joined.
> 2. Before it's completed initializing the station, we take an 
> interrupt,
>    with a packet from the STA.
> 3. That interrupt is a management frame from the station which causes
>    rate_control_rate_update to be called, which calls back into the 
> ath10k
>    with the not-fully initialized station.

I'm a bit confused by the stack trace - is this IBSS and the stack
trace is just bad? I don't really see how we get from sta_ps_transition
to sta_rc_update?

> 4. It reaches ath10k_sta_rc_update before the interrupted thread had
> reached ath10k_sta_state()
>    Therefore it has not yet initialized its workqueue. Still NULL.
> 5. When this NULL workqueue gets passed to queue_work, it passes
>    the first check that its not in use because of the NULL struct, 
> but fails the
>    next check in __queue_work because a NULL structure makes the test
>    for an empty list fail.
> 
> 
> Proposed patch is to not add the new station in the hash until after 
> the
> driver initializes it. But I'm not clear what implications this has. 
> Could this
> cause other problems?
> 

I think the issue Michał pointed out is valid - but we can probably
check sta->uploaded in the relevant places?

johannes
