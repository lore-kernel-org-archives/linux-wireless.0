Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:41380 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbeIRSHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 14:07:19 -0400
Received: by mail-io1-f65.google.com with SMTP id q4-v6so1361892iob.8
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2018 05:34:55 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
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
Message-ID: <847cc635-cb90-821d-5824-07e7f941db75@mojatatu.com> (sfid-20180918_143459_059354_D1CD8B32)
Date: Tue, 18 Sep 2018 08:34:53 -0400
MIME-Version: 1.0
In-Reply-To: <1537177132.2957.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-17 5:38 a.m., Johannes Berg wrote:
> On Thu, 2018-09-13 at 18:58 -0300, Marcelo Ricardo Leitner wrote:
> 

[..]

> 
> So in one case I was thinking of, there are some fields that simply
> cannot be used for input, they're only used for output. > But it may not
> always be obvious to somebody using the API. Thus, I think it makes
> sense to instruct the kernel to reject that, so that whoever gets
> confused has immediate feedback that their usage is wrong. If we ignore
> that, they may not realize their error immediately.
> 
> I think the ethtool case is similar: you can read and write some fields,
> and only read others - but if you try to write the read-only fields
> would you prefer to be told "sorry, this is not possible" vs. it being
> silently ignored? I'd definitely prefer the former.
> 
>> Maybe it would be better to have NLA_IGNORE instead? </idea>
> 
> I don't think so, it doesn't give any feedback to the application author
> that they're doing something wrong.
> 

Maybe time to introduce kernel side access-control flags?
Read/Write permissions for example. Attrs marked as read only
(in the kernel) cannot be written to.


cheers,
jamal
