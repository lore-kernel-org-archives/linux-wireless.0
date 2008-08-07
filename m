Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:59780 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYHGRSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 13:18:37 -0400
Date: Thu, 7 Aug 2008 20:17:42 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211/cfg80211: Add BSS configuration options for AP mode
Message-ID: <20080807171742.GB21060@jm.kir.nu> (sfid-20080807_191840_116628_D20329C7)
References: <20080807170701.GA21060@jm.kir.nu> <1218129093.3630.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1218129093.3630.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 07, 2008 at 07:11:33PM +0200, Johannes Berg wrote:

> I guess we'll also need to make the mlme code actually use it, as it
> stands it looks like we never enable short slot. Oh well, later.

Yes.. I tried applying your patch
(013-BROKEN-mac80211-bss-slot-time.patch) for this and the results were
enough to convince me that I do not want to do it today as part of the
AP mode patch ;-):

patching file net/mac80211/mlme.c
Hunk #1 FAILED at 342.
Hunk #2 FAILED at 2305.
Hunk #3 FAILED at 2537.
Hunk #4 FAILED at 2564.
Hunk #5 FAILED at 2601.
Hunk #6 FAILED at 2618.
Hunk #7 FAILED at 2729.
Hunk #8 FAILED at 2862.
Hunk #9 FAILED at 2898.
Hunk #10 succeeded at 2989 (offset 54 lines).
Hunk #11 succeeded at 3201 (offset 52 lines).
Hunk #12 FAILED at 3235.
Hunk #13 FAILED at 3252.
11 out of 13 hunks FAILED -- saving rejects to file
net/mac80211/mlme.c.rej


I did not look into details at how much work would be needed to make
this apply cleanly, but I would expect this to be relatively simple
change.

-- 
Jouni Malinen                                            PGP id EFC895FA
