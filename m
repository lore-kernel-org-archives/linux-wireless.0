Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34831 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbcA3T6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 14:58:40 -0500
Subject: Re: [patch] mac80211: free sinfo on error path
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arnd Bergmann <arnd@arndb.de>
References: <20160130143906.GD3462@mwanda>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <56AD15ED.9030908@gmail.com> (sfid-20160130_205846_521267_28D6BB48)
Date: Sat, 30 Jan 2016 20:58:37 +0100
MIME-Version: 1.0
In-Reply-To: <20160130143906.GD3462@mwanda>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 30-01-16 15:39, Dan Carpenter wrote:
> There is a missing kfree(sinfo) on error in sta_info_insert_finish().
> 
> Fixes: 5fe74014172d ('mac80211: avoid excessive stack usage in sta_info')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Hi Dan,

A fix for this has already been posted [1]. Although your 'Fixes:' tag
is useful to have, I guess.

Regards,
Arend

[1]
http://mid.gmane.org/1454060944-11320-1-git-send-email-sudipm.mukherjee@gmail.com

> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 6c198e6..1502efb 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -562,6 +562,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
>   out_err:
>  	mutex_unlock(&local->sta_mtx);
>  	rcu_read_lock();
> +	kfree(sinfo);
>  	return err;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
