Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3CPM5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:57:08 -0400
Message-ID: <1363362270.8656.25.camel@jlt4.sipsolutions.net> (sfid-20130316_135711_818028_F9300C93)
Subject: Re: [PATCH 1/2] mac80211: some fixes for ieee80211_do_stop while
 suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1363021279-9809-1-git-send-email-sgruszka@redhat.com>
References: <1363021279-9809-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 16:44:30 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-11 at 18:01 +0100, Stanislaw Gruszka wrote:
> Is possible that we close interface while we are suspended, that
> can result warning like below (and some others similar):

> Patch try to avoid calling most of drv callbacks when stopping interface
> while suspended.

try :-)

> Some further work is probably needed to handle ROC, DFS, WDS and
> ieee80211_{add,del}_virtual_monitor . However patch should fix issues

Fixing either any of those would be pretty tricky, I think.

> in most common scenario, i.e. managed mode without any new futures.

I hope you're not into the stock market now ;-)


> -		ieee80211_configure_filter(local);
> +		/* configure filter latter (if not suspended) */

later

> -		mutex_unlock(&local->mtx);
> +		/* tell driver latter (if not suspended) */

later

> -		if (going_down)
> +		if (going_down && !local->suspended)
>  			drv_remove_interface(local, sdata);

I really wonder if there's not a better solution ... I'll think about it
a bit.

johannes

