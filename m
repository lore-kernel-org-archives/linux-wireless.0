Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36497 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752123AbdAIUZA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 15:25:00 -0500
Received: by mail-wm0-f43.google.com with SMTP id c85so109202538wmi.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 12:24:59 -0800 (PST)
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
 <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a59ef282-921d-6591-ab33-0a8dd3ef4294@broadcom.com> (sfid-20170109_212816_040265_52D10AAD)
Date: Mon, 9 Jan 2017 21:24:56 +0100
MIME-Version: 1.0
In-Reply-To: <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9-1-2017 18:53, Jouni Malinen wrote:
> From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
> 
> This enhances the connect timeout API to also carry the reason for the
> timeout. These reason codes for the connect time out are represented by
> enum nl80211_timeout_reason and are passed to user space through a new
> attribute NL80211_ATTR_TIMEOUT_REASON (u32).
> 
> Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---

[...]

> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 4669391..472225d 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -38,6 +38,7 @@ struct cfg80211_conn {
>  		CFG80211_CONN_ASSOCIATE_NEXT,
>  		CFG80211_CONN_ASSOCIATING,
>  		CFG80211_CONN_ASSOC_FAILED,
> +		CFG80211_CONN_ASSOC_FAILED_TIMEOUT,

Was kinda expecting AUTH_FAILED_TIMEOUT....

>  		CFG80211_CONN_DEAUTH,
>  		CFG80211_CONN_ABANDON,
>  		CFG80211_CONN_CONNECTED,
> @@ -140,7 +141,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
>  	return err;
>  }
>  
> -static int cfg80211_conn_do_work(struct wireless_dev *wdev)
> +static int cfg80211_conn_do_work(struct wireless_dev *wdev,
> +				 enum nl80211_timeout_reason *treason)
>  {
>  	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
>  	struct cfg80211_connect_params *params;
> @@ -172,6 +174,7 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
>  					  params->key, params->key_len,
>  					  params->key_idx, NULL, 0);
>  	case CFG80211_CONN_AUTH_FAILED:
> +		*treason = NL80211_TIMEOUT_AUTH;

... but it seems AUTH failure always is a timeout?

Regards,
Arend
