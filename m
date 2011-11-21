Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1KUJaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 04:30:10 -0500
Subject: Re: [PATCH 2/3] mac80211: use WLAN_BACK_RECIPIENT instead of
 hardcoded 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1321842172-6732-3-git-send-email-mar.kolya@gmail.com> (sfid-20111121_032317_379708_83A50D25)
References: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
	 <1321842172-6732-3-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111121_032317_379708_83A50D25)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 10:30:06 +0100
Message-ID: <1321867806.3999.10.camel@jlt3.sipsolutions.net> (sfid-20111121_103038_688966_CDE6944F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-11-20 at 21:22 -0500, Nikolay Martynov wrote:
> From: kolya <mar.kolya@gmail.com>

> ---

Missing signature (see Documentation/SubmittingPatches).

>  net/mac80211/agg-rx.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 476b106..449d77b 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -73,8 +73,9 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
>  
>  #ifdef CONFIG_MAC80211_HT_DEBUG
> -	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
> -	       sta->sta.addr, tid);
> +	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
> +	       sta->sta.addr, tid, initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
> +               (int)reason);

please break lines to 80 cols (and maybe run scripts/checkpatch.pl)

johannes

