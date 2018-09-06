Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48445 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbeIFRhS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 13:37:18 -0400
Received: from mail-yw1-f69.google.com ([209.85.161.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fxtuy-00018p-VU
        for linux-wireless@vger.kernel.org; Thu, 06 Sep 2018 13:01:53 +0000
Received: by mail-yw1-f69.google.com with SMTP id v6-v6so6952561ywg.10
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 06:01:52 -0700 (PDT)
Date: Thu, 6 Sep 2018 08:01:49 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Henrik Laxhuber <henrik@laxhuber.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: Update regulatory rules for Switzerland (CH),
 and Liechtenstein (LI) on 5GHz
Message-ID: <20180906130149.GE4251@ubuntu-xps13> (sfid-20180906_150158_079730_59AF5F47)
References: <d7dddf8e-b434-2492-3564-6f35b558d750@laxhuber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <d7dddf8e-b434-2492-3564-6f35b558d750@laxhuber.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 18, 2018 at 02:01:50PM +0200, Henrik Laxhuber wrote:
> [ My previous message didn't go through because I hadn't signed up to ]
> [   the wireless-regdb mailing list; I apologise if anyone receives   ]
> [                         this message twice                          ]

Thanks for the patch. However you forgot to include a Signed-off-by tag
(see the CONTRIBUTING file). Please also only include a description of
the patch in the commit message, any additional comments/questions can
be included in a cover letter.

Also one small comment about the changes below.

> As far as I could tell, the regulatory information for Switzerland and
> Liechtenstein did not match the information published by the national
> regulator. I have gone ahead and updated the information according to
> the 'National Frequency Allocation Strategy Table' [0] for both
> countries.
> 
> On a somewhat related note, are there any plans to properly support TPC?
> There are quite a few entries in the database where maximum transmission
> power could be increased when TPC is in use. Being able to set a
> different maximum antenna gain and/or EIRP when TCP is in use could be
> helpful in these cases. I guess what's holding this back is lacking
> driver support?

I haven't heard of any plans for supporting TPC in the kernel.

> PS: Since [0] can be cumbersome to navigate, I am also providing the
> direct links to the applicable tables. It's possible that these links
> will rot:
> 5150 - 5350 MHz: [1]
> 5470 - 5725 MHz: [2]
> 
> [0] https://www.ofcomnet.ch/#/fatTable
> [1] https://www.ofcomnet.ch/api/rir/1010/05
> [2] https://www.ofcomnet.ch/api/rir/1010/04
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

This should also be changed to 5150-5250.

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
> 
