Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1284 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZHXR5y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 13:57:54 -0400
Subject: Re: [PATCH] mac80211: Fix output of minstrels rc_stats
From: Joe Perches <joe@perches.com>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1251135778-27288-1-git-send-email-hannemann@nets.rwth-aachen.de>
References: <1251135778-27288-1-git-send-email-hannemann@nets.rwth-aachen.de>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 10:57:56 -0700
Message-Id: <1251136676.3873.28.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-24 at 19:42 +0200, Arnd Hannemann wrote:
> An integer overflow in the minstrel debug code prevented the
> throughput to be displayed correctly. This patch fixes that,
> by swaping the division and multiplication.
> 
> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> ---
>  net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
> index 98f4807..caf9453 100644
> --- a/net/mac80211/rc80211_minstrel_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
> @@ -83,7 +83,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
>  		p += sprintf(p, "%3u%s", mr->bitrate / 2,
>  				(mr->bitrate & 1 ? ".5" : "  "));
>  
> -		tp = ((mr->cur_tp * 96) / 18000) >> 10;
> +		tp = ((mr->cur_tp / 18000) * 96) >> 10;

Maybe do_div instead?


