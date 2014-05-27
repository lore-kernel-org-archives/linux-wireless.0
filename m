Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34592 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaE0P6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 11:58:13 -0400
Message-ID: <1401206274.8146.8.camel@jlt4.sipsolutions.net> (sfid-20140527_175817_457981_2344D16E)
Subject: Re: [PATCH V2] regdb: Generalize the mW to dBm power conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: chaitanya.mgit@gmail.com
Cc: linville@tuxdriver.com, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org
Date: Tue, 27 May 2014 17:57:54 +0200
In-Reply-To: <1401107504-11385-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140526_143219_846087_559DD3B4)
References: <1401107504-11385-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20140526_143219_846087_559DD3B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-26 at 18:01 +0530, chaitanya.mgit@gmail.com wrote:
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

This patch is wrong :-)
Bonus points for those who can figure it out without looking at the one
I'm committing ;-)

johannes

