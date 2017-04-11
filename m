Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35834 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdDKO0E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 10:26:04 -0400
Received: by mail-pf0-f171.google.com with SMTP id i5so49555382pfc.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 07:26:04 -0700 (PDT)
Subject: Re: [PATCH v3 1/5] netlink: extended ACK reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20170408202434.12018-1-johannes@sipsolutions.net>
 <20170408202434.12018-2-johannes@sipsolutions.net>
 <fddba2c8-3b85-d5df-81c4-ef31c459e40c@cumulusnetworks.com>
 <1491838218.28432.5.camel@sipsolutions.net>
 <029e6587-c0e8-bdb0-49e9-2abe2946a7ff@cumulusnetworks.com>
 <20170411065908.GB1492@salvia> <1491894172.31620.2.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <9a68aa01-474c-7054-30c2-473ee1250abe@cumulusnetworks.com> (sfid-20170411_162608_269301_856B345A)
Date: Tue, 11 Apr 2017 08:25:57 -0600
MIME-Version: 1.0
In-Reply-To: <1491894172.31620.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/11/17 1:02 AM, Johannes Berg wrote:
> On Tue, 2017-04-11 at 08:59 +0200, Pablo Neira Ayuso wrote:
>> CAP_ACK means: trim off the payload that the netlink error message
>> is embedding, just like ICMP error does.
>>
>> What is exactly your concern? If the user explicitly requests this
>> via socket option for this socket, then we're expecting they do the
>> right handling for what they're asking for.
> 
> I think David's concern was that when you want to parse the ACK in a
> library (or application), you may not easily know if the application
> (or library) requested capping.

exactly.
