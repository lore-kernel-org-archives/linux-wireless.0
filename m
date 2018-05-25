Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44077 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965102AbeEYK1J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:27:09 -0400
Received: by mail-qt0-f195.google.com with SMTP id d3-v6so5866460qtp.11
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 03:27:09 -0700 (PDT)
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
Message-ID: <5B07E4F9.4050709@broadcom.com> (sfid-20180525_122730_472187_BC2A7307)
Date: Fri, 25 May 2018 12:27:05 +0200
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

Discussed this over here. As we are releasing 4366c1 firmware we could 
add a proper flag, but there may be other devices/firmwares that can 
support certain features so this approach is an acceptable 
alternative.... (more below)

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
> +};
> +
> +static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
> +};
> +
> +static void brcmf_feat_firmware_features(struct brcmf_pub *pub)
> +{
> +	const struct brcmf_feat_fwfeat *e;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(brcmf_feat_fwfeat_map); i++) {
> +		e = &brcmf_feat_fwfeat_map[i];
> +		if (!strcmp(e->fwid, pub->fwver)) {
> +			pub->feat_flags |= e->flags;

... However, let's be more verbose about this here.

Regards,
Arend
