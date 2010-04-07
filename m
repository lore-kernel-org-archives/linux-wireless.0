Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab0DGGaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 02:30:04 -0400
Subject: Re: [PATCH v2] mac80211: check whether scan is in progress before
 queueing scan_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1270619767-2459-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1270619767-2459-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 08:29:53 +0200
Message-ID: <1270621793.3858.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-07 at 08:56 +0300, Teemu Paasikivi wrote:
> As scan_work is queued from work_work it needs to be checked if scan
> has been started during execution of work_work. Otherwise, when hw
> scan is used, the stack gets error about hw being busy with ongoing
> scan. This causes the stack to abort scan without notifying the driver
> about it. This leads to a situation where the hw is scanning and the stack
> thinks it's not. Then when the scan finishes, the stack will complain by
> warnings.
> 
> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---
>  net/mac80211/work.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 1e1ea30..5df48a9 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -919,12 +919,17 @@ static void ieee80211_work_work(struct work_struct *work)
>  		run_again(local, jiffies + HZ/2);
>  	}
>  
> -	if (list_empty(&local->work_list) && local->scan_req)
> +	mutex_unlock(&local->work_mtx);
> +
> +	mutex_lock(&local->scan_mtx);
> +
> +	if (list_empty(&local->work_list) && local->scan_req &&
> +	    !local->scanning)
>  		ieee80211_queue_delayed_work(&local->hw,
>  					     &local->scan_work,
>  					     round_jiffies_relative(0));
>  
> -	mutex_unlock(&local->work_mtx);
> +	mutex_unlock(&local->scan_mtx);

But should we touch work_list w/o holding work_mtx?

johannes

