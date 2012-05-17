Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2EQTrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 15:47:16 -0400
Message-ID: <1337284032.4687.1.camel@jlt3.sipsolutions.net> (sfid-20120517_214719_567749_E8D392E6)
Subject: Re: [PATCH] cfg80211: fix memory leak/corruption of bss_list
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 May 2012 21:47:12 +0200
In-Reply-To: <1337270768-22719-1-git-send-email-eliad@wizery.com> (sfid-20120517_180630_404692_8C265625)
References: <1337270768-22719-1-git-send-email-eliad@wizery.com>
	 (sfid-20120517_180630_404692_8C265625)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-17 at 19:06 +0300, Eliad Peller wrote:
> cfg80211_dev_free() calls cfg80211_put_bss() directly on all
> the remaining bss entries, skipping the proper bss entry
> cleanup that usually made by __cfg80211_unlink_bss(), and
> leaving the bss_list and the rb_tree with dangling pointers.

>  	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
> -		cfg80211_put_bss(&scan->pub);
> +		cfg80211_unlink_bss(&rdev->wiphy, &scan->pub);
>  	kfree(rdev);

I don't see why we care, we free rdev anyway.

johannes

