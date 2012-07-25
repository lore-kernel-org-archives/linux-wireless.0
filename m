Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61938 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab2GYOWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 10:22:13 -0400
Received: by weyx8 with SMTP id x8so574093wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 07:22:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343225435.1693.10.camel@joe2Laptop>
References: <1343227629-14161-1-git-send-email-zajec5@gmail.com>
	<1343225435.1693.10.camel@joe2Laptop>
Date: Wed, 25 Jul 2012 16:22:11 +0200
Message-ID: <CACna6rwDo=oW42mEwHXT0M5c56tWWtBqqb+Wv+L0iKzSasux8A@mail.gmail.com> (sfid-20120725_162217_028674_68A04243)
Subject: Re: [PATCH V2] b43: be more user friendly with PHY info
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/25 Joe Perches <joe@perches.com>:
> On Wed, 2012-07-25 at 16:47 +0200, Rafał Miłecki wrote:
>> use PHY names instead of magic numbers.
> []
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> []
>> @@ -4277,6 +4277,37 @@ out:
> []
>> +static char *b43_phy_name(struct b43_wldev *dev, u8 phy_type)
>> +{
>> +     switch (phy_type) {
>> +     case B43_PHYTYPE_A:
>> +             return "A";
> []
>> +     }
>> +
>> +     b43err(dev->wl, "Unknown PHY Type: %d\n", phy_type);
>> +     return "UNKNOWN";
>
> In general, it's a bad idea to emit error messages
> in a generic call like this.

This function is not supposed to be called anywhere else, it's only
for a single user-friendly message.


>> @@ -4337,13 +4368,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
>>               unsupported = 1;
>>       }
>>       if (unsupported) {
>> -             b43err(dev->wl, "FOUND UNSUPPORTED PHY "
>> -                    "(Analog %u, Type %u, Revision %u)\n",
>> -                    analog_type, phy_type, phy_rev);
>> +             b43err(dev->wl, "FOUND UNSUPPORTED PHY (Analog %u, Type %s, Revision %u)\n",
>> +                    analog_type, b43_phy_name(dev, phy_type), phy_rev);
>
> The extra message doesn't add much useful info
> and can also cause errors in continued messages.

By "extra message" do you mean the one from b43_phy_name? I wanted to
print PHY type as digit somewhere (in case it is not recognized). I
can't use simple
return ("UNKNOWN %d", phy_type);
, such a solution would require allocating memory for string and
freeing it. It would complicate the function.

Do you have any suggestion for better handling this?

-- 
Rafał
