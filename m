Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab3FRMTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:19:55 -0400
Message-ID: <1371557978.8318.10.camel@jlt4.sipsolutions.net> (sfid-20130618_141959_143093_BDED72EA)
Subject: Re: [RFC 2/2] wireless:  Make sure __cfg80211_connect_result always
 puts bss.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Jun 2013 14:19:38 +0200
In-Reply-To: <1371515281-26879-2-git-send-email-greearb@candelatech.com> (sfid-20130618_022822_882338_7451297B)
References: <1371515281-26879-1-git-send-email-greearb@candelatech.com>
	 <1371515281-26879-2-git-send-email-greearb@candelatech.com>
	 (sfid-20130618_022822_882338_7451297B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-17 at 17:28 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, we can leak a bss reference.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/wireless/sme.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 6066720..ea2ce33 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -420,6 +420,7 @@ void cfg80211_sme_failed_assoc(struct wireless_dev *wdev)
>  	schedule_work(&rdev->conn_work);
>  }
>  
> +/** This method must consume bss one way or another */
>  void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  			       const u8 *req_ie, size_t req_ie_len,
>  			       const u8 *resp_ie, size_t resp_ie_len,
> @@ -435,11 +436,17 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  	ASSERT_WDEV_LOCK(wdev);
>  
>  	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
> -		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
> +		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)) {
> +		if (bss)
> +			cfg80211_put_bss(wdev->wiphy, bss);
>  		return;
> +	}

This is reasonable, though it'd be stupid to call it in this case, I'm
not worried about leaking when the warning triggers.

> -	if (wdev->sme_state != CFG80211_SME_CONNECTING)
> +	if (wdev->sme_state != CFG80211_SME_CONNECTING) {
> +		if (bss)
> +			cfg80211_put_bss(wdev->wiphy, bss);
>  		return;
> +	}

This code doesn't exist any more.

johannes

