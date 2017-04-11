Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdDKRb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 13:31:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 79EC2D25E1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 19:31:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66CC1DA871
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 19:31:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48D3BDA86B
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 19:31:49 +0200 (CEST)
Date: Tue, 11 Apr 2017 19:31:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: David Ahern <dsa@cumulusnetworks.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us
Subject: Re: [PATCH v3 1/5] netlink: extended ACK reporting
Message-ID: <20170411173143.GA1899@salvia> (sfid-20170411_193204_496298_B238E3E4)
References: <20170408202434.12018-1-johannes@sipsolutions.net>
 <20170408202434.12018-2-johannes@sipsolutions.net>
 <fddba2c8-3b85-d5df-81c4-ef31c459e40c@cumulusnetworks.com>
 <1491838218.28432.5.camel@sipsolutions.net>
 <029e6587-c0e8-bdb0-49e9-2abe2946a7ff@cumulusnetworks.com>
 <20170411065908.GB1492@salvia>
 <1491894172.31620.2.camel@sipsolutions.net>
 <9a68aa01-474c-7054-30c2-473ee1250abe@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9a68aa01-474c-7054-30c2-473ee1250abe@cumulusnetworks.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 11, 2017 at 08:25:57AM -0600, David Ahern wrote:
> On 4/11/17 1:02 AM, Johannes Berg wrote:
> > On Tue, 2017-04-11 at 08:59 +0200, Pablo Neira Ayuso wrote:
> >> CAP_ACK means: trim off the payload that the netlink error message
> >> is embedding, just like ICMP error does.
> >>
> >> What is exactly your concern? If the user explicitly requests this
> >> via socket option for this socket, then we're expecting they do the
> >> right handling for what they're asking for.
> > 
> > I think David's concern was that when you want to parse the ACK in a
> > library (or application), you may not easily know if the application
> > (or library) requested capping.
> 
> exactly.

Then, the library needs to be extended to enable this handling to
modify the way it needs to handle errors, together with the
setsockopt().
