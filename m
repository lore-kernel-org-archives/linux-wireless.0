Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D14FC433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Feb 2022 20:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiBPUfQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Feb 2022 15:35:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiBPUfN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Feb 2022 15:35:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EDB2AE72E
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2022 12:34:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id j4so2878687plj.8
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2022 12:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TPYAVPLt3DSLrT5QHqLW9+lhJ1UDrylzHFt/SATA1Sw=;
        b=LXQuXooAbkgrzg+wzZD+VJ5ySuEv+VaIy4DsRfyqOkZHFBYZ+S7TDPHn7/hJm3FIm9
         mab9/ZhAuAy2+Zaawh/1HDRYHfckDHKEuCSQVBNTp3S6NWQKkEk+LnbShf5plOeeQJWD
         AeMW0rE6Mwun1joleXH2QYA6lN2WC+b8R/HiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TPYAVPLt3DSLrT5QHqLW9+lhJ1UDrylzHFt/SATA1Sw=;
        b=hhwmivFbm1AN2L8pjMvfpwRsP2aYewiXnBkuA90cCz+wyhQ0DEIs7OkxqQAzbN0CtG
         og8ZP5EhouHPPvHBLGfxl739n0SFIpJSn0R5ca4dXKeAVECfC+FhzETSWDsfxUoDJ4JT
         seAHRZpjFjtkIiaDHhF2uOtK0PN/ZSY1EyrYi+GbA/UU6FJw/G/pLwVmcvT0GVzGfBOx
         njOhU16q1EY7o+N2RC1uju9Gz+ryn+XEsPrjTCXqgRifodUc0U7w0FPgpNyJN0HHalTP
         1zeRGvdCjymJ+jaTC8g93FGhjHnooN/c/hFKj4cS22FI6C/5lHw26sB+d1Za4x8sPkGU
         tssA==
X-Gm-Message-State: AOAM531sotPqs5ySQWop0a5MA3/JZfFzSO7A5+L8hcl4xdlD6PRUyClq
        FYoVK6R8UHrdloA88eDQ1V4WpA==
X-Google-Smtp-Source: ABdhPJxw5m6xEEf4zWFTXNmj0NNXcyrU2pH1NzSQVfQfjbPkoDN5tg30lfInuAbeSYuFZgQiiXlTBA==
X-Received: by 2002:a17:903:22d0:b0:14d:7bba:3746 with SMTP id y16-20020a17090322d000b0014d7bba3746mr563276plg.155.1645043696869;
        Wed, 16 Feb 2022 12:34:56 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b11sm18369885pfl.123.2022.02.16.12.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 12:34:56 -0800 (PST)
Date:   Wed, 16 Feb 2022 12:34:56 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] carl9170: Replace zero-length arrays with
 flexible-array members
Message-ID: <202202161234.15553997BA@keescook>
References: <20220216194955.GA904126@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216194955.GA904126@embeddedor>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 16, 2022 at 01:49:55PM -0600, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
