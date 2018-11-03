Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB24EC0044C
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 17:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 872EF2081B
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 17:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sq2EZLHH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 872EF2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbeKDCtS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 22:49:18 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41901 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbeKDCtS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 22:49:18 -0400
Received: by mail-oi1-f196.google.com with SMTP id y192-v6so4134020oie.8;
        Sat, 03 Nov 2018 10:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6fXUCkP8+QZdQWuF+K9sFdaALxI4SQZAgbVitFO/VB4=;
        b=Sq2EZLHH7I6NdHMvRaBO1yTxqe3Eq1/3WZ67xrEGRKruPfzeZXQkwuXATjdPHeAV2W
         GxSWG/iXM1lCuRq7xzce6vvGvc6Tbk780WAnI6ZfNOWWB9+4MOboKVvudEdBEqdyQLbj
         YzJ7NvG5IyuIs0gegxf7GqHrS8asUtSDoz3pXU+rPjAbUXbS1h0aD6wZIDcuWNMuTZeX
         giS9DnXNKQbswey7anLgqS6UspDoGYHugJcyd3iOwCSAAClorkNvx9wn4Miq2Q+2PK/C
         sjGCbW3P10ITVk8h4lQGj0nUHdWYE8AO+AGQipOEQidJyUMuaqFkYPnCNmztvqelusRA
         7drA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6fXUCkP8+QZdQWuF+K9sFdaALxI4SQZAgbVitFO/VB4=;
        b=pVajWUxqi3gJpn4b/4to7l0LfMohNyU0Vcy8spxoHsc+5XD8x4UgxT/Ea7ETh3tdxz
         D8ULXagb/jCy2a7A39pWemy3nLOGJMOBYu/18818V05OGHIKijz/eIvA34o9SOv45n4l
         gBMTaCQyYfqg53wrswUHcUxtUZ+H2/iskGYiKkzpbjbkLsIcSamQxBucpFTcXYy7aSFj
         hMhyg33Y1kJ7ArcCwUZRR+vFm+2itOCaIM4P+64dUlLPlgvD65dfyrjWQrXDMfl1VLzU
         whx9MJawXtsKk5+ey5fDTD+Af9WLaJvSwGtBzOb3Yg/P2AHiEQM4acRc6axuVd117Zr5
         GtSA==
X-Gm-Message-State: AGRZ1gJQ7fLzdSD5Ub9lN5n8rXpAoLF/quLaMRC7janCVOt2it4sw0ah
        VOla2dNbRiAKy77J4k1JzJ1fANfH
X-Google-Smtp-Source: AJdET5d5Csxj//wlclWOj7ngz0dYg26X7v0GmTk12U7KQmbWURSgs1t8ldwMFWjUpFFB1qCd+Nrfhg==
X-Received: by 2002:aca:4c53:: with SMTP id z80-v6mr1245838oia.318.1541266643349;
        Sat, 03 Nov 2018 10:37:23 -0700 (PDT)
Received: from [192.168.1.118] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y204-v6sm4697329oiy.40.2018.11.03.10.37.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 03 Nov 2018 10:37:22 -0700 (PDT)
Subject: Re: [PATCH 4/5] b43: Use common cordic algorithm from kernel lib
To:     Priit Laes <plaes@plaes.org>, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, b43-dev@lists.infradead.org
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
 <c208360e5cc314ac1ad81f907f4538cf2dcbd196.1541238842.git-series.plaes@plaes.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e18ec785-af47-847b-445d-fdc2f76223d8@lwfinger.net>
Date:   Sat, 3 Nov 2018 12:37:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c208360e5cc314ac1ad81f907f4538cf2dcbd196.1541238842.git-series.plaes@plaes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/3/18 4:59 AM, Priit Laes wrote:
> Signed-off-by: Priit Laes <plaes@plaes.org>

Where is the commit message? The stuff in the cover letter (Patch 0/N) never 
makes it to the git repository. You must have a message in each of the 
individual patches.

NACK.

Larry

> ---
>   drivers/net/wireless/broadcom/b43/Kconfig  |  1 +
>   drivers/net/wireless/broadcom/b43/phy_lp.c | 13 +++++++------
>   drivers/net/wireless/broadcom/b43/phy_n.c  | 13 +++++++------
>   3 files changed, 15 insertions(+), 12 deletions(-)
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
> 

