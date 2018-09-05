Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43568 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbeIEQO0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 12:14:26 -0400
Message-ID: <1536147865.3528.14.camel@sipsolutions.net> (sfid-20180905_134437_326751_43C1DABF)
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 05 Sep 2018 13:44:25 +0200
In-Reply-To: <1536147683.3528.12.camel@sipsolutions.net> (sfid-20180905_134134_899874_E6692541)
References: <20180905113402.7665-1-johannes@sipsolutions.net>
         <1536147453.3528.11.camel@sipsolutions.net> <87k1o05g04.fsf@toke.dk>
         <1536147683.3528.12.camel@sipsolutions.net>
         (sfid-20180905_134134_899874_E6692541)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 13:41 +0200, Johannes Berg wrote:
> On Wed, 2018-09-05 at 13:40 +0200, Toke Høiland-Jørgensen wrote:
> > 
> > Guess we'll have to deal with everything else if we ever move management
> > frames onto the TXQ path as well...
> 
> Depends on whether we care for management frame priorities or not ... so
> far we haven't really.

Actually, for the most part we have implemented that properly. Except
for the TXQ I added for bufferable management ... oh well, I think we're
the only user thereof now.

I'm not sure we want to have a TXQ per TID for management, that seems
overkill. But I'm also not sure how to solve this otherwise ...

johannes
