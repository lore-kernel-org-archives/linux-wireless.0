Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:47964 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYKZO00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 09:26:26 -0500
Date: Wed, 26 Nov 2008 16:26:13 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: only transition STAs ps->wake on data frames
Message-ID: <20081126142613.GB8607@jm.kir.nu> (sfid-20081126_152631_035219_97E45CDF)
References: <1227708178.4613.110.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227708178.4613.110.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2008 at 03:02:58PM +0100, Johannes Berg wrote:
> When a station goes to PS mode to scan, it will then send
> probe requests without the PS bit set. mac80211 will take
> that as indication that the station woke up, but it didn't.
> This patch changes mac80211 to only consider doze->wake
> transitions on data frames to to fix that issue.

IEEE Std 802.11-2007 is indeed quite unclear on number of power save
related topics. This is being worked on in IEEE 802.11 TGmb, but well,
nothing final from that is going to come out for years, so we better
follow common sense here.

It looks like this change is the best option we have for processing
doze->wake transition. The standard actually has text that mandates that
management frames shall not have Power Management field set to one and
as such, the STA sending Probe Request frames does need to remain awake
to receive the Probe Response, but if it also happens to be associated
at the same time, the AP that it is associated with should probably not
think that the STA is going to remain awake after having received the
Probe Response frame. This patch seems to take care of this corner case.

Based on what happens with the discussions at TGmb, this area may need
to be changed again. For example, I could think of Action frames being
handled like Data frames here, but well, that can happen once we get
some more thought out comments about proposed changes to the standard.

-- 
Jouni Malinen                                            PGP id EFC895FA
