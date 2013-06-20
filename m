Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3FTFh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 01:37:56 -0400
Message-ID: <1371706669.8224.2.camel@jlt4.sipsolutions.net> (sfid-20130620_073802_683504_E157CB11)
Subject: Re: [GIT] net merged into net-next
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	stephen@networkplumber.org
Date: Thu, 20 Jun 2013 07:37:49 +0200
In-Reply-To: <20130619.165713.2010181145193961339.davem@davemloft.net>
References: <20130619.165713.2010181145193961339.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 16:57 -0700, David Miller wrote:
> 
> 'net' has been merged into 'net-next', the only non-trivial merge
> conflict was in wireless.
> 
> It has to do with the bug fix that went recently into 'net' to fix the
> race that Linus discovered, which overlaps with the 'net-next' locking
> changes to nl80211.
> 
> I am pretty sure I fixed a bug in those locking changes in my merge
> commit, in that the RTNL mutex was not released in all return paths of
> nl80211_dump_wiphy().

Yes.

> Please double-check my work.

Looks good, thanks.

We had a fix for the RTNL mutex bug on its way to you (currently in
wireless-next), but this way is good too :-)

johannes


