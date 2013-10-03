Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53077 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3JCMFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 08:05:37 -0400
Message-ID: <524D5DA5.3090702@openwrt.org> (sfid-20131003_140550_986018_CEDB0E89)
Date: Thu, 03 Oct 2013 14:05:57 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Paul Menzel <paulepanter@users.sourceforge.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: rt2800lib: remove TXMIXER_GAIN
 entries from the extended EEPROM map
References: <1380742914-22486-1-git-send-email-juhosg@openwrt.org> <1380789509.8125.6.camel@mattotaupa>
In-Reply-To: <1380789509.8125.6.camel@mattotaupa>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Paul,

<...>

>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index c706ddc..c979bb7 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -280,10 +280,8 @@ static const unsigned int rt2800_eeprom_map_ext[EEPROM_WORD_COUNT] = {
>>  	[EEPROM_RSSI_BG]		= 0x0028,
>>  	[EEPROM_TXPOWER_DELTA]		= 0x0028, /* Overlaps with RSSI_BG */
>>  	[EEPROM_RSSI_BG2]		= 0x0029,
>> -	[EEPROM_TXMIXER_GAIN_BG]	= 0x0029, /* Overlaps with RSSI_BG2 */
>>  	[EEPROM_RSSI_A]			= 0x002a,
>>  	[EEPROM_RSSI_A2]		= 0x002b,
>> -	[EEPROM_TXMIXER_GAIN_A]		= 0x002b, /* Overlaps with RSSI_A2 */
>>  	[EEPROM_TXPOWER_BG1]		= 0x0030,
>>  	[EEPROM_TXPOWER_BG2]		= 0x0037,
>>  	[EEPROM_EXT_TXPOWER_BG3]	= 0x003e,
> 
> Do you know if this fixes any problems and should be backported to
> stable?

This is a cleanup patch, it does not fix any problem. The removed entries are
not used by the code at all.

> If any testing can be done on
> 
>         idVendor           0x148f Ralink Technology, Corp.
>         idProduct          0x2870 RT2870 Wireless Adapter
> 
> please tell me.

The extended EEPROM map is used only for the RT3593 chipset, it does not affect
RT2870 in any way.

> 
> With the fixes above,
> 
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>

Thank you for the review! I will send an updated version.


-Gabor
