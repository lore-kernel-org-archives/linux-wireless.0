Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32870 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754029AbdDKINt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 04:13:49 -0400
Received: by mail-wr0-f196.google.com with SMTP id l28so7227821wre.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 01:13:49 -0700 (PDT)
Date: Tue, 11 Apr 2017 10:13:46 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH net-next v4 1/5] netlink: extended ACK reporting
Message-ID: <20170411081346.GD1976@nanopsycho> (sfid-20170411_101509_368218_37CB131D)
References: <20170411065700.2623-1-johannes@sipsolutions.net>
 <20170411065700.2623-2-johannes@sipsolutions.net>
 <20170411071900.GC1976@nanopsycho>
 <1491895758.31620.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491895758.31620.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tue, Apr 11, 2017 at 09:29:18AM CEST, johannes@sipsolutions.net wrote:
>On Tue, 2017-04-11 at 09:19 +0200, Jiri Pirko wrote:
>> 
>> > +	NUM_NLMSGERR_ATTRS,
>> 
>> According to the rest of the uapi, this should be rather named:
>> 	__NLMSGERR_ATTR_MAX
>
>nl80211 uses NUM_ so I guess that's a matter of convention, but I can
>change that I guess.

Please do.


>
>> > 		if (err || (nlh->nlmsg_flags & NLM_F_ACK))
>> > -			netlink_ack(skb, nlh, err);
>> > +			netlink_ack(skb, nlh, err, NULL);
>> 
>> Wouldn't it make sense to leave netlink_ack as is and add
>> netlink_ack_ext for those who need to pass non-null?
>
>I thought about it, but didn't really see much point. The churn isn't
>super big (a dozen callers or so), and I thought it makes sense to
>point out to the users that there's something here.

Makes sense.
