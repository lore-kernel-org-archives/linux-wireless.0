Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34669 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760068AbdAIMHt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 07:07:49 -0500
Received: by mail-pg0-f44.google.com with SMTP id 14so29924775pgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 04:07:49 -0800 (PST)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Johannes Berg <johannes@sipsolutions.net>,
        Dmitry Shmidt <dimitrysh@google.com>
References: <94eb2c110db85c2379054172dad0@google.com>
 <1480948100.31788.15.camel@sipsolutions.net>
 <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
 <1481093061.4092.17.camel@sipsolutions.net>
 <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
 <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com>
 <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
 <1481645205.20412.32.camel@sipsolutions.net>
 <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com>
 <1483536510.7312.5.camel@sipsolutions.net>
 <CAH7ZN-zenL8SsqUAzMH5-Hb1RmUDDwgqqUKWEbPX=qaPV7e3TA@mail.gmail.com>
 <1483616763.4394.8.camel@sipsolutions.net>
 <cd31be64-579a-a702-c642-b80690aac5b2@broadcom.com>
 <1483623882.4394.20.camel@sipsolutions.net>
 <ac6c15d8-5d4f-722c-7d7e-c43f6a118b53@broadcom.com>
 <1483958921.17582.20.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <eb6a9c5e-0817-3b63-1e2f-d6bbff867b05@broadcom.com> (sfid-20170109_130755_277154_19D8ED31)
Date: Mon, 9 Jan 2017 13:07:44 +0100
MIME-Version: 1.0
In-Reply-To: <1483958921.17582.20.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 9-1-2017 11:48, Johannes Berg wrote:
> On Thu, 2017-01-05 at 20:59 +0100, Arend Van Spriel wrote:
>>
>> From what Dmitry listed I guess there's really only one.
> 
> Ok. I guess I need to go back to that then.
> 
>> Early on in the thread Luca gave some other examples of scan
>> extensions so may need to consider notification/dump methods that are
>> extensible. It seems awkward to have a single "initiate" command and
>> a couple of "notification/retrieval" commands. It may not be so bad
>> as long as it is clear which retrieval command goes with a
>> notification.
> 
> Well, we might not even need different commands. We need different
> storage internally, but if you request the results for a given scan ID
> then you might get a totally different result format? Though that
> wouldn't lend itself well to query "everything you have" which is also
> useful. But even then, it could be done by passing the appropriate
> "report type" attribute to the dump command - we need that anyway for
> trigger.

True. With "report type" attribute you do not mean the actual
report_type thing, right. Hopefully you mean the parameter attribute
that implicitly relates to a "report type". The risk here is that it
requires careful description of what user-space needs to look for if it
gets a notification. I think having separate notification/retrieval
commands lowers the risk of misinterpretation.

> I think with that discussion we're getting ahead of ourselves though -
> do we really know that we just need the two result types
> 
>  * full, and
>  * partial (for history scan)
> 
> and have we even defined the attributes we want in the partial one?

Not sure if we're getting ahead of ourselves. Yes, we have to determine
attributes for each scan "report type", but it is not a prerequisite for
the other topic. I guess to answer the question about the partial
results attributes we need to know what the possible higher-level
use-cases are. Other source of information would be to look what is done
for g-scan in Android "M" or "N", but not sure if that is best approach
as we may not consider all use-cases.

Regards,
Arend
