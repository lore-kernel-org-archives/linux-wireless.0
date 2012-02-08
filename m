Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab2BHPhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 10:37:31 -0500
Received: by iacb35 with SMTP id b35so1019340iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 07:37:31 -0800 (PST)
Message-ID: <4F3296B8.2050007@lwfinger.net> (sfid-20120208_163735_287121_2A8E8229)
Date: Wed, 08 Feb 2012 09:37:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: REGRESSION: crash in wireless-testing smoketest
References: <4F313815.3020107@broadcom.com> ( sfid-20120207_154219_853529_011888C8) <4F313C53.2040604@sipsolutions.net> <4F315E7E.7040203@broadcom.com> <1328646776.4223.0.camel@jlt3.sipsolutions.net> <4F32484B.7020409@broadcom.com> <4F327273.5090301@sipsolutions.net> <4F327C30.8060802@broadcom.com>
In-Reply-To: <4F327C30.8060802@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 07:44 AM, Arend van Spriel wrote:
> On 02/08/2012 02:02 PM, Johannes Berg wrote:
>>> I rerun the test on a kernel with some more lock checking and got lucky.
>>>
>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512283] wlan0: authenticate
>>> with 98:fc:11:8e:94:57
>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512515] wlan0: send auth to
>>> 98:fc:11:8e:94:57 (try 1/3)
>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.514184] BUG: unable to handle
>>> kernel NULL pointer dereference at 00000004
>>
>> ...
>>
>>> Apparently, minstrel_ht expects some tx_status field filled in by
>>> brcmsmac/mac80211. Have not found the problem yet.
>>
>> So the patch you sent fixes this? Just making sure it's not a different
>> thing.
>>
>> johannes
>>
>
> Yes. I should probably have referred to this thread.

I have also seen the same crash in minstrel_tx_status, but it showed up in the 
middle of revising p54usb to use asynchronous firmware loading, and I thought I 
had some kind of subtle timing problem in the initialization. I certainly will 
test the patch and report back.

Larry

