Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53603 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3FXRcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 13:32:11 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so8738686wgh.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 10:32:10 -0700 (PDT)
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org> <1371915734-13966-2-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1371915734-13966-2-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <2DDF15FE-CA30-4683-ABFE-63204952F561@gmail.com> (sfid-20130624_193214_880657_8A0CA9B5)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/3] rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
Date: Mon, 24 Jun 2013 19:32:07 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 22 jun. 2013, at 17:42, Gabor Juhos <juhosg@openwrt.org> wrote:

> Ralink 3T chipsets are using a different EEPROM
> layout than the others. The EEPROM on these devices
> contain more data than the others which does not fit
> into 272 byte which the rt2800 driver actually uses.
> 
> The Ralink reference driver defines EEPROM_SIZE to
> 512/1024 bytes for PCI/USB devices respectively.
> 
> Increase the EEPROM_SIZE constant to 512 bytes, in
> order to make room for EEPROM data of 3T devices.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2800.h |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index fe43d01..d78c495 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -100,7 +100,7 @@
> #define CSR_REG_BASE            0x1000
> #define CSR_REG_SIZE            0x0800
> #define EEPROM_BASE            0x0000
> -#define EEPROM_SIZE            0x0110
> +#define EEPROM_SIZE            0x0200
> #define BBP_BASE            0x0000
> #define BBP_SIZE            0x00ff
> #define RF_BASE                0x0004
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
