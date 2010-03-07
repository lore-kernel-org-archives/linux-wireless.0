Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0CGTDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 14:03:01 -0500
Subject: Re: [PATCH] mac80211: Fix sta_mtx unlocking on insert STA failure
 path
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100306163508.GA9236@jm.kir.nu>
References: <20100306163508.GA9236@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Mar 2010 20:02:47 +0100
Message-ID: <1267988567.3912.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-06 at 18:35 +0200, Jouni Malinen wrote:
> Commit 34e895075e21be3e21e71d6317440d1ee7969ad0 introduced sta_mtx
> locking into sta_info_insert() (now sta_info_insert_rcu), but forgot
> to unlock this mutex on one of the error paths. Fix this by adding
> the missing mutex_unlock() call for the case where STA insert fails
> due to an entry existing already. This may happen at least in AP mode
> when a STA roams between two BSSes (vifs).
> 
> Signed-off-by: Jouni Malinen <j@w1.fi>

Thanks.

> ---
>  net/mac80211/sta_info.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> By the way, that roaming between two vifs did not work either, but
> regardless, fixing missing mutex_unlock is of higher priority.. The STA
> entry was not updated to point to the correct dev when the STA roamed
> from one BSS to another one (both BSSes running on the same wiphy). To
> be more exact, I think it was updated once, but not when roaming back to
> the original BSS.

This must be due to the sta_find_bss thing Felix did because hostapd
wasn't using the right ifindex...

johannes

