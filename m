Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48449 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0EKLRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 07:17:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 04:17:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19433.15591.251225.477469@gargle.gargle.HOWL>
Date: Tue, 11 May 2010 16:47:59 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath9k_htc: Lock sta_notify() callback
In-Reply-To: <1273575453.3669.55.camel@jlt3.sipsolutions.net>
References: <19433.14190.31764.174876@gargle.gargle.HOWL>
	<1273575453.3669.55.camel@jlt3.sipsolutions.net>
From: <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2010-05-11 at 16:24 +0530, Sujith.Manoharan@atheros.com wrote:
> > Since ->sta_notify() can sleep, protect
> > the callback with a mutex.
> 
> While this may be a correct change, it's not a correct description :)
> 
> You should be locking _data_, not _code_, and due to mac80211 the
> callback cannot be invoked twice at the same time anyway.

It protects all the binary data between lock and unlock. :-)

I encountered a problem with sta_notify() with a script doing
a load/scan/connect/unload cycle and NetworkManager also running,
doing its own scan/connect processing. And at some point,
ath9k_htc_remove_station() failed. Which led me to suspect overlapping
calls to sta_notify().

I do see sta_mtx being taken at all the places where sta_remove() is called
in mac80211, so am not sure how I managed to hit it.

Sujith
