Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbbJUA3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 20:29:55 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 01/16] rtl8xxxu: Treat REG_9346CR as an 8-bit wide register
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-2-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 20:29:54 -0400
In-Reply-To: <1445323546-12807-2-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:31 +0200")
Message-ID: <wrfja8rdxdvh.fsf@redhat.com> (sfid-20151021_022958_643628_D662A979)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> rtl8723au driver treats REG_9346CR register as either 8- or 16-bit wide,
> while rtl8192cu driver treats it as 8-bit wide, and so does rtl8188eu
> driver.  Use the lowest common denominator strategy.
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

NACK - this is a 16 bit register and the vendor drivers take the lazy
approach of just reading/writing the lower 8 bits when they feel like
it.

My code is more consistent, so this one is not going in.

Jes

>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 11fcfda..5f90261 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -1928,10 +1928,10 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>  	u16 val16, efuse_addr, offset;
>  	u32 val32;
>  
> -	val16 = rtl8xxxu_read16(priv, REG_9346CR);
> -	if (val16 & EEPROM_ENABLE)
> +	val8 = rtl8xxxu_read8(priv, REG_9346CR);
> +	if (val8 & EEPROM_ENABLE)
>  		priv->has_eeprom = 1;
> -	if (val16 & EEPROM_BOOT)
> +	if (val8 & EEPROM_BOOT)
>  		priv->boot_eeprom = 1;
>  
>  	val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
