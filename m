Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33492 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbJWFiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:38:50 -0400
Received: by lffv3 with SMTP id v3so71470229lff.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 22:38:49 -0700 (PDT)
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> <1445323546-12807-2-git-send-email-jsitnicki@gmail.com> <wrfja8rdxdvh.fsf@redhat.com>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 01/16] rtl8xxxu: Treat REG_9346CR as an 8-bit wide register
In-reply-to: <wrfja8rdxdvh.fsf@redhat.com>
Date: Fri, 23 Oct 2015 07:38:47 +0200
Message-ID: <871tcmta8o.fsf@frog.home> (sfid-20151023_073859_677439_8AFB5EB9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 02:29 AM CEST, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> rtl8723au driver treats REG_9346CR register as either 8- or 16-bit wide,
>> while rtl8192cu driver treats it as 8-bit wide, and so does rtl8188eu
>> driver.  Use the lowest common denominator strategy.
>>
>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> NACK - this is a 16 bit register and the vendor drivers take the lazy
> approach of just reading/writing the lower 8 bits when they feel like
> it.
>
> My code is more consistent, so this one is not going in.

Makes sense.  It didn't occur to me to refer to register offset
definitions and check if REG_9346CR really is 16-bit wide.  Now that you
pointed it out I see it:

#define REG_9346CR                      0x000A
#define REG_EE_VPD                      0x000C

-Jakub

>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index 11fcfda..5f90261 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -1928,10 +1928,10 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>>  	u16 val16, efuse_addr, offset;
>>  	u32 val32;
>>  
>> -	val16 = rtl8xxxu_read16(priv, REG_9346CR);
>> -	if (val16 & EEPROM_ENABLE)
>> +	val8 = rtl8xxxu_read8(priv, REG_9346CR);
>> +	if (val8 & EEPROM_ENABLE)
>>  		priv->has_eeprom = 1;
>> -	if (val16 & EEPROM_BOOT)
>> +	if (val8 & EEPROM_BOOT)
>>  		priv->boot_eeprom = 1;
>>  
>>  	val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
