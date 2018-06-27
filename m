Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934936AbeF0QFC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 12:05:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: net: ipw2x00: Replace NULL comparison with !priv
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180603111136.4262-1-rvarsha016@gmail.com>
References: <20180603111136.4262-1-rvarsha016@gmail.com>
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Varsha Rao <rvarsha016@gmail.com>
Message-Id: <20180627160501.E369660B10@smtp.codeaurora.org> (sfid-20180627_180521_932263_5E047796)
Date: Wed, 27 Jun 2018 16:05:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Varsha Rao <rvarsha016@gmail.com> wrote:

> Remove extra parentheses and replace NULL comparison with !priv, to fix
> clang warning of extraneous parentheses and check patch issue. Following
> coccinelle script is used to fix it.
> 
> @disable is_null,paren@
> expression e;
> statement s;
> @@
> if (
> - (e==NULL)
> +!e
>  )
> s
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

4e5f881d430a net: ipw2x00: Replace NULL comparison with !priv

-- 
https://patchwork.kernel.org/patch/10445241/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
