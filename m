Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36543 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbbCCT1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 14:27:09 -0500
Date: Tue, 03 Mar 2015 14:27:07 -0500 (EST)
Message-Id: <20150303.142707.350079915695359225.davem@davemloft.net> (sfid-20150303_202729_892485_1DD0197C)
To: joe@perches.com
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: David Miller <davem@davemloft.net>
In-Reply-To: <1425409397.17273.38.camel@perches.com>
References: <1425370617.2450.3.camel@sipsolutions.net>
	<20150303.135737.630359651880852880.davem@davemloft.net>
	<1425409397.17273.38.camel@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Tue, 03 Mar 2015 11:03:17 -0800

> On Tue, 2015-03-03 at 13:57 -0500, David Miller wrote:
>> From: Johannes Berg <johannes@sipsolutions.net>
>> Date: Tue, 03 Mar 2015 09:16:57 +0100
>> 
>> > Other than that, I guess I'll apply this, but I really wish there was a
>> > way to distinguish more easily which of these require alignment and
>> > which don't.
>> 
>> You can't apply "this" without the dependency patch #1.
>> 
>> Therefore this should probably all go through my tree.
> 
> Hey David.
> 
> The eth_<foo>_addr functions already exist so
> 1/14 isn't a dependency.
> 
> It's just a trivial improvement on existing code
> with CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS and
> at least the arm 4.6.3 compiler.

You're right.  But I think we're skipping this series for now, see
my other reply.

If GCC can't emit as good an inline memset as we can come up with
for 6 byte constant lengths, that's a GCC bug that should be fixed.
