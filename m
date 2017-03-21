Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34386 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757436AbdCUNrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 09:47:53 -0400
Received: by mail-ot0-f193.google.com with SMTP id x37so22465418ota.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Mar 2017 06:47:52 -0700 (PDT)
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
To: Kalle Valo <kvalo@codeaurora.org>
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
 <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
 <1489866302.13995.3.camel@sipsolutions.net>
 <be488eab-b822-f99a-a0d2-737e52f5b048@lwfinger.net>
 <87h92mam8p.fsf@purkki.adurom.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b39583af-73f2-f82e-a125-fc3aca68c54f@lwfinger.net> (sfid-20170321_144842_123884_3520965E)
Date: Tue, 21 Mar 2017 08:47:50 -0500
MIME-Version: 1.0
In-Reply-To: <87h92mam8p.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2017 06:43 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> On 03/18/2017 02:45 PM, Johannes Berg wrote:
>>> On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
>>>>
>>>> I have duplicated your bug and I have bisected it to
>>>>
>>>> commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
>>>> Author: Johannes Berg <johannes.berg@intel.com>
>>>> Date:   Mon Oct 24 14:40:04 2016 +0200
>>>>
>>>>      genetlink: use idr to track families
>>>>
>>>> This patch is quite extensive and I have no idea which part is
>>>> failing, thus all I can do is report this confirmation.
>>>
>>> I don't think that makes any sense - have you verified that reverting
>>> that makes it go away?
>>
>> Something is wrong with my wireless-testing-next tree. I just built
>> the mainline 4.11-rc3, and it does not have the problem. I'm now sure
>> that the bisection was wrong.
>>
>> I will need to refresh w-d-n and try again.
>
> Do you mean wireless-drivers-next or wireless-testing? If the latter,
> please note that you cannot really bisect anything on wireless-testing
> because it's rebased every time. wireless-drivers-next should be safe to
> use for bisection because I don't rebase that unless a major disaster
> happens, and IIRC that has not yet happened.
>
> (Well, in theory you can bisect wireless-testing but you have to be
> _really_ careful how to bisect and make sure that you follow the history
> correctly. Definitely not recommended.)

By w-d-n, I meant wireless-drivers-next. I have never done much with 
wireless-testing since the change in maintainers. Thanks for the warning.

Larry
