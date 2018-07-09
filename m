Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55960 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932366AbeGIJiw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 05:38:52 -0400
Message-ID: <1531129130.3298.26.camel@sipsolutions.net> (sfid-20180709_113856_359206_6CCEF192)
Subject: Re: [PATCH] mac80211: restrict delayed tailroom needed decrement
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2018 11:38:50 +0200
In-Reply-To: <fa862aa4-8cc6-ade1-68f8-88941b59a47e@codeaurora.org>
References: <1531126681-5146-1-git-send-email-mpubbise@codeaurora.org>
         <1531126957.3298.23.camel@sipsolutions.net>
         <99231cb4-8977-c9c4-ff11-0c57899e30b7@codeaurora.org>
         <1531128396.3298.25.camel@sipsolutions.net>
         <fa862aa4-8cc6-ade1-68f8-88941b59a47e@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-07-09 at 15:07 +0530, Manikanta Pubbisetty wrote:

> > I think you should do
> > 
> > ieee80211_key_destroy(..., type == STATION);
> 
> Even this would boil down to the same behavior, no?

Yes, but I think it's easier to understand than thinking "ok this will
delay" when you pass the parameter as true, but then it won't unless
extra conditions are met.

> I was going through the source to figure out that; but all that I could 
> understand is this was mainly done to improve roam time.

Ok, so perhaps more callers should be updated - still I think it'd be
easier to understand.

johannes
