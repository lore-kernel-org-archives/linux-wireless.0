Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:41107 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKJzV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 04:55:21 -0500
Received: by mail-qt0-f195.google.com with SMTP id i40so36910387qti.8
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 01:55:20 -0800 (PST)
Subject: Re: [PATCH] dt-bindings: net: wireless: Add sg parameters dts parsing
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        devicetree@vger.kernel.org
References: <20171211081144.GA140567@aremote07.aus.cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Kalle Valo <kvalo@codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A2E5606.8010707@broadcom.com> (sfid-20171211_105525_839083_81E5FBE8)
Date: Mon, 11 Dec 2017 10:55:18 +0100
MIME-Version: 1.0
In-Reply-To: <20171211081144.GA140567@aremote07.aus.cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2017 9:11 AM, Chi-Hsien Lin wrote:
> broken_sg_support, sd_head_align, and sd_sgentry_align are used in
> brcmfmac code but not configurable in dts file. Add the parsing logic.
> Now they can be configured like below in dts:
> 	brcm,broken_sg_support;
> 	brcm,sd_head_align = <4>;
> 	brcm,sd_sgentry_align = <4>;
>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> ---
>   .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt        | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index 86602f2..4d42f0d 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -17,6 +17,11 @@ Optional properties:
>   	When not specified the device will use in-band SDIO interrupts.
>    - interrupt-names : name of the out-of-band interrupt, which must be set
>   	to "host-wake".
> + - broken_sg_support : flag for broken sg list support of SDIO host controller.
> +	Set this to true if the SDIO host controller has higher align
> +	requirement than 32 bytes for each scatterlist item.

In DT context, this does not characterize the device but as described it 
is about the SDIO host controller. I think the same applies to the 
properties below, but not entirely sure about that.

> + - sg_head_align : alignment requirement for start of data buffer.
> + - sg_sgentry_align : length alignment requirement for each sg entry.

Regards,
Arend
