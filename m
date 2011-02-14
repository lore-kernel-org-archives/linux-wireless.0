Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1BNKJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:09:52 -0500
Subject: Re: [PATCH v2] mac80211: add missing locking in ieee80211_reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1297183399-2296-1-git-send-email-eliad@wizery.com>
References: <1297183399-2296-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:09:50 +0100
Message-ID: <1297678190.3785.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 18:43 +0200, Eliad Peller wrote:
> When suspending an associated system, and then resuming,
> the station vif is being reconfigured without taking the
> sdata->u.mgd.mtx lock, which results in the following warning:

...

>  net/mac80211/util.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index cf68700..d036597 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1210,7 +1210,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		switch (sdata->vif.type) {
>  		case NL80211_IFTYPE_STATION:
>  			changed |= BSS_CHANGED_ASSOC;
> +			mutex_lock(&sdata->u.mgd.mtx);
>  			ieee80211_bss_info_change_notify(sdata, changed);
> +			mutex_unlock(&sdata->u.mgd.mtx);
>  			break;
>  		case NL80211_IFTYPE_ADHOC:
>  			changed |= BSS_CHANGED_IBSS;

Oi, this is a complicated locking rule.

Can you please stick a

lockdep_assert_held(...)

in the right place to make sure we catch it even on drivers that don't
use the probe_req function?

johannes

