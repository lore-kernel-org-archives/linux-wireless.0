Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48ED3C6FD18
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Apr 2023 11:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjDSLX4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Apr 2023 07:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbjDSLXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2023 07:23:48 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9471D7A88
        for <linux-wireless@vger.kernel.org>; Wed, 19 Apr 2023 04:23:22 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f178da21b5so10597215e9.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Apr 2023 04:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681903400; x=1684495400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MJaD7fXEAvYuTbSM75xX8Hr2S7PXb+gmhtMbcdPKD34=;
        b=LT0hnR4L4vk2hcE2A0PvFmn2eTY7c/x6jjdyIxU4tcHg2ayO6ayOmKDS7i1HG7gLQT
         wsTa19J64Dda7rQjD8PLaOHsMCzPyzGuxWHit0ZZBg5wW+2agfnXhK6dM44M9q16HvkY
         Vsf80BldIY+MVuqr4+aESTxS62XNJotKUud1W9KPO1nQu/N6imT9qF5IHP1BhMTbjgTC
         bN88ZFLadbPZoBgI6LOJpqBUGjAXprPeHOqRoCoB9K/ptstjdIxbl+NUKQznSX4qv2bm
         6zSwxYybSWpLZUQhrkKjoePKhxQu43OUrHWpKSt/8MN0rbYKZj8MQpendyJt5XuZ3VrW
         AnAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681903400; x=1684495400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJaD7fXEAvYuTbSM75xX8Hr2S7PXb+gmhtMbcdPKD34=;
        b=B2aobiVNwIn3Pac1oTKrwPVO47Lx1OldvbUW4qWePcNkdWRfCNFC0m6XDdiqpXgYCS
         vZ3HlrSjaAVy/heroroBB+QpFBqhYkWpIfrW8wBaci8dJf7qZKEAh/gQ/joUaTzcpJ42
         QcI6blUxoVVLXhNx/ZTnldrGlA3ba6Gq04pPzE8ou/r87VPl0tF7pETdAR7KfocqNUxn
         pgSdA+nYP4sjaE7gxn3Y4k7unN3H+uaMJuaCAZSEetNbuMzSebsjdSRj6Zc3Jn7Llj9v
         misLh/BKkT0t64ypea2gr75iYai/gVpIRWkbf2RIAk6aiKzhRNCgiCOGiR7s7gxgbIpt
         j2UA==
X-Gm-Message-State: AAQBX9f6Mk9vWUT7ZM+FSu4P1UE+wd3n5sNr46vBo30MRTOfAyha6qCQ
        2+eHYfdTpOlke4r7qcxKTPVkHQ==
X-Google-Smtp-Source: AKy350ZhBsf72Zmu68VQgDH9ExnPMMR1SIAr7YW5IrJftrf6cCb+wwm/BHYD5Wsku/qg1zDpSbVQFQ==
X-Received: by 2002:adf:f745:0:b0:2f7:6d72:561f with SMTP id z5-20020adff745000000b002f76d72561fmr4372733wrp.48.1681903400338;
        Wed, 19 Apr 2023 04:23:20 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f12-20020adffccc000000b002d45575643esm15484506wrs.43.2023.04.19.04.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 04:23:19 -0700 (PDT)
Date:   Wed, 19 Apr 2023 14:23:16 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     yingsha xu <ysxu@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Benc <jbenc@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        hust-os-kernel-patches@googlegroups.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mac80211: use IS_ERR to check return value
Message-ID: <85ce5bf1-810d-4a7b-a465-e25aa34f719b@kili.mountain>
References: <20230416083028.14044-1-ysxu@hust.edu.cn>
 <f23c038b2b586a45a8b3c757495d5bb51ee4ac7e.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23c038b2b586a45a8b3c757495d5bb51ee4ac7e.camel@sipsolutions.net>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 18, 2023 at 10:36:14AM +0200, Johannes Berg wrote:
> On Sun, 2023-04-16 at 16:30 +0800, yingsha xu wrote:
> > According to the annotation of function debugfs_create_fs, if
> > an error occurs, ERR_PTR(-ERROR) will be returned instead of
> > a null pointer or zero value.
> > 
> > Fix it by using IS_ERR().
> 
> I don't this this is right, or fixed anything ...
> 
> If debugfs indeed returned an ERR_PTR() value, then the later debugfs
> adds will do nothing.
> 
> Since it doesn't look like debugfs_create_dir() can actually return NULL
> these days (not sure it ever could), I guess we can even remove the
> check.
> 

Correct.  They have a patch ready which deletes the check and the
comment.  Someone should have replied to this thread to NAK their own
patch so that you didn't bother reviewing it.

> But you could've just read the comment there too, to know what the NULL
> check was about ...

The comment was always wrong.  Debugfs could return NULL but then
the other debugfs functions turned into no ops...

regards,
dan carpenter
