Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C253C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D7B20851
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389975AbfBROZe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:25:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32809 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730325AbfBROZd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 09:25:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id h22so12254056wmb.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2019 06:25:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wJmiiDXrXKl7TWvXYWRH6np07CPxQRRsx/r5C7eEbas=;
        b=K34d/XG+BmrTiU0dZ3AQ8jzjUWFyrCBmPfzhaeBNZfoH2Us4J9Ect5pX5JAPD6XegN
         6lhOVQf4ODwjKCRdoIZCb+7eyMLrhf7d3nS+Sh56hoWvzxziWQAZDu3my8hiQDpENbym
         JjyBCMpOSQ+SMNE+wvsgGE3oRNT+Su0/ei+DYyTjOWgB4NVrTUwxbkDJUwuAp5CHZhQf
         xasdy+5YGsD460NsDvwUVMjmaVaj9qc6iFnOjVNNSxEPzm73XvhR+j+WgKFfJgi6ua/e
         mzOZvH81h561Qs/y8fLhzDPEqZUXZuB5NlTUy1GQJeo+PNydHsEndf5hfwpRgvvR7e9m
         HTew==
X-Gm-Message-State: AHQUAuZXGxn9RYznpmNe17ndiPuZqpNPvOqOoZcLwfNsgd+K9HDoRAGG
        VDCXENuIqbyeap1LtrAqBFwNNA==
X-Google-Smtp-Source: AHgI3Ia1ji1GtY+sbU+9Ipq0Qb225b7ge9LworkwdLTBmVk+A+BTVjhFaOERpXQggXT69n4hWtOZxg==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr4512878wml.57.1550499931562;
        Mon, 18 Feb 2019 06:25:31 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o64sm15105963wmo.47.2019.02.18.06.25.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 Feb 2019 06:25:30 -0800 (PST)
Date:   Mon, 18 Feb 2019 15:25:28 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190218142527.GA9283@localhost.localdomain>
References: <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218135247.GA9602@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> commit 0d9813319b40399a0d8fd761d2fcfedee5701487
> Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Date:   Fri Sep 7 23:13:12 2018 +0200

[...]

> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 062614ad0d51..08425b1d2c30 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -550,21 +550,33 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
>  
> -int mt76x02_insert_hdr_pad(struct sk_buff *skb)
> +void mt76x02_align_skb(struct sk_buff *skb)
>  {
> -	int len = ieee80211_get_hdrlen_from_skb(skb);
> +	int align = ((unsigned long) skb->data) & 3;
> +	int hdrlen, skblen;
>  
> -	if (len % 4 == 0)
> -		return 0;
> +	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
> +	WARN_ON_ONCE(align == 0 && (hdrlen & 3));
> +
> +	if (align == 0)
> +		return;

Hi Stanislaw,

is it possible that skb->data is 4 byte aligned but hdrlen is not? (e.g 4addr
data frames, not qos)?

>  
> -	skb_push(skb, 2);
> -	memmove(skb->data, skb->data + 2, len);
> +	if (hdrlen & 3) {
> +		/* Align frame and add 2 bytes pad after header. */
> +		skb_push(skb, 2);
> +		memmove(skb->data, skb->data + 2, hdrlen);
>  
> -	skb->data[len] = 0;
> -	skb->data[len + 1] = 0;
> -	return 2;
> +		skb->data[hdrlen] = 0;
> +		skb->data[hdrlen + 1] = 0;
> +	} else {
> +		/* Only for probe request frames. */

are you sure this is true *only* for probe requests?
this could hit performances and it is used even in pci code

Regards,
Lorenzo

> +		skblen = skb->len;
> +		skb_push(skb, 2);
> +		memmove(skb->data, skb->data + 2, skblen);
> +		skb_trim(skb, skblen);
> +	}
>  }
> -EXPORT_SYMBOL_GPL(mt76x02_insert_hdr_pad);
> +EXPORT_SYMBOL_GPL(mt76x02_align_skb);
>  
>  void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
>  {
> -- 
> 2.7.5
> 

