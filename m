Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:62150 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMK5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 06:57:03 -0400
Received: by mail-ig0-f175.google.com with SMTP id uq10so9756951igb.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2014 03:57:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
Date: Wed, 13 Aug 2014 13:57:02 +0300
Message-ID: <CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com> (sfid-20140813_125711_112115_B3F5AC4E)
Subject: Re: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2014 at 10:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There are a few possible cases of where BSS data came from:
>  1) only a beacon has been received
>  2) only a probe response has been received
>  3) the driver didn't report what it received (this happens
>     when using cfg80211_inform_bss[_width]())
>  4) both probe response and beacon data has been received
>
> Unfortunately, in the userspace API, a few things weren't
> there:
>  a) there was no way to differentiate cases 1) and 4) above
>     without comparing the data of the IEs
>  b) the TSF was always from the last frame, instead of being
>     exposed for beacon/probe response separately like IEs
>
> Fix this by
>    i) exporting a new flag attribute that indicates whether
>       or not probe response data has been received - this
>       addresses (a)
>   ii) exporting a BEACON_TSF attribute that holds the beacon's
>       TSF if a beacon has been received
>  iii) not exporting the beacon attributes in case (3) above
>       as that would just lead userspace into thinking the
>       data actually came from a beacon when that isn't clear
>
> Reported-by: William Seto
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> @@ -937,6 +941,9 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
>         if (res->pub.capability & WLAN_CAPABILITY_ESS)
>                 regulatory_hint_found_beacon(wiphy, channel, gfp);
>
> +       /* assume drivers don't mix and match too badly */
> +       res->known_frame_type = false;
> +
>         trace_cfg80211_return_bss(&res->pub);
>         /* cfg80211_bss_update gives us a referenced result */
>         return &res->pub;
> @@ -1011,6 +1018,9 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
>         if (res->pub.capability & WLAN_CAPABILITY_ESS)
>                 regulatory_hint_found_beacon(wiphy, channel, gfp);
>
> +       /* assume drivers don't mix and match too badly */
> +       res->known_frame_type = true;
> +

i think you should set the flag only in case of a beacon.
otherwise, you might "validate" res->ies although it contains probe
response data.

Eliad.
