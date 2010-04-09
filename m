Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab0DIIJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:09:22 -0400
Subject: Re: [PATCH] mac80211: check whether scan is in progress before
 queueing scan_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1270544094-20980-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 10:09:17 +0200
Message-ID: <1270800557.3870.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-06 at 11:54 +0300, Teemu Paasikivi wrote:
> As scan_work is queued from work_work it needs to be checked if scan
> has been started during execution of work_work. Otherwise, when hw
> scan is used, the stack gets error about hw being busy with ongoing
> scan. This causes the stack to abort scan without notifying the driver
> about it. This leads to a situation where the hw is scanning and the stack
> thinks it's not. Then when the scan finishes, the stack will complain by
> warnings.

Actually, let's go with this patch. It should solve both Luis's and your
problem, and I just reviewed the locking -- currently scan_mtx and
work_mtx are completely independent.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---
>  net/mac80211/work.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 1e1ea30..7bd8670 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -919,11 +919,16 @@ static void ieee80211_work_work(struct work_struct *work)
>  		run_again(local, jiffies + HZ/2);
>  	}
>  
> -	if (list_empty(&local->work_list) && local->scan_req)
> +	mutex_lock(&local->scan_mtx);
> +
> +	if (list_empty(&local->work_list) && local->scan_req &&
> +	    !local->scanning)
>  		ieee80211_queue_delayed_work(&local->hw,
>  					     &local->scan_work,
>  					     round_jiffies_relative(0));
>  
> +	mutex_unlock(&local->scan_mtx);
> +
>  	mutex_unlock(&local->work_mtx);
>  
>  	ieee80211_recalc_idle(local);


