Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:52327 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753963AbcIAJmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 05:42:36 -0400
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
        <1472720848.9608.1.camel@sipsolutions.net> <8760qgugb0.fsf@toke.dk>
        <1472722020.9608.3.camel@sipsolutions.net>
Date: Thu, 01 Sep 2016 11:42:31 +0200
In-Reply-To: <1472722020.9608.3.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 01 Sep 2016 11:27:00 +0200")
Message-ID: <871t14ufaw.fsf@toke.dk> (sfid-20160901_114239_344883_7434E40F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Yeah, was going to do that anyway. But since I'm touching the code
>> anyway, this might be an opportunity to avoid constructs like this:
>>=20
>> if (!invoke_tx_handlers(tx))
>> =C2=A0 /* continue sending the packet */
>>=20
>> Most other succeed/fail functions seem to be of type bool, so it
>> would help consistency as well. Unless there is some particular
>> reason why this function happens to be using 0 to indicate success?
>>=20
>
> It's just convention in the kernel, really.
>
> IMHO if a function has a bool return value it should be have a more
> expressive name that indicates better what's going on, like e.g.
>
> bool ieee80211_is_radar_required(...);
>
> but of course that's not always done.

Well, it's applied somewhat inconsistently across mac80211, it seems
(e.g. ieee80211_tx() and ieee80211_tx_prepare_skb() are bool, while
invoke_tx_handlers() and ieee80211_skb_resize() are int). But okay,
don't have that strong an opinion about the colour of this particular
bikeshed so I'll keep it the way it is ;)

-Toke
