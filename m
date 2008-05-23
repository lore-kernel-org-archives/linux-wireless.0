Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYEWLhB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 07:37:01 -0400
Subject: Re: [PATCH 1/1] mac80211: reorder channel and freq reporting in
	wext scan report
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1211495796-2881-1-git-send-email-tomas.winkler@intel.com>
References: <1211495796-2881-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Fri, 23 May 2008 07:36:48 -0400
Message-Id: <1211542608.30036.8.camel@localhost.localdomain> (sfid-20080523_133707_171611_11895A2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 01:36 +0300, Tomas Winkler wrote:
> This patch switch order of channel and freq (SIOCGIWFREQ) reports
> in scan results in order to overcome wpa_supplicant inability
> to handle channel numbers in 5.2Ghz band.
> Wext reporting channel number is ambiguous as channels 7-12 (802.11j)
> exist on both bands.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  net/mac80211/mlme.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7cfd12e..c7eca4d 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -4095,18 +4095,17 @@ ieee80211_sta_scan_result(struct net_device *dev,
>  
>  	memset(&iwe, 0, sizeof(iwe));
>  	iwe.cmd = SIOCGIWFREQ;
> -	iwe.u.freq.m = bss->freq;
> -	iwe.u.freq.e = 6;
> +	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
> +	iwe.u.freq.e = 0;
>  	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>  					  IW_EV_FREQ_LEN);
>  
>  	memset(&iwe, 0, sizeof(iwe));
>  	iwe.cmd = SIOCGIWFREQ;
> -	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
> -	iwe.u.freq.e = 0;
> +	iwe.u.freq.m = bss->freq;
> +	iwe.u.freq.e = 6;
>  	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
>  					  IW_EV_FREQ_LEN);
> -
>  	memset(&iwe, 0, sizeof(iwe));
>  	iwe.cmd = IWEVQUAL;
>  	iwe.u.qual.qual = bss->signal;

