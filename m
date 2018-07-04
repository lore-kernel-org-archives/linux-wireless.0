Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58928 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932290AbeGDHyW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 03:54:22 -0400
Message-ID: <1530690856.3324.2.camel@sipsolutions.net> (sfid-20180704_095507_880305_C6BBC078)
Subject: Re: [PATCH] mac80211: don't put null-data frames on the normal TXQ
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 04 Jul 2018 09:54:16 +0200
In-Reply-To: <87zhz7ea1s.fsf@toke.dk>
References: <20180703124725.30917-1-johannes@sipsolutions.net>
         <e9813f60-5cf5-a4bf-5906-623282319991@bowerswilkins.com>
         <1530661681.4735.51.camel@sipsolutions.net> <87zhz7ea1s.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-04 at 09:26 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > I see no evidence of ath9k doing this correctly, so this might fix a
> > bug there, but I may have missed it.
> 
> ath9k does check for this, in ath_tx_sched_aggr() and in
> ath_tx_form_aggr(); it'll check for the IEEE80211_TX_CTL_AMPDU flag, and
> stop building the current aggregate if the flag is not set.

Ok, thanks. Nevertheless, I guess it's more efficient to not stop the
aggregate on encountering a (QoS-)NDP :-)

johannes
