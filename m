Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE87C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 209CA2145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 209CA2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbeJRRNq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 13:13:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34089 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbeJRRNq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 13:13:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id l6-v6so32380564wrt.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 02:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bzUMtdHxnnXFviSiK40OdxOxpixlTl1I3udDPriUU3c=;
        b=iPV1OkhQEPjdpVHW+gPyNftL3awNTJMs9KUkRfd5ShW1EXwL0bZiPtDjI/vaYE0T3j
         sSLG7sK1+2Amds6ltmIqukWSEWye3X8cNyIlWx8c3UqVuNVhxzPNN5kvgPX93wWV4f3+
         LM+nWjz+9oaVjDuiBGRX+xq8mJy64eFa7FEG75fl7yIQIVDGCUXoCZqhogH3bmnR8UeQ
         oCP9HJE99AQvrF1Naq36PuyNX5scZG3hzqZGcjv6ebww1GsAjSSmIvyXz+jmffQLvjZO
         5WXXFGJOs7pWPH9InFmR7VhiNly8oXnwlx4l+HT/hZKJC+FFa44FvT6Vz/fkYgYsb8Or
         aLrw==
X-Gm-Message-State: ABuFfoijeCDMz7FW49nllS8O8rMHWqpGex0NrKcOH/4xkDJcBFGq0lAW
        I8P/HnAsLAl7xBDhPSl2Xer3Ew==
X-Google-Smtp-Source: ACcGV60AY4YI5XVw6fthdCvMNjrd5Wx3iUR3JPqYfQ7M4fPT85YX0clBV1aKrUziB4TvNRVOVX6Lxg==
X-Received: by 2002:adf:c405:: with SMTP id v5-v6mr29612274wrf.20.1539854019224;
        Thu, 18 Oct 2018 02:13:39 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r128-v6sm2475572wma.40.2018.10.18.02.13.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 02:13:38 -0700 (PDT)
