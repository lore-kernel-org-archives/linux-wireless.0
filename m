Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57862 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934954Ab1ESWM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 18:12:29 -0400
Received: by gwaa18 with SMTP id a18so1107261gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 15:12:29 -0700 (PDT)
Message-ID: <4DD595C9.105@lwfinger.net> (sfid-20110520_001233_103619_C9E19FED)
Date: Thu, 19 May 2011 17:12:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix bogus compilation warning for phy_n
References: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net> <BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com>
In-Reply-To: <BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2011 04:43 PM, Rafał Miłecki wrote:
> 2011/5/19 Larry Finger<Larry.Finger@lwfinger.net>:
>> When cross-compiling the 2.6.39 wireless-testing source using GCC version
>> (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291] on an x86_64 system,
>> the following warning is issued:
>>
>>   CC [M]  drivers/net/wireless/b43/phy_n.o
>> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_cal_tx_iq_lo’:
>> drivers/net/wireless/b43/phy_n.c:3096: warning: ‘last’ may be used
>>         uninitialized in this function
>>
>> A quick look at the code shows that the warning is bogus and a gcc bug,
>> but to ensure clean compilation for all users, mark the offending variable
>> as uninitialized.
>
> Did you check for both "last" usages on this function? From my quick
> review it seems "last" is set in case of
> 1) mphase_cal_phase_id>  2
> xor
> 2) b43_nphy_tx_tone returning success
>
> I'm not so sure if this patch is correct.

My analysis is as follows: "last" is created in line 3096. In line 3256, it is 
set by the statement "last = (dev->phy.rev < 3) ? 6 : 7;". In line 3258 and 
3300, it is tested for equality with "nphy->mphase_cal_phase_id". As there is no 
path around line 3256, it seems to me that last must be assigned a value at 3256 
and the warning is bogus.

The call in line 3154 to b43_nphy_tx_tone is "error = b43_nphy_tx_tone(dev, 
freq, 250, true, false);" and does not access last.

If this patch is not correct, then last must be initialized to zero and the 
older compiler is correct and the newer ones are buggy for not reporting the 
problem.

Larry

