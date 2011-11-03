Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50989 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1KCWvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 18:51:07 -0400
Received: by qabj40 with SMTP id j40so1596790qab.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 15:51:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG6FYg__nsSLa93AmzcMgckg8HG3FjD3LxpyDfA77WTsVm0oA@mail.gmail.com>
References: <CAMG6FYg__nsSLa93AmzcMgckg8HG3FjD3LxpyDfA77WTsVm0oA@mail.gmail.com>
Date: Thu, 3 Nov 2011 23:51:06 +0100
Message-ID: <CAMJBoFM5=EYR5wD41ym1FX25iTwTPRpwurhwv8hcSC6Fh2sZQA@mail.gmail.com> (sfid-20111103_235112_074801_CBC91D4D)
Subject: Re: [PATCH v2] cfg80211: merge in beacon ies of hidden bss.
From: Vitaly Wool <vitalywool@gmail.com>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

On Thu, Nov 3, 2011 at 10:59 PM, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
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
> Change-Id: I7d10f8546484f51b803b5c003c8208e471b7522b
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>

as a matter of fact, I haven't had a chance to look into your patch in
great detail. But what I can say is that it does work for me, tested
against 2 access points and with 2 different chips (STE's CW1100 and
TI's WL1271L), so let me add

Tested-by: Vitaly Wool <vitalywool@gmail.com>

Thanks,
   Vitaly
