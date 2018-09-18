Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:38572 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbeIRS1n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 14:27:43 -0400
Received: by mail-io1-f67.google.com with SMTP id y3-v6so1422390ioc.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2018 05:55:14 -0700 (PDT)
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
From: Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <26dd9a66-9515-93aa-e21f-51c37db6be2c@mojatatu.com> (sfid-20180918_145521_797344_A0C9BF64)
Date: Tue, 18 Sep 2018 08:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <1537274378.2957.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-18 8:39 a.m., Johannes Berg wrote:
> On Tue, 2018-09-18 at 08:34 -0400, Jamal Hadi Salim wrote:
> 

>> Maybe time to introduce kernel side access-control flags?
>> Read/Write permissions for example. Attrs marked as read only
>> (in the kernel) cannot be written to.
> 
> I dunno, that might work for ethtool, but I want to use it for something
> that's not even an attribute you could think about writing to, but the
> result of some operation you started.
>

Execute permission kind of thing? i.e if i understood you correctly
if acl is "rwx" then attribute can only be written to (or read from) if
the "thing executing" is complete
> What would the practical difference be though? Hopefully you wouldn't
> have write-only attributes, and then NLA_REJECT is basically equivalent?
>

If ACL says "-w-" then reading should get explicit permission denied
code possibly with an extack which is more descriptive that reading
is not allowed.

cheers,
jamal
