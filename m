Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33149 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759530AbdCVQI0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 12:08:26 -0400
Received: by mail-ot0-f196.google.com with SMTP id i50so16579222otd.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 09:08:25 -0700 (PDT)
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
 <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
 <1489866302.13995.3.camel@sipsolutions.net>
 <45449c16-5a51-5cec-3254-6f3ce0b71b8a@lwfinger.net>
 <20170322151525.GA12702@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <87d7b733-1176-4f18-1fe2-6ccadc5c5576@lwfinger.net> (sfid-20170322_170937_345680_9FC615A9)
Date: Wed, 22 Mar 2017 11:08:23 -0500
MIME-Version: 1.0
In-Reply-To: <20170322151525.GA12702@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2017 10:15 AM, Stanislaw Gruszka wrote:
> On Sat, Mar 18, 2017 at 04:30:04PM -0500, Larry Finger wrote:
>> On 03/18/2017 02:45 PM, Johannes Berg wrote:
>>> On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
>>>>
>>>> I have duplicated your bug and I have bisected it to
>>>>
>>>> commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
>>>> Author: Johannes Berg <johannes.berg@intel.com>
>>>> Date:   Mon Oct 24 14:40:04 2016 +0200
>>>>
>>>>     genetlink: use idr to track families
>>>>
>>>> This patch is quite extensive and I have no idea which part is
>>>> failing, thus all I can do is report this confirmation.
>>>
>>> I don't think that makes any sense - have you verified that reverting
>>> that makes it go away?
>>
>> Due to conflicts, I cannot simply revert it; however if I check out
>> the previous commit 489111e5c25b93be80340c3113d71903d7c82136
>> ("genetlink: statically initialize families"), then the kernel is
>> OK.
>
> I just posted a patch which most likely fixes this problem. I have some
> other issue on my setup, but seems this issue is also caused by the
> same bug in 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a.

Stanislaw,

Your patch does fix this problem. Thanks.

Larry
