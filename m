Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2095DC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA2F220840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:29:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA2F220840
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbeKITJl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:09:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53888 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbeKITJl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 14:09:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id f10-v6so1325786wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 01:29:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L8AYgvUWj9Ukkg2GVuswIyoL/8rS++xAM4+KqvN5/hg=;
        b=POUFM4eYo3o8j/cbQmtHmJq4zNbbzjx0o+biq1NSxo6BoxPiVjYrwciJM3pBbdvwjk
         95q0f88VgQKjljXy6uGl6fGj8pXEL7+zAAeLMJ0edG0rmqM0hLTOFh31Edhqiz1MR+x9
         oJ5cSAvW2ALR/HQ5/X9CGWDXYUwYBtUKQ5KgC+KLlYji4xF5v51SyNSkmYIH9icEfHW0
         Ie48/FmLs/iRwkbpUcyo6WaloBuFBG+qAp82cq6GuQlw7tdh5dlwmqbqNbAJAOk0Wwz7
         6+xWNI2ohjgj0BW21lxF2H4jEr0aeniWwhxnlL08k9s3+kEOp+Z4bhtkxJT3K9gSok5u
         FUTQ==
X-Gm-Message-State: AGRZ1gL7fWbz1X4nE8iYwwD3x27W87jEFLm442i0OkRTJygfbGXtCKJX
        RWuJiCPYnuTQoBPMaDnaGQlP2Q==
X-Google-Smtp-Source: AJdET5ef9Ln04AR5GdMunWi0d079727uo2YvAB1uQ7pZSZ6FDeXGEt5aQKPxQAI5sC9FFpkgw4Z3Ug==
X-Received: by 2002:a1c:ee8d:: with SMTP id j13-v6mr4070965wmi.125.1541755796201;
        Fri, 09 Nov 2018 01:29:56 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a18-v6sm7657000wrt.79.2018.11.09.01.29.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 01:29:55 -0800 (PST)
Date:   Fri, 9 Nov 2018 10:29:51 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 4/4] mt76x02: set protection according to ht
 capabilities
Message-ID: <20181109092951.GC4174@localhost.localdomain>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541688430-31855-5-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use information about protection that mac80211 provide to us.
> Used protection should be part of ht capabilites that either
> remote AP provde to us in STA mode or is set in hostapd.conf
> in ht_capab option.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 58 +++++++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  4 ++
>  3 files changed, 64 insertions(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index 567a7ab47fab..6096efc4119b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -753,6 +753,64 @@ void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val)
>  		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
>  }
>  
> +void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
> +				   int ht_mode)
> +{
> +	int mode = ht_mode & IEEE80211_HT_OP_MODE_PROTECTION;
> +	bool non_gf = !!(ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
> +	u32 prot[6];
> +	bool ht_rts[4] = {};
> +	int i;
> +
> +	for (i = 0; i < 6; i++) {

maybe better ARRAY_SIZE() here?

> +		prot[i] = mt76_rr(dev, MT_CCK_PROT_CFG + i * 4);
> +		if (i >= 2)
> +			prot[i] &= ~(MT_PROT_CFG_CTRL | MT_PROT_CFG_RATE);
> +	}
> +
> +	if (legacy_prot) {
> +		prot[1] &= ~MT_PROT_CFG_CTRL;
> +		prot[1] |= MT_PROT_CTRL_CTS2SELF;
> +
> +		prot[2] |= MT_PROT_RATE_CCK_11;
> +		prot[3] |= MT_PROT_RATE_CCK_11;
> +		prot[4] |= MT_PROT_RATE_CCK_11;
> +		prot[5] |= MT_PROT_RATE_CCK_11;
> +	} else {
> +		prot[2] |= MT_PROT_RATE_OFDM_24;
> +		prot[3] |= MT_PROT_RATE_DUP_OFDM_24;
> +		prot[4] |= MT_PROT_RATE_OFDM_24;
> +		prot[5] |= MT_PROT_RATE_DUP_OFDM_24;
> +	}
> +
> +	switch (mode) {
> +	case IEEE80211_HT_OP_MODE_PROTECTION_NONE:

I think you can cover it with 'default' case

> +		break;
> +
> +	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
> +		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
> +		break;
> +
> +	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
> +		ht_rts[1] = ht_rts[3] = true;
> +		break;
> +
> +	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
> +		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
> +		break;

this code is duplicated of 'IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER'.
maybe better to have:

	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
		break;

> +	}
> +
> +	if (non_gf)
> +		ht_rts[2] = ht_rts[3] = true;
> +
> +	for (i = 0; i < 4; i++)

ARRAY_SIZE() here?

> +		if (ht_rts[i])
> +			prot[i + 2] |= MT_PROT_CTRL_RTS_CTS;
> +
> +	for (i = 0; i < 6; i++)

ARRAY_SIZE() here?

> +		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
> +}
> +
>  void mt76x02_update_channel(struct mt76_dev *mdev)
>  {
>  	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
> index 34da8c600db8..9035397ae081 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
> @@ -197,6 +197,8 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
>  			    struct mt76x02_tx_status *stat, u8 *update);
>  int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
>  			   void *rxi);
> +void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
> +				   int ht_mode);
>  void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val);
>  void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
>  void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index fda67b0923a6..51db4d3dcc13 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -682,6 +682,10 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
>  		tasklet_enable(&dev->pre_tbtt_tasklet);
>  	}
>  
> +	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
> +		mt76x02_mac_set_tx_protection(dev, info->use_cts_prot,
> +					      info->ht_operation_mode);
> +
>  	if (changed & BSS_CHANGED_BASIC_RATES &&
>  	    vif->type == NL80211_IFTYPE_STATION) {
>  		mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
> -- 
> 1.9.3
> 
