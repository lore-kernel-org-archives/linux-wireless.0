Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1KQVtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:49:46 -0500
Subject: Re: [PATCH] wifi-debugfs: Fix AMSDU rate printout.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321566487-31705-1-git-send-email-greearb@candelatech.com> (sfid-20111117_224815_705423_97548BC6)
References: <1321566487-31705-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111117_224815_705423_97548BC6)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 22:49:45 +0100
Message-ID: <1321566585.3997.49.camel@jlt3.sipsolutions.net> (sfid-20111117_224949_505570_23427FE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 13:48 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> It was flipped.  See section 7.3.2.56 of the 802.11n
> spec for details.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

but the subject should be "mac80211: fix AMSDU rate output in debugfs"
or so, maybe John can fix it up.

> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 c5f3417... 3110cbd... M	net/mac80211/debugfs_sta.c
>  net/mac80211/debugfs_sta.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index c5f3417..3110cbd 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -274,9 +274,9 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
>  
>  		PRINT_HT_CAP((htc->cap & BIT(10)), "HT Delayed Block Ack");
>  
> -		PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
> -			     "3839 bytes");
>  		PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: "
> +			     "3839 bytes");
> +		PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
>  			     "7935 bytes");
>  
>  		/*


