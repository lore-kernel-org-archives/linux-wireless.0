Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53412 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2ECNrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 09:47:51 -0400
Date: Thu, 3 May 2012 09:34:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] NFC: Select CRC_CCITT for SHDLC link layer of HCI
 based drivers
Message-ID: <20120503133447.GG9285@tuxdriver.com> (sfid-20120503_154755_600954_E3055AAC)
References: <1336021968-19478-1-git-send-email-marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336021968-19478-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Was there a [PATCH 1/2]?  I didn't get it...

On Thu, May 03, 2012 at 07:12:48AM +0200, Marcel Holtmann wrote:
> The SHDLC link layer of HCI based drivers uses CRC-CCITT and thus
> needs to select that kernel option.
> 
> Otherwise it ends up with this linking error:
> 
> net/built-in.o: In function `nfc_shdlc_add_len_crc':
> net/nfc/hci/shdlc.c:113: undefined reference to `crc_ccitt'
> 
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> ---
>  net/nfc/hci/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/nfc/hci/Kconfig b/net/nfc/hci/Kconfig
> index 17213a6..fd67f51 100644
> --- a/net/nfc/hci/Kconfig
> +++ b/net/nfc/hci/Kconfig
> @@ -9,6 +9,7 @@ config NFC_HCI
>  
>  config NFC_SHDLC
>  	depends on NFC_HCI
> +	select CRC_CCITT
>  	bool "SHDLC link layer for HCI based NFC drivers"
>  	default n
>  	---help---
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
