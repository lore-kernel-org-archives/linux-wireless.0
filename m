Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933185AbdDGTGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:06:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 325161395CE
        for <linux-wireless@vger.kernel.org>; Fri,  7 Apr 2017 21:06:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23118DA729
        for <linux-wireless@vger.kernel.org>; Fri,  7 Apr 2017 21:06:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04E5FDA7E9
        for <linux-wireless@vger.kernel.org>; Fri,  7 Apr 2017 21:06:01 +0200 (CEST)
Date: Fri, 7 Apr 2017 21:06:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/3] netlink: extended error reporting
Message-ID: <20170407190601.GA22991@salvia> (sfid-20170407_210611_346683_9F64A016)
References: <20170407182620.6438-1-johannes@sipsolutions.net>
 <20170407.115315.23470877439489670.davem@davemloft.net>
 <1491591552.5800.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1491591552.5800.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 07, 2017 at 08:59:12PM +0200, Johannes Berg wrote:
[...]
> Heh. I think I really want to solve - at least partially - nla_parse()
> to see that it can be done this way. It'd be nice to even transform all
> the callers (I generated half of these patches with spatch anyway) to
> have at least that.

We can just have a modified version of nla_parse that deals with this.
We can probably use struct nla_policy to place the extended error code
or the string (as we discussed I don't need string errors, but I'm
fine if other people find it useful).

Thanks!
