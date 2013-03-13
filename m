Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45105 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3CMTP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 15:15:28 -0400
Received: by mail-ob0-f171.google.com with SMTP id x4so1400532obh.16
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 12:15:27 -0700 (PDT)
Message-ID: <5140D04A.4070708@lwfinger.net> (sfid-20130313_201533_520489_72FDB1A9)
Date: Wed, 13 Mar 2013 14:15:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	alessandro.lannocca@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
References: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net> <5140ACCB.4050408@iki.fi> <20130313184656.GD19917@tuxdriver.com>
In-Reply-To: <20130313184656.GD19917@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2013 01:46 PM, John W. Linville wrote:
> On Wed, Mar 13, 2013 at 06:43:55PM +0200, Jussi Kivilinna wrote:
>> On 13.03.2013 17:28, Larry Finger wrote:
>>> The driver was failing to clear the BSSID when a disconnect happened. That
>>> prevented a reconnection. This problem is reported at
>>> https://bugzilla.redhat.com/show_bug.cgi?id=789605,
>>> https://bugzilla.redhat.com/show_bug.cgi?id=866786,
>>> https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
>>> https://bugzilla.kernel.org/show_bug.cgi?id=46171.
>>>
>>> Thanks to Jussi Kivilinna for making the critical observation
>>> that led to the solution.
>>>
>>> Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>>> Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>>> Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Cc: Stable <stable@vger.kernel.org>
>>> ---
>>>
>>> John,
>>>
>>> As you can see by the number of bug reports, this patch should be
>>> pushed as soon as possible.
>>>
>>> Thanks,
>>>
>>> Larry
>>> ---
>>>
>>>   base.h         |    3 +
>>>   pci.c          |    2 -
>>
>> Seems like leak from another patch/change?
>
> I edited-out those bits...

Thanks,

Larry


