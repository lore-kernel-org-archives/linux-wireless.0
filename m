Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34674 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3CIXb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 18:31:57 -0500
Received: by mail-oa0-f51.google.com with SMTP id h2so3393720oag.10
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 15:31:57 -0800 (PST)
Message-ID: <513BC669.7090209@lwfinger.net> (sfid-20130310_003210_354043_7D4F7F3A)
Date: Sat, 09 Mar 2013 17:31:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Joe Perches <joe@perches.com>, Hauke Mehrtens <hauke@hauke-m.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de> <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com> <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net> <1361384969.2219.4.camel@joe-AO722> <51252132.3050603@hauke-m.de> <1361391065.2223.5.camel@joe-AO722> <512595BC.5030607@lwfinger.net> <CACna6rzQNo9CBrg08y6y+bf3009_EuL5f2UqOXVLKSoE_q7BRQ@mail.gmail.com>
In-Reply-To: <CACna6rzQNo9CBrg08y6y+bf3009_EuL5f2UqOXVLKSoE_q7BRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/09/2013 05:02 PM, Rafał Miłecki wrote:
> 2013/2/21 Larry Finger <Larry.Finger@lwfinger.net>:
>>> Signed-off-by: Joe Perches <joe@perches.com>
>>> ---
>>>
>>> V2: Add missing SPOFF
>>
>>
>> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> I didn't confirm my issue to be related to this patch, but with recent
> kernels my MAC has changed from
> 00:11:22:33:44:55
> to
> 11:00:33:22:55:44
>
> Larry: did you verify MAC didn't change for you?

I just checked it on PowerPC and it changed it the same way as yours did.

The problem is that the MAC is stored in the SPROM in big-endian order, thus the 
sequence

+       for (i = 0; i < 3; i++) {
+               *mac++ = in[i];
+               *mac++ = in[i] >> 8;
+       }

needs to be changed to

+       for (i = 0; i < 3; i++) {
+               *mac++ = in[i] >> 8;
+               *mac++ = in[i];
+       }

After that change, it is OK, at least on the PPC.

BTW, that patch is not yet in my copy of wireless-testing.

Larry

