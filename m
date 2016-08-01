Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:57719 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcHAHE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 03:04:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, zajec5@gmail.com,
	leoli@freescale.com, qiang.zhao@freescale.com,
	viresh.kumar@linaro.org, linux-wireless@vger.kernel.org,
	David.Laight@aculab.com, netdev@vger.kernel.org,
	scottwood@freescale.com, akpm@linux-foundation.org,
	davem@davemloft.net, linux@roeck-us.net
Subject: Re: [v4] Fix to avoid IS_ERR_VALUE and IS_ERR abuses on 64bit systems.
Date: Mon, 01 Aug 2016 09:02:21 +0200
Message-ID: <1956647.cOmaJREgOE@wuerfel> (sfid-20160801_090610_288704_8EBD9BC9)
In-Reply-To: <1469963924-8800-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1469963924-8800-1-git-send-email-arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 31, 2016 4:48:44 PM CEST Arvind Yadav wrote:
> IS_ERR_VALUE() assumes that parameter is an unsigned long.
> It can not be used to check if 'unsigned int' is passed insted.
> Which tends to reflect an error.
> 
> In 64bit architectures sizeof (int) == 4 && sizeof (long) == 8.
> IS_ERR_VALUE(x) is ((x) >= (unsigned long)-4095).
> 
> IS_ERR_VALUE() of 'unsigned int' is always false because the 32bit
> value is zero extended to 64 bits.
> 
> Value of (unsigned int)-4095 is always less than value of
> (unsigned long)-4095.
> 
> Now We are taking only first 32 bit for error checking rest of the 32 bit
> we ignore such that we get appropriate comparison on 64bit system as well.

This is completely wrong: if you have a valid 64-bit pointer like
0x00001234ffffff00, this will be interpreted as an error now.

> First 32bit of Value of (unsigned int)-4095 and (unsigned long)-4095 will
> be equal.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  include/linux/err.h | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> index 1e35588..c2a2789 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -18,7 +18,17 @@
>  
>  #ifndef __ASSEMBLY__
>  
> -#define IS_ERR_VALUE(x) unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)
> +#define IS_ERR_VALUE(x) unlikely(is_error_check(x))
> +
> +static inline int is_error_check(unsigned long error)

Please leave the existing macro alone. I think you were looking for
something specific to the return code of qe_muram_alloc() function,
so please add a helper in that subsystem if you need it, not in
the generic header files.

	Arnd
