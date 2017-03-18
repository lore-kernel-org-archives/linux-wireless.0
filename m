Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33222 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdCRViW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 17:38:22 -0400
Received: by mail-ot0-f194.google.com with SMTP id i50so6553639otd.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Mar 2017 14:37:43 -0700 (PDT)
Subject: Re: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com>
 <8c844f92-6148-2ad7-068c-a919891c7a90@lwfinger.net>
 <1489866302.13995.3.camel@sipsolutions.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <45449c16-5a51-5cec-3254-6f3ce0b71b8a@lwfinger.net> (sfid-20170318_224406_996444_059E8690)
Date: Sat, 18 Mar 2017 16:30:04 -0500
MIME-Version: 1.0
In-Reply-To: <1489866302.13995.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2017 02:45 PM, Johannes Berg wrote:
> On Sat, 2017-03-18 at 12:41 -0500, Larry Finger wrote:
>>
>> I have duplicated your bug and I have bisected it to
>>
>> commit 2ae0f17df1cd52aafd1ab0415ea1f1dd56dc0e2a
>> Author: Johannes Berg <johannes.berg@intel.com>
>> Date:   Mon Oct 24 14:40:04 2016 +0200
>>
>>      genetlink: use idr to track families
>>
>> This patch is quite extensive and I have no idea which part is
>> failing, thus all I can do is report this confirmation.
>
> I don't think that makes any sense - have you verified that reverting
> that makes it go away?

Due to conflicts, I cannot simply revert it; however if I check out the previous 
commit 489111e5c25b93be80340c3113d71903d7c82136 ("genetlink: statically 
initialize families"), then the kernel is OK.

Larry
