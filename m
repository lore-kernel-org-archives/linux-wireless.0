Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:49268 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbcIAIX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 04:23:29 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160824162015.29933-1-toke@toke.dk>
        <20160830131548.6014-1-toke@toke.dk>
        <1472677599.5470.13.camel@sipsolutions.net>
Date: Thu, 01 Sep 2016 10:23:23 +0200
In-Reply-To: <1472677599.5470.13.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 31 Aug 2016 23:06:39 +0200")
Message-ID: <87inug81vo.fsf@toke.dk> (sfid-20160901_102335_325718_CC93D4C7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> +static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
>> +{
>> +	return invoke_tx_handlers_early(tx) ||
>> invoke_tx_handlers_late(tx);
>> +}
>
> Ugh, please, no, don't be tricky where it's not necessary. Now every
> person reading this has to first look up the return type, and then the
> return value, and make sure they understand that success is actually
> the value 0 ... that's way too much to ask.

Noted. Any objections to turning these into bool return types?


I'll go through and fix your other comments and send a new version.
Thanks for the feedback :)

-Toke
