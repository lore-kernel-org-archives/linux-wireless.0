Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51541 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbcIAJU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 05:20:56 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160824162015.29933-1-toke@toke.dk>
        <20160830131548.6014-1-toke@toke.dk>
        <1472677599.5470.13.camel@sipsolutions.net> <87inug81vo.fsf@toke.dk>
        <1472718860.4249.0.camel@sipsolutions.net> <8737lk816p.fsf@toke.dk>
        <1472720848.9608.1.camel@sipsolutions.net>
Date: Thu, 01 Sep 2016 11:20:51 +0200
In-Reply-To: <1472720848.9608.1.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 01 Sep 2016 11:07:28 +0200")
Message-ID: <8760qgugb0.fsf@toke.dk> (sfid-20160901_112100_312047_84C92E3B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > They have three possible values ... :)
>> 
>> Ah, no, not the handlers themselves. Meant the invoke_tx_handlers()
>> function (or all three of them after my patch; hence the plural). To
>> avoid the "0 means true" confusion you alluded to :)
>> 
>
> Ah. Actually, even I got confused and thought the return value *was*
> the same as the handler.
>
> I think it doesn't matter to be tricky, gcc is probably going to (have
> to) generate exactly the same code like when you explicitly put an if
> statement in there, it seems?

Yeah, was going to do that anyway. But since I'm touching the code
anyway, this might be an opportunity to avoid constructs like this:

if (!invoke_tx_handlers(tx))
  /* continue sending the packet */

Most other succeed/fail functions seem to be of type bool, so it would
help consistency as well. Unless there is some particular reason why
this function happens to be using 0 to indicate success?

-Toke
