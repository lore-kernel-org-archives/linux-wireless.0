Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39834 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752367AbdIAUkg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 16:40:36 -0400
Date: Fri, 1 Sep 2017 22:40:30 +0200
From: Antony Antony <antony@phenome.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Rob Herring <robh@kernel.org>, Antony Antony <antony@phenome.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        devicetree <devicetree@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] Documentation: dt-binding: net: wireless: add
 bcm43430-fmac
Message-ID: <20170901204030.2zpsoa4i53tdegs3@AntonyAntony.local> (sfid-20170901_224039_757329_13405B15)
References: <20170829214309.34466-1-antony@phenome.org>
 <CAGb2v66=JvS9wHkUNBwd+vHwx4NAQsaWyhx1OyEokSZizo+7-g@mail.gmail.com>
 <20170830120218.ms3xuhp4qsibistv@AntonyAntony.local>
 <20170901164911.aiu5ej5u546z5kow@rob-hp-laptop>
 <bb53a79e-8045-3c9b-8c98-8d4815c3b57a@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bb53a79e-8045-3c9b-8c98-8d4815c3b57a@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 01, 2017 at 09:10:41PM +0200, Arend van Spriel wrote:
> On 01-09-17 18:49, Rob Herring wrote:
> > On Wed, Aug 30, 2017 at 02:02:18PM +0200, Antony Antony wrote:
> > > hi,
> > > 
> > > On Wed, Aug 30, 2017 at 10:28:20AM +0800, Chen-Yu Tsai wrote:
> > > > On Wed, Aug 30, 2017 at 5:43 AM, Antony Antony <antony@phenome.org> wrote:
> > > 
> > > > > a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > > > > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> > > > > @@ -6,7 +6,9 @@ connects the device to the system.
> > > > > 
> > > > >   Required properties:
> > > > > 
> > > > > - - compatible : Should be "brcm,bcm4329-fmac".
> > > > > + - compatible : should be one of the following:
> > > > > +       * "brcm,bcm4329-fmac"
> > > > > +       * "brcm,bcm43430-fmac"
> > > > 
> > > > You updated the bindings, but not the driver. So it's not actually
> > > > going to work. More specifically, OOB interrupts won't work.
> > > > 
> > > 
> > > understood, ignore this patch for now. Thanks Chen-Yu.
> > > 
> > > > IIRC, The compatible string for this particular case, as it was
> > > > originally proposed, only serves as a placeholder for the driver
> > > > to check against. None of the instances in sunxi device trees
> > > > match the actual chip model. Actual model matching is done
> > > > through SDIO, as you've already seen.
> > > 
> > > yes it seems SDIO driveer code is smarter, once it initialize
> > > brcm,bcm4329-fmac it ignore the DT info and read the chip details to locate
> > > firmware file.
> > > 
> > > I also noticed other boards using bcm4329-fmac in similar situations.
> > > https://patchwork.kernel.org/patch/9739181/
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts?h=v4.13-rc7
> > > 
> > > I will resend "NanoPi NEO Plus2" dts with "brcm,bcm4329-fmac" and see where
> > > it goes.
> > 
> > Adding the compatible or instead of? The former would be better. You
> > should still have the actual chip in case you do have some difference to
> > handle.
> 
> Hi Rob,
> 
> Actually the Broadcom wifi chips themselves are discoverable. So once the
> driver has access to the register space of the device it can determine the
> actual chip, its revision, and exactly what cores (and their revision) are
> present in the chip. Hence there is a single compatible string as there is
> no need to convey the same information through device tree data.

In my expereince this how it seems to work.

I jsut discovered s/brcm,bcm4329-fmac/brcm/ can load the broadcom driver.

brcmf: wifi@1 {
	reg = <1>;
	compatible = "brcm";
}; 

This looks better to me. Maxime, Would this work? 

regards,
-antony
