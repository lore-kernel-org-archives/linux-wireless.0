Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:46528 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755824AbdLOVqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 16:46:55 -0500
Date: Fri, 15 Dec 2017 15:46:53 -0600
From: Rob Herring <robh@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] dt-bindings: net: wireless: Add sg parameters dts parsing
Message-ID: <20171215214653.fqbw5epxtd5j6jml@rob-hp-laptop> (sfid-20171215_224701_623527_0B98CD7F)
References: <20171211081144.GA140567@aremote07.aus.cypress.com>
 <5A2E5606.8010707@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A2E5606.8010707@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 11, 2017 at 10:55:18AM +0100, Arend van Spriel wrote:
> On 12/11/2017 9:11 AM, Chi-Hsien Lin wrote:
> > broken_sg_support, sd_head_align, and sd_sgentry_align are used in
> > brcmfmac code but not configurable in dts file. Add the parsing logic.
> > Now they can be configured like below in dts:
> > 	brcm,broken_sg_support;
> > 	brcm,sd_head_align = <4>;
> > 	brcm,sd_sgentry_align = <4>;
> > 
> > Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> > ---
> >   .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt        | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > index 86602f2..4d42f0d 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > @@ -17,6 +17,11 @@ Optional properties:
> >   	When not specified the device will use in-band SDIO interrupts.
> >    - interrupt-names : name of the out-of-band interrupt, which must be set
> >   	to "host-wake".
> > + - broken_sg_support : flag for broken sg list support of SDIO host controller.
> > +	Set this to true if the SDIO host controller has higher align
> > +	requirement than 32 bytes for each scatterlist item.
> 
> In DT context, this does not characterize the device but as described it is
> about the SDIO host controller. I think the same applies to the properties
> below, but not entirely sure about that.

Yes. However, all of this should be implied by the host controller's 
compatible property.

For future reference, don't use '_' in property names either.

Rob
