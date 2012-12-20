Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTLQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:16:20 -0500
Message-ID: <1356002202.10029.3.camel@jlt4.sipsolutions.net> (sfid-20121220_121622_829833_D4014D42)
Subject: Re: [PATCH] mac80211: optimise AP stop RCU handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>
Date: Thu, 20 Dec 2012 12:16:42 +0100
In-Reply-To: <1355493476-2927-1-git-send-email-johannes@sipsolutions.net> (sfid-20121214_145817_787355_201B178C)
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	 <1355493476-2927-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121214_145817_787355_201B178C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 14:57 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If there are VLANs, stopping an AP is inefficient as it
> calls rcu_barrier() once for each interface (the VLANs
> and the AP itself). Optimise this by moving rcu_barrier()
> out of the station cleanups and calling it only once for
> all interfaces combined.

Applied.

johannes

