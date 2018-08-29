Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:36198 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbeH2LkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 07:40:01 -0400
Message-ID: <1535528658.5215.19.camel@sipsolutions.net> (sfid-20180829_094443_235110_C995D58E)
Subject: Re: [RFC v2 2/4] mac80211: Add airtime accounting and scheduling to
 TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Wed, 29 Aug 2018 09:44:18 +0200
In-Reply-To: <153115422499.7447.2570671473822724496.stgit@alrua-x1> (sfid-20180709_183717_542396_91AD1C0D)
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
         <153115422499.7447.2570671473822724496.stgit@alrua-x1>
         (sfid-20180709_183717_542396_91AD1C0D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-07-09 at 18:37 +0200, Toke Høiland-Jørgensen wrote:
> 
> @@ -427,6 +428,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>  	sta->cparams.interval = MS2TIME(100);
>  	sta->cparams.ecn = true;
>  
> +	sta->airtime.weight = 1;

Perhaps it might be useful to start with a higher default (even
something like 1<<8) as that would allow adjusting up/down single
stations, without having to adjust all stations and listening to new
additions to adjust them quickly etc?

Theoretically this doesn't really matter, but from a practical POV it
may be easier to leave them all at the default and just adjust the ones
that need adjustment for some reason.

> ieee80211_sta_register_airtime

Do we really need this? We already have at least TX status with airtime,
for ieee80211_sta_tx_notify() and friends, and the station pointer in
that context, so couldn't we piggy-back on this? At least WMM-AC already
requires the driver to provide this.

johannes
