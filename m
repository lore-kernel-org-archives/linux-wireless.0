Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:41050 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZI1LGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 07:06:34 -0400
Date: Mon, 28 Sep 2009 12:06:29 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wext: add back wireless/ dir in sysfs for cfg80211
 interfaces
In-Reply-To: <1254130453.6583.22.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909281201260.5361@sister.anvils>
References: <1254130453.6583.22.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 28 Sep 2009, Johannes Berg wrote:
> The move away from wireless handlers the drivers assign
> to wireless handlers being assigned by cfg80211 broke
> the sysfs registration (the wireless/ dir went missing)
> because the handlers were assigned only after sysfs
> registration and thus the registration never noticed a
> device was wireless.

I couldn't make much sense of that: too much assigning!

> 
> Fix this by special-casing cfg80211-based devices, all
> of which are required to have an ieee80211_ptr, in the
> sysfs code, and also using get_wireless_stats() to have
> the same values reported as in procfs.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I confirm this works for me too: I won't venture an ignorant opinion
on which is the right solution; but my failed boots do suggest that
keeping away from the notifier infrastructure may make a wiser fix.

Thanks a lot for all your efforts on this, Johannes.

Hugh
