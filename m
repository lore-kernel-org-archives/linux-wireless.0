Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:49215 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdKHNbQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 08:31:16 -0500
Date: Thu, 9 Nov 2017 00:31:07 +1100
From: Simon Shields <simon@lineageos.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, devicetree@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
Message-ID: <20171108133105.GA15990@lineageos.org> (sfid-20171108_143121_090938_50C4D2AB)
References: <20171104132421.GA1541@archbox.home>
 <5A004099.90200@broadcom.com>
 <20171106112726.GA25134@lineageos.org>
 <5A019463.9060701@broadcom.com>
 <20171107133112.GA1323@lineageos.org>
 <5A02DE93.8030502@broadcom.com>
 <20171108114302.GA1291@lineageos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171108114302.GA1291@lineageos.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 08, 2017 at 10:43:05PM +1100, Simon Shields wrote:
> Hi Arend,
> 
> On Wed, Nov 08, 2017 at 11:38:11AM +0100, Arend van Spriel wrote:
> > + Stefan
> > 
> > On 11/7/2017 2:31 PM, Simon Shields wrote:
> > > Hi Arend,
> > > 
> > > On Tue, Nov 07, 2017 at 12:09:23PM +0100, Arend van Spriel wrote:
> > > > On 11/6/2017 12:27 PM, Simon Shields wrote:
> > > > > On Mon, Nov 06, 2017 at 11:59:37AM +0100, Arend van Spriel wrote:
> > > > > > On 11/4/2017 2:24 PM, Simon Shields wrote:
> > > > > > > Some boards use an external 32khz clock for low-power
> > > > > > > mode timing. Make sure the clock is powered on while the chipset
> > > > > > > is active.
> > > > > > 
> > > > > > Do you have such a board? With the little documentation I can get my hands
> > > > > > on here I wonder whether the clock needs to be enabled before the device is
> > > > > > powered. If you have the hardware I would like to check some registers in
> > > > > > the device.
> > > > > > 
> > > > > 
> > > > > Yes. Trats2 (exynos4412-based) has such a setup. The BCM4334 works fine
> > > > > with this patch and one more that enables the WL_REG_EN pin when
> > > > > brcmfmac is probed.
> > > > 
> > > > Ok. So this is exactly the thing I was wondering about. So it makes me
> > > > curious how the WL_REG_EN patch looks like. Can you provide that?
> > > > 
> > > 
> > > Here[0] is a link to the patch in its current state. Obviously, it's not
> > > ready at all for mainlining :-)
> > > 
> > > [0]: https://github.com/fourkbomb/linux/commit/436e59e58b44d856c186fc4767560cecbcbc0c59.patch
> > 
> > Thanks. Indeed doing it in module_init of brcmfmac is not going to fly.
> > Actually the MMC stack has a mechanism to power the SDIO device. This can be
> > configured through the device tree [1]. I just checked and it actually
> > includes specifying the external clock as well.
> > 
> 
> It looks like mmc-pwrseq-simple would handle the clock case, but it
> doesn't handle the regulator properly: it sets the GPIO to high before
> powering on, then lowers it immediately after powering it on.
> 
> I guess a simpler approach here would be to extend pwrseq-simple to behave
> as we need it to.

I missed something really obvious... All that's needed is to invert the
GPIO, like this[0]. Thanks for the pointer :)

Cheers,
Simon

[0]: https://patchwork.kernel.org/patch/10048501/
