Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42367 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab0FXOpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 10:45:18 -0400
Date: Thu, 24 Jun 2010 10:32:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Message-ID: <20100624143245.GA2368@tuxdriver.com>
References: <201006241521.47623.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201006241521.47623.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 24, 2010 at 03:21:47PM +0200, Helmut Schaa wrote:

> So, is the current implementation in rt2x00 supposed to work and mac80211
> needs fixing?
> 
> Could we add a parameter to ieee80211_beacon_get_tim that indicates if a _new_
> beacon should be generated or if the _current_ beacon should be updated in
> response to the set_tim callback?
> 
> Any other ideas?

Since we seem to want to allow ieee80211_beacon_get_tim to be called
from the set_tim callbacks, maybe we could manage bss->dtim_count
somewhere other than ieee80211_beacon_add_tim?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
