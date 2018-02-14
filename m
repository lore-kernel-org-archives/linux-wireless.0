Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34203 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967751AbeBNNDn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 08:03:43 -0500
Received: by mail-oi0-f52.google.com with SMTP id k15so16432313oib.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2018 05:03:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A82B4F8.2090209@broadcom.com>
References: <CAD8Lp47D5sGCpxSiFYQviu0a62W4aj-5Sgs6sjE7E2cZWwsUwg@mail.gmail.com>
 <5A82B4F8.2090209@broadcom.com>
From: Daniel Drake <drake@endlessm.com>
Date: Wed, 14 Feb 2018 16:03:41 +0300
Message-ID: <CAD8Lp46ta_mQriB1eOJxnTmgoy5n5T9_AyNpVKuL2C4uuLrf3g@mail.gmail.com> (sfid-20180214_140347_188146_59D6BBE8)
Subject: Re: Make brcmfmac repeat authentication requests
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for the fast response.

On Tue, Feb 13, 2018 at 12:50 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> I tried to find info about that access point equipment, but not getting any
> hits apart from a olivetti laser printer, but I doubt it is that. Can you
> provide more details.

The device itself is basically unbranded (just says "4G LTE"). It's an
access point and mifi bridge (so insert a sim card and it shares your
mobile data connection on the LAN). It comes as part of a solar home
solutions package.

MF928 is listed as the product name behind the battery. In the web UI
it says it is from the EV910 product family, hardware version
LR521_V1.0. I can't find info online about it.

> User-space (wpa_supplicant) would retry the connect attempt so I guess you
> are saying that the timing between the two auth requests is important?

Yes, the error goes up to userspace which then retries. However around
15 seconds pass before the authentication request is sent again, and
also as part of the retry it redoes the probe requests etc. Windows
does the same but there is only a 3 second delay. I haven't checked if
this device needs the authentication request resent in less than 3
seconds, or if the problem is that it needs to be sent twice in
consecutive frames (i.e. without another probe request in the middle).

> Is firmware not repeating at all or is the time between the two auth
> requests too long?

Firmware is not repeating at all.

> Checking firmware there is a 300ms timeout and it does a retry if the limit
> is not reached. However, that limit is initialized to zero :-p
>
> Could you try the patch below?

Thanks for looking into the firmware! Unfortunately the change does
not appear to make any difference. As before, the auth request is
ACKed by the AP but then the conversation halts until userspace steps
in on timeout a few seconds later.

Daniel


> Regards,
> Arend
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> b/drivers
> index 19686ef..af1ab00 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -384,6 +384,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>                 goto done;
>         }
>
> +       /* allow join retry by firmware */
> +       (void)brcmf_fil_iovar_int_set(ifp, "assoc_retry_max", 1);
> +
>         /* Enable tx beamforming, errors can be ignored (not supported) */
>         (void)brcmf_fil_iovar_int_set(ifp, "txbf", 1);
>
