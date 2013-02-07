Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49616 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3BGFv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 00:51:29 -0500
Message-ID: <1360216223.12095.47.camel@cumari.coelho.fi> (sfid-20130207_065132_857114_03893372)
Subject: Re: [RFC] mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Thu, 7 Feb 2013 07:50:23 +0200
In-Reply-To: <1360191576-6894-1-git-send-email-johannes@sipsolutions.net>
References: <1360191576-6894-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 23:59 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are only a few drivers that use HW scan, and
> all of those don't need a non-idle transition before
> starting the scan -- some don't even care about idle
> at all. Remove the flag and code associated with it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Actually I'm not 100% sure about wl1251, but I think if
> it has a problem with that it can fix it in the hw_scan
> callback?

I think it does affect wl1251.  IIRC, we need at least to disable beacon
filtering when starting to scan (which is done in the idle->active
transition).

But you're right that we could do this in the hw_scan callback.  We can
simulate an active/idle cycle when we start/stop scan.

--
Luca.

