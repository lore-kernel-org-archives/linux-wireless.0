Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763742AbdEXNoX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:44:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] libertas: Avoid reading past end of buffer
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170515212640.GA45443@beast>
References: <20170515212640.GA45443@beast>
To: Kees Cook <keescook@chromium.org>
Cc: netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org
Message-Id: <20170524134422.7230F60DD9@smtp.codeaurora.org> (sfid-20170524_154504_430182_9778114F)
Date: Wed, 24 May 2017 13:44:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:
> Using memcpy() from a string that is shorter than the length copied means
> the destination buffer is being filled with arbitrary data from the kernel
> rodata segment. Instead, redefine the stat strings to be ETH_GSTRING_LEN
> sizes, like other drivers. This lets us use a single memcpy that does not
> leak rodata contents. Additionally adjust indentation to keep checkpatch.pl
> happy.
> 
> This was found with the future CONFIG_FORTIFY_SOURCE feature.
> 
> Cc: Daniel Micay <danielmicay@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

12e3c0433e8a libertas: Avoid reading past end of buffer

-- 
https://patchwork.kernel.org/patch/9727997/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
