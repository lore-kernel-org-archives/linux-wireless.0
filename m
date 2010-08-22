Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53561 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0HVXfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 19:35:15 -0400
Received: by qyk33 with SMTP id 33so4951176qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 16:35:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
	<AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>
Date: Mon, 23 Aug 2010 01:35:14 +0200
Message-ID: <AANLkTimcwFn3Xxs9SmH5PC4Co0EetOpbxBggQz8SEyoY@mail.gmail.com>
Subject: Re: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock
 control call
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/23 Julian Calaby <julian.calaby@gmail.com>:
> Rafal,
>
> Couple of minor style issues, if you're re-submitting.

Thanks for reviewing! :)


> 2010/8/23 Rafał Miłecki <zajec5@gmail.com>:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_common.c |   20 ++++++++++++++++++++
>>  drivers/net/wireless/b43/phy_common.h |   11 +++++++++++
>>  drivers/net/wireless/b43/phy_n.c      |    4 ++--
>>  drivers/net/wireless/b43/phy_n.h      |    1 -
>>  4 files changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
>> index 8f7d7ef..b06e3f0 100644
>> --- a/drivers/net/wireless/b43/phy_common.c
>> +++ b/drivers/net/wireless/b43/phy_common.c
>> @@ -466,3 +466,23 @@ struct b43_c32 b43_cordic(int theta)
>>
>>        return ret;
>>  }
>> +
>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
>> +static void b43_clock_control(struct b43_wldev *dev, u32 mode)
>> +{
>> +       ; /* TODO */
>
> You don't need the semicolon here, as I understand it.

Yeah, could be skipped without causing warning. However it was
replaced anyway with 2/2. And this code doesn't come from the patch
you comment in this thread ;)


>> +}
>> +
>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
>> +void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width)
>> +{
>> +       bool fast = dev->phy.forcefastclk;;
>
> Double semicolon - and is it necessary to assign a local variable here?

Bingo for double semicolon. We need to keep copy of "forcefastclk" as
this can be changed in sub calls.

-- 
Rafał
