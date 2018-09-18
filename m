Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:51761 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728631AbeIRSpc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 14:45:32 -0400
Received: by mail-it0-f67.google.com with SMTP id e14-v6so3079806itf.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2018 06:13:00 -0700 (PDT)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
To: Johannes Berg <johannes@sipsolutions.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jbenc@redhat.com
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913193004.GF4590@localhost.localdomain>
 <20180913212742.GC3876@unicorn.suse.cz>
 <20180913215839.GI27095@localhost.localdomain>
 <1537177132.2957.6.camel@sipsolutions.net>
 <847cc635-cb90-821d-5824-07e7f941db75@mojatatu.com>
 <1537274378.2957.23.camel@sipsolutions.net>
 <26dd9a66-9515-93aa-e21f-51c37db6be2c@mojatatu.com>
 <1537275441.2957.26.camel@sipsolutions.net>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <1a1e0b60-24d9-a313-f46e-afb590a99b3a@mojatatu.com> (sfid-20180918_151304_658872_671B8EA1)
Date: Tue, 18 Sep 2018 09:12:57 -0400
MIME-Version: 1.0
In-Reply-To: <1537275441.2957.26.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-18 8:57 a.m., Johannes Berg wrote:
> On Tue, 2018-09-18 at 08:55 -0400, Jamal Hadi Salim wrote:
> 
>> Execute permission kind of thing? i.e if i understood you correctly
>> if acl is "rwx" then attribute can only be written to (or read from) if
>> the "thing executing" is complete
> 
> But it's not an attribute that you're executing, it's some kind of
> command, and then you get the return value of that command in that
> attribute?
>
> Say you want to scan for wifi networks - you trigger a scan, later you
> get a notification giving you some data about the scan (let's say the
> time it took) - there's no way you can set that time attribute.
> 

Not very familiar with how wifi scan gets initiated. I am guessing
you issue some GET or SET to start a scan - and you get an async
response when it is complete (and it would include the time it took)?
Or maybe you get an immediate response and event notification later
and the time spent is in that notification?
I would still see that as a read-only attribute.
And the utility of "execute" bit is only in blocking another scan
from being initiated when one is in progress, if that is a desired
goal.
Note in most net devices stats can only be read but not written to
for example.

> (NB: it doesn't work this way, we don't have that attribute now, but I
> didn't want to pick a more complicated example)
> 
>>> What would the practical difference be though? Hopefully you wouldn't
>>> have write-only attributes, and then NLA_REJECT is basically equivalent?
>>>
>>
>> If ACL says "-w-" then reading should get explicit permission denied
>> code possibly with an extack which is more descriptive that reading
>> is not allowed.
> 
> Perhaps. But NLA_REJECT comes with an extack string to tell you, so ...
> 
> I dunno. I think we already bloated the policies too much by including
> the validation_data pointer, and would hate to add more to that :-)

Your mileage may vary. NLA_REJECT may work acls offer more fine grained
controls.


cheers,
jamal
