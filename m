Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:58783 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965569Ab0B0LJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 06:09:31 -0500
Received: by ewy20 with SMTP id 20so498833ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 03:09:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002092359.24301.mb@bu3sch.de>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	 <1265745883-3392-9-git-send-email-zajec5@gmail.com>
	 <201002092359.24301.mb@bu3sch.de>
Date: Sat, 27 Feb 2010 12:09:30 +0100
Message-ID: <b170af451002270309l1cbc880et100fc4e468386934@mail.gmail.com>
Subject: Re: [PATCH 08/11] b43: implement writing to MMIO shared memory
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/9 Michael Buesch <mb@bu3sch.de>:
> On Tuesday 09 February 2010 21:04:40 Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_common.c |   11 +++++++++++
>>  drivers/net/wireless/b43/phy_common.h |    2 ++
>>  2 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
>> index 8f7d7ef..0b0f9df 100644
>> --- a/drivers/net/wireless/b43/phy_common.c
>> +++ b/drivers/net/wireless/b43/phy_common.c
>> @@ -466,3 +466,14 @@ struct b43_c32 b43_cordic(int theta)
>>
>>       return ret;
>>  }
>> +
>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacWriteShm */
>> +void b43_bmac_write_shm(struct b43_wldev *dev, u32 offset, u16 value)
>> +{
>> +     b43_write32(dev, B43_MMIO_SHM_CONTROL, 0x00010000 | (offset >> 2));
>> +     b43_read32(dev, B43_MMIO_SHM_CONTROL);
>> +     if (offset & 2)
>> +             b43_write16(dev, 0x165, value);
>> +     else
>> +             b43_write16(dev, B43_MMIO_SHM_DATA, value);
>> +}
>
> I'd like to put a biiiig questionmark on this.
> We already have SHM access. Your function does exactly the same, except that it
> accesses the bullshit register h165.

Yeah, that 0x165 is really crappy. Let's hope it really should be
0x166 (B43_MMIO_SHM_DATA_UNALIGNED).

Do you think we should add dummy-read to b43_shm_control_word as
BmacWriteShm does? Currently we do not perform that.

-- 
Rafał
