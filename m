Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:56776 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbdBRUqd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Feb 2017 15:46:33 -0500
To: Ryan Mounce <ryan@mounce.com.au>, seth.forshee@canonical.com
References: <20170218063515.16071-1-ryan@mounce.com.au>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <9d768854-e41d-fdb1-967d-7fdd7d692226@dd-wrt.com> (sfid-20170218_214708_035856_C4684961)
Date: Sat, 18 Feb 2017 21:45:33 +0100
MIME-Version: 1.0
In-Reply-To: <20170218063515.16071-1-ryan@mounce.com.au>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Subject: Re: [PATCH] wireless-regdb: Update rules for Australia (AU) and add
 60GHz rules
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

maybe i'm blind. but you reduced the channel width from 160 to 80 mhz. 
but i can't find any restriction in the document in a quick review

Sebastian

Am 18.02.2017 um 07:35 schrieb Ryan Mounce:
> Sourced from the latest legislation at
> https://www.legislation.gov.au/Details/F2016C0043
>
> The current rules exceed legal limits between 5250-5330MHz, and permit
> illegal operation in 5600-5650MHz (reserved for weather radar).
>
> Signed-off-by: Ryan Mounce <ryan@mounce.com.au>
> ---
>   db.txt | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index 05108e0..b951e0c 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -85,12 +85,17 @@ country AT: DFS-ETSI
>   	# 60 GHz band channels 1-4, ref: Etsi En 302 567
>   	(57000 - 66000 @ 2160), (40)
>   
> +# Source:
> +# https://www.legislation.gov.au/Details/F2016C00432
> +# Both DFS-ETSI and DFS-FCC are acceptable per AS/NZS 4268 Appendix B
>   country AU: DFS-ETSI
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
>   country AW: DFS-ETSI
>   	(2402 - 2482 @ 40), (20)


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
