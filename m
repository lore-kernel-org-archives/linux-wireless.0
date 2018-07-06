Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35952 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934112AbeGFSmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 14:42:18 -0400
Received: by mail-ed1-f68.google.com with SMTP id t3-v6so9301026eds.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2018 11:42:17 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: specify some features per firmware version
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180704203130.12086-1-zajec5@gmail.com>
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
Message-ID: <5B3FB807.1070705@broadcom.com> (sfid-20180706_204222_406774_EDD60775)
Date: Fri, 6 Jul 2018 20:42:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180704203130.12086-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

resending without HTML...

On 7/4/2018 10:31 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> Some features supported by firmware aren't advertised and there is no
> way for a driver to query them. This includes e.g. monitor mode details.
>
> Most firmwares support monitor interface but only the latest ones
> /announce/ it with a "monitor" flag in the "cap" iovar. There isn't any
> reliable detection method for older firmwares (BRCMF_C_MONITOR was tried
> but "it only indicates the core part of the stack supports").
>
> Similarly support for tagging monitor frames and building radiotap
> headers can't be reliably detected for all firmwares.
>
> This commit adds table that allows mapping features to firmware version.
> It adds mappings for 43602a1 and 4366b1 firmwares from
> linux-firmware.git. Both were confirmed to be passing monitor frames.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 38 ++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> index 4db4d444407a..ab1d9eb1e9dc 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
> @@ -93,6 +93,42 @@ static int brcmf_feat_debugfs_read(struct seq_file *seq, void *data)
>   }
>   #endif /* DEBUG */
>
> +struct brcmf_feat_fwfeat {
> +	const char * const fwid;
> +	u32 feat_flags;
> +};
> +
> +static const struct brcmf_feat_fwfeat brcmf_feat_fwfeat_map[] = {
> +	/* brcmfmac43602-pcie.ap.bin from linux-firmware.git ea1178515b88 */
> +	{ "01-6cb8e269", BIT(BRCMF_FEAT_MONITOR) },
> +	/* brcmfmac4366b-pcie.bin from linux-firmware.git 52442afee990 */
> +	{ "01-c47a91a4", BIT(BRCMF_FEAT_MONITOR) },
> +};

Not sure if people will realize what the sha1 implies here. Can we just 
drop the comments here?

Regards,
Arend
