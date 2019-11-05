Return-Path: <SRS0=b/BL=Y5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD27C5DF60
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Nov 2019 15:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D578217F5
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Nov 2019 15:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389868AbfKEPvk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:51:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38404 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389760AbfKEPvk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Nov 2019 10:51:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iS17K-0002CI-Qb; Tue, 05 Nov 2019 16:51:38 +0100
Message-ID: <0690b548e233fba3758df0ce1eeca1c0803a62c4.camel@sipsolutions.net>
Subject: Re: [PATCH] net/fq_impl: Switch to kvmalloc() for memory allocation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
Date:   Tue, 05 Nov 2019 16:51:37 +0100
In-Reply-To: <20191105154951.546285-1-toke@redhat.com>
References: <20191105154951.546285-1-toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-11-05 at 16:49 +0100, Toke Høiland-Jørgensen wrote:
> The FQ implementation used by mac80211 allocates memory using kmalloc(),
> which can fail; and Johannes reported that this actually happens in
> practice.
> 
> To avoid this, switch the allocation to kvmalloc() instead; this also
> brings fq_impl in line with all the FQ qdiscs.
> 
> Fixes: 557fc4a09803 ("fq: add fair queuing framework")
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/net/fq_impl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/fq_impl.h b/include/net/fq_impl.h
> index 107c0d700ed6..d3873db91c71 100644
> --- a/include/net/fq_impl.h
> +++ b/include/net/fq_impl.h
> @@ -313,7 +313,7 @@ static int fq_init(struct fq *fq, int flows_cnt)
>  	fq->limit = 8192;
>  	fq->memory_limit = 16 << 20; /* 16 MBytes */
>  
> -	fq->flows = kcalloc(fq->flows_cnt, sizeof(fq->flows[0]), GFP_KERNEL);
> +	fq->flows = kvcalloc(fq->flows_cnt, sizeof(fq->flows[0]), GFP_KERNEL);

You need a corresponding kvfree(), no?

johannes

