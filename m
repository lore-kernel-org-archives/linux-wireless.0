Return-Path: <SRS0=hThr=N5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9F9C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 03:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A90CE2080C
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Nov 2018 03:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csIdLTH3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A90CE2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbeKRNu3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Nov 2018 08:50:29 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39522 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbeKRNu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Nov 2018 08:50:29 -0500
Received: by mail-ot1-f65.google.com with SMTP id g27so24829812oth.6;
        Sat, 17 Nov 2018 19:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:subject:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M2lXyr/0xoPHPNaM6BqG/99o3ekLDcSliBz+VUOIsrA=;
        b=csIdLTH3sQm3QzwFCofY800JG8geN5JgzF4o7K5jWuqdteqysb1IEleU1CX+BOOIHH
         +skIoURWkMWbkBJ9XSCvtgvOcpPJWY+HpUQIk3uYrAqpPsVSLzu9ulx1mT15yJ0f2DZJ
         USTYkKJM/fZIJm5XrjSws6VUOGrTFad5+0C4ZNWY84ceZzublVRdK/aI2DaMqCo6cFJO
         sJwBDu2T2QY3znSHqPhR50LSn3yTuowWhTJFHnpUP73NNSTxU0ZdtwA3Pz471IUgwNrU
         5q9TtHXf/WLGwTH4NNoJUrhEaPNi6OUmOKLXjslbr493r150xpU9FaZRKuyBK6ZHvuOI
         +3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:subject:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M2lXyr/0xoPHPNaM6BqG/99o3ekLDcSliBz+VUOIsrA=;
        b=EeNObVubojTN3U6hXgUzSsWaAr7d/2pdxDADFD+xZmBtoAxbzXnE/tf+92FJ+qPEnW
         ojDZoxLaDX452F4BmgbusCl8whnuMYU0WgbLIEtbQfFEFvYrI/WRUpgPMbKIhjNyTHIi
         JVX/J1WaSx5qT/X43yUoW3AIxfocjPSEgd5yGW4LYAxRpRUnt4PSlTx5p0bhrlZZKEsO
         8W5P55HzvASgUJ0Sb7mIbn1FIvggoVCrV0WmnwYRip/R0OTXaRF4Em0HNwGCrv28sLWL
         sO4OzhEETGiRRzSCzIOzIAprLbFqpXIrTMSMvJ3sth+9e/6w7Elir9bACeYf2JWdKn6I
         g2pg==
X-Gm-Message-State: AGRZ1gLBubrJXWnqKZwL3gEh66hsWOa4YgSecuDLNHQomH3mJGuSZNjo
        26jrs+Oxc2MzGZbe2WybEworjOd0
X-Google-Smtp-Source: AJdET5dFWmX5CkJDM6PudBN/892L1viq3LAoBoTfIM1HdHxbD2ecVTnPHI+SGPCbHMtgXcNH2Sd9vQ==
X-Received: by 2002:a9d:1ef:: with SMTP id e102mr10709743ote.100.1542511895605;
        Sat, 17 Nov 2018 19:31:35 -0800 (PST)
