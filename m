Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:43836 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755022AbeCSJcJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 05:32:09 -0400
Received: by mail-io0-f196.google.com with SMTP id l12so19935514ioc.10
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2018 02:32:09 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] dt: bindings: add new dt entries for
 brcmfmac
To: Alexey Roslyakov <alexey.roslyakov@gmail.com>, andrew@lunn.ch,
        kvalo@codeaurora.org, robh+dt@kernel.org, mark.rutland@arm.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        netdev@vger.kernel.org
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
 <20180319014032.9394-3-alexey.roslyakov@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AAF838D.2030105@broadcom.com> (sfid-20180319_103224_485968_202B14BF)
Date: Mon, 19 Mar 2018 10:31:57 +0100
MIME-Version: 1.0
In-Reply-To: <20180319014032.9394-3-alexey.roslyakov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/19/2018 2:40 AM, Alexey Roslyakov wrote:
> In case if the host has higher align requirements for SG items, allow
> setting device-specific aligns for scatterlist items.
>
> Signed-off-by: Alexey Roslyakov <alexey.roslyakov@gmail.com>
> ---
>   Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index 86602f264dce..187b8c1b52a7 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -17,6 +17,11 @@ Optional properties:
>   	When not specified the device will use in-band SDIO interrupts.
>    - interrupt-names : name of the out-of-band interrupt, which must be set
>   	to "host-wake".
> + - brcm,broken-sg-support : boolean flag to indicate that the SDIO host
> +	controller has higher align requirement than 32 bytes for each
> +	scatterlist item.
> + - brcm,sd-head-align : alignment requirement for start of data buffer.
> + - brcm,sd-sgentry-align : length alignment requirement for each sg entry.

Hi Alexey,

Thanks for the patch. However, the problem with these is that they are 
characterizing the host controller and not the wireless device. So from 
device tree perspective , which is to describe the hardware, these 
properties should be SDIO host controller properties. Also I am not sure 
if the broken-sg-support is still needed. We added that for omap_hsmmc, 
but that has since changed to scatter-gather emulation so it might not 
be needed anymore.

Regards,
Arend
