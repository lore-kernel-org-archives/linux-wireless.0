Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753860AbdDLPa6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:30:58 -0400
Date: Wed, 12 Apr 2017 11:30:56 -0400 (EDT)
Message-Id: <20170412.113056.1269483192753304111.davem@davemloft.net> (sfid-20170412_173112_590845_EC1A3645)
To: johannes@sipsolutions.net
Cc: dsa@cumulusnetworks.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pablo@netfilter.org, jhs@mojatatu.com,
        jbenc@redhat.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v5 1/5] netlink: extended ACK reporting
From: David Miller <davem@davemloft.net>
In-Reply-To: <1492010503.2855.14.camel@sipsolutions.net>
References: <20170412123408.22012-2-johannes@sipsolutions.net>
        <dbc81431-487b-f218-a4c6-2caa44783d97@cumulusnetworks.com>
        <1492010503.2855.14.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 12 Apr 2017 17:21:43 +0200

> On Wed, 2017-04-12 at 09:06 -0600, David Ahern wrote:
>> 
>> There was a discussion about side effects of adding strings (bloat,
>> internationalization). Should ATTR_MSG be removed until that is
>> ironed out? Leaving it in suggests it is ok to start adding strings.
> 
> I really do want the strings; this is why I named the struct member
> "_msg" and added the NL_SET_ERR_MSG() macro, that will easily allow
> both making the strings optional with Kconfig (bloat) and collecting
> them into a separate data section (translation).

Yep, this is a long range plan.