Received: from [192.168.1.103] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 35sm12211478ott.13.2018.11.17.19.31.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Nov 2018 19:31:33 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
To:     Priit Laes <plaes@plaes.org>, Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
Message-ID: <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
Date:   Sat, 17 Nov 2018 21:31:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/14/18 12:27 PM, Priit Laes wrote:
> Kernel library has a common cordic algorithm which is identical
> to internally implementatd one, so use it and drop the duplicate
> implementation.
> 
> Signed-off-by: Priit Laes <plaes@plaes.org>
> ---
>   drivers/net/wireless/broadcom/b43/Kconfig      |  1 +-
>   drivers/net/wireless/broadcom/b43/phy_common.c | 47 +-------------------
>   drivers/net/wireless/broadcom/b43/phy_common.h |  9 +----
>   drivers/net/wireless/broadcom/b43/phy_lp.c     | 13 ++---
>   drivers/net/wireless/broadcom/b43/phy_n.c      | 13 ++---
>   5 files changed, 15 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/Kconfig b/drivers/net/wireless/broadcom/b43/Kconfig
> index fba8560..3e41457 100644
> --- a/drivers/net/wireless/broadcom/b43/Kconfig
> +++ b/drivers/net/wireless/broadcom/b43/Kconfig
> @@ -4,6 +4,7 @@ config B43
>   	select BCMA if B43_BCMA
>   	select SSB if B43_SSB
>   	select FW_LOADER
> +	select CORDIC
>   	---help---
>   	  b43 is a driver for the Broadcom 43xx series wireless devices.
>   
> diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
> index 85f2ca9..98c4fa5 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_common.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_common.c
> @@ -604,50 +604,3 @@ void b43_phy_force_clock(struct b43_wldev *dev, bool force)
>   #endif
>   	}
>   }
> -
> -/* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
> -struct b43_c32 b43_cordic(int theta)
> -{
> -	static const u32 arctg[] = {
> -		2949120, 1740967, 919879, 466945, 234379, 117304,
> -		  58666,   29335,  14668,   7334,   3667,   1833,
> -		    917,     458,    229,    115,     57,     29,
> -	};
> -	u8 i;
> -	s32 tmp;
> -	s8 signx = 1;
> -	u32 angle = 0;
> -	struct b43_c32 ret = { .i = 39797, .q = 0, };
> -
> -	while (theta > (180 << 16))
> -		theta -= (360 << 16);
> -	while (theta < -(180 << 16))
> -		theta += (360 << 16);
> -
> -	if (theta > (90 << 16)) {
> -		theta -= (180 << 16);
> -		signx = -1;
> -	} else if (theta < -(90 << 16)) {
> -		theta += (180 << 16);
> -		signx = -1;
> -	}
> -
> -	for (i = 0; i <= 17; i++) {
> -		if (theta > angle) {
> -			tmp = ret.i - (ret.q >> i);
> -			ret.q += ret.i >> i;
> -			ret.i = tmp;
> -			angle += arctg[i];
> -		} else {
> -			tmp = ret.i + (ret.q >> i);
> -			ret.q -= ret.i >> i;
> -			ret.i = tmp;
> -			angle -= arctg[i];
> -		}
> -	}
> -
> -	ret.i *= signx;
> -	ret.q *= signx;
> -
> -	return ret;
> -}
> diff --git a/drivers/net/wireless/broadcom/b43/phy_common.h b/drivers/net/wireless/broadcom/b43/phy_common.h
> index 57a1ad8..4213cac 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_common.h
> +++ b/drivers/net/wireless/broadcom/b43/phy_common.h
> @@ -7,13 +7,6 @@
>   
>   struct b43_wldev;
>   
> -/* Complex number using 2 32-bit signed integers */
> -struct b43_c32 { s32 i, q; };
> -
> -#define CORDIC_CONVERT(value)	(((value) >= 0) ? \
> -				 ((((value) >> 15) + 1) >> 1) : \
> -				 -((((-(value)) >> 15) + 1) >> 1))
> -
>   /* PHY register routing bits */
>   #define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
>   #define  B43_PHYROUTE_BASE		0x0000 /* Base registers */
> @@ -450,6 +443,4 @@ bool b43_is_40mhz(struct b43_wldev *dev);
>   
>   void b43_phy_force_clock(struct b43_wldev *dev, bool force);
>   
> -struct b43_c32 b43_cordic(int theta);
> -
>   #endif /* LINUX_B43_PHY_COMMON_H_ */
> diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
> index 6922cbb..1718e3b 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_lp.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
> @@ -23,6 +23,7 @@
>   
>   */
>   
> +#include <linux/cordic.h>
>   #include <linux/slab.h>
>   
>   #include "b43.h"
> @@ -1780,9 +1781,9 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
>   {
>   	struct b43_phy_lp *lpphy = dev->phy.lp;
>   	u16 buf[64];
> -	int i, samples = 0, angle = 0;
> +	int i, samples = 0, theta = 0;
>   	int rotation = (((36 * freq) / 20) << 16) / 100;
> -	struct b43_c32 sample;
> +	struct cordic_iq sample;
>   
>   	lpphy->tx_tone_freq = freq;
>   
> @@ -1798,10 +1799,10 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
>   	}
>   
>   	for (i = 0; i < samples; i++) {
> -		sample = b43_cordic(angle);
> -		angle += rotation;
> -		buf[i] = CORDIC_CONVERT((sample.i * max) & 0xFF) << 8;
> -		buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF);
> +		sample = cordic_calc_iq(theta);
> +		theta += rotation;
> +		buf[i] = CORDIC_FLOAT((sample.i * max) & 0xFF) << 8;
> +		buf[i] |= CORDIC_FLOAT((sample.q * max) & 0xFF);
>   	}
>   
>   	b43_lptab_write_bulk(dev, B43_LPTAB16(5, 0), samples, buf);
> diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
> index 44ab080..1f9378a 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_n.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_n.c
> @@ -23,6 +23,7 @@
>   
>   */
>   
> +#include <linux/cordic.h>
>   #include <linux/delay.h>
>   #include <linux/slab.h>
>   #include <linux/types.h>
> @@ -1513,7 +1514,7 @@ static void b43_radio_init2055(struct b43_wldev *dev)
>   
>   /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/LoadSampleTable */
>   static int b43_nphy_load_samples(struct b43_wldev *dev,
> -					struct b43_c32 *samples, u16 len) {
> +					struct cordic_iq *samples, u16 len) {
>   	struct b43_phy_n *nphy = dev->phy.n;
>   	u16 i;
>   	u32 *data;
> @@ -1544,7 +1545,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>   {
>   	int i;
>   	u16 bw, len, rot, angle;
> -	struct b43_c32 *samples;
> +	struct cordic_iq *samples;
>   
>   	bw = b43_is_40mhz(dev) ? 40 : 20;
>   	len = bw << 3;
> @@ -1561,7 +1562,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>   		len = bw << 1;
>   	}
>   
> -	samples = kcalloc(len, sizeof(struct b43_c32), GFP_KERNEL);
> +	samples = kcalloc(len, sizeof(struct cordic_iq), GFP_KERNEL);
>   	if (!samples) {
>   		b43err(dev->wl, "allocation for samples generation failed\n");
>   		return 0;
> @@ -1570,10 +1571,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>   	angle = 0;
>   
>   	for (i = 0; i < len; i++) {
> -		samples[i] = b43_cordic(angle);
> +		samples[i] = cordic_calc_iq(angle);
>   		angle += rot;
> -		samples[i].q = CORDIC_CONVERT(samples[i].q * max);
> -		samples[i].i = CORDIC_CONVERT(samples[i].i * max);
> +		samples[i].q = CORDIC_FLOAT(samples[i].q * max);
> +		samples[i].i = CORDIC_FLOAT(samples[i].i * max);
>   	}
>   
>   	i = b43_nphy_load_samples(dev, samples, len);

There is a fundamental flaw in this patch. Routine b43_cordic() takes an angle 
in degrees scaled by 2^16, whereas cordic_calc_iq() takes an angle in degrees. 
For a given input, the two routines must get different answers. At a minimum, 
the calculation of rot would need to remove the left shift of 16.

 From what I see of the two algorithms, the method is identical once the 
differences in scaling are handled. Even so, applying this patch to b43 leads to 
a series of B43 error messages followed by a crash in kfree.

Just to add to the level of rejection: NACK.

Larry
