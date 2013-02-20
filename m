Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab3BTKIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:08:17 -0500
Message-ID: <1361354894.8629.16.camel@jlt4.sipsolutions.net> (sfid-20130220_110822_439258_15B7BF0B)
Subject: Re: [RFC 2/2] mac80211: sync suspend and stop interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 11:08:14 +0100
In-Reply-To: <20130219164831.GB27140@redhat.com>
References: <20130219164714.GA27140@redhat.com>
	 <20130219164831.GB27140@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-19 at 17:48 +0100, Stanislaw Gruszka wrote:
> Is possible that we close interface while we are suspended, that
> results in warning like below (and some other similar):
> 
> WARNING: at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0x62e/0x670 [mac80211]()
> wlan0:  Failed check-sdata-in-driver check, flags: 0x4
> Call Trace:
>  [<ffffffff8105c9d6>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffffa045d46e>] ieee80211_do_stop+0x62e/0x670 [mac80211]
>  [<ffffffffa045d4ca>] ieee80211_stop+0x1a/0x20 [mac80211]
>  [<ffffffff815122ed>] __dev_close_many+0x7d/0xc0
>  [<ffffffff81513af8>] dev_close_many+0x88/0x100
>  [<ffffffff81513f2a>] dev_close+0x3a/0x50
>  [<ffffffffa03c90ae>] cfg80211_rfkill_set_block+0x6e/0xa0 [cfg80211]
>  [<ffffffffa03c9106>] cfg80211_rfkill_sync_work+0x26/0x30 [cfg80211]
> 
> To fix check if interface was removed during suspend in
> ieee80211_do_stop() before perform any action that require operation
> on the interface.

This would also become simpler then because the key stuff for instance
wouldn't be necessary any more.

johannes

