Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0DZJxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 05:53:10 -0400
Subject: Re: [RFC PATCH 1/1] mac80211: Disable cfg80211 assoc timeout
 warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272275367-7532-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
References: <1272275367-7532-1-git-send-email-ext-saravanan.dhanabal@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 11:53:06 +0200
Message-ID: <1272275586.3619.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-26 at 12:49 +0300, Saravanan Dhanabal wrote:
> While the association response is queued and yet to be
> processed, if the interface goes down, ieee80211_stop
> marks work queue items as IEEE80211_WORK_ABORT. This
> creates assoc timeout warnings which are actually caused
> by if down. Those warnings could be avoided, since they
> are not beacuse of association response.
> 
> This patch disables assoc timeout warnings if interface is
> not running.

I don't think this is the right fix, we just debated exactly this
problem too.

The right fix would be to make mac80211 kill the association work when
deauthentication is requested. We're testing that fix right now.

johannes

> Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
> ---
>  net/wireless/mlme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 0855f0d..a3ab86c 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -337,7 +337,7 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
>  		}
>  	}
>  
> -	WARN_ON(!done);
> +	WARN_ON(netif_running(dev) && !done);
>  
>  	wdev_unlock(wdev);
>  }


