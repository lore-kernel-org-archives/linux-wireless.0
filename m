Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:3260 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab0DJVa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 17:30:57 -0400
Message-ID: <4BC0EE0E.1050702@gmail.com>
Date: Sat, 10 Apr 2010 23:30:54 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 7/9] rt2x00: Add rt3071 support in rt2800 register initialization.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-8-git-send-email-gwingerde@gmail.com> <201004090038.44150.IvDoorn@gmail.com>
In-Reply-To: <201004090038.44150.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/10 00:38, Ivo van Doorn wrote:
> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>> Add RT3071 specific register initializations to rt2x00, based on the latest
>> Ralink rt3070 vendor driver.
>>
>> With this patch my RT3071 based devices start showing a sign of life.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |  105 +++++++++++++++++++++++++++---
>>  1 files changed, 94 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 52e2422..209fd85 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -1036,7 +1036,8 @@ EXPORT_SYMBOL_GPL(rt2800_link_stats);
>>  static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
>>  {
>>  	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
>> -		if (rt2x00_rt(rt2x00dev, RT3070))
>> +		if (rt2x00_rt(rt2x00dev, RT3070) ||
>> +		    rt2x00_rt(rt2x00dev, RT3071))
>>  			return 0x1c + (2 * rt2x00dev->lna_gain);
>>  		else
>>  			return 0x2e + rt2x00dev->lna_gain;
>> @@ -1085,6 +1086,7 @@ EXPORT_SYMBOL_GPL(rt2800_link_tuner);
>>  int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>>  {
>>  	u32 reg, reg2;
>> +	u16 eeprom;
>>  	unsigned int i;
>>  
>>  	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
>> @@ -1202,7 +1204,20 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>>  	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
>>  	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
>>  
>> -	if (rt2x00_rt(rt2x00dev, RT3070)) {
>> +	if (rt2x00_rt(rt2x00dev, RT3071)) {
>> +		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
>> +		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
>> +		if (rt2x00_rev(rt2x00dev) < 0x0211) {
>> +			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
>> +			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
>> +				reg = 0x0000002c;
>> +			else
>> +				reg = 0x0000000f;
>> +		} else {
>> +			reg = 0x00000000;
>> +		}
> 
> Is these some meaning to this fields, which makes it easier to use set_field32
> with some definition to indicate how the field is named to understand what
> the value means?

Nope, I'm sorry. I have no clue here. Let's keep it as is for now, as it in the
same style as the other register writes for this register set.

> 
>> -	if (rt2x00_rt(rt2x00dev, RT3070)) {
>> +	if (rt2x00_rt(rt2x00dev, RT3071)) {
>> +		rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
>> +		rfcsr &= ~0x0c;
>> +		rfcsr |= 0x31;
>> +		rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>> +
>> +		rt2800_rfcsr_read(rt2x00dev, 15, &rfcsr);
>> +		rfcsr &= ~0x08;
>> +		rt2800_rfcsr_write(rt2x00dev, 15, rfcsr);
>> +
>> +		rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
>> +		rfcsr &= ~0x08;
>> +		rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
>> +
>> +		rt2800_rfcsr_read(rt2x00dev, 21, &rfcsr);
>> +		rfcsr &= ~0x08;
>> +		rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
>> +	}
> 
> Perhaps this needs some rt2x00_set_field8() magic as well. Not sure though

OK. I'll add some for macros here for these RF CSRs. It probably won't get prettier,
as they will have generic names without a real meaning.

---
Gertjan.

