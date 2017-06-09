Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34861 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbdFINKG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 09:10:06 -0400
Received: by mail-oi0-f41.google.com with SMTP id p7so30484444oif.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 06:10:05 -0700 (PDT)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Johannes Berg <johannes@sipsolutions.net>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
 <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
 <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
 <1496993334.2424.1.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <08fb9e64-a01e-54ea-7627-a0664d350710@gmail.com> (sfid-20170609_151020_772662_C6122A2E)
Date: Fri, 9 Jun 2017 08:10:04 -0500
MIME-Version: 1.0
In-Reply-To: <1496993334.2424.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>
> We've actually discussed doing precisely this, for - among other things
> - this reason. Just nobody stepped up yet to propose the necessary APIs
> and do the remaining work to use it etc.
>

Do you have any thoughts on what the operations should look like or do 
you want me to take a stab in the dark at this?

>> Having userspace track individual packets in the kernel sounds  wrong
>> to  me.  This also won't help with the packets being received out-of-
>> order.  It would be nice if both the RX and TX ordering was
>> preserved.  Hence my thinking about running PAE over NL80211.  It
>> would then be up to the kernel / drivers to guarantee that the
>> various packets are ordered appropriately.
>
> That's actually not possible, since ordering set_key operations vs.
> transmitted packets isn't something that's easily done by drivers.

Fair enough, but at least the kernel can do its best to make sure that 
such races do not manifest themselves out into userspace.  E.g. making 
sure that PAE events arrive after the connect events, etc.

>
> However, the solution is far simpler! Once you have nl80211 PAE
> transport, you can easily even set the key before transmitting the
> packet and simply indicate that this particular packet should _not_ be
> encrypted regardless of key presence.
>

Makes sense.  Should PAE packets always be sent unencrypted?  Or should 
userspace be notified whether PAE was received unencrypted and send a 
response with the same flag?

Also, while we're on this subject.  Should the kernel auto-manage the 
LINKMODE and OPERSTATE flags?  It would seem that it already has the 
information to do so, and having userspace manage this just introduces 
another source of latency / possibility of race conditions, etc.

Regards,
-Denis
