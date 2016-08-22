Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34338 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbcHVTTw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 15:19:52 -0400
Received: by mail-qt0-f174.google.com with SMTP id u25so33043178qtb.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2016 12:19:51 -0700 (PDT)
Subject: Re: [PATCHv7 4/4] mt7601u: use linux/bitfield.h
To: Jakub Kicinski <jakub.kicinski@netronome.com>
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
 <1471625049-12643-5-git-send-email-jakub.kicinski@netronome.com>
 <161e3391-9a95-6388-6b93-99a5b12a2036@broadcom.com>
 <20160822115254.62ee6589@jkicinski-Precision-T1700>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <8958bdba-d01d-026c-a018-f2a94bff3e52@broadcom.com> (sfid-20160822_211955_867724_9F5A7008)
Date: Mon, 22 Aug 2016 21:19:41 +0200
MIME-Version: 1.0
In-Reply-To: <20160822115254.62ee6589@jkicinski-Precision-T1700>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-8-2016 12:52, Jakub Kicinski wrote:
> On Fri, 19 Aug 2016 21:02:02 +0200, Arend Van Spriel wrote:
>> On 19-8-2016 18:44, Jakub Kicinski wrote:
>>> Use the newly added linux/bitfield.h.
>>>
>>> Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
>>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>> ---

[snip]

>>> diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> index 8d8ee0344f7b..da6faea092d6 100644
>>> --- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> +++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> @@ -45,8 +45,8 @@ mt7601u_efuse_read(struct mt7601u_dev *dev, u16 addr, u8 *data,
>>>  	val = mt76_rr(dev, MT_EFUSE_CTRL);
>>>  	val &= ~(MT_EFUSE_CTRL_AIN |
>>>  		 MT_EFUSE_CTRL_MODE);
>>> -	val |= MT76_SET(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
>>> -	       MT76_SET(MT_EFUSE_CTRL_MODE, mode) |
>>> +	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
>>> +	       FIELD_PREP(MT_EFUSE_CTRL_MODE, mode) |
>>>  	       MT_EFUSE_CTRL_KICK;  
>>
>> MT_EFUSE_CTRL_KICK is probably a 1-bit field in MT_EFUSE_CTRL register.
>> It looks like you did not want to go all the way although you do give an
>> example in bitfield.h, ie. + *  #define REG_FIELD_B  BIT(7).
> 
> True, I just wanted to show in the examples that BIT() is OK to use.
> My feeling is that ORing in always set flags is acceptable, or at least
> it was my feeling when I wrote this code ;)

I find it tricky to have the user do the field clearing separately.
Especially if you allow the calling function to pass additional opaque
"flags". In my experience this is more error prone than anything else
when dealing with bit fields and as such it is unfortunate this aspect
is not addressed in your patches.

I would rather see:

	val = mt76_rr(dev, MT_EFUSE_CTRL);
	FIELD_SET(val, MT_EFUSE_CTRL_AIN, addr & ~0xf);
	FIELD_SET(val, MT_EFUSE_CTRL_MODE, mode);
	FIELD_SET(val, MT_EFUSE_CTRL_KICK, 1);
 	mt76_wr(dev, MT_EFUSE_CTRL, val);

in which FIELD_SET takes care of clearing the indicated field. I am
wondering how much these two solutions differ in terms of assembly
instructions.

Regards,
Arend
