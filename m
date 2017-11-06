Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:56658 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbdKFL1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 06:27:54 -0500
Date: Mon, 6 Nov 2017 22:27:29 +1100
From: Simon Shields <simon@lineageos.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, devicetree@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
Message-ID: <20171106112726.GA25134@lineageos.org> (sfid-20171106_122757_249384_5A9416BE)
References: <20171104132421.GA1541@archbox.home>
 <5A004099.90200@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A004099.90200@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 06, 2017 at 11:59:37AM +0100, Arend van Spriel wrote:
> On 11/4/2017 2:24 PM, Simon Shields wrote:
> > Some boards use an external 32khz clock for low-power
> > mode timing. Make sure the clock is powered on while the chipset
> > is active.
> 
> Do you have such a board? With the little documentation I can get my hands
> on here I wonder whether the clock needs to be enabled before the device is
> powered. If you have the hardware I would like to check some registers in
> the device.
> 

Yes. Trats2 (exynos4412-based) has such a setup. The BCM4334 works fine
with this patch and one more that enables the WL_REG_EN pin when
brcmfmac is probed.

Without this patch (and only enabling WL_REG_EN), the chip is detected but
attempting to initialise it fails with a bunch of timeouts.

> Regards,
> Arend

Cheers,
Simon
