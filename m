Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37570 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1EPSRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 14:17:37 -0400
Message-ID: <4DD16A3A.20705@hauke-m.de> (sfid-20110516_201933_706751_BD6ED637)
Date: Mon, 16 May 2011 20:17:30 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] compat: backport PCI_EEPROM_WIDTH_93C86
References: <1305567815-73528-1-git-send-email-nbd@openwrt.org> <1305567815-73528-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1305567815-73528-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2011 07:43 PM, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/linux/compat-2.6.36.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
> index 7a82522..2d756d1 100644
> --- a/include/linux/compat-2.6.36.h
> +++ b/include/linux/compat-2.6.36.h
> @@ -123,6 +123,8 @@ static inline void tty_unlock(void) __releases(kernel_lock)
>  
>  #define __rcu
>  
> +#define PCI_EEPROM_WIDTH_93C86	8
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
>  
>  #endif /* LINUX_26_36_COMPAT_H */

NACK on this patch.

PCI_EEPROM_WIDTH_93C86 is already defined in
include/linux/eeprom_93cx6.h which is shipped with compat-wireless.

Hauke
