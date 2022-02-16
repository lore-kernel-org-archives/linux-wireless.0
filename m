Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2432EC4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Feb 2022 20:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiBPUe4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Feb 2022 15:34:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiBPUex (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Feb 2022 15:34:53 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727FF2A4175
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2022 12:34:39 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d17so3167583pfl.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2022 12:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=34foyzQgH1WJK6GDE5OU+q5UkwqrR0OjV9oJltEHxZ8=;
        b=aLEwSzUXsbHpjpEbePXetqBJCK4mTyMypKirkaRKMEIJxOo32byNWjOdNhSj/8uD2a
         3NOBFqO/DEwyTQOCCwXkOozXzVsnNwapuTJJgqkgFnqWssFy5spfqxO7k1X8Jv7HmB3F
         g0Fj4Iu3e14KFwBmtuO6nVr+jZNAw1rSkPFiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=34foyzQgH1WJK6GDE5OU+q5UkwqrR0OjV9oJltEHxZ8=;
        b=Ll/je+Ri5IyaE+iDr4GVs7UUPXA5i6MDmfC0O/2i8do2/oOAou9heaVmIlNYEqzASu
         hEDK5uJILET7YvIIcHPFE7KfbPzFbVM3MGmMEbEaB9oNYpHmO4oR5fsa8uLBoFzCDlmn
         JHYpup08pBrFhD9tkJm9hPXFK9/fBgC7CbIfmZzlCd+kD2tRHatxwgSQIsrVR12VxhaA
         QCIontVQdCvFvUAJTWTEVDJOV+PisV0QKKlFa/zL1r80mVvHi2PB96B5oz/FX1iQcASM
         Mhp5bLYBpgE8X2rEHSdCo4uNo3vqcuso5Kpw+nvYo3cBMYoDHPROy8m1tEKNLYiHzHtM
         5J7g==
X-Gm-Message-State: AOAM5310TMdQJgVwrPwWNOazIRJRLxbLCds1T+y90/QkIyGu/ntigO2g
        lZkmh0reNFmswrE/vdV+mi3Ojw==
X-Google-Smtp-Source: ABdhPJznIfmcDoGkWc9lXrl3Y/k3eI/Gzm5CrHU0WAf7yVBSM4pE0rhp0jVMulgBcFjnnnVwf+OaRQ==
X-Received: by 2002:a05:6a00:15c7:b0:4e1:5aa5:1dd7 with SMTP id o7-20020a056a0015c700b004e15aa51dd7mr5121282pfu.60.1645043678639;
        Wed, 16 Feb 2022 12:34:38 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id lx4sm20562299pjb.1.2022.02.16.12.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 12:34:38 -0800 (PST)
Date:   Wed, 16 Feb 2022 12:34:37 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] ath: Replace zero-length arrays with
 flexible-array members
Message-ID: <202202161234.FCBA0EE18@keescook>
References: <20220216194915.GA904081@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216194915.GA904081@embeddedor>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 16, 2022 at 01:49:15PM -0600, Gustavo A. R. Silva wrote:
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
