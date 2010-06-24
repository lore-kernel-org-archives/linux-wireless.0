Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0FXPy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:54:56 -0400
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
In-Reply-To: <1277394837.3870.9.camel@jlt3.sipsolutions.net>
References: <201006241521.47623.helmut.schaa@googlemail.com>
	 <1277394714.3870.8.camel@jlt3.sipsolutions.net>
	 <1277394837.3870.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 17:54:56 +0200
Message-ID: <1277394896.3870.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-24 at 17:53 +0200, Johannes Berg wrote:
> On Thu, 2010-06-24 at 17:51 +0200, Johannes Berg wrote:
> 
> >  b) You need to get a new beacon frame from mac80211 only when it
> >     changes. You can do this from set_tim(). HOWEVER: since you're not
> >     getting a new one from mac80211 all the time anyway, you NEED to
> >     have the driver or firmware overwrite the DTIM count, like b43's
> >     firmware for example will do.
> 
> Oh and "when it changes" doesn't include DTIM period changes, obviously.

Er, it does include "DTIM period" changes (shouldn't actually happen
anyway), I meant "DTIM count field changes".

johannes

