Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932549AbdCULnt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 07:43:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country regulatory rules
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
        <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
        <1489866302.13995.3.camel@sipsolutions.net>
        <be488eab-b822-f99a-a0d2-737e52f5b048@lwfinger.net>
Date: Tue, 21 Mar 2017 13:43:34 +0200
In-Reply-To: <be488eab-b822-f99a-a0d2-737e52f5b048@lwfinger.net> (Larry
        Finger's message of "Mon, 20 Mar 2017 13:47:39 -0500")
Message-ID: <87h92mam8p.fsf@purkki.adurom.net> (sfid-20170321_124700_748874_4050D78B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 03/18/2017 02:45 PM, Johannes Berg wrote:
>> On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
>>>
>>> I have duplicated your bug and I have bisected it to
>>>
>>> commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
>>> Author: Johannes Berg <johannes.berg@intel.com>
>>> Date:   Mon Oct 24 14:40:04 2016 +0200
>>>
>>>      genetlink: use idr to track families
>>>
>>> This patch is quite extensive and I have no idea which part is
>>> failing, thus all I can do is report this confirmation.
>>
>> I don't think that makes any sense - have you verified that reverting
>> that makes it go away?
>
> Something is wrong with my wireless-testing-next tree. I just built
> the mainline 4.11-rc3, and it does not have the problem. I'm now sure
> that the bisection was wrong.
>
> I will need to refresh w-d-n and try again.

Do you mean wireless-drivers-next or wireless-testing? If the latter,
please note that you cannot really bisect anything on wireless-testing
because it's rebased every time. wireless-drivers-next should be safe to
use for bisection because I don't rebase that unless a major disaster
happens, and IIRC that has not yet happened.

(Well, in theory you can bisect wireless-testing but you have to be
_really_ careful how to bisect and make sure that you follow the history
correctly. Definitely not recommended.)

-- 
Kalle Valo
