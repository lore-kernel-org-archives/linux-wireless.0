Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab1J1INK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:13:10 -0400
Subject: Re: [wireless-next PATCH 4/5] wifi: Warn if cannot add station
 debugfs entries.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319778680-11405-4-git-send-email-greearb@candelatech.com> (sfid-20111028_071154_398499_47BB01A2)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 <1319778680-11405-4-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071154_398499_47BB01A2)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:13:08 +0200
Message-ID: <1319789588.3914.16.camel@jlt3.sipsolutions.net> (sfid-20111028_101313_539271_BDEC7413)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 c5f3417... 1ceec86... M	net/mac80211/debugfs_sta.c
>  net/mac80211/debugfs_sta.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index c5f3417..1ceec86 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -337,8 +337,11 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
>  
>  	sta->debugfs.add_has_run = true;
>  
> -	if (!stations_dir)
> +	if (!stations_dir) {
> +		printk(KERN_DEBUG "%s: sta_debugfs_add: stations_dir is NULL\n",
> +			sta->sdata->name);
>  		return;
> +	}

I honestly don't see any point in this.

johannes

