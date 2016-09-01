Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35009 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbcIAIe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 04:34:27 -0400
Message-ID: <1472718860.4249.0.camel@sipsolutions.net> (sfid-20160901_103432_196736_E0DA43A6)
Subject: Re: [PATCH v4] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 01 Sep 2016 10:34:20 +0200
In-Reply-To: <87inug81vo.fsf@toke.dk>
References: <20160824162015.29933-1-toke@toke.dk>
         <20160830131548.6014-1-toke@toke.dk>
         <1472677599.5470.13.camel@sipsolutions.net> <87inug81vo.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > +static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
> > > +{
> > > +	return invoke_tx_handlers_early(tx) ||
> > > invoke_tx_handlers_late(tx);
> > > +}
> > 
> > Ugh, please, no, don't be tricky where it's not necessary. Now
> > every
> > person reading this has to first look up the return type, and then
> > the
> > return value, and make sure they understand that success is
> > actually
> > the value 0 ... that's way too much to ask.
> 
> Noted. Any objections to turning these into bool return types?

They have three possible values ... :)

johannes
