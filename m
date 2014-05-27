Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40253 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaE0PpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 11:45:09 -0400
Date: Tue, 27 May 2014 11:31:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: chaitanya.mgit@gmail.com
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] regdb: Generalize the mW to dBm power conversion
Message-ID: <20140527153127.GC5694@tuxdriver.com> (sfid-20140527_174513_548224_463E0320)
References: <1401107504-11385-1-git-send-email-chaitanya.mgit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401107504-11385-1-git-send-email-chaitanya.mgit@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 06:01:44PM +0530, chaitanya.mgit@gmail.com wrote:
> Generalize the power conversion from mW to dBm 
> using log. This should fix the below compilation
> error for country NO which adds a new power value
> 2000mW which is not handled earlier.
> 
>  CC [M]  net/wireless/wext-sme.o
>  CC [M]  net/wireless/regdb.o
> net/wireless/regdb.c:1130:1: error: Unknown undeclared here (not in
> a function)
> net/wireless/regdb.c:1130:9: error: expected } before power
> make[2]: *** [net/wireless/regdb.o] Error 1
> make[1]: *** [net/wireless] Error 2
> make: *** [net] Error 2
> 
> Reported-By:  John Walker <john@x109.net>
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> 
> ---
>  net/wireless/genregdb.awk |   12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/net/wireless/genregdb.awk b/net/wireless/genregdb.awk
> index 4119833..949ee38 100644
> --- a/net/wireless/genregdb.awk
> +++ b/net/wireless/genregdb.awk
> @@ -68,17 +68,7 @@ function parse_reg_rule()
>  	sub(/,/, "", units)
>  	dfs_cac = $9
>  	if (units == "mW") {
> -		if (power == 100) {
> -			power = 20
> -		} else if (power == 200) {
> -			power = 23
> -		} else if (power == 500) {
> -			power = 27
> -		} else if (power == 1000) {
> -			power = 30
> -		} else {
> -			print "Unknown power value in database!"
> -		}
> +		power = 10 * (log(power)/log(10))
>  	} else {
>  		dfs_cac = $8
>  	}

I'm not fond of the unnecessary parenthesis.  But otherwise it seems great.

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
