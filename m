Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37704 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933530Ab3HGXDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 19:03:52 -0400
Message-ID: <5202D173.4050408@hauke-m.de> (sfid-20130808_010356_684106_853E43E7)
Date: Thu, 08 Aug 2013 01:00:03 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: linux-wireless@vger.kernel.org, mcgrof@kernel.org,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Subject: Re: [PATCH] backports: rename some mem functions to not break custom
 kernels
References: <1375865563-1196-1-git-send-email-arik@wizery.com>
In-Reply-To: <1375865563-1196-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please add backports mailing list ( backports@vger.kernel.org ) next time.

On 08/07/2013 10:52 AM, Arik Nemtsov wrote:
> When custom patches are cherry-picked to a kernel, some symbols exported
> by backports may clash with the built-in ones. Rename the backports
> symbols using the standard backport_ prefix to prevent that. Backported
> drivers will resolve to the correct function via a define.
> 
> The offending symbols were exported by the patch below:
> 
> commit 2ce5c22448bb45998318267c00b5d6ef9cff3170
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Thu Jun 6 13:48:04 2013 +0200
> 
>     backports: backport some memory functions
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  backport/backport-include/asm/mtrr.h |  7 +++++--
>  backport/backport-include/linux/io.h | 14 +++++++-------
>  backport/compat/backport-3.11.c      | 16 ++++++++--------
>  3 files changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/backport/backport-include/asm/mtrr.h b/backport/backport-include/asm/mtrr.h
> index cf0f6fd..c5760b4 100644
> --- a/backport/backport-include/asm/mtrr.h
> +++ b/backport/backport-include/asm/mtrr.h
> @@ -7,14 +7,17 @@
>   * The following functions are for use by other drivers that cannot use
>   * arch_phys_wc_add and arch_phys_wc_del.
>   */
> +#ifndef phys_wc_to_mtrr_index
>  #ifdef CONFIG_MTRR
> -extern int phys_wc_to_mtrr_index(int handle);
> +extern int backport_phys_wc_to_mtrr_index(int handle);
>  #else
> -static inline int phys_wc_to_mtrr_index(int handle)
> +static inline int backport_phys_wc_to_mtrr_index(int handle)
>  {
>  	return -1;
>  }
>  #endif /* CONFIG_MTRR */
> +#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)

You should put this line before the #ifndef phy_.... and then you do not
have to use backport_phys_wc_to_mtrr_index with the prefix anywhere in
backports. This also applies for the other places where you manually add
backport_.

> +#endif
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,11,0)) */
>  
>  #endif /* __BACKPORT_ASM_MTRR_H */
> diff --git a/backport/backport-include/linux/io.h b/backport/backport-include/linux/io.h
> index 9a5b308..5f62c62 100644
> --- a/backport/backport-include/linux/io.h
> +++ b/backport/backport-include/linux/io.h
> @@ -15,22 +15,22 @@
>   */
>  #ifndef arch_phys_wc_add
>  #ifdef CONFIG_MTRR
> -extern int __must_check arch_phys_wc_add(unsigned long base,
> -					 unsigned long size);
> -extern void arch_phys_wc_del(int handle);
> +extern int __must_check backport_arch_phys_wc_add(unsigned long base,
> +						  unsigned long size);
> +extern void backport_arch_phys_wc_del(int handle);
>  #else
> -static inline int __must_check arch_phys_wc_add(unsigned long base,
> -						unsigned long size)
> +static inline int __must_check backport_arch_phys_wc_add(unsigned long base,
> +							 unsigned long size)
>  {
>  	return 0;  /* It worked (i.e. did nothing). */
>  }
>  
> -static inline void arch_phys_wc_del(int handle)
> +static inline void backport_arch_phys_wc_del(int handle)
>  {
>  }
>  #endif /* CONFIG_MTRR */
>  
> -#define arch_phys_wc_add arch_phys_wc_add
> +#define arch_phys_wc_add LINUX_BACKPORT(arch_phys_wc_add)
>  #endif
>  
>  #endif /* __BACKPORT_LINUX_IO_H */
> diff --git a/backport/compat/backport-3.11.c b/backport/compat/backport-3.11.c
> index c6d5a02..5ff17d1 100644
> --- a/backport/compat/backport-3.11.c
> +++ b/backport/compat/backport-3.11.c
> @@ -21,7 +21,7 @@
>  #define MTRR_TO_PHYS_WC_OFFSET 1000
>  
>  /**
> - * arch_phys_wc_add - add a WC MTRR and handle errors if PAT is unavailable
> + * backport_arch_phys_wc_add - add a WC MTRR and handle errors if PAT is unavailable
>   * @base: Physical base address
>   * @size: Size of region
>   *
> @@ -32,7 +32,7 @@
>   * Drivers must store the return value to pass to mtrr_del_wc_if_needed,
>   * but drivers should not try to interpret that return value.
>   */
> -int arch_phys_wc_add(unsigned long base, unsigned long size)
> +int backport_arch_phys_wc_add(unsigned long base, unsigned long size)
>  {
>  	int ret;
>  
> @@ -49,7 +49,7 @@ int arch_phys_wc_add(unsigned long base, unsigned long size)
>  	}
>  	return ret + MTRR_TO_PHYS_WC_OFFSET;
>  }
> -EXPORT_SYMBOL_GPL(arch_phys_wc_add);
> +EXPORT_SYMBOL_GPL(backport_arch_phys_wc_add);
>  
>  /*
>   * arch_phys_wc_del - undoes arch_phys_wc_add
> @@ -60,17 +60,17 @@ EXPORT_SYMBOL_GPL(arch_phys_wc_add);
>   * The API guarantees that mtrr_del_wc_if_needed(error code) and
>   * mtrr_del_wc_if_needed(0) do nothing.
>   */
> -void arch_phys_wc_del(int handle)
> +void backport_arch_phys_wc_del(int handle)
>  {
>  	if (handle >= 1) {
>  		WARN_ON(handle < MTRR_TO_PHYS_WC_OFFSET);
>  		mtrr_del(handle - MTRR_TO_PHYS_WC_OFFSET, 0, 0);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(arch_phys_wc_del);
> +EXPORT_SYMBOL_GPL(backport_arch_phys_wc_del);
>  
>  /*
> - * phys_wc_to_mtrr_index - translates arch_phys_wc_add's return value
> + * backport_phys_wc_to_mtrr_index - translates arch_phys_wc_add's return value
>   * @handle: Return value from arch_phys_wc_add
>   *
>   * This will turn the return value from arch_phys_wc_add into an mtrr
> @@ -80,13 +80,13 @@ EXPORT_SYMBOL_GPL(arch_phys_wc_del);
>   * in printk line.  Alas there is an illegitimate use in some ancient
>   * drm ioctls.
>   */
> -int phys_wc_to_mtrr_index(int handle)
> +int backport_phys_wc_to_mtrr_index(int handle)
>  {
>  	if (handle < MTRR_TO_PHYS_WC_OFFSET)
>  		return -1;
>  	else
>  		return handle - MTRR_TO_PHYS_WC_OFFSET;
>  }
> -EXPORT_SYMBOL_GPL(phys_wc_to_mtrr_index);
> +EXPORT_SYMBOL_GPL(backport_phys_wc_to_mtrr_index);
>  
>  #endif /* CONFIG_MTRR */
> 

