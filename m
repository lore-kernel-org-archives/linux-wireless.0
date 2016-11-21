Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37172 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbcKUPKW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 10:10:22 -0500
Received: by mail-wm0-f45.google.com with SMTP id t79so149756181wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 07:10:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7d04126f-0f24-b4a4-6d13-6f52046d7671@neratec.com>
References: <20161121140423.24367-1-benjamin@sipsolutions.net> <7d04126f-0f24-b4a4-6d13-6f52046d7671@neratec.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 21 Nov 2016 16:10:19 +0100
Message-ID: <CA+BoTQm5do0pfMpQ=ua=Q3Uomd2jV6_xbRFK=BMzUi-D5z7C+A@mail.gmail.com> (sfid-20161121_161025_505788_35F0EE28)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Prevent radar detection and spectral
 scan to be used concurrently
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Benjamin Berg <benjamin@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2016 at 15:41, Zefir Kurtisi <zefir.kurtisi@neratec.com> wro=
te:
> On 11/21/2016 03:04 PM, Benjamin Berg wrote:
>> In the case that a spectral scan is enabled the PHY errors sent by the
>> hardware as part of the scanning might trigger the radar detection and
>> channels might be marked as 'unusable' incorrectly. This patch fixes
>> the issue by preventing the spectral scan to be enabled if DFS is used
>> and only analysing the PHY errors for DFS if radar detection is enabled.
>>
>> [...]
>
> From the relevant source code portion in channel.c:ath_set_channel()
>
> 80         /* Enable radar pulse detection if on a DFS channel. Spectral
> 81          * scanning and radar detection can not be used concurrently.
> 82          */
> 83         if (hw->conf.radar_enabled) {
> 84                 u32 rxfilter;
> 85
> 86                 rxfilter =3D ath9k_hw_getrxfilter(ah);
> 87                 rxfilter |=3D ATH9K_RX_FILTER_PHYRADAR |
> 88                                 ATH9K_RX_FILTER_PHYERR;
> 89                 ath9k_hw_setrxfilter(ah, rxfilter);
> 90                 ath_dbg(common, DFS, "DFS enabled at freq %d\n",
> 91                         chan->center_freq);
> 92         } else {
> 93                 /* perform spectral scan if requested. */
> 94                 if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
> 95                         sc->spec_priv.spectral_mode =3D=3D SPECTRAL_CH=
ANSCAN)
> 96                         ath9k_cmn_spectral_scan_trigger(common, &sc->s=
pec_priv);
> 97         }
>
> it seems that spectral can't ever be activated while operating on a DFS c=
hannel.
>
> If you need to catch the opposite case, i.e. prevent feeding pseudo-radar=
 pulses
> into the pattern detector, you just need to ensure that they depend on
> hw->conf.radar_enabled. A patch like the attached one should be enough.

Good point. I guess set_channel could be oversimplified as well. I
mean, it makes sense to consider radar and spectral mutually exclusive
if they use the same phyerr code. However some chips actually seem (as
per the comment I mentioned) to distinguish the two so I don't know if
the "mutually exclusive" is true for all chips per se. Just thinking
out loud.

I also wonder if calling ieee80211_radar_detect() should have any
effect if there are no radar operated interfaces in the first place?


Micha=C5=82
