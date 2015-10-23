Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35873 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbJWFp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:45:27 -0400
Received: by lffz202 with SMTP id z202so71743551lff.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 22:45:26 -0700 (PDT)
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> <1445323546-12807-3-git-send-email-jsitnicki@gmail.com> <wrfj37x5xcln.fsf@redhat.com>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 02/16] rtl8xxxu: Use REG_EFUSE_TEST register only on multifunctional devices
In-reply-to: <wrfj37x5xcln.fsf@redhat.com>
Date: Fri, 23 Oct 2015 07:45:24 +0200
Message-ID: <87zizarvd7.fsf@frog.home> (sfid-20151023_074530_621204_AC0A6CBC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 02:57 AM CEST, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> rtl8192cu driver doesn't read/write the REG_EFUSE_TEST register.
>> Neither does the rtl8188eu driver.  Do it only for RTL8192CU-based
>> devices.
>>
>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 9 ++++++---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
>>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> This looks a reasonable change - I verified the 8723BU does this as
> well, but 8192EU doesn't.
>
> I did modify you commit message slightly since it said "Do it only for
> RTL8192CU-based devices" and I am sure you meant 8723AU (and now
> 8723BU).
>
> If you dislike the change to the message, let me know and I'll pull the
> patch or change it.

You're right.  It should say "RTL8723AU-based devices".  Must have had a
brain-fart there.  Thanks for fixing the message.

-Jakub

>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index 5f90261..a8d7e0a 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -1704,6 +1704,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
>>  			priv->has_bluetooth = 1;
>>  		if (val32 & MULTI_GPS_FUNC_EN)
>>  			priv->has_gps = 1;
>> +		priv->is_multi_func = 1;
>>  	} else if (val32 & SYS_CFG_TYPE_ID) {
>>  		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
>>  		bonding &= HPON_FSM_BONDING_MASK;
>> @@ -1934,9 +1935,11 @@ static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>>  	if (val8 & EEPROM_BOOT)
>>  		priv->boot_eeprom = 1;
>>  
>> -	val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
>> -	val32 = (val32 & ~EFUSE_SELECT_MASK) | EFUSE_WIFI_SELECT;
>> -	rtl8xxxu_write32(priv, REG_EFUSE_TEST, val32);
>> +	if (priv->is_multi_func) {
>> +		val32 = rtl8xxxu_read32(priv, REG_EFUSE_TEST);
>> +		val32 = (val32 & ~EFUSE_SELECT_MASK) | EFUSE_WIFI_SELECT;
>> +		rtl8xxxu_write32(priv, REG_EFUSE_TEST, val32);
>> +	}
>>  
>>  	dev_dbg(dev, "Booting from %s\n",
>>  		priv->boot_eeprom ? "EEPROM" : "EFUSE");
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> index f2a1bac..622e6f5 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> @@ -597,6 +597,7 @@ struct rtl8xxxu_priv {
>>  	struct rtl8723au_idx ht20_max_power_offset[3];
>>  	u32 chip_cut:4;
>>  	u32 rom_rev:4;
>> +	u32 is_multi_func:1;
>>  	u32 has_wifi:1;
>>  	u32 has_bluetooth:1;
>>  	u32 enable_bluetooth:1;
