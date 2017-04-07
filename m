Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934449AbdDGTqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:46:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ACAB1170D2C
        for <linux-wireless@vger.kernel.org>; Fri,  7 Apr 2017 21:46:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E206DA391
        for <linux-wireless@vger.kernel.org>; Fri,  7 Apr 2017 21:46:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C97D7DA38C
        for <linux-wireless@vger.kernel.org>; Fri,  7 Apr 2017 21:46:00 +0200 (CEST)
Date: Fri, 7 Apr 2017 21:45:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/3] netlink: extended error reporting
Message-ID: <20170407194557.GA23613@salvia> (sfid-20170407_214850_727826_5DACE531)
References: <20170407182620.6438-1-johannes@sipsolutions.net>
 <20170407.115315.23470877439489670.davem@davemloft.net>
 <1491591552.5800.1.camel@sipsolutions.net>
 <20170407190601.GA22991@salvia>
 <1491592185.5800.7.camel@sipsolutions.net>
 <20170407192134.GA23205@salvia>
 <1491593357.5800.13.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491593357.5800.13.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 07, 2017 at 09:29:17PM +0200, Johannes Berg wrote:
> On Fri, 2017-04-07 at 21:21 +0200, Pablo Neira Ayuso wrote:
> > I think the most flexible way is to pass the container error
> > structure to nla_parse() so it sets this for you. This would also
> > save tons of "malformed attribute" strings.
> 
> Yes, for sure. The thing is we'll probalby have to pass down the
> request skb *and* the error struct so that we can get the offset, and
> this seems like the generic thing that we really should try to get the
> most information generated.

We only need to store the pointer to the attribute in the error
container structure. We can calculate the offset from nl_err() by
pasing the skbuff as parameter there, right?
