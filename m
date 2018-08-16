Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33289 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbeHPTfM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 15:35:12 -0400
Received: by mail-oi0-f65.google.com with SMTP id 8-v6so9153736oip.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2018 09:35:39 -0700 (PDT)
Subject: Re: [PATCH v6 2/3] mac80211: Define new driver callback replace_key
To: Alexander Wetzel <alexander@wetzel-home.de>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-3-alexander@wetzel-home.de>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <6b36b011-d02e-778b-d7a1-951ab8aee721@gmail.com> (sfid-20180816_183543_614687_1901345E)
Date: Thu, 16 Aug 2018 11:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <20180814104255.4183-3-alexander@wetzel-home.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexander,

Just minor nitpicks:

> + * @replace_key: Replace an exiting in use key with a new one while guaranteeing
> + * 	to not leak clear text packets. Implementing this callback will enable
> + * 	mac80211 to announce NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE.
> + * 	Packets already queued must not be send out encrypted with the new key
send out -> sent out
> + * 	and packets decoded with the old key must not be handed over to mac80211
> + * 	when the driver is not checking IV/ICV itself once the callback has been
> + * 	completed.
> + * 	Mac80211 will log an error when asked to use replace a PTK key
> + * 	without replace_key but will still perform the then potentially
> + * 	insecure action via set_key for backward compatibility for now.
> + *

Not sure this part really belongs in the driver method description?

>    * @update_tkip_key: See the section "Hardware crypto acceleration"
>    * 	This callback will be called in the context of Rx. Called for drivers
>    * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.

<snip>

> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 4fb2709cb527..84cc8005c19a 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -572,9 +572,14 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
>   				      NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT);
>   	}
>   
> +	if (ops->replace_key)
> +		wiphy_ext_feature_set(wiphy,
> +				      NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE);
> +
>   	if (!ops->set_key)
>   		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
>   
> +

Stray whitespace?

>   	if (ops->wake_tx_queue)
>   		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_TXQS);
>   

Regards,
-Denis
