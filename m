Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0FNGaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 02:30:19 -0400
Subject: Re: [PATCH 2/3] mac80211: Set changed basic rates flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1276496145-5623-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276496145-5623-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 08:30:12 +0200
Message-ID: <1276497012.3926.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 09:15 +0300, Teemu Paasikivi wrote:
> Add changed basic rates flag to bss_changed while joinig ibss network.
> 
> This patch is split from the patch containing support for setting basic
> rates when creating ibss network. Original patch was posted by Johannes
> Berg on the linux-wireless posting list.
> 

Signed-off-by: Johannes Berg <johannes.berg@intel.com>

> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---
>  net/mac80211/ibss.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 8be5a96..ff91265 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -178,6 +178,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  	bss_change |= BSS_CHANGED_BSSID;
>  	bss_change |= BSS_CHANGED_BEACON;
>  	bss_change |= BSS_CHANGED_BEACON_ENABLED;
> +	bss_change |= BSS_CHANGED_BASIC_RATES;
>  	bss_change |= BSS_CHANGED_IBSS;
>  	sdata->vif.bss_conf.ibss_joined = true;
>  	ieee80211_bss_info_change_notify(sdata, bss_change);


