Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D958BC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E172098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98E172098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbeJCP7l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 11:59:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44351 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbeJCP7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 11:59:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id 63-v6so5220725wra.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 02:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QLK3iN1ry/IiJCVa41drOZfvh30cqIjxnmRhY2HRung=;
        b=hr8UwWmobNsYWyqvbdoAc2OT7miTV5FgiMAjgXdfIIbW4PCc1d8O9K/2XbJ+vqcgX4
         ArqD567LEhFzf7ELbow6MH4EXw9IbYy4rfxxM7ujosdqwQcggBuqmHfv9GsgR6zKZ3l+
         vw8gGSIn7JF3hg6Lzu6URiFa8QMfaL6tDClXfWCimmvLgicqZzhsKIOV01t/FPyVfjry
         JGHQb7G+CTVQnNnzHCNNDG5i0TBcxJFz/QpXlpYiiEWExZXsJMuOPcGCk009fTY8fHpD
         N3x9axDnkiQTQ1G5H+Ul/p4vzXgCfNhsg3sR9s+hcKQ/PHWG9Ej+3K1HdOhbdvS5Te57
         odhA==
X-Gm-Message-State: ABuFfoj1oF8/iK26pDfFFe3YgQEWcI87NvUlq65NGv1Kj9brmQjYla16
        vdPAp4pE+yVYFNtwSpfbhZomWg==
X-Google-Smtp-Source: ACcGV63UT/d+TV1lCeP/E1MQtQG1LrHjrDMPZOs6slkabGjBY6e3D6tT3bN9kKnsv/hHeSVxyue9LQ==
X-Received: by 2002:adf:f0d2:: with SMTP id x18-v6mr530689wro.287.1538557930056;
        Wed, 03 Oct 2018 02:12:10 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y203-v6sm1492506wmd.1.2018.10.03.02.12.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 02:12:09 -0700 (PDT)
Date:   Wed, 3 Oct 2018 11:12:07 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: fix frag length allocation for usb
Message-ID: <20181003091206.GA27279@localhost.localdomain>
References: <1538554631-5168-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538554631-5168-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> This is correct fix for c12128ce44b0 ("mt76: use a per rx queue page
> fragment cache"). We use wrong length when we allocate segments for
> MCU transmissions, which require bigger segment size than e->buf_size.
> 
> Commit 481bb0432414 ("mt76: usb: make rx page_frag_cache access atomic")
> partially solved the problem or actually mask it by changing
> mt76u_mcu_init_rx() and mt76u_alloc_queues() sequence, so e->buf_size
> become non zero any longer, but still not big enough to handle MCU data.

Hi Stanislaw,

I agree that we should use len in page_frag_alloc() instead of q->buf_size, so

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

but reviewing the code I guess the real issue is not q->buf_size (since it should
be bigger than MCU_RESP_URB_SIZE) but it is the sequence of calls in
mt76x0u_register_device() since mt76u_alloc_queues need to be called before
mt76u_mcu_init_rx()

Regards,
Lorenzo

> 
> Patch fixes memory corruption which can manifest itself as random,
> not easy to reproduce crashes, during mt76 driver load or unload.
> 
> Fixes: c12128ce44b0 ("mt76: use a per rx queue page fragment cache")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index de7785c4f6af..6b643ea701e3 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -286,7 +286,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
>  		void *data;
>  		int offset;
>  
> -		data = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
> +		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
>  		if (!data)
>  			break;
>  
> -- 
> 2.7.5
> 
