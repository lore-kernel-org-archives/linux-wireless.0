Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0L1JxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:53:06 -0500
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for
 802.11j
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Dave Kilroy <kilroyd@googlemail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1293529861.3526.8.camel@jlt3.sipsolutions.net>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
	 <AANLkTi=R58EGLrsT5sTk7JTqWvaeJ5caytHMt3VCSOki@mail.gmail.com>
	 <201012281843.57453.br1@einfach.org>
	 <1293529861.3526.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:53:03 +0100
Message-ID: <1293529983.3526.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 10:51 +0100, Johannes Berg wrote:

> > ieee80211_dsss_chan_to_freq - atmel, airo, wl3501_cs, orinoco, rndis_wlan
> > ieee80211_freq_to_dsss_chan - atmel, airo, orinoco, zd1201
> > 
> > Anyhow i guess it would make sense to have a common channel to frequency 
> > mapping function for mac80211 and other wireless drivers? The problem is now 
> > we have to use enum ieee80211_band which is defined cfg80211.h...

Interestingly, I just noticed that the above ones also have different
semantics -- they try to round to the nearest channel rather than
returning an error if the center frequency isn't exact.

johannes

