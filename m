Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753882AbcL3NBI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 08:01:08 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: net: wireless: ath: wil6210: constify cfg80211_ops structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1482014667-27082-1-git-send-email-bhumirks@gmail.com>
References: <1482014667-27082-1-git-send-email-bhumirks@gmail.com>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, qca_merez@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhumika Goyal <bhumirks@gmail.com>
Message-Id: <20161230130107.3C0256145A@smtp.codeaurora.org> (sfid-20161230_140336_534138_31A3DB37)
Date: Fri, 30 Dec 2016 13:01:07 +0000 (UTC)
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
>   18133	   6632	      0	  24765	   60bd wireless/ath/wil6210/cfg80211.o
> 
> File size after:
>    text	   data	    bss	    dec	    hex	filename
>   18933	   5832	      0	  24765	   60bd wireless/ath/wil6210/cfg80211.o
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

The prefix should be "wil6210:", I can fix that before I commit this.

-- 
https://patchwork.kernel.org/patch/9479127/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
