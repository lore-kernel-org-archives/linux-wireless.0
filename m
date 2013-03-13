Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40800 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CMSBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 14:01:22 -0400
Received: by mail-ob0-f177.google.com with SMTP id eh20so1340368obb.36
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 11:01:21 -0700 (PDT)
Message-ID: <5140BEE8.5010703@lwfinger.net> (sfid-20130313_190134_137538_3EB82646)
Date: Wed, 13 Mar 2013 13:01:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
CC: John W Linville <linville@tuxdriver.com>,
	alessandro.lannocca@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH for 3.9] rtlwifi: rtl8192cu: Fix problem that prevents
 reassociation
References: <51409b0d.AKkQggbo18xQwrFd%Larry.Finger@lwfinger.net> <5140ACCB.4050408@iki.fi>
In-Reply-To: <5140ACCB.4050408@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2013 11:43 AM, Jussi Kivilinna wrote:
> On 13.03.2013 17:28, Larry Finger wrote:
>> The driver was failing to clear the BSSID when a disconnect happened. That
>> prevented a reconnection. This problem is reported at
>> https://bugzilla.redhat.com/show_bug.cgi?id=789605,
>> https://bugzilla.redhat.com/show_bug.cgi?id=866786,
>> https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
>> https://bugzilla.kernel.org/show_bug.cgi?id=46171.
>>
>> Thanks to Jussi Kivilinna for making the critical observation
>> that led to the solution.
>>
>> Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>> Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>> Tested-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org>
>> ---
>>
>> John,
>>
>> As you can see by the number of bug reports, this patch should be
>> pushed as soon as possible.
>>
>> Thanks,
>>
>> Larry
>> ---
>>
>>   base.h         |    3 +
>>   pci.c          |    2 -
>
> Seems like leak from another patch/change?
>
>>   rtl8192cu/hw.c |   87 ++++++++++++++++++++++-----------------------------------
>>   3 files changed, 39 insertions(+), 53 deletions(-)

Yes, there were some differences between having the patch at the end of the 
line. I'll fix and send V2.

Larry


