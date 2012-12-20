Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTLMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:12:20 -0500
Message-ID: <1356001957.10029.0.camel@jlt4.sipsolutions.net> (sfid-20121220_121234_725402_71BEDE57)
Subject: Re: [PATCH 0/5] mac80211: fix station cleanup/destruction
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>
Date: Thu, 20 Dec 2012 12:12:37 +0100
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235922_790374_BA80AD0B)
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121213_235922_790374_BA80AD0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 23:59 +0100, Johannes Berg wrote:
> Turns out that not only was flush_workqueue() slow as reported
> by Ben, it was also broken because this is way too late to
> finish the station destruction in AP mode.
> 
> Fixing this with keeping the roaming semantics (no RCU barrier
> or synchronize in there) is a bit tricky so the first patch just
> fixes the problem, and the last patch puts back the optimisation.

Applied all.

johannes

