Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38054 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbeE1IG1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 04:06:27 -0400
Message-ID: <1527494784.8221.1.camel@sipsolutions.net> (sfid-20180528_100632_326702_A962B51A)
Subject: Re: [RFC] mac80211: add stop/start logic for software TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date: Mon, 28 May 2018 10:06:24 +0200
In-Reply-To: <af87d35a-f5d8-0766-b650-0ba3e941e839@codeaurora.org>
References: <1526672192-3873-1-git-send-email-mpubbise@codeaurora.org>
         <1527068760.3759.13.camel@sipsolutions.net>
         <af87d35a-f5d8-0766-b650-0ba3e941e839@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-28 at 12:49 +0530, Manikanta Pubbisetty wrote:
> > 
> > This doesn't seem right, all the logic that clears the TXQ_STOP etc.
> > still needs to be invoked, otherwise your TXQ will get stuck completely
> > since you'll never run this code again.
> 
> If the queues are blocked more than the block ack timeout then the 
> traffic should be sent only in the next BA session.
> I am not really sure whether the queues will be blocked more than the 
> block ack timeout value unless the queues are stopped because of 
> multiple reasons.
> In any case, traffic will be pushed out in subsequent BA sessions, no?

I'm not really sure what you're saying, but it sounds almost like you're
confusing a "BA session" with a single A-MPDU? The session will get
stuck if you do the code this way, I think.

> > Also, you have the same problem as above - you never re-run this code so
> >   you'd get stuck completely.
> 
> I didn't get your point here. By the time the queues gets started again, 
> there could be possibility that the station might have been back to 
> sleep. In this case, it is better not to send the traffic, no?
> Anyways, station would receive the traffic in the next cycle when it is 
> out of sleep. Considering codel logic, there could be frame drops 
> though; maybe I am missing something?

But this is still the old code before cycling, so you never get here
during the TX cycle you're thinking of?

johannes
