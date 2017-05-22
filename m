Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934647AbdEVP1u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 11:27:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ray_cs: Avoid reading past end of buffer
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170505223841.GA20367@beast>
References: <20170505223841.GA20367@beast>
To: Kees Cook <keescook@chromium.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>
Message-Id: <20170522152750.1EC2A601D1@smtp.codeaurora.org> (sfid-20170522_172819_722440_44FE8457)
Date: Mon, 22 May 2017 15:27:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kees Cook <keescook@chromium.org> wrote:
> Using memcpy() from a buffer that is shorter than the length copied means
> the destination buffer is being filled with arbitrary data from the kernel
> rodata segment. In this case, the source was made longer, since it did not
> match the destination structure size. Additionally removes a needless cast.
> 
> This was found with the future CONFIG_FORTIFY_SOURCE feature.
> 
> Cc: Daniel Micay <danielmicay@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

e48d661eb13f ray_cs: Avoid reading past end of buffer

-- 
https://patchwork.kernel.org/patch/9714453/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
