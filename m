Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2GZQqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 12:46:09 -0400
Message-ID: <1343321165.4477.4.camel@jlt3.sipsolutions.net> (sfid-20120726_184622_709807_E9B53370)
Subject: Re: [PATCH v6] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	coelho <coelho@ti.com>
Date: Thu, 26 Jul 2012 18:46:05 +0200
In-Reply-To: <501170F2.3050300@net.t-labs.tu-berlin.de>
References: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	  (sfid-20120726_180930_993025_AB3D0B96) <1343319453.4477.2.camel@jlt3.sipsolutions.net>
	  (sfid-20120726_181745_936314_D74A954D) <1343319579.4477.3.camel@jlt3.sipsolutions.net>
	 <501170F2.3050300@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-26 at 18:31 +0200, Thomas Huehn wrote:

> This is the call path
> 
> in main.c ... INIT_WORK(&wl->tx_work, wl1271_tx_work);
>  jumps to tx.c...wl1271_tx_work(struct work_struct *work)
>   calls wl1271_tx_work(struct work_struct *work)
>    calls wlcore_tx_work_locked(struct wl1271 *wl)
>     calls wl1271_skb_queue_head()
>      calls wl12xx_tx_get_hlid()
>       calls wl12xx_tx_get_hlid_ap() .... where sta is needed.
> 
> But I could not find any point in the call path where I could grab the
> sta pointer and pass it through. I will move the rcu into
> wl12xx_tx_get_hlid_ap(), but I do not see any cheaper way here as using rcu.

I don't know this driver, maybe it could determine the hlid before and
store that.

johannes

