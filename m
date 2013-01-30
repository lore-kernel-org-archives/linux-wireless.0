Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50004 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3BnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 20:43:24 -0500
Received: by mail-pa0-f52.google.com with SMTP id kp6so751503pab.25
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 17:43:23 -0800 (PST)
Date: Tue, 29 Jan 2013 17:42:22 -0800
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] cfg80211: simplify mesh BSS comparison
Message-ID: <20130130014222.GA25214@cable.cozybit.com> (sfid-20130130_024327_945507_C0A73E24)
References: <1359503120-25685-1-git-send-email-johannes@sipsolutions.net>
 <1359503120-25685-2-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359503120-25685-2-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 30, 2013 at 12:45:20AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of first checking if a BSS is an MBSS
> and then doing the comparisons, inline it all
> into the BSS comparison function. This avoids
> doing the IE searches twice and is also a lot
> less code.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/scan.c | 120 +++++++++++++++++-----------------------------------
>  1 file changed, 39 insertions(+), 81 deletions(-)
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 72ef3b2..5fd7c47 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -288,26 +288,6 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
>  }
>  EXPORT_SYMBOL(cfg80211_find_vendor_ie);
>  
> -static int cmp_ies(u8 num, const u8 *ies1, int len1, const u8 *ies2, int len2)
> -{
> -	const u8 *ie1 = cfg80211_find_ie(num, ies1, len1);
> -	const u8 *ie2 = cfg80211_find_ie(num, ies2, len2);
> -
> -	/* equal if both missing */
> -	if (!ie1 && !ie2)
> -		return 0;
> -	/* sort missing IE before (left of) present IE */
> -	if (!ie1)
> -		return -1;
> -	if (!ie2)
> -		return 1;
> -
> -	/* sort by length first, then by contents */
> -	if (ie1[1] != ie2[1])
> -		return ie2[1] - ie1[1];
> -	return memcmp(ie1 + 2, ie2 + 2, ie1[1]);
> -}
> -

FWIW cfg80211_get_mesh() has no users either.

>  static int cmp_bss(struct cfg80211_bss *a,
>  		   struct cfg80211_bss *b,
>  		   bool hide_ssid)
>  {
>  	const struct cfg80211_bss_ies *a_ies, *b_ies;
> -	const u8 *ie1;
> -	const u8 *ie2;
> +	const u8 *ie1 = NULL;
> +	const u8 *ie2 = NULL;
>  	int i, r;
>  
> -	r = cmp_bss_core(a, b);
> -	if (r)
> -		return r;
> +	if (a->channel != b->channel)
> +		return b->channel->center_freq - a->channel->center_freq;
>  
>  	a_ies = rcu_access_pointer(a->ies);
>  	if (!a_ies)
> @@ -444,6 +367,41 @@ static int cmp_bss(struct cfg80211_bss *a,
>  	if (!b_ies)
>  		return 1;
>  
> +	if (WLAN_CAPABILITY_IS_STA_BSS(a->capability))
> +		ie1 = cfg80211_find_ie(WLAN_EID_MESH_ID,
> +				       a_ies->data, a_ies->len);
> +	if (WLAN_CAPABILITY_IS_STA_BSS(a->capability))

You probably wanted:

	if (WLAN_CAPABILITY_IS_STA_BSS(b->capability))

--
Thomas
