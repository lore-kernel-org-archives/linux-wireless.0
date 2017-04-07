Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934155AbdDGTeU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:34:20 -0400
Date: Fri, 07 Apr 2017 12:34:09 -0700 (PDT)
Message-Id: <20170407.123409.2077477736939768290.davem@davemloft.net> (sfid-20170407_213436_047843_FC274527)
To: pablo@netfilter.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170407192134.GA23205@salvia>
References: <20170407190601.GA22991@salvia>
        <1491592185.5800.7.camel@sipsolutions.net>
        <20170407192134.GA23205@salvia>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 7 Apr 2017 21:21:34 +0200

> For my usecases in netfilter, the attributes and an specific error
> code should be enough to figure out what is wrong. Will not need
> strings.
> 
> BTW, we may not have an offset, eg. EINVAL because of missing
> attribute. Given we have different requirements, I would leave it to
> each subsystem to decide what netlink error attributes are specified.

Yep, completely agreed.

The use cases for offset and missing attribute I see as follows:

1) Top-level attribute is missing. Here, offset is set to zero
   and the missing attribute number is given as well.

2) Nested attribute is missing.  Offset is set to the location of the
   beginning of nesting, inside of which the missing attribute was
   needed.
