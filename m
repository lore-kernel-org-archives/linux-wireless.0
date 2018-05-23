Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55397 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754153AbeEWH6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:58:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id a8-v6so6306782wmg.5
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2018 00:58:37 -0700 (PDT)
Subject: Re: [PATCH 1/3] brcmfmac: allow specifying features per firmware
 version
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180522131836.26858-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B051F2A.9090501@broadcom.com> (sfid-20180523_100309_105154_D13AECA7)
Date: Wed, 23 May 2018 09:58:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180522131836.26858-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2018 3:18 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> Some features supported by firmware aren't advertised and there is no
> way for a driver to query them. This includes e.g. monitor mode details.
> Some firmwares support tagging monitor frames, some build radiotap
> header but there is no way to detect it.
>
> This commit adds table that will allow specifying features like:
> { "01-abcdef01", BIT(BRCMF_FEAT_FOO) }

I have my reservations taking this route. Full-dongle monitor mode is 
not very reliable especially when running it next to regular STA/AP 
interface due to memory constraints. So enabling a feature from host 
side could cause issues that are hard to debug. So I think it would be 
better if the cap iovar would get a new flag for this. Please hold this 
patch and let me discuss internally.

some more specific comments below...

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 24 ++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> index 876731c57bf5..1194d31d3902 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> @@ -91,6 +91,28 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
>   }
>   #endif /* DEBUG */
>
> +struct brcmf_feat_fwfeat {
> +	const char * const fwid;
> +	u32 flags;

For consistency call this feat_flags as well.

> +};
> +
> +static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
> +};
> +
> +static void brcmf_feat_firmware_features(struct brcmf_pub *pub)

Try to keep name of the struct brcmf_pub instance 'drvr'. Maybe the 
function name could be brcmf_feat_firmware_overrides() instead.

Regards,
Arend
