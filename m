Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65481 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0HVXhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 19:37:38 -0400
Received: by qyk33 with SMTP id 33so4952068qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 16:37:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikMxL41zrR+KDF1Od_SKpbQhsQWHWiAAAULYx+F@mail.gmail.com>
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>
	<AANLkTi=TMhmTF+ztooAu=E1e1zdw-cBnaSZCKj=Utik0@mail.gmail.com>
	<AANLkTikMxL41zrR+KDF1Od_SKpbQhsQWHWiAAAULYx+F@mail.gmail.com>
Date: Mon, 23 Aug 2010 01:37:35 +0200
Message-ID: <AANLkTi=qqSNWFO4NnyMVbnamreQuo9e3xAXZSwPbkqH4@mail.gmail.com>
Subject: Re: [PATCH 1/2] b43: N-PHY: band width setting with dumb clock
 control call
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 sierpnia 2010 01:30 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> On Mon, Aug 23, 2010 at 1:20 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Rafal,
>>
>> Couple of minor style issues, if you're re-submitting.
>>
>> 2010/8/23 Rafał Miłecki <zajec5@gmail.com>:
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/phy_common.c |   20 ++++++++++++++++++++
>>>  drivers/net/wireless/b43/phy_common.h |   11 +++++++++++
>>>  drivers/net/wireless/b43/phy_n.c      |    4 ++--
>>>  drivers/net/wireless/b43/phy_n.h      |    1 -
>>>  4 files changed, 33 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
>>> index 8f7d7ef..b06e3f0 100644
>>> --- a/drivers/net/wireless/b43/phy_common.c
>>> +++ b/drivers/net/wireless/b43/phy_common.c
>>> @@ -466,3 +466,23 @@ struct b43_c32 b43_cordic(int theta)
>>>
>>>        return ret;
>>>  }
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
>>> +static void b43_clock_control(struct b43_wldev *dev, u32 mode)
>>> +{
>>> +       ; /* TODO */
>>
>> You don't need the semicolon here, as I understand it.
>>
>>> +}
>>> +
>>> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
>>> +void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width)
>>> +{
>>> +       bool fast = dev->phy.forcefastclk;;
>>
>> Double semicolon - and is it necessary to assign a local variable here?
>
> I agree - don't blindly follow the specs; accessing struct members it
> not expensive.

Check for sub call "b43_clock_control", it sets "forcefastclk". And we
use local "fast" variable *after* calling "b43_clock_control". I
believe it is needed.

-- 
Rafał
