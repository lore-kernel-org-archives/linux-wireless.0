Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:49861 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752895AbcIAIi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 04:38:27 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160824162015.29933-1-toke@toke.dk>
        <20160830131548.6014-1-toke@toke.dk>
        <1472677599.5470.13.camel@sipsolutions.net> <87inug81vo.fsf@toke.dk>
        <1472718860.4249.0.camel@sipsolutions.net>
Date: Thu, 01 Sep 2016 10:38:22 +0200
In-Reply-To: <1472718860.4249.0.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 01 Sep 2016 10:34:20 +0200")
Message-ID: <8737lk816p.fsf@toke.dk> (sfid-20160901_103830_879124_AE36B042)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > > +static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
>> > > +{
>> > > +	return invoke_tx_handlers_early(tx) ||
>> > > invoke_tx_handlers_late(tx);
>> > > +}
>> > 
>> > Ugh, please, no, don't be tricky where it's not necessary. Now
>> > every
>> > person reading this has to first look up the return type, and then
>> > the
>> > return value, and make sure they understand that success is
>> > actually
>> > the value 0 ... that's way too much to ask.
>> 
>> Noted. Any objections to turning these into bool return types?
>
> They have three possible values ... :)

Ah, no, not the handlers themselves. Meant the invoke_tx_handlers()
function (or all three of them after my patch; hence the plural). To
avoid the "0 means true" confusion you alluded to :)

-Toke
