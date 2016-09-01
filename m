Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35329 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932318AbcIAJ1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 05:27:05 -0400
Message-ID: <1472722020.9608.3.camel@sipsolutions.net> (sfid-20160901_112708_609135_D8DD27AE)
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 01 Sep 2016 11:27:00 +0200
In-Reply-To: <8760qgugb0.fsf@toke.dk>
References: <20160824162015.29933-1-toke@toke.dk>
         <20160830131548.6014-1-toke@toke.dk>
         <1472677599.5470.13.camel@sipsolutions.net> <87inug81vo.fsf@toke.dk>
         <1472718860.4249.0.camel@sipsolutions.net> <8737lk816p.fsf@toke.dk>
         <1472720848.9608.1.camel@sipsolutions.net> <8760qgugb0.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Yeah, was going to do that anyway. But since I'm touching the code
> anyway, this might be an opportunity to avoid constructs like this:
> 
> if (!invoke_tx_handlers(tx))
>   /* continue sending the packet */
> 
> Most other succeed/fail functions seem to be of type bool, so it
> would help consistency as well. Unless there is some particular
> reason why this function happens to be using 0 to indicate success?
> 

It's just convention in the kernel, really.

IMHO if a function has a bool return value it should be have a more
expressive name that indicates better what's going on, like e.g.

bool ieee80211_is_radar_required(...);

but of course that's not always done.

johannes
