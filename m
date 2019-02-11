Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1423C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 863FD2082F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfBKJrP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:47:15 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51871 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKJrP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:47:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so16411214wmj.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 01:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NjQffYfwqXAAXDWvUUZYm7OxJR3TKi0I1dmjUrCSfig=;
        b=sDzmTCrFoyQqAvXmsWTDfaGmWPKFIetEr2FgsHtFiElPCvFdKGhMLUjw7LCxtYK018
         +t/HzEpn9WX4kn8lbO38XEKdsn1n2nSEj7BgbRIQnfYO1OftlZqaT73bd5EE4aPZJESQ
         pGzcHS0O8Wbp8s+lJ9GKCMz6Dr53ekRdJL04UoHpEA0OJSNOnP8Eu0QLHzI/tT0YU836
         7TgAe7pkVRF0v9BuD5tL8c4KiQ8UfAZlZR0FtrNdyZVjEsTNjrg3sNTrppxPVCG7MCW7
         S0fVnOlfX+wMisWxtIzPy0vykjPt0ZbFMc4b3gpYJwlfi5nK0RIrYmxpsc+EtC28Qiv8
         NTwg==
X-Gm-Message-State: AHQUAuYlix+BNCy5g06mm8zZciHLrZH62/vlWwC4pWB1Ond6Oi40GuEz
        woEY6Hda3gIj955D/7pE0dDlhw==
X-Google-Smtp-Source: AHgI3IaEQfspyF7J4BKmTbt/IF29JqYoxmdIAX7vNdZxF5zJC31FUhDBcGoqy3NH9L8ZGOkTooalYg==
X-Received: by 2002:adf:b68a:: with SMTP id j10mr13432959wre.224.1549878432983;
        Mon, 11 Feb 2019 01:47:12 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l6sm7054881wrv.70.2019.02.11.01.47.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 01:47:12 -0800 (PST)
Date:   Mon, 11 Feb 2019 10:47:10 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mt76x02u: correct pad for fragments
Message-ID: <20190211094708.GA3467@localhost.localdomain>
References: <1549874264-7661-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549874264-7661-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Modifying skb->len & data_len doesn't look correct. Issue is not critical
> we just pad 2 times, except first padding is not filled with zeros.
> 
> However I'm not sure if we should not add pad to all skb's in frags
> list.

Hi Stanislaw,

IIRC the first packet of a A-MSDU burst keeps track of the burst length 
so if we add the a pad to last one we need to update the skb->len/data_len
of the first one. No need to pad all skbs in the frag list, just last one

Regards,
Lorenzo

> Additionally remove unlikely(pad) condition, we always pad for at least
> four bytes what is needed by HW.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  .../wireless/mediatek/mt76/mt76x02_usb_core.c | 22 +++++++------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> index dc2226c722dd..c7ca2d93720a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> @@ -49,21 +49,15 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
>  	       FIELD_PREP(MT_TXD_INFO_DPORT, port) | flags;
>  	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
>  
> -	pad = round_up(skb->len, 4) + 4 - skb->len;
> -	skb_walk_frags(skb, iter) {
> +	skb_walk_frags(skb, iter)
>  		last = iter;
> -		if (!iter->next) {
> -			skb->data_len += pad;
> -			skb->len += pad;
> -			break;
> -		}
> -	}
> -
> -	if (unlikely(pad)) {
> -		if (skb_pad(last, pad))
> -			return -ENOMEM;
> -		__skb_put(last, pad);
> -	}
> +
> +	/* Add zero pad of 4 - 7 bytes at the end of buffer */
> +	pad = round_up(skb->len, 4) + 4 - skb->len;
> +	if (skb_pad(last, pad))
> +		return -ENOMEM;
> +	__skb_put(last, pad);
> +
>  	return 0;
>  }
>  
> -- 
> 2.19.2
> 
