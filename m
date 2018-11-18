Return-Path: <SRS0=hThr=N5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC490C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 08:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3512075B
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 08:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="CbgQe43W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F3512075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbeKRSnH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Nov 2018 13:43:07 -0500
Received: from plaes.org ([188.166.43.21]:41628 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbeKRSnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Nov 2018 13:43:07 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 6837540282;
        Sun, 18 Nov 2018 08:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542529408; bh=lvIvPWSqyWpis1qLGU3PqHLECnA5L44sR3mNl1gxsZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CbgQe43Wcy5Sq2nENBlSTysWcx5uim4KqsVsieHOif/jSbn64EiCo86lg/R3NWada
         oQaEYoBtfQAsI67MfUVoyG6uwAZJ6+mr5/Qmf4x8F/Kl5jQT+68Zxchx8xSAJrvORk
         WHcEJQamKdr7agevT0vSNSaqITmdcBPUkQrb7BQ182MokERWfVI+WDKDik+3WFPU0f
         yOII1OVjc7GhIez2NsCkCTDu1TfmkSzjqwObZa2oy5zlb/t37EeL35JnYvPxGfMttn
         lHtqwKpuEy4QH4pmX7MD90pQKmOsjLbdaQarIPnVy8GHI7L1GkntsjYoGHZ7r4zD+G
         oorfnRpr31N9g==
Date:   Sun, 18 Nov 2018 08:23:27 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
Message-ID: <20181118082327.ttrz2nl5owi2hoqv@plaes.org>
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
 <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Nov 17, 2018 at 09:31:35PM -0600, Larry Finger wrote:
> On 11/14/18 12:27 PM, Priit Laes wrote:
> > Kernel library has a common cordic algorithm which is identical
> > to internally implementatd one, so use it and drop the duplicate
> > implementation.
> > 
> > Signed-off-by: Priit Laes <plaes@plaes.org>
> > ---
> >   drivers/net/wireless/broadcom/b43/Kconfig      |  1 +-
> >   drivers/net/wireless/broadcom/b43/phy_common.c | 47 +-------------------
> >   drivers/net/wireless/broadcom/b43/phy_common.h |  9 +----
> >   drivers/net/wireless/broadcom/b43/phy_lp.c     | 13 ++---
> >   drivers/net/wireless/broadcom/b43/phy_n.c      | 13 ++---
> >   5 files changed, 15 insertions(+), 68 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/b43/Kconfig b/drivers/net/wireless/broadcom/b43/Kconfig
> > index fba8560..3e41457 100644
> > --- a/drivers/net/wireless/broadcom/b43/Kconfig
> > +++ b/drivers/net/wireless/broadcom/b43/Kconfig
> > @@ -4,6 +4,7 @@ config B43
> >   	select BCMA if B43_BCMA
> >   	select SSB if B43_SSB
> >   	select FW_LOADER
> > +	select CORDIC
> >   	---help---
> >   	  b43 is a driver for the Broadcom 43xx series wireless devices.
> > diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
> > index 85f2ca9..98c4fa5 100644
> > --- a/drivers/net/wireless/broadcom/b43/phy_common.c
> > +++ b/drivers/net/wireless/broadcom/b43/phy_common.c
> > @@ -604,50 +604,3 @@ void b43_phy_force_clock(struct b43_wldev *dev, bool force)
> >   #endif
> >   	}
> >   }
> > -
> > -/* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
> > -struct b43_c32 b43_cordic(int theta)
> > -{
> > -	static const u32 arctg[] = {
> > -		2949120, 1740967, 919879, 466945, 234379, 117304,
> > -		  58666,   29335,  14668,   7334,   3667,   1833,
> > -		    917,     458,    229,    115,     57,     29,
> > -	};
> > -	u8 i;
> > -	s32 tmp;
> > -	s8 signx = 1;
> > -	u32 angle = 0;
> > -	struct b43_c32 ret = { .i = 39797, .q = 0, };
> > -
> > -	while (theta > (180 << 16))
> > -		theta -= (360 << 16);
> > -	while (theta < -(180 << 16))
> > -		theta += (360 << 16);
> > -
> > -	if (theta > (90 << 16)) {
> > -		theta -= (180 << 16);
> > -		signx = -1;
> > -	} else if (theta < -(90 << 16)) {
> > -		theta += (180 << 16);
> > -		signx = -1;
> > -	}
> > -
> > -	for (i = 0; i <= 17; i++) {
> > -		if (theta > angle) {
> > -			tmp = ret.i - (ret.q >> i);
> > -			ret.q += ret.i >> i;
> > -			ret.i = tmp;
> > -			angle += arctg[i];
> > -		} else {
> > -			tmp = ret.i + (ret.q >> i);
> > -			ret.q -= ret.i >> i;
> > -			ret.i = tmp;
> > -			angle -= arctg[i];
> > -		}
> > -	}
> > -
> > -	ret.i *= signx;
> > -	ret.q *= signx;
> > -
> > -	return ret;
> > -}
> > diff --git a/drivers/net/wireless/broadcom/b43/phy_common.h b/drivers/net/wireless/broadcom/b43/phy_common.h
> > index 57a1ad8..4213cac 100644
> > --- a/drivers/net/wireless/broadcom/b43/phy_common.h
> > +++ b/drivers/net/wireless/broadcom/b43/phy_common.h
> > @@ -7,13 +7,6 @@
> >   struct b43_wldev;
> > -/* Complex number using 2 32-bit signed integers */
> > -struct b43_c32 { s32 i, q; };
> > -
> > -#define CORDIC_CONVERT(value)	(((value) >= 0) ? \
> > -				 ((((value) >> 15) + 1) >> 1) : \
> > -				 -((((-(value)) >> 15) + 1) >> 1))
> > -
> >   /* PHY register routing bits */
> >   #define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
> >   #define  B43_PHYROUTE_BASE		0x0000 /* Base registers */
> > @@ -450,6 +443,4 @@ bool b43_is_40mhz(struct b43_wldev *dev);
> >   void b43_phy_force_clock(struct b43_wldev *dev, bool force);
> > -struct b43_c32 b43_cordic(int theta);
> > -
> >   #endif /* LINUX_B43_PHY_COMMON_H_ */
> > diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
> > index 6922cbb..1718e3b 100644
> > --- a/drivers/net/wireless/broadcom/b43/phy_lp.c
> > +++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
> > @@ -23,6 +23,7 @@
> >   */
> > +#include <linux/cordic.h>
> >   #include <linux/slab.h>
> >   #include "b43.h"
> > @@ -1780,9 +1781,9 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
> >   {
> >   	struct b43_phy_lp *lpphy = dev->phy.lp;
> >   	u16 buf[64];
> > -	int i, samples = 0, angle = 0;
> > +	int i, samples = 0, theta = 0;
> >   	int rotation = (((36 * freq) / 20) << 16) / 100;
> > -	struct b43_c32 sample;
> > +	struct cordic_iq sample;
> >   	lpphy->tx_tone_freq = freq;
> > @@ -1798,10 +1799,10 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
> >   	}
> >   	for (i = 0; i < samples; i++) {
> > -		sample = b43_cordic(angle);
> > -		angle += rotation;
> > -		buf[i] = CORDIC_CONVERT((sample.i * max) & 0xFF) << 8;
> > -		buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF);
> > +		sample = cordic_calc_iq(theta);
> > +		theta += rotation;
> > +		buf[i] = CORDIC_FLOAT((sample.i * max) & 0xFF) << 8;
> > +		buf[i] |= CORDIC_FLOAT((sample.q * max) & 0xFF);
> >   	}
> >   	b43_lptab_write_bulk(dev, B43_LPTAB16(5, 0), samples, buf);
> > diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> > index 44ab080..1f9378a 100644
> > --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> > +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> > @@ -23,6 +23,7 @@
> >   */
> > +#include <linux/cordic.h>
> >   #include <linux/delay.h>
> >   #include <linux/slab.h>
> >   #include <linux/types.h>
> > @@ -1513,7 +1514,7 @@ static void b43_radio_init2055(struct b43_wldev *dev)
> >   /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
> >   static int b43_nphy_load_samples(struct b43_wldev *dev,
> > -					struct b43_c32 *samples, u16 len) {
> > +					struct cordic_iq *samples, u16 len) {
> >   	struct b43_phy_n *nphy = dev->phy.n;
> >   	u16 i;
> >   	u32 *data;
> > @@ -1544,7 +1545,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
> >   {
> >   	int i;
> >   	u16 bw, len, rot, angle;
> > -	struct b43_c32 *samples;
> > +	struct cordic_iq *samples;
> >   	bw = b43_is_40mhz(dev) ? 40 : 20;
> >   	len = bw << 3;
> > @@ -1561,7 +1562,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
> >   		len = bw << 1;
> >   	}
> > -	samples = kcalloc(len, sizeof(struct b43_c32), GFP_KERNEL);
> > +	samples = kcalloc(len, sizeof(struct cordic_iq), GFP_KERNEL);
> >   	if (!samples) {
> >   		b43err(dev->wl, "allocation for samples generation failed\n");
> >   		return 0;
> > @@ -1570,10 +1571,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
> >   	angle = 0;
> >   	for (i = 0; i < len; i++) {
> > -		samples[i] = b43_cordic(angle);
> > +		samples[i] = cordic_calc_iq(angle);
> >   		angle += rot;
> > -		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
> > -		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
> > +		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
> > +		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
> >   	}
> >   	i = b43_nphy_load_samples(dev, samples, len);
> 
> There is a fundamental flaw in this patch. Routine b43_cordic() takes an
> angle in degrees scaled by 2^16, whereas cordic_calc_iq() takes an angle in
> degrees. For a given input, the two routines must get different answers. At
> a minimum, the calculation of rot would need to remove the left shift of 16.

Thanks for the hint. I modified my "test harness" a bit to plot out values
from -360 .. 360 and transformed the theta for b43_cordic argument using CORDIC_FIXED macro:

b43_cordic(CORDIC_FIXED(theta));
cordic_calc_iq(theta);

Then I plotted the results and well.. they are not that pretty. While the results give
identical answers between certain ranges of degrees, the cordic algorithm for b43 seems
to be broken for certain ranges: (-270..-180 ; -90 .. 0; 90.. 180 and 270..360).

You can find my test harnesses here:

https://gist.github.com/plaes/284993a4fc65e0926d0628a11f0cf874

> 
> From what I see of the two algorithms, the method is identical once the
> differences in scaling are handled. Even so, applying this patch to b43
> leads to a series of B43 error messages followed by a crash in kfree.
> 
> Just to add to the level of rejection: NACK.
> 
> Larry
