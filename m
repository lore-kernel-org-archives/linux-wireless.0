Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3DZSHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 14:07:10 -0400
Message-ID: <517AC21E.30705@infradead.org> (sfid-20130426_200715_656386_3F44BD3B)
Date: Fri, 26 Apr 2013 11:06:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] NFC: Add missing RFKILL dependency for Kconfig
References: <1366999114-26903-1-git-send-email-marcel@holtmann.org>
In-Reply-To: <1366999114-26903-1-git-send-email-marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/13 10:58, Marcel Holtmann wrote:
> Since the NFC subsystem gained RFKILL support, it needs to be able
> to build properly with whatever option for RFKILL has been selected.
> 
> on i386:
> 
> net/built-in.o: In function `nfc_unregister_device':
> (.text+0x6a36d): undefined reference to `rfkill_unregister'
> net/built-in.o: In function `nfc_unregister_device':
> (.text+0x6a378): undefined reference to `rfkill_destroy'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a493): undefined reference to `rfkill_alloc'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a4a4): undefined reference to `rfkill_register'
> net/built-in.o: In function `nfc_register_device':
> (.text+0x6a4b3): undefined reference to `rfkill_destroy'
> net/built-in.o: In function `nfc_dev_up':
> (.text+0x6a8e8): undefined reference to `rfkill_blocked'
> 
> when CONFIG_RFKILL=m but NFC is builtin.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  net/nfc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
> index 60c3bbb..28afdb1 100644
> --- a/net/nfc/Kconfig
> +++ b/net/nfc/Kconfig
> @@ -4,6 +4,7 @@
>  
>  menuconfig NFC
>  	depends on NET
> +	depends on RFKILL || !RFKILL
>  	tristate "NFC subsystem support"
>  	default n
>  	help
> 


-- 
~Randy
