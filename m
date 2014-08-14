Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:60612 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaHNLin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 07:38:43 -0400
Received: by mail-ig0-f181.google.com with SMTP id h3so4667489igd.8
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2014 04:38:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1408014478-20401-1-git-send-email-johannes@sipsolutions.net>
References: <1408014478-20401-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 14 Aug 2014 14:38:42 +0300
Message-ID: <CAB3XZEf95f+TeTtCOGC-9XrkEYe9Zh1oxPjXxsnCiTaGm9Rzjg@mail.gmail.com> (sfid-20140814_133846_824493_1374D863)
Subject: Re: [PATCH v2 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2014 at 2:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There are a few possible cases of where BSS data came from:
>  1) only a beacon has been received
>  2) only a probe response has been received
>  3) the driver didn't report what it received (this happens when
>     using cfg80211_inform_bss[_width]())
>  4) both probe response and beacon data has been received
>
> Unfortunately, in the userspace API, a few things weren't there:
>  a) there was no way to differentiate cases 1) and 4) above
>     without comparing the data of the IEs
>  b) the TSF was always from the last frame, instead of being
>     exposed for beacon/probe response separately like IEs
>
> Fix this by
>    i) exporting a new flag attribute that indicates whether or
>       not probe response data has been received - this addresses (a)
>   ii) exporting a BEACON_TSF attribute that holds the beacon's TSF
>       if a beacon has been received
>  iii) not exporting the beacon attributes in case (3) above as that
>       would just lead userspace into thinking the data actually came
>       from a beacon when that isn't clear
>
> To implement this, track inside the IEs struct whether or not it
> (definitely) came from a beacon.
>
> Reported-by: William Seto
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
looks good.

> @@ -982,11 +983,12 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
> +       ies->from_beacon = !ieee80211_is_probe_resp(mgmt->frame_control);
it's basically the same, but i think ieee80211_is_beacon() is a bit
more straight-forward :)

Eliad.
