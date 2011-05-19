Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58861 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESWkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 18:40:31 -0400
Received: by qyk7 with SMTP id 7so3610484qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 15:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD595C9.105@lwfinger.net>
References: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net>
	<BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com>
	<4DD595C9.105@lwfinger.net>
Date: Fri, 20 May 2011 00:40:30 +0200
Message-ID: <BANLkTi=P-uCzunSyjf2ziX6BaCyq9Muj+g@mail.gmail.com> (sfid-20110520_004034_658689_2499B202)
Subject: Re: [PATCH] b43: Fix bogus compilation warning for phy_n
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 maja 2011 00:12 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 05/19/2011 04:43 PM, Rafał Miłecki wrote:
>>
>> 2011/5/19 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>> When cross-compiling the 2.6.39 wireless-testing source using GCC version
>>> (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291] on an x86_64 system,
>>> the following warning is issued:
>>>
>>>  CC [M]  drivers/net/wireless/b43/phy_n.o
>>> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_cal_tx_iq_lo’:
>>> drivers/net/wireless/b43/phy_n.c:3096: warning: ‘last’ may be used
>>>        uninitialized in this function
>>>
>>> A quick look at the code shows that the warning is bogus and a gcc bug,
>>> but to ensure clean compilation for all users, mark the offending
>>> variable
>>> as uninitialized.
>>
>> Did you check for both "last" usages on this function? From my quick
>> review it seems "last" is set in case of
>> 1) mphase_cal_phase_id>  2
>> xor
>> 2) b43_nphy_tx_tone returning success
>>
>> I'm not so sure if this patch is correct.
>
> My analysis is as follows: "last" is created in line 3096. In line 3256, it
> is set by the statement "last = (dev->phy.rev < 3) ? 6 : 7;". In line 3258
> and 3300, it is tested for equality with "nphy->mphase_cal_phase_id". As
> there is no path around line 3256, it seems to me that last must be assigned
> a value at 3256 and the warning is bogus.
>
> The call in line 3154 to b43_nphy_tx_tone is "error = b43_nphy_tx_tone(dev,
> freq, 250, true, false);" and does not access last.
>
> If this patch is not correct, then last must be initialized to zero and the
> older compiler is correct and the newer ones are buggy for not reporting the
> problem.

I should have describe where I can see the problem.

If error is other than 0 (it can be as the result of "error =
b43_nphy_tx_tone(dev, freq, 250, true, false);"), then "last" won't be
set in 3256. In 3300 we use "last", no matter what "error" is.

-- 
Rafał
