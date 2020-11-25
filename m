Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E16DC63777
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Nov 2020 20:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA3C207BB
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Nov 2020 20:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/ziLLWQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgKYUnQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Nov 2020 15:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgKYUnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Nov 2020 15:43:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D07E1206F9;
        Wed, 25 Nov 2020 20:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606336995;
        bh=19NyyXgzTkJppECGsDPkjrBwfFr4gigQN43AMQEHkwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t/ziLLWQZO4jn6MUI5afmp+MWnpyeMeZ8FMU0LGxlgXRswHLR18PwO9/aG/+wS/dY
         DyulRRr4DagfIKuhMiMQirzHe+3BmEPn25yt+7fpD6evotDAisJr7dL+q6jiDAvGR9
         tmvy2k0TsCMNusTCXRjUNpz93c1gUcgRnbM1Tz9A=
Date:   Wed, 25 Nov 2020 12:43:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marco Elver <elver@google.com>
Cc:     davem@davemloft.net, johannes@sipsolutions.net, a.nogikh@gmail.com,
        andreyknvl@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, idosch@idosch.org, fw@strlen.de,
        willemb@google.com
Subject: Re: [PATCH net-next] net: switch to storing KCOV handle directly in
 sk_buff
Message-ID: <20201125124313.593fc2b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125173436.1894624-1-elver@google.com>
References: <20201125173436.1894624-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 25 Nov 2020 18:34:36 +0100 Marco Elver wrote:
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ffe3dcc0ebea..070b1077d976 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -233,6 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  	skb->end = skb->tail + size;
>  	skb->mac_header = (typeof(skb->mac_header))~0U;
>  	skb->transport_header = (typeof(skb->transport_header))~0U;
> +	skb_set_kcov_handle(skb, kcov_common_handle());
>  
>  	/* make sure we initialize shinfo sequentially */
>  	shinfo = skb_shinfo(skb);
> @@ -249,9 +250,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  
>  		fclones->skb2.fclone = SKB_FCLONE_CLONE;
>  	}
> -
> -	skb_set_kcov_handle(skb, kcov_common_handle());

Why the move?

>  out:
>  	return skb;
>  nodata:
> @@ -285,8 +283,6 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
>  	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
>  	atomic_set(&shinfo->dataref, 1);
>  
> -	skb_set_kcov_handle(skb, kcov_common_handle());
> -
>  	return skb;
>  }

And why are we dropping this?

If this was omitted in earlier versions it's just a independent bug, 
I don't think build_skb() will call __alloc_skb(), so we need a to
set the handle here.
