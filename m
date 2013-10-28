Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab3J1Om2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:42:28 -0400
Message-ID: <1382971344.17956.27.camel@jlt4.sipsolutions.net> (sfid-20131028_154232_256966_D9F8E195)
Subject: Re: [PATCH 01/14] cfg80211: consolidate passive-scan and no-ibss
 flags
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	janusz.dziedzic@tieto.com, smihir@qti.qualcomm.com,
	tushnimb@qca.qualcomm.com
Date: Mon, 28 Oct 2013 15:42:24 +0100
In-Reply-To: <1382376158-25586-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192245_289775_8181E11B)
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
	 <1382376158-25586-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131021_192245_289775_8181E11B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2206,10 +2206,9 @@ enum nl80211_band_attr {
>   * @NL80211_FREQUENCY_ATTR_FREQ: Frequency in MHz
>   * @NL80211_FREQUENCY_ATTR_DISABLED: Channel is disabled in current
>   *	regulatory domain.
> - * @NL80211_FREQUENCY_ATTR_PASSIVE_SCAN: Only passive scanning is
> - *	permitted on this channel in current regulatory domain.
> - * @NL80211_FREQUENCY_ATTR_NO_IBSS: IBSS networks are not permitted
> - *	on this channel in current regulatory domain.
> + * @NL80211_FREQUENCY_ATTR_NO_IR: no mechanisms that initiate radiation
> + * 	are permitted on this channel, this includes sending probe
> + * 	requests, or modes of operation that require beaconing.
>   * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
>   *	on this channel in current regulatory domain.
>   * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
> @@ -2236,8 +2235,8 @@ enum nl80211_frequency_attr {
>  	__NL80211_FREQUENCY_ATTR_INVALID,
>  	NL80211_FREQUENCY_ATTR_FREQ,
>  	NL80211_FREQUENCY_ATTR_DISABLED,
> -	NL80211_FREQUENCY_ATTR_PASSIVE_SCAN,
> -	NL80211_FREQUENCY_ATTR_NO_IBSS,
> +	NL80211_FREQUENCY_ATTR_NO_IR,
> +	__NL80211_FREQUENCY_ATTR_NO_IBSS,
>  	NL80211_FREQUENCY_ATTR_RADAR,
>  	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
>  	NL80211_FREQUENCY_ATTR_DFS_STATE,

I don't think you can make this change, it breaks API and ABI because
the old IBSS flag is now ignored on input from old CRDA?

johannes

