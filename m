Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPIst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 03:48:49 -0500
Message-ID: <1353055762.9490.0.camel@jlt4.sipsolutions.net> (sfid-20121116_094851_388775_27A171DB)
Subject: Re: [PATCH] mac80211: fix invalid kfree on sched scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Nov 2012 09:49:22 +0100
In-Reply-To: <1353055599-8332-1-git-send-email-eliad@wizery.com> (sfid-20121116_094644_781155_F469B55C)
References: <1353055599-8332-1-git-send-email-eliad@wizery.com>
	 (sfid-20121116_094644_781155_F469B55C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 10:46 +0200, Eliad Peller wrote:
> Commit 30dd3ed ("mac80211: don't hang on to sched_scan_ies")
> converted sched_scan_ies to a local variable.
> However, since it wasn't initialized, in a case of
> unsupported band, sched_scan_ies.ie[] was uninitialized,
> and freeing it could corrupt the memory.
> 
> Fix it by simply initializing sched_scan_ies to 0.

Yep, already have that in the tree :-)

commit bca1e29fb54c51856dda6772d488d41b10ed91da
Author: David Spinadel <david.spinadel@intel.com>
Date:   Mon Oct 29 14:49:41 2012 +0200

    mac80211: init sched_scan_ies


johannes

