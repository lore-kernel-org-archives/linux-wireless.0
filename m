Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37781 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1KCPOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 11:14:52 -0400
Received: by gyc15 with SMTP id 15so337256gyc.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 08:14:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
References: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com>
Date: Thu, 3 Nov 2011 17:14:51 +0200
Message-ID: <CAB3XZEeaF+Vy+7THnh62Q2ZeH0oWLa6W=JZZNegUA9TeVdwFWw@mail.gmail.com> (sfid-20111103_161455_465007_7BF1E814)
Subject: Re: [PATCH] cfg80211: merge in beacon ies of hidden bss.
From: Eliad Peller <eliad@wizery.com>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Dmitry,

On Wed, Nov 2, 2011 at 8:19 PM, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> The problem with PSM when a hidden SSID was used was originally
> reported by Juuso Oikarinen.
>
>  - When generally scanning, the AP is getting a bss entry with
>   a zero SSID.
>  - When associationg, a probe-req is sent to the AP with the SSID,
>   and as a result a probe-responseis received with the hidden
>   SSID in place. As a consequence, a second bss entry is created
>   for the AP, now with the real SSID.
>  - After association, mac80211 executes ieee80211_recalc_ps(),
>   but does not switch to powersave becuse the beacon-ies are missing.
>
> As result, the STA does not ever enter PSM.
>
> The patch merges in beacon ies of hidden bss from beacon to the probe
> response, creating a consistant set of ies in place.
>
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> ---
[...]
> +static int cmp_hidden_bss(struct cfg80211_bss *a,
> +                  struct cfg80211_bss *b)
> +{
> +       const u8 *ie1;
> +       const u8 *ie2;
> +       size_t ielen;
> +       int i;
> +       int r;
> +
> +       r = cmp_bss_core(a, b);
> +       if (r)
> +               return r;
> +
> +       ie1 = cfg80211_find_ie(WLAN_EID_SSID,
> +                       a->information_elements,
> +                       a->len_information_elements);
> +       ie2 = cfg80211_find_ie(WLAN_EID_SSID,
> +                       b->information_elements,
> +                       b->len_information_elements);
> +       if (!ie1 && !ie2)
> +               return 0;
> +       if (!ie1 || !ie2)
> +               return -1;
> +
> +       ielen = min(ie1[1], ie2[1]);
> +       for (i = 0; i < ielen; ++i)
> +               if (ie2[i + 2])
> +                       return -1;
> +
> +       return ie2[1] - ie1[1];

you don't account for the ssid = "" case.


> +static int
> +merge_hidden_ies(struct cfg80211_internal_bss *res,
> +                struct cfg80211_internal_bss *hidden)
> +{
> +       if (unlikely(res->pub.beacon_ies))
> +               return -EALREADY;
> +       if (WARN_ON(!hidden->pub.beacon_ies))
> +               return -EINVAL;
> +
> +       res->pub.beacon_ies = kmalloc(hidden->pub.len_beacon_ies, GFP_ATOMIC);
> +       if (unlikely(!res->pub.beacon_ies))
> +               return -ENOMEM;
> +
> +       res->beacon_ies_allocated = true;
> +       res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
> +       memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
> +                       res->pub.len_beacon_ies);
> +
> +       return 0;
> +}
> +
i think the "merge" here is a bit misleading - there is no actual merge.
you copy the beacon_ies from the beacon, but we still end up with 2 bss nodes.
your solution does workaround the specific psm problem, but we still
end up with a duplicate bss conf node that will never get updated
(because the beacons will update the "original" bss node).

i guess this problem already exists with the current code.
not sure what is the correct way solve it, though.
maybe check for both the hidden name and the actual name?

Eliad.
