Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52630 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbYJ3Pvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:51:48 -0400
Date: Thu, 30 Oct 2008 17:50:46 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211_hwsim: Add support for client PS mode testing
Message-ID: <20081030155046.GC3923@jm.kir.nu> (sfid-20081030_165209_511884_BB818D09)
References: <20081030150455.GA3923@jm.kir.nu> <1225379715.3690.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225379715.3690.66.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 04:15:15PM +0100, Johannes Berg wrote:
> On Thu, 2008-10-30 at 17:04 +0200, Jouni Malinen wrote:
> > This introduces a debugfs file (mac80211_hwsim/phy#/ps) that can be
> > used
> 
> Why not use the cfg80211-provided debugfs dir /ieee80211/phy#/ and maybe
> put it below hwsim/ in there because mac80211 has things in there too?
> That way you save all the code setting up the directory etc.

Good point.. I did actually find out about that some time ago, but did
not remember anymore. I'll move the files there.

> > Mode 2 (automatic PS-Poll) does not yet parse Beacon frames, but
> > eventually, it should take a look at TIM IE and send PS-Poll if a
> > traffic bit is set for our AID.
> 
> Out of curiosity, is there any hw that implements this? b43 surely would
> need such code too, and then it could be in mac80211? I can see setting
> the PM bit be a decision of the driver, but if more than one driver ends
> up needing ps-poll, maybe mac80211 should be handling it?

Yes, or well, firmware more likely. Anyway, AP will have to support it
and the main purpose of this hwsim code is indeed to allow AP PS
buffering code to be tested. Anyway, should there be other drivers that
would like to do the same, this could of course be eventually moved to
mac80211. I'm just not sure whether I would expect this (Beacon parsing)
to happen in driver. Rather, I would expect the hardware to provide
helper here (i.e., process Beacon frames without indicating them to
host, generate an interrupt on Beacon frame that has TIM IE with our bit
set). Sending the PS-Poll could potentially be done in mac80211. I would
need to take a closer look at how this is done in modern wlan designs..
Then again, many vendors choose not to use PS-Poll at all even.

As far as setting FC PwrMgt bit is concerned, that could possible be in
mac80211. Though, there is some timing consideration and likely
potential race conditions that would need to be understood based on the
exact hardware design.

-- 
Jouni Malinen                                            PGP id EFC895FA
