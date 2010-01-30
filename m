Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:56151 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0A3WjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 17:39:08 -0500
Received: by iwn3 with SMTP id 3so3046832iwn.23
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 14:39:04 -0800 (PST)
Message-ID: <4B64B506.2030902@lwfinger.net>
Date: Sat, 30 Jan 2010 16:39:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in b43 with BCM4311/2
References: <4B64A2F2.6060608@lwfinger.net>	 <1264887027.3546.207.camel@johannes.local>  <4B64AAEB.9020806@lwfinger.net> <1264888699.3546.208.camel@johannes.local>
In-Reply-To: <1264888699.3546.208.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2010 03:58 PM, Johannes Berg wrote:
> On Sat, 2010-01-30 at 15:55 -0600, Larry Finger wrote:
>> On 01/30/2010 03:30 PM, Johannes Berg wrote:
> 
>> My AP returns the following in the scan output:
>>
>> Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
>>           24 Mb/s; 36 Mb/s; 54 Mb/s
>> Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
>>
>> I don't see any * markings.
> 
> Check with iw, instead of iwlist, I think?

        Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0
        Extended supported rates: 6.0 9.0 12.0 48.0

OK, only the CCK rates are the basic ones.

> Strange. can the patch be reverted as a whole and then it's ok again?

No the patch cannot be reverted, but I have disabled both parts of it separately
without helping the situation. My bisection must have given a false result.

When I use my 4315 device with an LP PHY, it is OK. The problem has to be in the
G PHY-only code, which your patch didn't touch. I'll have to go back through the
patches in the 2.6.28 merge.

I'll let you know what I find.

Larry
