Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38615 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756386Ab1KPL5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 06:57:22 -0500
Received: by bkbzu5 with SMTP id zu5so504540bkb.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 03:57:20 -0800 (PST)
Subject: Re: redesigning authentication/association flows
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1321442014.4773.42.camel@jlt3.sipsolutions.net>
References: <1321442014.4773.42.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 13:57:16 +0200
Message-ID: <1321444636.2408.112.camel@cumari> (sfid-20111116_125726_221306_BC561B62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-16 at 12:13 +0100, Johannes Berg wrote: 
> I've been growing unhappy with the way I designed authentication and
> association in cfg80211 and I'm ready to admit that the way it works now
> was a design mistake. Just see the tx_sync as an example, and if we
> explicitly do remain-on-channel for the authentication or association
> then we'll have to start doing GO NoA sync within r-o-c which will be a
> nightmare.

[...]

> Note that this gets rid of the stupid tx_sync, the attempt at doing this
> off-channel, and we never have to deal with tx_sync in remain-on-channel
> which would be really really strange.
> 
> The only difference really is that today, if auth fails, we can stay
> connected. HOWEVER, wpa_supplicant isn't actually able to deal with
> that, gets confused and recovers with clear_state_mismatch().
> 
> 
> I think this will help all drivers, from at76c50x which is broken
> completely today, wl1251 which has a dummy join, wl12xx which has a work
> around with remain-on-channel but this doesn't work well with a GO (NoA)
> and of course iwlwifi (which has tx_sync for this) and iwlegacy which
> has a bunch of RXON ping-pong things going on.

As discussed on the phone, I think this should be okay with wl12xx.  We
will have to study it a bit further to be sure, but my first impression
is that it's should be fine.

One small correction from my mistake, wl1251 doesn't have a dummy join,
it's the old wl12xx which did (with older firmwares that didn't support
roc/croc).  Sorry, I got confused.

-- 
Cheers,
Luca.

