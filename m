Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbeHaT4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:56:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcmfmac: fix wrong strnchr usage
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180822132215.27669-1-linux@rasmusvillemoes.dk>
References: <20180822132215.27669-1-linux@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-Id: <20180831154818.9D0E96038E@smtp.codeaurora.org> (sfid-20180831_174917_633677_8E1B0B35)
Date: Fri, 31 Aug 2018 15:48:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> strnchr takes arguments in the order of its name: string, max bytes to
> read, character to search for. Here we're passing '\n' aka 10 as the
> buffer size, and searching for sizeof(buf) aka BRCMF_DCMD_SMLEN aka
> 256 (aka '\0', since it's implicitly converted to char) within those 10
> bytes.
> 
> Just interchanging the last two arguments would still leave a bug,
> because if we've been successful once, there are not sizeof(buf)
> characters left after the new value of p.
> 
> Since clmver is immediately afterwards passed as a %s argument, I assume
> that it is actually a properly nul-terminated string. For that case, we
> have strreplace().
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Patch applied to wireless-drivers-next.git, thanks.

cb18e2e9ec71 brcmfmac: fix wrong strnchr usage

-- 
https://patchwork.kernel.org/patch/10572951/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