Date:   Thu, 18 Oct 2018 11:13:36 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: antenna select corrections
Message-ID: <20181018091335.GB4938@localhost.localdomain>
References: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Update mt76x0_phy_ant_select() to conform vendor driver, most notably
> add dual antenna mode support, read configuration from EEPROM and
> move ant select out of channel config to init phase. Plus small MT7630E
> quirk for MT_CMB_CTRL register which vendor driver dedicated to this
> chip do.
> 
> This make MT7630E workable with mt76x0e driver and do not cause any
> problems on MT7610U for me.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 52 ++++++++++++++++------
>  .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    | 10 ++---
>  2 files changed, 44 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index 37e1ead1dc85..143cbe6d7899 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -431,21 +431,47 @@ int mt76x0_phy_wait_bbp_ready(struct mt76x02_dev *dev)
>  
>  static void mt76x0_phy_ant_select(struct mt76x02_dev *dev)
>  {
> -	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> -
> -	/* single antenna mode */
> -	if (chan->band == NL80211_BAND_2GHZ) {
> -		mt76_rmw(dev, MT_COEXCFG3,
> -			 BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
> -		mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
> +	u16 ee_ant = mt76x02_eeprom_get(dev, MT_EE_ANTENNA);
> +	u16 nic_conf2 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
> +	u32 wlan, coex3, cmb;
> +	bool ant_div;
> +
> +	wlan = mt76_rr(dev, MT_WLAN_FUN_CTRL);
> +	cmb = mt76_rr(dev, MT_CMB_CTRL);
> +	coex3 = mt76_rr(dev, MT_COEXCFG3);
> +
> +	cmb   &= ~(BIT(15) | BIT(12));

I guess should be BIT(14) here (at least for single antenna mode)

> +	wlan  &= ~(BIT(6) | BIT(5));
> +	coex3 &= ~GENMASK(5, 1);

according to vendor sdk BIT(1) should not cleared if device supports 5GHz band
(signle antenna mode)

Regards,
Lorenzo

> +
> +	if (ee_ant & MT_EE_ANTENNA_DUAL) {
> +		/* dual antenna mode */
> +		ant_div = !(nic_conf2 & MT_EE_NIC_CONF_2_ANT_OPT) &&
> +			  (nic_conf2 & MT_EE_NIC_CONF_2_ANT_DIV);
> +		if (ant_div)
> +			cmb |= BIT(12);
> +		else
> +			coex3 |= BIT(4);
> +		coex3 |= BIT(3);
> +		if (dev->mt76.cap.has_2ghz)
> +			wlan |= BIT(6);
>  	} else {
> -		mt76_rmw(dev, MT_COEXCFG3, BIT(5) | BIT(2),
> -			 BIT(4) | BIT(3));
> -		mt76_clear(dev, MT_WLAN_FUN_CTRL,
> -			   BIT(6) | BIT(5));
> +		/* sigle antenna mode */
> +		if (dev->mt76.cap.has_5ghz) {
> +			coex3 |= BIT(3) | BIT(4);
> +		} else {
> +			wlan |= BIT(6);
> +			coex3 |= BIT(1);
> +		}
>  	}
> -	mt76_clear(dev, MT_CMB_CTRL, BIT(14) | BIT(12));
> +
> +	if (is_mt7630(dev))
> +		cmb |= BIT(14) | BIT(11);
> +
> +	mt76_wr(dev, MT_WLAN_FUN_CTRL, wlan);
> +	mt76_wr(dev, MT_CMB_CTRL, cmb);
>  	mt76_clear(dev, MT_COEXCFG0, BIT(2));
> +	mt76_wr(dev, MT_COEXCFG3, coex3);
>  }
>  
>  static void
> @@ -612,7 +638,6 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
>  	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
>  	mt76x02_phy_set_band(dev, chandef->chan->band,
>  			     ch_group_index & 1);
> -	mt76x0_phy_ant_select(dev);
>  
>  	mt76_rmw(dev, MT_EXT_CCA_CFG,
>  		 (MT_EXT_CCA_CFG_CCA0 |
> @@ -795,6 +820,7 @@ void mt76x0_phy_init(struct mt76x02_dev *dev)
>  {
>  	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibration_work);
>  
> +	mt76x0_phy_ant_select(dev);
>  	mt76x0_phy_rf_init(dev);
>  	mt76x02_phy_set_rxpath(dev);
>  	mt76x02_phy_set_txdac(dev);
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
> index b3ec74835d10..1de041590050 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
> @@ -25,6 +25,7 @@ enum mt76x02_eeprom_field {
>  	MT_EE_VERSION =				0x002,
>  	MT_EE_MAC_ADDR =			0x004,
>  	MT_EE_PCI_ID =				0x00A,
> +	MT_EE_ANTENNA =				0x022,
>  	MT_EE_NIC_CONF_0 =			0x034,
>  	MT_EE_NIC_CONF_1 =			0x036,
>  	MT_EE_COUNTRY_REGION_5GHZ =		0x038,
> @@ -104,6 +105,8 @@ enum mt76x02_eeprom_field {
>  	__MT_EE_MAX
>  };
>  
> +#define MT_EE_ANTENNA_DUAL			BIT(15)
> +
>  #define MT_EE_NIC_CONF_0_RX_PATH		GENMASK(3, 0)
>  #define MT_EE_NIC_CONF_0_TX_PATH		GENMASK(7, 4)
>  #define MT_EE_NIC_CONF_0_PA_TYPE		GENMASK(9, 8)
> @@ -118,12 +121,9 @@ enum mt76x02_eeprom_field {
>  #define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
>  #define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
>  
> -#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
> -#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
> -#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
> +#define MT_EE_NIC_CONF_2_ANT_OPT		BIT(3)
> +#define MT_EE_NIC_CONF_2_ANT_DIV		BIT(4)
>  #define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
> -#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
> -#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
>  
>  #define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END - \
>  						 MT_EE_USAGE_MAP_START + 1)
> -- 
> 1.9.3
> 
