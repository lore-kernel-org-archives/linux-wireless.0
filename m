Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:50305 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbbAHM7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 07:59:46 -0500
Received: by mail-lb0-f180.google.com with SMTP id l4so2692287lbv.11
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 04:59:45 -0800 (PST)
Message-ID: <54AE7F3F.3070802@cogentembedded.com> (sfid-20150108_135957_382392_1B7538A1)
Date: Thu, 08 Jan 2015 15:59:43 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ying Xue <ying.xue@windriver.com>, johannes@sipsolutions.net
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] mac80211: silent build warnings
References: <1420700655-9427-1-git-send-email-ying.xue@windriver.com>
In-Reply-To: <1420700655-9427-1-git-send-email-ying.xue@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 1/8/2015 10:04 AM, Ying Xue wrote:

> Silent the following build warnings:

> net/mac80211/mlme.c: In function ‘ieee80211_rx_mgmt_beacon’:
> net/mac80211/mlme.c:1348:3: warning: ‘pwr_level_cisco’ may be used uninitialized in this function [-Wuninitialized]
> net/mac80211/mlme.c:1315:6: note: ‘pwr_level_cisco’ was declared here

> Signed-off-by: Ying Xue <ying.xue@windriver.com>
> ---
>   net/mac80211/mlme.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 2c36c47..13b5506 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1312,7 +1312,7 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
>   {
>   	bool has_80211h_pwr = false, has_cisco_pwr = false;
>   	int chan_pwr = 0, pwr_reduction_80211h = 0;
> -	int pwr_level_cisco, pwr_level_80211h;
> +	int pwr_level_cisco = 0, pwr_level_80211h = 0;

    OK, but why are you also initializing the second variable?

WBR, Sergei

