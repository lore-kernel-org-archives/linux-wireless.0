Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2LFNE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 08:04:29 -0500
Message-ID: <1354799092.10150.4.camel@jlt4.sipsolutions.net> (sfid-20121206_140432_548989_F02510FC)
Subject: Re: [PATCH] mac80211: cancel work instead of waiting for it to do
 nothing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Date: Thu, 06 Dec 2012 14:04:52 +0100
In-Reply-To: <1354697531-11174-1-git-send-email-johannes@sipsolutions.net> (sfid-20121205_095152_764242_8CC65446)
References: <1354697531-11174-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121205_095152_764242_8CC65446)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 09:52 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the sdata work is pending while the interface is stopped,
> we currently flush it. If it's not running this means waiting
> for it to run, which could take a while if the workqueue is
> backlogged. However, the work exits right away if it starts
> to run while the interface is already stopping. There's no
> point in waiting for that, so use cancel_work_sync() instead.

Applied.

johannes

