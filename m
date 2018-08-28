Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50680 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbeH1Mhx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:37:53 -0400
Message-ID: <1535446026.5895.5.camel@sipsolutions.net> (sfid-20180828_104719_815245_7CDDC463)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander@wetzel-home.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 10:47:06 +0200
In-Reply-To: <20180814104255.4183-2-alexander@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
         <20180814104255.4183-2-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 12:42 +0200, Alexander Wetzel wrote:
> Drivers able to correctly replace a in-use key should set
> NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE to allow the userspace (e.g.
> hostapd or wpa_supplicant) to rekey PTK keys.
> 
> The userspace must detect a PTK rekey attempt and only go ahead with the
> rekey when the driver has set this flag. If the driver is not supporting
> the feature the userspace either must not replace the PTK key or perform
> a full re-association.
> 
> Ignoring this flag and continuing to rekey the connection can still
> work but has to be considered insecure and broken. It can leak cleartext
> packets or freeze the connection and is only supported to allow the
> userspace to be updated.
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>  include/uapi/linux/nl80211.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 7acc16f34942..b41b9ade0449 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -5224,6 +5224,11 @@ enum nl80211_feature_flags {
>   *	except for supported rates from the probe request content if requested
>   *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
>   *
> + * @NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE: Driver/device confirm that they are
> + *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
> + *      if this flag is not set. Ignoring this can leak clear text packets and/or
> + *      freeze the connection.


If you have a flag here, why say "userspace must not" rather than just
outright prevent userspace from doing it?

johannes
