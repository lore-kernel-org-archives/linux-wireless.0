Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58872 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3G0IwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jul 2013 04:52:09 -0400
Received: by mail-wi0-f174.google.com with SMTP id j17so1001962wiw.7
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jul 2013 01:52:08 -0700 (PDT)
Date: Sat, 27 Jul 2013 10:51:53 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] [PATCH] mac80211: handle VHT radiotap info for tx status
Message-ID: <20130727085153.GA31401@gobelin> (sfid-20130727_105215_584631_0A55EFD8)
References: <1374861514-29022-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1374861514-29022-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 07:58:34PM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> The radiotap VHT info is 12 bytes (required to be aligned on 2) :
> u16 known - IEEE80211_RADIOTAP_VHT_KNOWN_*
> u8 flags - IEEE80211_RADIOTAP_VHT_FLAG_*
> u8 bandwidth
> u8 mcs_nss[4]
> u8 coding
> u8 group_id
> u16 partial_aid
> 
> ATM mac80211 can properly handle IEEE80211_RADIOTAP_VHT_KNOWN_GI,
> IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH and mcs_nss[0] (i.e single user).
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/status.c | 76 ++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 63 insertions(+), 13 deletions(-)
> 
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 6ad4c14..1a1c7fd 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -235,7 +235,8 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
>  
>  	/* IEEE80211_RADIOTAP_RATE rate */
>  	if (info->status.rates[0].idx >= 0 &&
> -	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
> +	    !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
> +					     IEEE80211_TX_RC_VHT_MCS)))
>  		len += 2;
>  
>  	/* IEEE80211_RADIOTAP_TX_FLAGS */
> @@ -244,16 +245,21 @@ static int ieee80211_tx_radiotap_len(struct ieee80211_tx_info *info)
>  	/* IEEE80211_RADIOTAP_DATA_RETRIES */
>  	len += 1;
>  
> -	/* IEEE80211_TX_RC_MCS */
> -	if (info->status.rates[0].idx >= 0 &&
> -	    info->status.rates[0].flags & IEEE80211_TX_RC_MCS)
> -		len += 3;
> +	/* IEEE80211_RADIOTAP_MCS
> +	 * IEEE80211_RADIOTAP_VHT */
> +	if (info->status.rates[0].idx >= 0) {
> +		if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS)
> +			len += 3;
> +		else if (info->status.rates[0].flags & IEEE80211_TX_RC_VHT_MCS)
> +			len += ALIGN(len, 2) + 12;
The '+' is a typo, should be
			len = ALIGN(len, 2) + 12;

-- 
Karl
