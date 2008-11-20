Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:40022 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbYKTI2z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 03:28:55 -0500
Date: Thu, 20 Nov 2008 10:27:50 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Rami Rosen <ramirose@gmail.com>,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Message-ID: <20081120082750.GG5078@jm.kir.nu> (sfid-20081120_092901_337239_CA2B67F3)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> <1226943608.3902.36.camel@johannes.berg> <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com> <1227106146.26243.43.camel@johannes.berg> <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com> <1227107869.26243.52.camel@johannes.berg> <20081119160135.GB3485@tuxdriver.com> <1227126620.26243.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227126620.26243.71.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 09:30:19PM +0100, Johannes Berg wrote:

> That's a good question. The distinction here is between empowering users
> to do the wrong thing (AP without proper PS support) and enforcing the
> right thing (with the consequence of complete loss of AP functionality).
> The issue I see here is that users will see "ohh shiny, AP support"
> without knowing that it doesn't actually really support it. Not sure
> which side of the line we want to stand on, I prefer the correctness
> side but I can see arguments for the other side, would just like to have
> users know. Maybe we could have some way to tell hostapd this and then
> have hostapd print a huge warning about it when started up?

I would be fine adding such a warning into hostapd if someone comes up
with the patch and mac80211/nl80211 changes to provide the
working-PS-mode capability flag.

Is the problem with zd1211rw just in PS buffering of multicast/broadcast
frames or does it also have problems with unicast? Many use cases could
handle the multicast/broadcast case, but if unicast PS buffering does
not work properly, there may be more issues.. Anyway, this leaves a
nasty surprise for the end user who may not even realize what power
saving really means in context of 802.11 and would not have any way of
figuring out why the connection does not work suddenly when the STA goes
to power save mode.

-- 
Jouni Malinen                                            PGP id EFC895FA
