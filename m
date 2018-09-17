Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:39274 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbeIQNLv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 09:11:51 -0400
Message-ID: <1537170327.2957.2.camel@sipsolutions.net> (sfid-20180917_094544_354215_EA12CBF3)
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 17 Sep 2018 09:45:27 +0200
In-Reply-To: <20180913203952.GA3876@unicorn.suse.cz>
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913084603.7979-2-johannes@sipsolutions.net>
         <20180913115849.GF29691@unicorn.suse.cz>
         <1536840173.4160.4.camel@sipsolutions.net>
         <20180913121227.GH29691@unicorn.suse.cz>
         <1536840966.4160.6.camel@sipsolutions.net>
         <20180913194116.GG4590@localhost.localdomain>
         <20180913203952.GA3876@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-13 at 22:39 +0200, Michal Kubecek wrote:

> > What about
> > #define NLA_FIELD_ETH_ADDR  { .type = NLA_BINARY_EXACT, .len = ETH_ALEN }
> > 
> > Or even
> > #define NLA_FIELD_BINARY_EXACT(_len)	{ .type = NLA_BINARY_EXACT, .len = (_len) }
> > #define NLA_FIELD_ETH_ADDR		NLA_FIELD_BINARY_EXACT(ETH_ALEN)
> > 
> > So that one would just:
> >    [MYADDR] = NLA_FIELD_ETH_ADDR,
> 
> Yes, that's how I understoold Johannes' proposal above.

I was really thinking of

	[MYADDR] = { NLA_FIELD_ETH_ADDR },

but it doesn't really matter much to me either way.

johannes
