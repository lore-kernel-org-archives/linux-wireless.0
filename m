Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:6115 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0BEUbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 15:31:22 -0500
Received: by ey-out-2122.google.com with SMTP id d26so939513eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 12:31:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911002050934p1a2f587fo863b4896e553f2c3@mail.gmail.com>
References: <1265285514-28798-2-git-send-email-zajec5@gmail.com>
	 <69e28c911002050934p1a2f587fo863b4896e553f2c3@mail.gmail.com>
Date: Fri, 5 Feb 2010 21:31:20 +0100
Message-ID: <b170af451002051231xefa1c28p9549db5d4ce48204@mail.gmail.com>
Subject: Re: [PATCH] b43: N-PHY: handle allocation fail in samples generation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 5 lutego 2010 18:34 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/2/4 Rafał Miłecki <zajec5@gmail.com>:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/net/wireless/b43/phy_n.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
>> index 074b34c..795bb1e 100644
>> --- a/drivers/net/wireless/b43/phy_n.c
>> +++ b/drivers/net/wireless/b43/phy_n.c
>> @@ -1069,6 +1069,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
>>        }
>>
>>        samples = kzalloc(len * sizeof(struct b43_c32), GFP_KERNEL);
>> +       if (!samples) {
>> +               b43err(dev->wl, "allocation for samples generation failed\n");
>> +               return 0;
>
> return -ENOMEM;

Function was somehow designed to return unsigned only. Returning 0
means error (see place where we call b43_nphy_gen_load_samples, we
check result for 0 there.

Is that OK then?

>> +       }
>>        rot = (((freq * 36) / bw) << 16) / 100;
>>        angle = 0;
>>
>> --
>> 1.6.4.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Rafał
