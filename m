Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024CFC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE9EA2086A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 10:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfBTKbm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:31:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40482 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfBTKbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 05:31:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id q1so25334891wrp.7
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2019 02:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0UWLE5Xga0v6Pfkkx3AvgziId/cfX7dN7ySIMoeeoD4=;
        b=YfunUt4pDYAL7YZnVNY1L67g8OXKbIGtkBhLxaM9nVW5PCKI98peYnyQDsf5jA5fTK
         ya/JXXDzsYVpTmbhe7UwadNFSisFzuhzaTbkYbcmnYJhv1Ig6NvLU1nJvidvJT/K0ErC
         agCI8V5HJwQG4WWIXeJupGx422ztlwyKo7/tyFf/rw/kpF+sl0hKlFyQ/q3r+JUEpBoS
         QWQbEnPjGaeDcQDEl1s9FyVFcNrmLAlA22R5ZxPu9hoN7IiIi4m+OvJSxUDhKpQ5/2Un
         Z8LnXrZQOLuFjAaR1xKWgsxK3JJBHt4siDQXR0EcjfcFJTtnPSpWPK/lei/tH5MOIjbB
         wFVQ==
X-Gm-Message-State: AHQUAuZunXiOEh416eEu8v/AR8Umh+whyKwOXJJNsww343L5YsDvG/hT
        hjqW+KAbLFrwrJVedpbebvpgBg==
X-Google-Smtp-Source: AHgI3IZB1eSZEwmZ+cuH0AtIVO54ms8vEINcvrVmF1PdWyG/bHQnjyF+uyFFPYCvrotvu7ZJ4DMY+Q==
X-Received: by 2002:a05:6000:1c2:: with SMTP id t2mr13314252wrx.109.1550658700107;
        Wed, 20 Feb 2019 02:31:40 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o8sm6593087wma.1.2019.02.20.02.31.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Feb 2019 02:31:39 -0800 (PST)
Date:   Wed, 20 Feb 2019 11:31:37 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mt76usb: allow mt76u_bulk_msg be used for reads
Message-ID: <20190220103136.GB2626@localhost.localdomain>
References: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550657565-7263-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Extend mt76u_bulk_msg() such it can be used for synchronous bulk reads.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h            | 13 ++++++++++---
>  drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c |  4 ++--
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 

[...]

> @@ -737,8 +738,14 @@ mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
>  	unsigned int pipe;
>  	int sent;
>  
> -	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
> -	return usb_bulk_msg(udev, pipe, data, len, &sent, timeout);
> +	if (actual_len) {
> +		pipe = usb_rcvbulkpipe(udev, usb->in_ep[MT_EP_IN_CMD_RESP]);
> +	} else {
> +		actual_len = &sent;
> +		pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);

Hi Stanislaw,

I guess you can drop sent here since even if actual_len is NULL it will be managed
by usb_start_wait_urb()

Regards,
Lorenzo

> +	}
> +
> +	return usb_bulk_msg(udev, pipe, data, len, actual_len, timeout);
>  }
>  
>  int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> index e469e383cb88..f497c8e4332a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
> @@ -126,7 +126,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
>  	if (ret)
>  		return ret;
>  
> -	ret = mt76u_bulk_msg(dev, skb->data, skb->len, 500);
> +	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500);
>  	if (ret)
>  		return ret;
>  
> @@ -271,7 +271,7 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, u8 *data,
>  
>  	data_len = MT_CMD_HDR_LEN + len + sizeof(info);
>  
> -	err = mt76u_bulk_msg(&dev->mt76, data, data_len, 1000);
> +	err = mt76u_bulk_msg(&dev->mt76, data, data_len, NULL, 1000);
>  	if (err) {
>  		dev_err(dev->mt76.dev, "firmware upload failed: %d\n", err);
>  		return err;
> -- 
> 2.7.5
> 
