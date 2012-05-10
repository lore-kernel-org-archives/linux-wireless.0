Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2EJH0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:26:34 -0400
Message-ID: <1336634791.4334.5.camel@jlt3.sipsolutions.net> (sfid-20120510_092639_619325_A4E11E6F)
Subject: Re: [PATCH 1/7] mac80211: add tracking of temporary offchannel sdata
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 10 May 2012 09:26:31 +0200
In-Reply-To: <1336632282-2278-2-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
	 <1336632282-2278-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

> This is necessary if we want to have a sdata-based
> channel recalculation.
> 
> Change-Id: I223e052146893b3ae1ca46de7d90c54ffc589f1b
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/work.c        |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index b5e491b..c109960 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -997,6 +997,7 @@ struct ieee80211_local {
>  	struct ieee80211_channel *oper_channel, *csa_channel;
>  
>  	/* Temporary remain-on-channel for off-channel operations */
> +	struct ieee80211_sub_if_data *tmp_sdata;
>  	struct ieee80211_channel *tmp_channel;
>  	enum nl80211_channel_type tmp_channel_type;

Do you actually need this? I'm still tempted to not worry about any of
this and force drivers to implement remain-on-channel in the driver or
device for multi-channel, and this temporary thing is only used for
remain-on-channel operations now.

johannes

