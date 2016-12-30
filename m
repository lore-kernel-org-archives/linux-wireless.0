Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbcL3N41 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:56:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: libertas: constify cfg80211_ops structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1482015444-28899-1-git-send-email-bhumirks@gmail.com>
References: <1482015444-28899-1-git-send-email-bhumirks@gmail.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>
Message-Id: <20161230135627.06A91613B1@smtp.codeaurora.org> (sfid-20161230_145702_893239_E34B94A2)
Date: Fri, 30 Dec 2016 13:56:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bhumika Goyal <bhumirks@gmail.com> wrote:
> cfg80211_ops structures are only passed as an argument to the function
> wiphy_new. This argument is of type const, so cfg80211_ops strutures
> having this property can be declared as const.
> Done using Coccinelle
> 
> @r1 disable optional_qualifier @
> identifier i;
> position p;
> @@
> static struct cfg80211_ops i@p = {...};
> 
> @ok1@
> identifier r1.i;
> position p;
> @@
> wiphy_new(&i@p,...)
> 
> @bad@
> position p!={r1.p,ok1.p};
> identifier r1.i;
> @@
> i@p
> 
> @depends on !bad disable optional_qualifier@
> identifier r1.i;
> @@
> +const
> struct cfg80211_ops i;
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>   21225	   1954	     16	  23195	   5a9b	wireless/marvell/libertas/cfg.o
> 
> File size after:
>    text	   data	    bss	    dec	    hex	filename
>   22041	   1154	     16	  23211	   5aab	wireless/marvell/libertas/cfg.o
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

26eb994d5239 libertas: constify cfg80211_ops structures

-- 
https://patchwork.kernel.org/patch/9479131/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
