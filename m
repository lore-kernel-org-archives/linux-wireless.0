Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57287 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758715AbXLQVGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:06:00 -0500
Subject: Re: [patch 8/9] debugfs: Revamp debugfs_create_{u,x,s}{8,16,32,64}
	to support signed integers
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197909780.4885.52.camel@johannes.berg>
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.677829348@gmx.de>
	 (sfid-20071217_003027_870531_D9FE80DE)  <1197909780.4885.52.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:05:56 +0100
Message-Id: <1197925556.7505.10.camel@localhost> (sfid-20071217_210609_210117_A3DEABBB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 17:43 +0100, Johannes Berg wrote:
> On Mon, 2007-12-17 at 01:20 +0100, mattias.nissler@gmx.de wrote:
> > This makes debugfs use its own file_operations for the value accessor files
> > created by debugfs_create_XXX. Having that, we can also have proper versions
> > for signed integers.
> 
> I think I'd probably prefer if this didn't duplicate all the fs/libfs.c
> simple attribute functionality but extended libfs instead to define
> attributes that can have their own print/scan functions. Or something
> like that.

Yeah, I actually tried that. See this thread:
http://lkml.org/lkml/2007/12/16/78

As far as I understand, your point is the same what Greg said.

> 
> As far as I can tell, the only reason you're doing this huge amount of
> code duplication is the "(unsigned long long)" cast in fs/libfs.c, or am
> I missing something?

Yes. Moreover, conceptually it's much cleaner to use the correct data
type.

> 
> You might even be able to get around that: define the get() function in
> simple_attr to return unsigned long long (rather than u64 as it does
> now) and then remove the cast. Then, %lld will still print a negative
> number if applicable.

And the compiler doesn't even complain. That's a cool hack ;-) But
still, it's a hack.

Mattias

