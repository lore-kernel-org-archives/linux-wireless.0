Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0D4C2D0E4
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Nov 2020 09:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135452073C
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Nov 2020 09:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kiCSZDEg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbgKXJmN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Nov 2020 04:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731433AbgKXJmM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Nov 2020 04:42:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584DBC0613D6;
        Tue, 24 Nov 2020 01:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7Z4sCBK7+r3zxiDTPSYcv0Xe629cAkXNqDnpxaka9BI=; b=kiCSZDEgg3lnkgExk/osaqCd9M
        ULK/cxluf5kC4iJST/I3Ul0DnxDBfU3QAGlbeA8q7avb0PHFcWZVVhSW3iqtM6ihK5yNIA7IOk5Hk
        DnQZovtZqURQZbw/kpyVF4AxKFpUoBiLJmz7vfxKVTU0dNlPQWNHSDK0UrnwqBTD7Ik2FHtzQ7m2X
        5N/DIPf9z5ygV9AjUpu+3q+8L2YNu8GP8qMJ8LqQGi+XyG1UeUtqvNWUHjOsqvTSm1ATTc2mQHvLG
        /OcZGPX86MAHIASoVJVwPqBaOpT/YmN34xAqUeLKmYFOrnh7Rv1E4hV47ZlVS0oUt/eXqBYssoin9
        lpso3lNg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khUpt-0000OQ-6d; Tue, 24 Nov 2020 09:42:09 +0000
Date:   Tue, 24 Nov 2020 09:42:09 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 4/9] relay: allow the use of const callback structs
Message-ID: <20201124094209.GD31963@infradead.org>
References: <cover.1606153547.git.jani.nikula@intel.com>
 <cc3ff292e4eb4fdc56bee3d690c7b8e39209cd37.1606153547.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc3ff292e4eb4fdc56bee3d690c7b8e39209cd37.1606153547.git.jani.nikula@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> +/* subbuf_start callback wrapper */
> +static int cb_subbuf_start(struct rchan_buf *buf, void *subbuf,
> +			   void *prev_subbuf, size_t prev_padding)

I don't think the comment adds any information over just looking at the
function and the two callers.  I'd also name it relay_subbuf_start
instead of the cb_ prefix not used anywhere else in the file.


>  {
> +	if (buf->chan->cb->subbuf_start)
> +		return buf->chan->cb->subbuf_start(buf, subbuf,
> +						   prev_subbuf, prev_padding);
> +
>  	if (relay_buf_full(buf))
>  		return 0;

This could also be simplified a bit more to:

	if (!buf->chan->cb->subbuf_start)
		return !relay_buf_full(buf);
	return buf->chan->cb->subbuf_start(buf, subbuf, prev_subbuf,
					   prev_padding);

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
