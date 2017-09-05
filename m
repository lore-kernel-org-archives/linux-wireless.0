Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33286 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbdIEJy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 05:54:59 -0400
Message-ID: <1504605297.12380.8.camel@sipsolutions.net> (sfid-20170905_115513_319803_716F2FB9)
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Tue, 05 Sep 2017 11:54:57 +0200
In-Reply-To: <87zia91nmc.fsf@toke.dk>
References: <20170622102030.9795-1-johannes@sipsolutions.net>
         <20170622102030.9795-3-johannes@sipsolutions.net> <87378lvyfz.fsf@toke.dk>
         <1504517620.9797.3.camel@sipsolutions.net> <87mv6a35lb.fsf@toke.dk>
         <1504594708.6667.1.camel@sipsolutions.net> <8760cx34cm.fsf@toke.dk>
         <1504603125.12380.7.camel@sipsolutions.net> <87zia91nmc.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-05 at 11:49 +0200, Toke Høiland-Jørgensen wrote:
> 
> Ah, so the station is attached to the VLAN interface, not the parent
> interface?

Doesn't actually matter, but if the VLAN goes where the station belongs
then either the station must've moved somewhere else or have been
destroyed, you can't have the station pointing to a VLAN that no longer
exists :)

> I guess that the only case where there is likely to be any
> significant effects of dropping the whole queue is if someone is
> sending large amounts of multicast traffic (live video streaming? is
> that even feasible over WiFi?) while reconfiguring their VLAN setup.
> That is probably not a terribly common combination...

Right.

Anyway I've applied this with the pointless null check removed.

johannes
