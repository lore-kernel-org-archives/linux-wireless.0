Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4174C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 11:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7402320827
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 11:12:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7402320827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbeJ3UFt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 16:05:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44012 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbeJ3UFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 16:05:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id t10-v6so12090066wrn.10
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2018 04:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MTNmnoNjIiDQxPrkp9XqbGkHNY6w22h+LPk2yuDMEfI=;
        b=WT0+RGovXJ2Riu+P+Dc5a9GLxQ44SrTWJ2qa2eNBjPVllboO1QvWfCGpBzqtK2GEUf
         HzTemy+KVGpocFRH/dtC5xucH5wWXAiJGHqlNw2FIGq7ReV+NE9GzN3BYvbB+tB6SNRH
         G5pXuS9vn3dDNdaUmpmNUTiSGvBc9S+OnGnJeXtF4v8yfWTnSYVapTown0gY3a/v2MaB
         oMF0ggnCMQbNUuxvOipQhUVi+tjCCIJI5lbd6dSNfwoPBRTBePqX1Iwyip5vKqstlLT7
         tV4mhY+yHflnkKk4XyBcv+fBGbUzdY37sXFap+GZxIMDVnXb4IqcCRRZy6LSD9JElbkt
         OqJQ==
X-Gm-Message-State: AGRZ1gIS4YNDz4+SejEruxvNocehexsoJ+fYpAKt6pJlu3tf7G4C6LjA
        3bLaM6gibV5GMdQfMtIx6kMSvA==
X-Google-Smtp-Source: AJdET5fdNYAv9ug4iNKjONKGzS+kQrC1ski63S9Ey2+15vhl9U33gqmrKkIUJGm4mI936LJGIMIVig==
X-Received: by 2002:a5d:4983:: with SMTP id r3-v6mr18624300wrq.72.1540897965375;
        Tue, 30 Oct 2018 04:12:45 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 191-v6sm15420400wmk.30.2018.10.30.04.12.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Oct 2018 04:12:43 -0700 (PDT)
Date:   Tue, 30 Oct 2018 12:12:41 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: use band parameter for LC calibration
Message-ID: <20181030111240.GD32471@localhost.localdomain>
References: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index c734987a344c..ca24b5716b58 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -522,6 +522,7 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
>  void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
>  {
>  	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> +	int is_5ghz = (chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
>  	u32 val, tx_alc, reg_val;
>  
>  	if (is_mt7630(dev))
> @@ -542,7 +543,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
>  	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
>  	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
>  
> -	if (chan->band == NL80211_BAND_5GHZ) {
> +	if (is_5ghz) {
>  		if (chan->hw_value < 100)
>  			val = 0x701;
>  		else if (chan->hw_value < 140)
> @@ -555,7 +556,7 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
>  
>  	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val, false);
>  	msleep(350);
> -	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 1, false);
> +	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
>  	usleep_range(15000, 20000);
>  
>  	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
> -- 
> 2.7.5
> 

Tested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Regards,
Lorenzo
