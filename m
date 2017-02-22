Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35432 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933745AbdBVVa7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 16:30:59 -0500
Received: by mail-it0-f51.google.com with SMTP id 203so152364038ith.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2017 13:30:59 -0800 (PST)
Date: Wed, 22 Feb 2017 15:30:57 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Ryan Mounce <ryan@mounce.com.au>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Update rules for Australia (AU) and add
 60GHz rules
Message-ID: <20170222213057.GA33925@ubuntu-hedt> (sfid-20170222_223144_200745_7E831898)
References: <20170218063515.16071-1-ryan@mounce.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170218063515.16071-1-ryan@mounce.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 18, 2017 at 05:05:15PM +1030, Ryan Mounce wrote:
> Sourced from the latest legislation at
> https://www.legislation.gov.au/Details/F2016C0043

This link isn't working for me.

> The current rules exceed legal limits between 5250-5330MHz, and permit
> illegal operation in 5600-5650MHz (reserved for weather radar).

The changes also increases the limits for most other ranges, by quite a
bit in some cases. Seems that this should also be mentioned in the
changelog, and I'd like to be able to check those changes against the
documentation.

Thanks,
Seth

> 
> Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
> ---
>  db.txt | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index 05108e0..b951e0c 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -85,12 +85,17 @@ country AT: DFS-ETSI
>  	# 60 GHz band channels 1-4, ref: Etsi En 302 567
>  	(57000 - 66000 @ 2160), (40)
>  
> +# Source:
> +# https://www.legislation.gov.au/Details/F2016C00432
> +# Both DFS-ETSI and DFS-FCC are acceptable per AS/NZS 4268 Appendix B
>  country AU: DFS-ETSI
> -	(2402 - 2482 @ 40), (20)
> -	(5170 - 5250 @ 80), (17), AUTO-BW
> -	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
> -	(5490 - 5710 @ 160), (24), DFS
> -	(5735 - 5835 @ 80), (30)
> +	(2402 - 2482 @ 40), (36)
> +	(5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW
> +	(5250 - 5330 @ 80), (23), NO-OUTDOOR, AUTO-BW, DFS
> +	(5490 - 5590 @ 80), (30), DFS
> +	(5650 - 5730 @ 80), (30), DFS
> +	(5735 - 5835 @ 80), (36)
> +	(57000 - 66000 @ 2160), (43), NO-OUTDOOR
>  
>  country AW: DFS-ETSI
>  	(2402 - 2482 @ 40), (20)
> -- 
> 2.11.0
> 
