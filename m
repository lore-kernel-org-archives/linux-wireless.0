Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753263AbdLHNUr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 08:20:47 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wireless: use ARRAY_SIZE
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171114031941.22105-1-jeremy.lefaure@lse.epita.fr>
References: <20171114031941.22105-1-jeremy.lefaure@lse.epita.fr>
To: =?utf-8?q?J=C3=A9r=C3=A9my_Lefaure?= <jeremy.lefaure@lse.epita.fr>
Cc: linux-wireless@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>
Message-Id: <20171208132047.0BBC2607F4@smtp.codeaurora.org> (sfid-20171208_142050_963312_4FAFD519)
Date: Fri,  8 Dec 2017 13:20:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jérémy Lefaure wrote:

> Using the ARRAY_SIZE macro improves the readability of the code. Also,
> it is not always useful to use a variable to store this constant
> calculated at compile time.
> 
> Found with Coccinelle with the following semantic patch:
> @r depends on (org || report)@
> type T;
> T[] E;
> position p;
> @@
> (
>  (sizeof(E)@p /sizeof(*E))
> |
>  (sizeof(E)@p /sizeof(E[...]))
> |
>  (sizeof(E)@p /sizeof(T))
> )
> 
> Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>

Patch applied to wireless-drivers-next.git, thanks.

53ac79359327 wireless: use ARRAY_SIZE

-- 
https://patchwork.kernel.org/patch/10057021/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
