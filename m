Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35844 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbbDVHhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 03:37:06 -0400
Received: by iebrs15 with SMTP id rs15so31377385ieb.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2015 00:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429559536-22907-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1429559536-22907-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 22 Apr 2015 10:37:06 +0300
Message-ID: <CAB3XZEdK5C8sJ--OZhnBbAoKCHTB90UXHHZd1xW9AeJjp2Dh2w@mail.gmail.com> (sfid-20150422_093712_084062_8A170DA9)
Subject: Re: [PATCH] mac80211: Disable U-APSD if connected to a SISO AP
From: Eliad Peller <eliad@wizery.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avri Altman <avri.altman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2015 at 10:52 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Avri Altman <avri.altman@intel.com>
>
> This concerns a bugy behavior of some APs, that advertise themselves
> falsely as supporting U-APSD, but they don't which affects throughput.
> It was detected in iPhones, but recently also with some Netgear models.
> Those devices also advertise their capabilities as SISO, so use that
> and disable U-APSD if connected to a SISO AP.
>
> Signed-off-by: Avri Altman <avri.altman@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
[...]

>  static bool is_uapsd_supported(struct ieee802_11_elems *elems)
>  {
>         u8 qos_info;
> +       int i;
>
>         if (elems->wmm_info && elems->wmm_info_len == 7
>             && elems->wmm_info[5] == 1)
> @@ -53,6 +54,22 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
>                 /* no valid wmm information or parameter element found */
>                 return false;
>
> +       /*
> +        * if the AP does not advertise MIMO capabilities -
> +        * disable U-APSD. iPhones, among others, advertise themselves
> +        * as U-APSD capable when they aren't. Avoid connecting to
> +        * those devices in U-APSD enabled.
> +        */
> +       if (elems->parse_error || !elems->ht_cap_elem)
> +               goto mimo;
> +
> +       for (i = 1; i < 4; i++) {
> +               if (elems->ht_cap_elem->mcs.rx_mask[i])
> +                       goto mimo;
> +       }
> +       return false;
> +
> +mimo:
>         return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
>  }
this is pretty confusing, as MIMO really has nothing to do with uapsd.
i guess this is only some heuristics for "incompatible ap". better
move it into a new function with a name indicating that this is only a
workaround.
this will also improve the function flow, which became a bit weird
with this patch.

Eliad.
