Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3BGKMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 05:12:22 -0500
Message-ID: <1360231964.8038.5.camel@jlt4.sipsolutions.net> (sfid-20130207_111226_642606_63B7F9E7)
Subject: Re: pull-request: mac80211-next 2013-02-04
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Feb 2013 11:12:44 +0100
In-Reply-To: <1360001465.17993.30.camel@jlt4.sipsolutions.net> (sfid-20130204_191056_397270_06E2176E)
References: <1360001465.17993.30.camel@jlt4.sipsolutions.net>
	 (sfid-20130204_191056_397270_06E2176E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 19:11 +0100, Johannes Berg wrote:
> John,
> 
> I've accumulated a bunch of patches again, so here's a new pull request
> for mac80211-next.
> 
> The biggest change I have is undoubtedly Marco's mesh powersave
> implementation. Beyond that, I have a patch from Emmanuel to modify the
> DTIM period API in mac80211, scan improvements and a removal of some
> previous workaround code from Stanislaw, dynamic short slot time from
> Thomas and 64-bit station byte counters from Vladimir. I also made a
> number of changes myself, some related to WoWLAN, some auth/deauth
> improvements and most of them BSS list cleanups.
> 
> Let me know if there are any problems.

John, when you pull this, can you change IEEE80211_HW_NEED_DTIM_PERIOD
to IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC in our new mvm driver
(drivers/net/wireless/iwlwifi/mvm/mac80211.c) please? This overlapped
between the two trees and I didn't notice it before and didn't pull in
wireless-next before the patch.

Alternatively, I can rebase if you wish, let me know.

johannes

