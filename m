Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:44002 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeIMRMO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 13:12:14 -0400
Message-ID: <1536840173.4160.4.camel@sipsolutions.net> (sfid-20180913_140310_635852_4B1837F4)
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 13 Sep 2018 14:02:53 +0200
In-Reply-To: <20180913115849.GF29691@unicorn.suse.cz>
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913084603.7979-2-johannes@sipsolutions.net>
         <20180913115849.GF29691@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-13 at 13:58 +0200, Michal Kubecek wrote:

> The code looks correct to me but I have some doubts. Having a special
> policy for MAC addresses may lead to adding one for IPv4 address (maybe
> not, we can use NLA_U32 for them), IPv6 addresses and other data types
> with fixed length. Wouldn't it be more helpful to add a variant of
> NLA_BINARY (NLA_BINARY_EXACT?) which would fail/warn if attribute length
> isn't equal to .len?

Yeah, I guess we could do that, and then

#define NLA_ETH_ADDR .len = ETH_ALEN, .type = NLA_BINARY_EXACT
#define NLA_IP6_ADDR .len = 16, .type = NLA_BINARY_EXACT

or so?

johannes
