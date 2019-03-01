Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2C9C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CFDB2085A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfCAJ66 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:58:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbfCAJ66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 04:58:58 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 75BDB3147B3C;
        Fri,  1 Mar 2019 09:58:57 +0000 (UTC)
Received: from localhost (unknown [10.40.206.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C8B55D707;
        Fri,  1 Mar 2019 09:58:54 +0000 (UTC)
Date:   Fri, 1 Mar 2019 10:58:53 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC 2/2] mt76: introduce mt76_hw_queue data structure
Message-ID: <20190301095852.GA31324@redhat.com>
References: <cover.1551431791.git.lorenzo@kernel.org>
 <e42f2de79766a2bd507d66ea2dabb0e79a684450.1551431791.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e42f2de79766a2bd507d66ea2dabb0e79a684450.1551431791.git.lorenzo@kernel.org>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 01 Mar 2019 09:58:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 01, 2019 at 10:22:04AM +0100, Lorenzo Bianconi wrote:
> -struct mt76_queue {
> +struct mt76_hw_queue {
>  
>  	u16 first;
>  	u16 head;
>  	u16 tail;
> -	int ndesc;
> -	int queued;
> -	int buf_size;
>  
> +	dma_addr_t desc_dma;
> +
> +	int buf_size;
>  	u8 buf_offset;
> +
>  	u8 hw_idx;
>  
> -	dma_addr_t desc_dma;
> -	struct sk_buff *rx_head;
>  	struct page_frag_cache rx_page;
>  	spinlock_t rx_page_lock;
> +	struct sk_buff *rx_head;
> +};
> +
> +struct mt76_queue {
> +	struct mt76_hw_queue *hwq;
> +
> +	struct list_head swq;
> +	int swq_queued;
>  };

I don't think massive renaming is necessary. It makes patch more complex
and eventual future backporting of fixes harder. Simpler approach would
be doing:

struct mt76_sw_queue {
	struct mt76_queue *q;

	struct list_head swq;
	int swq_queued;
}

what should achieve the same goal without massive changes in the code.

Stanislaw
