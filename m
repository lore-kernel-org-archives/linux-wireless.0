Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46330 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934375Ab3FSX5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 19:57:14 -0400
Date: Wed, 19 Jun 2013 16:57:13 -0700 (PDT)
Message-Id: <20130619.165713.2010181145193961339.davem@davemloft.net> (sfid-20130620_015721_443801_DBCC240E)
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	stephen@networkplumber.org
Subject: [GIT] net merged into net-next
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


'net' has been merged into 'net-next', the only non-trivial merge
conflict was in wireless.

It has to do with the bug fix that went recently into 'net' to fix the
race that Linus discovered, which overlaps with the 'net-next' locking
changes to nl80211.

I am pretty sure I fixed a bug in those locking changes in my merge
commit, in that the RTNL mutex was not released in all return paths of
nl80211_dump_wiphy().

Please double-check my work.

Thanks.
