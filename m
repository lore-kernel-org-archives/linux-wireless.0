Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3622C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95AE12089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:39:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95AE12089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbeJCQ0f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:26:35 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39153 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbeJCQ0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:26:35 -0400
Received: by mail-wr1-f48.google.com with SMTP id 61-v6so4592714wrb.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 02:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HFerWzQuqJUnKw3ndIS1+nebX54MvvjYCIIQjiP+6c4=;
        b=GdDWI5QvMbTIFj9pUQQcZ8ZGwYU/bT4eQ63Fs7HEp4Lu5J40Wxs0CvN2mwEZ5efKM9
         n9wqkIp/CBGWWwkfXuL/z+UMevWVqNyHpr8N7wDvWuKZhisZhr9ALf0MhfojdA3KvhSC
         /lLPfyei8OqGsPzc8Gf8iR2qVSI3Jf/ZMQv7hJQYiqYvJwOIzV7KdnApX5l6GI1apQpK
         V34+0oZ/Z3Wwky3c6vYRvNvY8XWwQ27IkpiySczccN0A85F3EKdkiGganX07dvdBa/Oz
         0mrHJkK5yX8rmQKivykT4il7mEB1EO+Nz7Sb/YNRYsGHWfSPYRnVbzqgh1obYZlDpezE
         bJaA==
X-Gm-Message-State: ABuFfogZ0EVp3kLWM5PleNEAvrnPv8D5vep4jiJmvU0ud2mT1mX+58ET
        lPYfgHCCLxoldLbBrw0smp1bcmM+3xM=
X-Google-Smtp-Source: ACcGV63J/l5aMEGX/XAcKdYPoqu9tO7ZiDHZhMR5bUM8bEO0Fk6bKP+myP2hTCOfLUK+v9u6msgdrw==
X-Received: by 2002:adf:fd4a:: with SMTP id h10-v6mr621518wrs.280.1538559537462;
        Wed, 03 Oct 2018 02:38:57 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id u76-v6sm1979526wmd.10.2018.10.03.02.38.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 02:38:56 -0700 (PDT)
Date:   Wed, 3 Oct 2018 11:38:54 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mt76: make frag_cache global per cpu structure
Message-ID: <20181003093853.GC27279@localhost.localdomain>
References: <1538558230-16576-1-git-send-email-sgruszka@redhat.com>
 <1538558230-16576-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538558230-16576-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> +static DEFINE_PER_CPU(struct page_frag_cache, mt76_frag_cache);
> +
> +void *mt76_alloc_frag(unsigned int fragsz)
> +{
> +	struct page_frag_cache *fc;
> +	unsigned long flags;
> +	void *data;
> +
> +	local_irq_save(flags);

I like this approach since we will avoid a cache miss for the spinlock :)
Do we still need to disable local_irq here since (not considering fw upload)
I guess there is no contention for mt76_frag_cache

Regards,
Lorenzo

> +	fc = this_cpu_ptr(&mt76_frag_cache);
> +	data = page_frag_alloc(fc, fragsz, GFP_ATOMIC);
> +	local_irq_restore(flags);
> +	return data;
> +}
> +EXPORT_SYMBOL_GPL(mt76_alloc_frag);
> +
>  MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
> index 018d475504a2..6cb6c0e993c4 100644
> --- a/drivers/net/wireless/mediatek/mt76/util.h
> +++ b/drivers/net/wireless/mediatek/mt76/util.h
> @@ -41,4 +41,5 @@ mt76_skb_set_moredata(struct sk_buff *skb, bool enable)
>  		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
>  }
>  
> +void *mt76_alloc_frag(unsigned int fragsz);
>  #endif
> -- 
> 2.7.5
> 
