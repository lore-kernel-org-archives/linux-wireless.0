Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2KXKfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 05:35:17 -0500
Message-ID: <1353753342.9789.1.camel@jlt4.sipsolutions.net> (sfid-20121124_113526_498758_3E4FE432)
Subject: Re: Badness at net/mac80211/offchannel.c:264
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Liao <Felix.Liao@watchguard.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ocean Su <Ocean.Su@watchguard.com>,
	Joe Qiao <Joe.Qiao@watchguard.com>,
	Bryan Phillippe <Bryan.Phillippe@watchguard.com>
Date: Sat, 24 Nov 2012 11:35:42 +0100
In-Reply-To: <1AA9BD91549CF94C901B05C32D2B081101E00E00@ES02Ch.wgti.net>
References: <1AA9BD91549CF94C901B05C32D2B081101E00C99@ES02Ch.wgti.net>
	 (sfid-20121123_113037_122856_FE2675E8) <1353712774.5908.15.camel@jlt4.sipsolutions.net>
	 <1AA9BD91549CF94C901B05C32D2B081101E00E00@ES02Ch.wgti.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-11-24 at 01:19 +0000, Felix Liao wrote:
> Hi Johannes,
> Thanks for your help, I just make some tests with the patch you provided. 
> Yes, there is none warning calltrace again, and none other calltrace too.
> 
> But for the tmp_list, when we abort a roc and add to the tail of
> tmp_list, We will delete it from tmp_list in the work async, we need
> to modify the prev and next pointer of the head of tmp_list, I think
> they are freed from the stack of function ieee80211_roc_purge(), it is
> dangerous.

No, it's fine because we flush the asynchronous work there by calling
flush_delayed_work() so it's not actually asynchronous but synchronous.

The reason I didn't just make it call the ieee80211_sw_roc_work()
function is that it may already be scheduled, and we need to catch that
case as well.

johannes

