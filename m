Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:52668 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbeIJRkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 13:40:33 -0400
Message-ID: <1536583587.3224.71.camel@sipsolutions.net> (sfid-20180910_144731_778424_E68AAB8C)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 14:46:27 +0200
In-Reply-To: <87zhwpjzme.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk>
         <1536577419.3224.50.camel@sipsolutions.net> <87zhwpjzme.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 14:39 +0200, Toke Høiland-Jørgensen wrote:

> > From then on, right now we basically just try to refill the hardware
> > queue from the TXQ whenever the hardware releases frames from that
> > queue. If there are none, we fall back to putting them on the hardware
> > queue from the wake signal.
> 
> OK. So if the TXQ is ineligible to dequeue packets, but still have them
> queued, there would need to be a signal (such as wake_txq()) when it
> becomes eligible again, right?

Right. It wouldn't have to be wake_txq, but that seems as appropriate as
anything else.

If we were to use ieee80211_airtime_may_transmit(), we'd have to have
something that tells us "I previously told you it may not transmit, but
now I changed my mind" :-)

johannes
