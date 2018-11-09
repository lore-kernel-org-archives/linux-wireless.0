Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725C1C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465B220827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 465B220827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbeKIUuE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:50:04 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39080 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeKIUuE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:50:04 -0500
Received: by mail-wr1-f68.google.com with SMTP id b13so1439825wrx.6
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 03:09:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cVgjsHQnx51SPtK/AxFCle1/pyM/xz58i/ZRdGbQaf4=;
        b=ITnba/pBGZi1WN6nK/VC+nsgFwM4CNwegVpccMkOQ2zL/+TPIkwAInF/FPt1V+Bxrs
         x/oJxzYwpNOFaKGKv393lXuHABT3N4GxwwXZaCaIAh8Lg6XE2SiRh7cpO4Ap3QDTBh8R
         2LaOHo6BGQaH+uChQ/FH0s9D02xlNpRCn01ivkesw5fMw5DhUZK+i1NI7bKJTKDWvu0/
         bYXachR4gQoiTq22suA6ZFx40JJXl8sITykr13w5TUNG0cBcAAWMQQznBbw4XVvXz+8w
         rhy+KUZdTzSpsVxFMbZZxKmx0Kh4BLvQUjjebyrpWjy2rv68EC/s8LWinBD6rpbXG6hP
         Xozw==
X-Gm-Message-State: AGRZ1gJipZSMuq7LQcEmpT9dFUuR0Y8kV/WM85NUJYQpimSBkFOJkTMv
        7AkBnGm2jOt/k/+a6DujPKcdDg==
X-Google-Smtp-Source: AJdET5eV957aeOql3An/+XpBmWWPAyA7S9IC4FEtJjkPtEdxaEqecfv6wqOIussHWJsOJ06gvqpdcw==
X-Received: by 2002:adf:e6c4:: with SMTP id y4-v6mr7489535wrm.101.1541761795021;
        Fri, 09 Nov 2018 03:09:55 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y21-v6sm1011120wma.36.2018.11.09.03.09.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 03:09:54 -0800 (PST)
Date:   Fri, 9 Nov 2018 12:09:50 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] mt76x02: correct set bssid for STA
Message-ID: <20181109110949.GD4174@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541758814-2046-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use MT_MAC_APC_BSSID0_H_EN bit to indicatate we are
> setting BSSID for STA.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index 59b336e34cb5..cfeae5586897 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -826,10 +826,16 @@ void mt76x02_mac_work(struct work_struct *work)
>  
>  void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
>  {
> +	u32 bssid_h = FIELD_PREP(MT_MAC_APC_BSSID_H_ADDR,
> +				 get_unaligned_le16(addr + 4));
> +	u32 bssid_l = get_unaligned_le32(addr);
> +
> +	if (idx > 7)
> +		bssid_h |= MT_MAC_APC_BSSID0_H_EN;

This bit is to enable APClient mode and it is valid just for register 0x1094
(MT_MAC_APC_BSSID_{L,h}(0)). Moreover IIRC APClient has been disabled because
it causes a performance degradation.

> +
>  	idx &= 7;
> -	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), get_unaligned_le32(addr));
> -	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
> -		       get_unaligned_le16(addr + 4));
> +	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), bssid_l);
> +	mt76_wr(dev, MT_MAC_APC_BSSID_H(idx), bssid_h);
>  }
>  
>  static int
> -- 
> 1.9.3
> 
