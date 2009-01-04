Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:42938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328AbZADR3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 12:29:53 -0500
Date: Sun, 4 Jan 2009 18:43:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linville@tuxdriver.com,
	davem <davem@davemloft.net>
Subject: Re: [PATCH] Fix up truesize after pskb_expand_head() in wireless stack
Message-ID: <20090104174339.GX496@one.firstfloor.org> (sfid-20090104_183008_755042_38515B21)
References: <20090104151819.GA6590@basil.nowhere.org> <1231085150.3296.3.camel@johannes> <20090104162826.GT496@one.firstfloor.org> <1231087288.3296.15.camel@johannes>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231087288.3296.15.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 05:41:28PM +0100, Johannes Berg wrote:
> On Sun, 2009-01-04 at 17:28 +0100, Andi Kleen wrote:
> > > Thanks, but I'll need to look at this in more detail, we need to make
> > > sure that we orphan the skb before 
> > 
> > What do you mean with orphaning the skb? 
> 
> Well, touching truesize is absolutely not allowed while the skb is
> charged to a socket. This is what causes the truesize warning. The thing

The cause of the warnings was because the skb changed, but
truesize didn't.

> we need to do is figure out is why the skb has a wrong truesize.

Because it was expanded without truesize being adjusted (see my
original mail) 

-Andi
