Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0EZLwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 07:52:25 -0400
Subject: Re: [RFC PATCHv2] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1274873379-12944-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274873379-12944-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 13:52:19 +0200
Message-ID: <1274874739.3658.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 14:29 +0300, Juuso Oikarinen wrote:

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -858,6 +858,10 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>  	ieee80211_recalc_smps(local, sdata);
>  	mutex_unlock(&local->iflist_mtx);
>  
> +	rtnl_lock();
> +	ieee80211_set_arp_filter(sdata);
> +	rtnl_unlock();
> +

Please analyse locking in more detail and enable lockdep :)

This will cause deadlocks.

johannes

