Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A4FC6FD1F
	for <linux-wireless@archiver.kernel.org>; Sun, 19 Mar 2023 15:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCSPVW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 19 Mar 2023 11:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjCSPVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Mar 2023 11:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2638A1D902;
        Sun, 19 Mar 2023 08:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EA206105C;
        Sun, 19 Mar 2023 15:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E44FC433D2;
        Sun, 19 Mar 2023 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679239277;
        bh=X6Wow6KKerQaleqzMVF1PBmhuJOFPbG4PJDoBqXRDkA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fbwSp60FTnEXYV/5fsld3fc8yUiPTDcOW3Rcu+QM+hTT4jXXJMkWTC5NBD+TpoSxt
         XPuL/ekAke+/OIRqDYF904AmYi6AVkIessZCAJJGzEBRxMZieRhDUl8ud840BOsXbz
         B8retvRRHqhNXFSXoRdiOaZRNmdnuJHv3z+6jyfFcZYEE/7ksJ0HMbNH4recTsnYot
         zESPTm1nntrVq9yO69OW7arfzeLOb7t19LgVd1wiPnB4v/V+vZNwHYr8pocBRJQ1fw
         mfir6gRmX//iGnwbmXFYZeK//kFLduA1bGbtUWbGaaH3GXE20ZxOjV2+NuPHIwkRVE
         xpdu6Es0pdvDg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Tom Rix <trix@redhat.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] ipw2x00: remove unused _ipw_read16 function
In-Reply-To: <20230319135418.1703380-1-trix@redhat.com> (Tom Rix's message of
        "Sun, 19 Mar 2023 09:54:18 -0400")
References: <20230319135418.1703380-1-trix@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Sun, 19 Mar 2023 17:21:09 +0200
Message-ID: <87ilewix7e.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tom Rix <trix@redhat.com> writes:

> clang with W=1 reports
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:381:19: error:
>   unused function '_ipw_read16' [-Werror,-Wunused-function]
> static inline u16 _ipw_read16(struct ipw_priv *ipw, unsigned long ofs)
>                   ^
> This function and its wrapping marco are not used, so remove them.
>
> Signed-off-by: Tom Rix <trix@redhat.com>

I'll add "wifi:" to the title.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
