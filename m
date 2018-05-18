Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:44916 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbeERKZI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 06:25:08 -0400
Received: by mail-qt0-f194.google.com with SMTP id d3-v6so9558571qtp.11
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 03:25:08 -0700 (PDT)
Subject: Re: [PATCH 2/2] cfg80211: release station info tidstats where needed
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180518094742.10669-1-johannes@sipsolutions.net>
 <20180518094742.10669-2-johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFEAA02.2010303@broadcom.com> (sfid-20180518_122512_654826_FC7C3833)
Date: Fri, 18 May 2018 12:25:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180518094742.10669-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/18/2018 11:47 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This fixes memory leaks in cases where we got the station
> info but failed sending it out properly.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   include/net/cfg80211.h | 13 +++++++++++++
>   net/wireless/nl80211.c | 11 ++++++++---
>   2 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 8984d24d68b7..1c6364591856 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -5710,6 +5710,19 @@ void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
>    */
>   int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp);
>
> +/**
> + * cfg80211_sinfo_release_sinfo - release contents of station info

Maybe drop one '_sinfo' from the function name? Or 
cfg80211_sinfo_release_contents?

Regards,
Arend
