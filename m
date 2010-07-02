Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0GBSGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:06:04 -0400
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
In-Reply-To: <201007021959.45704.helmut.schaa@googlemail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com>
	 <201006272100.22216.helmut.schaa@googlemail.com>
	 <1278090770.15412.4.camel@jlt3.sipsolutions.net>
	 <201007021959.45704.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 20:06:04 +0200
Message-ID: <1278093964.15412.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-02 at 19:59 +0200, Helmut Schaa wrote:

> > unless your
> > device itself is capable of generating the TIM IE _right before_ the
> > beacon gets transmitted.
> 
> Agreed. At least on rt2800 we can use the pre tbtt interrupt to update the
> beacon just before it is sent out.

Careful though. You don't know how far in advance it is triggered (or
maybe you do) or if the time will be sufficient to generate and upload
the beacon to the device. You could even hit lock contention I think.

johannes

