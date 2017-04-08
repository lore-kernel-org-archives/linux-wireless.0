Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:32891 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdDHSkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 14:40:11 -0400
Received: by mail-it0-f67.google.com with SMTP id w11so1845377itb.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Apr 2017 11:40:11 -0700 (PDT)
Date: Sat, 8 Apr 2017 20:40:08 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH 1/5] netlink: extended ACK reporting
Message-ID: <20170408184008.GB1900@nanopsycho> (sfid-20170408_204127_257590_2DFF1668)
References: <20170408174900.12820-1-johannes@sipsolutions.net>
 <20170408174900.12820-2-johannes@sipsolutions.net>
 <20170408183440.GA1900@nanopsycho>
 <1491676621.5800.24.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1491676621.5800.24.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sat, Apr 08, 2017 at 08:37:01PM CEST, johannes@sipsolutions.net wrote:
>On Sat, 2017-04-08 at 20:34 +0200, Jiri Pirko wrote:
>> nla_total_size(sizeof(u32));
>> > +			if (extack &&
>> > +			    (extack->missing_attr || extack-
>> > >bad_attr))
>> 
>> Attr could be 0, right? I know that on the most of the places 0 is
>> UNSPEC, but I'm pretty sure not everywhere.
>
>Yeah, I guess we can't show a missing attribute of 0 now - bad_attr is
>a pointer so no problem there.
>
>I think I'll leave it like this - if anyone really wants to say
>"attribute 0 is missing" then we can add a flag later... The UAPI does
>take this into account by not including the attribute at all if the
>data is invalid, so 0 in the userspace API can be done

It a known issue, should be fixed right now. We are in no hurry. This
waited +15 years to be done, no harm in couple more days.


Also, could you please attach a patch to iproute2 for example which
would make use of this. I just want to make sure it clicks.

Thanks!
