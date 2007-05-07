Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41133 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934430AbXEGQwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 12:52:23 -0400
Date: Mon, 7 May 2007 18:52:24 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow sleeping in set_key op
Message-ID: <20070507185224.45f98d56@midnight.suse.cz>
In-Reply-To: <200705062037.35037.mb@bu3sch.de>
References: <200705062037.35037.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 6 May 2007 20:37:34 +0200 Michael Buesch wrote:
> [...]
>  static void finish_sta_info_free(struct ieee80211_local *local,
>  				 struct sta_info *sta)
>  {
> +	sta_info_key_disable(local, sta);
> +
>  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>  	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
>  	       local->mdev->name, MAC_ARG(sta->addr));
> @@ -213,6 +246,16 @@ static void finish_sta_info_free(struct 
>  	sta_info_put(sta);
>  }

There is a race here. You already removed the sta from sta_hash list
and you're not protected by any lock. Thus, it is possible to add a new
station with the same address before finish_sta_info_free is called.
When this happens, you call the set_key handler for the new key and
after that you call it again with DISABLE_KEY.

It's not easy to get this right. I remember also problems with
dereferencing already freed key when I thought about possible ways to
solve exactly this problem.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
