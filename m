Return-Path: <SRS0=7415=NL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A86ECDE44
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 10:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 646EF20685
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Oct 2018 10:07:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 646EF20685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbeJaTEu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Oct 2018 15:04:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54369 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbeJaTEu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Oct 2018 15:04:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id r63-v6so14511177wma.4
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2018 03:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bRO/0d13ER7/2YMkRqrzcDc36HrN3S9hFjthSXWVooM=;
        b=q1BHwypb7HnAZfuPLWTm0mPxjyqIvpERsMSMOTWdWw4iqN+2yh3oP8HdM3a77EO6US
         aOrQVnmuBg9aXTT0+v9t5IWKN4Tn1lnuaYkUJLGLIshGYW6Kxko+t6JCIxixMEUxlgQu
         bvg0uxp9RPMFLVLfA5clvtVVUSZL9+Xbm0ZRhvthNuqwiV2gVJmEXEiDf6azqpdxsQew
         YzbbjXXJD7EF5mJL4L6HhtCjOr8i6xmO7TybfEdGDoYn+7uIybiCYTR1p+vxlGjQDrE/
         A/RvDcIlKizp7/Iq68bppY9ox1C8qnHfH4CIa4BOLeiZbJH27twpNQR3R8asAGj5RJr0
         3SmA==
X-Gm-Message-State: AGRZ1gIrGjr75jsDlB2PsqDNpbuoynrvsO3y0fvHhhEo3qynMslen85e
        tZ/lTU7wUJbAOZk1dboDAwk8Jw==
X-Google-Smtp-Source: AJdET5fvpJAGlulHVDutFZvYMiwOrEKZQaUdZRGuqVlsapqYfadlMx3oWbzhYtmYUKWKhUhOrqaMow==
X-Received: by 2002:a7b:c00a:: with SMTP id c10-v6mr1735564wmb.73.1540980441455;
        Wed, 31 Oct 2018 03:07:21 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y195-v6sm19871376wme.22.2018.10.31.03.07.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Oct 2018 03:07:21 -0700 (PDT)
Date:   Wed, 31 Oct 2018 11:07:18 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: do not overwrite other MT_BBP(AGC, 8) fields
Message-ID: <20181031100718.GC9564@localhost.localdomain>
References: <1540971178-16407-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540971178-16407-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> MT_BBP(AGC, 8) register has values depend on band in
> mt76x0_bbp_switch_tab, so we should not overwrite other fields
> than MT_BBP_AGC_GAIN when setting gain.
> 
> This can fix performance issues when connecting to 2.4GHz AP.
> 
> Fixes: 4636a2544c3b ("mt76x0: phy: align channel gain logic to mt76x2 one")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index ba98814ae47d..88dd0aa7e877 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -690,10 +690,8 @@ static void mt76x0_phy_temp_sensor(struct mt76x02_dev *dev)
>  static void mt76x0_phy_set_gain_val(struct mt76x02_dev *dev)
>  {
>  	u8 gain = dev->cal.agc_gain_cur[0] - dev->cal.agc_gain_adjust;
> -	u32 val = 0x122c << 16 | 0xf2;
>  
> -	mt76_wr(dev, MT_BBP(AGC, 8),
> -		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain));
> +	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, gain);
>  
>  	if ((dev->mt76.chandef.chan->flags & IEEE80211_CHAN_RADAR) &&
>  	    !is_mt7630(dev))
> -- 
> 2.7.5
> 

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
