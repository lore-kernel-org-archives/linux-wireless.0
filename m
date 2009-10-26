Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54336 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbZJZS12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 14:27:28 -0400
Received: by fxm18 with SMTP id 18so12325707fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 11:27:32 -0700 (PDT)
Message-ID: <4AE5EA0D.4050207@lwfinger.net>
Date: Mon, 26 Oct 2009 13:27:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187: kernel oops when leds enabled
References: <4AE5BD6C.2050303@gmail.com> <4AE5C55B.5070309@lwfinger.net> <4AE5CDCB.8090400@gmail.com>
In-Reply-To: <4AE5CDCB.8090400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> Larry Finger wrote:
>> On 10/26/2009 10:17 AM, Richard Farina wrote:
>>
>>  
>>> I'm honestly a little surprised that no one has bothered to reproduce
>>> this in the month since I reported it but maybe it is more unique to my
>>> setup than it seems.
>>>     
>>
>> Your machine seems to be unique in that it happens most of the time.
>> It took more than 10 tries, but I finally got my copy of the
>> wireless-testing kernel to oops.
>>
>> I will be working on a patch.
>>
>>   
> Excellent! Thanks for looking into it.  I'll be as responsive as
> possible in testing any patches.

I finally got a full dump on my own machine. It is a kernel BUG from
"scheduling while atomic". That makes me think that the bug is not in
rtl8187, but that unplugging the RTL8187 module triggers a bug in the
kernel.

I'm currently building the latest git pull of Linus's tree to see if
the problem is still there. If so, I will post on LKML and make a
kernel bugzilla entry.

Larry
