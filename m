Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:53761 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751334AbdH3MCV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 08:02:21 -0400
Date: Wed, 30 Aug 2017 14:02:18 +0200
From: Antony Antony <antony@phenome.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Antony Antony <antony@phenome.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        devicetree <devicetree@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] Documentation: dt-binding: net: wireless: add
 bcm43430-fmac
Message-ID: <20170830120218.ms3xuhp4qsibistv@AntonyAntony.local> (sfid-20170830_140225_243687_89563AFC)
References: <20170829214309.34466-1-antony@phenome.org>
 <CAGb2v66=JvS9wHkUNBwd+vHwx4NAQsaWyhx1OyEokSZizo+7-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGb2v66=JvS9wHkUNBwd+vHwx4NAQsaWyhx1OyEokSZizo+7-g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Wed, Aug 30, 2017 at 10:28:20AM +0800, Chen-Yu Tsai wrote:
> On Wed, Aug 30, 2017 at 5:43 AM, Antony Antony <antony@phenome.org> wrote:

> > a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > @@ -6,7 +6,9 @@ connects the device to the system.
> >
> >  Required properties:
> >
> > - - compatible : Should be "brcm,bcm4329-fmac".
> > + - compatible : should be one of the following:
> > +       * "brcm,bcm4329-fmac"
> > +       * "brcm,bcm43430-fmac"
> 
> You updated the bindings, but not the driver. So it's not actually
> going to work. More specifically, OOB interrupts won't work.
>

understood, ignore this patch for now. Thanks Chen-Yu.

> IIRC, The compatible string for this particular case, as it was
> originally proposed, only serves as a placeholder for the driver
> to check against. None of the instances in sunxi device trees
> match the actual chip model. Actual model matching is done
> through SDIO, as you've already seen.

yes it seems SDIO driveer code is smarter, once it initialize 
brcm,bcm4329-fmac it ignore the DT info and read the chip details to locate 
firmware file.

I also noticed other boards using bcm4329-fmac in similar situations.
https://patchwork.kernel.org/patch/9739181/

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts?h=v4.13-rc7

I will resend "NanoPi NEO Plus2" dts with "brcm,bcm4329-fmac" and see where 
it goes. 

regards,
-antony
