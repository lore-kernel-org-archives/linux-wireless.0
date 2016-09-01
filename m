Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35245 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbcIAJHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 05:07:33 -0400
Message-ID: <1472720848.9608.1.camel@sipsolutions.net> (sfid-20160901_110802_060433_8E4DB42F)
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 01 Sep 2016 11:07:28 +0200
In-Reply-To: <8737lk816p.fsf@toke.dk>
References: <20160824162015.29933-1-toke@toke.dk>
         <20160830131548.6014-1-toke@toke.dk>
         <1472677599.5470.13.camel@sipsolutions.net> <87inug81vo.fsf@toke.dk>
         <1472718860.4249.0.camel@sipsolutions.net> <8737lk816p.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > They have three possible values ... :)
> 
> Ah, no, not the handlers themselves. Meant the invoke_tx_handlers()
> function (or all three of them after my patch; hence the plural). To
> avoid the "0 means true" confusion you alluded to :)
> 

Ah. Actually, even I got confused and thought the return value *was*
the same as the handler.

I think it doesn't matter to be tricky, gcc is probably going to (have
to) generate exactly the same code like when you explicitly put an if
statement in there, it seems?

johannes
