Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2DQPXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 11:23:50 -0400
Message-ID: <4F8D8B09.8080205@sipsolutions.net> (sfid-20120417_172354_632275_3C333DAD)
Date: Tue, 17 Apr 2012 08:23:53 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Piotr.Nakraszewicz@tieto.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Advertise dtim period to all drivers
References: <E50901D4F2CF69428D43141B7C85867929CC14EA67@EXMB03.eu.tieto.com>
In-Reply-To: <E50901D4F2CF69428D43141B7C85867929CC14EA67@EXMB03.eu.tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/17/2012 7:40 AM, Piotr.Nakraszewicz@tieto.com wrote:
> Hi,
>
> Don't look for IEEE80211_HW_NEED_DTIM_PERIOD flag after association finishes and advertise DTIM period to all drivers.

This is not possible. If you don't set the flag, we don't necessarily 
*know* the DTIM period since we might not ever have received a beacon 
from the AP.

johannes

> Signed-off-by: Piotr Nakraszewicz<piotr.nakraszewicz@tieto.com>
> ---
>   include/net/mac80211.h |    4 +---
>   net/mac80211/mlme.c    |    6 +-----
>   2 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index bebd89f..436267f 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -230,9 +230,7 @@ enum ieee80211_rssi_event {
>    *	if the hardware cannot handle this it must set the
>    *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
>    * @dtim_period: num of beacons before the next DTIM, for beaconing,
> - *	valid in station mode only while @assoc is true and if also
> - *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
> - *	@ps_dtim_period)
> + *	valid in station mode only while @assoc is true
>    * @last_tsf: last beacon's/probe response's TSF timestamp (could be old
>    *	as it may have been received during scanning long ago)
>    * @beacon_int: beacon interval
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c8836fa..39e0912 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1290,11 +1290,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>
>   	ieee80211_led_assoc(local, 1);
>
> -	if (local->hw.flags&  IEEE80211_HW_NEED_DTIM_PERIOD)
> -		bss_conf->dtim_period = bss->dtim_period;
> -	else
> -		bss_conf->dtim_period = 0;
> -
> +	bss_conf->dtim_period = bss->dtim_period;
>   	bss_conf->assoc = 1;
>
>   	/* Tell the driver to monitor connection quality (if supported) */

