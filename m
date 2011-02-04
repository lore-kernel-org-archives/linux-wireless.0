Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1BDPjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 10:39:09 -0500
Subject: Re: [RFC] mac80211: Fix parsing of MCS rates to radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1296833778-2912-1-git-send-email-mshajakhan@atheros.com>
References: <1296833778-2912-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 16:39:02 +0100
Message-ID: <1296833942.3671.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-04 at 21:06 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> Previously the MCS rate elements were parsed at the wrong position
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  net/mac80211/rx.c |   31 ++++++++++---------------------
>  1 files changed, 10 insertions(+), 21 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index c08b8e9..27b4b1f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -141,14 +141,16 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>  
>  	/* IEEE80211_RADIOTAP_RATE */
>  	if (status->flag & RX_FLAG_HT) {
> -		/*
> -		 * TODO: add following information into radiotap header once
> -		 * suitable fields are defined for it:
> -		 * - MCS index (status->rate_idx)
> -		 * - HT40 (status->flag & RX_FLAG_40MHZ)
> -		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
> -		 */
> -		*pos = 0;

Alright, so I forgot to remove this comment, but what made you think
that I added the code in the wrong place??

totally NAK, this breaks radiotap. Removing the comment there is fine,
replace it with

/*
 * MCS information is a separate field in radiotap,
 * added below.
 */

johannes

