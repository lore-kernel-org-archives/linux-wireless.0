Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2FLT66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:58:58 -0400
Message-ID: <1339531131.4531.22.camel@jlt3.sipsolutions.net> (sfid-20120612_215902_061392_F20E91FB)
Subject: Re: Why "iwlwifi: read multiple MAC addresses"?
From: Johannes Berg <johannes@sipsolutions.net>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 21:58:51 +0200
In-Reply-To: <3586963.qbQ3i1FPTG@penguin> (sfid-20120612_151131_759795_10C84786)
References: <3586963.qbQ3i1FPTG@penguin>
	 (sfid-20120612_151131_759795_10C84786)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 15:11 +0200, Lekensteyn wrote:

> I wonder what the following commit is used for:
> commit c6fa17ed3fadaf056173c409c0877df428a152ec
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Thu Jul 15 05:58:30 2010 -0700
> 
>     iwlwifi: read multiple MAC addresses

That commit is so that you see this:

> I was trying to debug wireless issues, and noticed that I had two MAC 
> addresses with only the last bit being different:
> 
>     $ cat /sys/class/ieee80211/phy0/addresses
>     00:23:14:xx:xx:x8
>     00:23:14:xx:xx:x9
> 
> Looking at a dump provided by /sys/kernel/debug/cfg80211/phy0/iwlwifi/data/nvm, 
> I see that the 16-bit word at 0x98 contains the value 4. What does this mean? 

The 4 actually means that there are 4 addresses assigned to this device,
for use in P2P scenarios etc. We only support 2 virtual interfaces in
Linux today, so we don't expose 4 (though we probably could.)

> Can this break something?

No.

johannes

