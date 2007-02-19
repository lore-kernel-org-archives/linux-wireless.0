Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:53062 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbXBSNnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 08:43:09 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJ8ly-0007E2-Te
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 08:41:42 -0500
Subject: Re: [PATCH] d80211: fix incorrect hw.priv setting in  ieee80211_alloc_hw()
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171866799.3471.1.camel@johannes.berg>
References: <20070217074208.348.69546.stgit@dv.roinet.com>
	 <1171707397.3487.5.camel@johannes.berg>  <1171835685.2201.4.camel@dv>
	 <1171866799.3471.1.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 08:43:04 -0500
Message-Id: <1171892584.8550.13.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-19 at 07:33 +0100, Johannes Berg wrote:
> On Sun, 2007-02-18 at 16:54 -0500, Pavel Roskin wrote:
> > Oh, and by the way, wouldn't it be reasonable to have an inline function
> > to calculate the pointer to the priv area instead of having an actual
> > field for the pointer?
> 
> Yeah, I guess that isn't too hard to do. But if you think about what the
> current code will compile to that's also just an addition based on the
> struct size that is known at compile time.

Perhaps you misunderstood my idea.  There is an field called priv in
struct ieee80211_hw.  That field will be written to, no matter how good
the compiler is at optimization.  And most drivers will access that
field by reading from memory.

Having an inline function brings following benefits:

1) Memory access is replaced with adding a constant (marginal speed-up)
2) Removing priv from struct ieee80211_hw (marginal memory saving)
3) priv cannot be written to (marginal safety improvement)

I see that the list doesn't look impressive, but I want to correct
possible misunderstanding anyway.

-- 
Regards,
Pavel Roskin

