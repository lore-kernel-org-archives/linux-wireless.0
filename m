Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42488 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbeIGRNp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 13:13:45 -0400
Received: from mail-yb1-f198.google.com ([209.85.219.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fyFwZ-0002LS-Ki
        for linux-wireless@vger.kernel.org; Fri, 07 Sep 2018 12:32:59 +0000
Received: by mail-yb1-f198.google.com with SMTP id r2-v6so5521521ybb.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 05:32:59 -0700 (PDT)
Date: Fri, 7 Sep 2018 07:32:56 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Henrik Laxhuber <henrik@laxhuber.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Switzerland
 (CH), and Liechtenstein (LI) on 5GHz
Message-ID: <20180907123256.GJ4251@ubuntu-xps13> (sfid-20180907_143303_436242_641A7964)
References: <2441d0ea-b862-9675-9342-356606d9228d@laxhuber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2441d0ea-b862-9675-9342-356606d9228d@laxhuber.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 06, 2018 at 04:13:22PM +0200, Henrik Laxhuber wrote:
> Update to reflect the current data published in the 'National Frequency
> Allocation Strategy Table' [0] for Switzerland and Liechtenstein, which
> at the time of writing points to the documents [1] and [2].
> 
> [0] https://www.ofcomnet.ch/#/fatTable
> [1] https://www.ofcomnet.ch/api/rir/1010/05
> [2] https://www.ofcomnet.ch/api/rir/1010/04
> 
> Signed-off-by: Henrik Laxhuber <henrik@laxhuber.com>
> ---
>  db.txt | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index 8cf7dee..69cea85 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -265,10 +265,14 @@ country CF: DFS-FCC
>      (5490 - 5730 @ 40), (24), DFS
>      (5735 - 5835 @ 40), (30)
> 
> +# Source:
> +# https://www.ofcomnet.ch/#/fatTable
> +# Note that the maximum transmitter power can be doubled for 5250-5710MHz
> if
> +# transmitter power control is in use: 5250-5330@23db, 5490-5710@30db
>  country CH: DFS-ETSI
>      (2402 - 2482 @ 40), (20)
> -    (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
> -    (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
> +    (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI

Maybe you missed this in my last reply, I had suggested this range can
be 5150-5250 as in the document you linked to. If you agree with this
change I can make it when I apply the patch.

Thanks,
Seth

> +    (5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
>      (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
>      # 60 GHz band channels 1-4, ref: Etsi En 302 567
>      (57000 - 66000 @ 2160), (40)
> @@ -743,11 +747,18 @@ country LC: DFS-ETSI
>      (5490 - 5710 @ 160), (30), DFS
>      (5735 - 5815 @ 80), (30)
> 
> +
> +# Source:
> +# https://www.ofcomnet.ch/#/fatTable
> +# Note that the maximum transmitter power can be doubled for 5250-5710MHz
> if
> +# transmitter power control is in use: 5250-5330@23db, 5490-5710@30db
>  country LI: DFS-ETSI
>      (2402 - 2482 @ 40), (20)
> -    (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
> -    (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
> +    (5170 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
> +    (5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
>      (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
> +    # 60 GHz band channels 1-4, ref: Etsi En 302 567
> +    (57000 - 66000 @ 2160), (40)
> 
>  country LK: DFS-FCC
>      (2402 - 2482 @ 40), (20)
> -- 
> 2.18.0
