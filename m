Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30640 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1L0QOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 11:14:20 -0500
Message-ID: <4EF9EED6.4040805@qca.qualcomm.com> (sfid-20111227_171428_979399_77C5C626)
Date: Tue, 27 Dec 2011 21:44:14 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: minor cleanup
References: <1325001841-1881-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1325001841-1881-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes and all,

i have a doubt why we should stop scanning in the following scenario:

*we have created an IBSS network as we cannot find no other network for 
IBSS_JOIN_TIMEOUT and when we had used 'fixed-freq' option, why can't we 
still keep scanning in the fixed frequency?

*we create two networks IBSS1 and IBSS2 with 'fixed-freq' option and 
they are not visible to each other till they had become 
creators(IBSS_JOIN_TIMEOUT). i assume unless we scan in the 'fixed-freq'
they won't be joining with each other as they have their own 'BSSID' 
which won't match when we receive each of their beacon frames. i will 
test this scenario to
confirm.  thanks in advance

thanks to Raj for his valuable inputs.


On Tuesday 27 December 2011 09:34 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> if we had set 'fixed-freq' paramter in iw ibss join command,
> scan request won't be intiated in this path with the state
> 'IEEE80211_IBSS_MLME_JOINED'
>
> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> ---
>   net/mac80211/ibss.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index f8a32bf..8875673 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -642,8 +642,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
>   	       "IBSS networks with same SSID (merge)\n", sdata->name);
>
>   	ieee80211_request_internal_scan(sdata,
> -			ifibss->ssid, ifibss->ssid_len,
> -			ifibss->fixed_channel ? ifibss->channel : NULL);
> +			ifibss->ssid, ifibss->ssid_len, NULL);
>   }
>
>   static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)


-- 
thanks,
shafi
