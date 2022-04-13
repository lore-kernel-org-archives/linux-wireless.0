Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C05CC433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Apr 2022 00:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiDMA0j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Apr 2022 20:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiDMA0i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Apr 2022 20:26:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7114C25E
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2022 17:24:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k29so196356pgm.12
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2022 17:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FgyYp5VcoidQ5XbfndPuDkccCsmpD6ZwuN3H0CutGCY=;
        b=ldUuYwzP3gD/rj7ALLtG+rGst+MSW0eFQKuy35D0bSdRsQBpS//HqjbyviqsQHhkvA
         fs0ojuosBvGohhltxkgUUvr6kv7EuIjYUAFaJpmR9VP43JRS7qY7Vg83HR6QMHVZfHno
         6Nw1CHQV1PtyjJZCd4cPCdaXzqEoaf9KgR8Xs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FgyYp5VcoidQ5XbfndPuDkccCsmpD6ZwuN3H0CutGCY=;
        b=o72di+/JTI9WlvaeM/cygBnvnSQFBg0t3CR0aKIyUQZ5Fkft+d2eoTDb08gBWup3yv
         tm9Z6YhLJUJPnCu63lXOKZJHhhMvJg1IFeQ1bZwLt+QkH8ZasngSCclIqN6ifvSHS9G1
         qI8CQeIrahWUFkyQw/Mqjclpj0X18XFy2L1xUpEgokWlxUr/uPwG/jUtuoO1rQ2ALqPw
         X8LsIfZJ+Vrke38f0BQ3xQHK7hCytkghIFPrBh0Wk8y6sGoFNLeRG6+ZvRh0P5ChMmyH
         BoCSvZUfZoNKoLBQaLZeZBJR6LmSER7td+/73+w68FmKU85WXZBbP1dcDkdTx/t481Hm
         O5xQ==
X-Gm-Message-State: AOAM530DKUiQBHpfrB8kvv3KR6NAMO77k1NR9OExi6MliIXJClpBtTcV
        JfJTcyAnXJnZUElIeZdMnSbt0g==
X-Google-Smtp-Source: ABdhPJy5FJY6Q6VWd+fk6QfKqME9E6j1FuWrwXXcbGKZvBz/6FWlvHnd3hcZqchTrqP3gllEJGM/cg==
X-Received: by 2002:a05:6a00:1c63:b0:505:cc7f:a21b with SMTP id s35-20020a056a001c6300b00505cc7fa21bmr10818937pfw.9.1649809450783;
        Tue, 12 Apr 2022 17:24:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm42471329pfj.146.2022.04.12.17.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 17:24:10 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:24:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Tom Rix <trix@redhat.com>
Cc:     luciano.coelho@intel.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, emmanuel.grumbach@intel.com,
        ayala.beker@intel.com, johannes.berg@intel.com,
        colin.i.king@googlemail.com, gustavoars@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mei: clean up comments
Message-ID: <202204121724.6EB95414@keescook>
References: <20220410142733.1454873-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410142733.1454873-1-trix@redhat.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 10, 2022 at 10:27:33AM -0400, Tom Rix wrote:
> SPDX
> *.h use /* */ style comments
> 
> Spelling replacements
> commnunication to communication
> adsress to address
> procotol to protocol
> addtional to additional
> kown to know
> negotiaion to negotiation
> mssage to message
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Looks good; thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
