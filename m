Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f66.google.com ([209.85.216.66]:38319 "EHLO
	mail-qw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0LJGg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 01:36:57 -0500
Received: by qwk3 with SMTP id 3so1236675qwk.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 22:36:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <26490304.1291947984094.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
References: <26490304.1291947984094.JavaMail.root@elwamui-rubis.atl.sa.earthlink.net>
Date: Fri, 10 Dec 2010 07:36:56 +0100
Message-ID: <AANLkTi=CP0x_iE8ENieujGbTEOD5X67--xA0TKwQ-GTe@mail.gmail.com>
Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: ikorot@earthlink.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 grudnia 2010 03:26 użytkownik  <ikorot@earthlink.net> napisał:
> -----Original Message-----
>>From: Rafał Miłecki <zajec5@gmail.com>
>>Sent: Dec 9, 2010 6:06 AM
>>To: ikorot@earthlink.net
>>Cc: Larry Finger <Larry.Finger@lwfinger.net>, Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
>>Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
>>
>>2010/12/8  <ikorot@earthlink.net>:
>>> Larry,
>>>
>>>
>>> -----Original Message-----
>>>>From: Larry Finger <Larry.Finger@lwfinger.net>
>>>>Sent: Dec 7, 2010 12:00 PM
>>>>To: ikorot@earthlink.net
>>>>Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
>>>>Subject: Re: [PATCH 1/4] b43: N-PHY: update init tables
>>>>
>>>>On 12/07/2010 01:49 PM, ikorot@earthlink.net wrote:
>>>>>> One reason is that these tables changed from non-zero to zero values between
>>>>>> Broadcom driver 4.174.64.19 and 5.10.56.46. As they might change again, I think
>>>>>> we should retain the full version.
>>>>>
>>>>> Is there a way to check for version of the driver?
>>>>> This way whoever uses old one won't be screwed...
>>>>
>>>>That will not be a problem as no older version of b43 works at all with b43. To
>>>>help you understand this change, when the 4.174.64.19 Broadcom driver was
>>>>reverse-engineered, the tables had non-zero values. Rafel later compared the
>>>>trace dumps of b43 with the latest version of wl and found that the values are
>>>>now zero. When I rechecked driver 5.10.56.46, I found them to be zero there as
>>>>well and changed the specs.
>>>
>>> Well, it maybe feasible to keep the old values and check
>>> the version of the driver, since you are saying yourself
>>> that the value might be changing in the future.
>>> Maybe for couple of releases only?
>>
>>Sorry, but I don't understand that at all. What do you mean by version
>>of the driver? What driver?
>
> #if B43_VERSION <= x.x.x.x
> // table initialized to some values
> #else
> //table initialized to 0's
> #endif

You want to put condition checking b43 version in... b43 driver? I
can't follow you.

-- 
Rafał
