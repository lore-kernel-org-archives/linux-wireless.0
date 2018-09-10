Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51650 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbeIJQSj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:18:39 -0400
Message-ID: <1536578695.3224.67.camel@sipsolutions.net> (sfid-20180910_132546_028968_58A95B50)
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 13:24:55 +0200
In-Reply-To: <87bm95li0s.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <1536565561.3224.10.camel@sipsolutions.net> <87bm95li0s.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 13:16 +0200, Toke Høiland-Jørgensen wrote:

> > > - I didn't get rid of the register_airtime() callback. As far as I can tell,
> > >   only iwlwifi uses the tx_time field in the struct tx_info. Which means that
> > >   we *could* probably use it for this and just make the other drivers set it;
> > >   but I'm not sure what effects that would have in relation to WMM-AC for
> > >   those drivers, so I chickened out. Will have to try it out, I guess; but it
> > >   also depends on whether ath10k needs to be able to report airtime
> > >   asynchronously anyway. So I'll hold off on that for a bit more.
> > 
> > I don't think you need to be concerned, the reporting through this has
> > no immediate effect as the driver would also have to set the feature
> > flag (NL80211_FEATURE_SUPPORTS_WMM_ADMISSION) for userspace to be able
> > to use WMM admission TSPECs, and getting tx_tspec->admitted_time to be
> > non-zero in ieee80211_sta_tx_wmm_ac_notify().
> 
> Great! In that case I'll try moving the reporting go through the tx_info
> struct and check that it works for ath9k :)

I'm not sure it would work for everyone (though I guess it should for
ath9k), so it may well be necessary to report it out-of-band from
frames. My objection wasn't so much to the out-of-band mechanism, but to
the fact that we have two reporting mechanisms that are each tied to one
feature, while reporting the same thing.

So if you figure out that you need to keep the reporting out-of-band I'm
perfectly fine with that, but I guess I'd argue the two should cross
over: reporting in-band should feed back to this, reporting out-of-band
should feed the admission mechanism.

johannes
