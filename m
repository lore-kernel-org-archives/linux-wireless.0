Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56131 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966609Ab3DRMT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 08:19:56 -0400
Received: by mail-wi0-f169.google.com with SMTP id h11so1872734wiv.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Apr 2013 05:19:55 -0700 (PDT)
Date: Thu, 18 Apr 2013 14:15:42 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] mac80211: minstrel_ht: initialize rates selection
Message-ID: <20130418121542.GA8638@magnum.frso.rivierawaves.com> (sfid-20130418_141958_929041_811A2EBC)
References: <1366285887-23416-1-git-send-email-karl.beldan@gmail.com>
 <1366285887-23416-2-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366285887-23416-2-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 01:51:27PM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Initialize {mp,mi}->{max_tp_rate,max_tp_rate2,max_prob_rate} in
> minstrel_ht's rate_init and rate_update.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index eb6dc3f..5768cc0 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -907,6 +907,9 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>  	if (!n_supported)
>  		goto use_legacy;
>  
> +	// initialize {mp,mi}->{max_tp_rate,max_tp_rate2,max_prob_rate}

The comment should have been:
{mi,mi->groups[*]} instead of {mp,mi}.

 
Karl
