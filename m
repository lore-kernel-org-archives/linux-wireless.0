Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab1KUJer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 04:34:47 -0500
Subject: Re: [PATCH 1/3] mac80211: add tx agg session timer to timeout
 inactive tids in way similar to rx agg sessions are being timed out
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1321842172-6732-2-git-send-email-mar.kolya@gmail.com> (sfid-20111121_032314_633142_7ED628C5)
References: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
	 <1321842172-6732-2-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111121_032314_633142_7ED628C5)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 10:34:43 +0100
Message-ID: <1321868083.3999.15.camel@jlt3.sipsolutions.net> (sfid-20111121_103450_564716_5E54BEA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-11-20 at 21:22 -0500, Nikolay Martynov wrote:
> From: kolya <mar.kolya@gmail.com>
> 
> ---

Same comment as on patch 2, but additionally: please make a short &
concise subject line and explain the change in proper text in the commit
log.

> @@ -689,6 +716,8 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
>  	 * more.
>  	 */
>  
> +	del_timer_sync(&tid_tx->session_timer);
> +
>  	ieee80211_agg_splice_packets(local, tid_tx, tid);

This is a deadlock waiting to happen.

> @@ -778,6 +807,10 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
>  			ieee80211_agg_tx_operational(local, sta, tid);
>  
>  		sta->ampdu_mlme.addba_req_num[tid] = 0;
> +
> +                if (tid_tx->timeout)
> +                        mod_timer(&tid_tx->session_timer, TU_TO_EXP_TIME(tid_tx->timeout));
> +

line breaks please

johannes

