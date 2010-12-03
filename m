Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab0LCSja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 13:39:30 -0500
Subject: RE: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
From: Johannes Berg <johannes@sipsolutions.net>
To: Frank Huang <frankh@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <77956EDC1B917843AC9B7965A3BD78B058FEF48E24@SC-VEXCH2.marvell.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
	 ,<1291380780.3499.119.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307D59F9D6D@SC-VEXCH1.marvell.com>
	 <77956EDC1B917843AC9B7965A3BD78B058FEF48E24@SC-VEXCH2.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 19:39:28 +0100
Message-ID: <1291401568.3499.142.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-03 at 09:01 -0800, Frank Huang wrote:
	
> [snip]

Mind you, there will definitely be more things to change in this
driver ... that was just the tip of the iceberg really.

Also, there is a lot of stuff talking of "ioctl". I initially wrongly
assumed you were using wireless extensions or something -- I apologise
for that misconception (but you'll have to agree that it was an easy
mistake to make!). However, the "ioctl" layer in the driver needs to be
_dissolved_ entirely, there's no real reason why for example
mwifiex_set_rf_channel() shouldn't directly call into the functions set
that the channel, rather than allocating an "ioctl" request and calling
it.

A better exmaple might be mwifiex_set_tx_power -- it calls
mwifiex_request_ioctl, which calls mwifiex_ioctl, which calls a
mode-dependent ioctl handler, which is, say, mwifiex_ops_sta_ioctl --
which then parses the arguments and calls mwifiex_power_ioctl. This in
turn calls mwifiex_power_ioctl_set_power, which finally does something
like allocating a command.

Almost *everything* described in that paragraph should be dissolved --
mwifiex_set_tx_power() should call a function pointer like
ops.set_tx_power which is set to a function similar to
mwifiex_power_ioctl_set_power, but that similar function should probably
wait for the command to be processed by the device as well.

There's really no need to marshal parameters and settings a few times
before they arrive at the hardware!

A more minor thing: there are a lot of static forward declarations that
aren't really necessary if you shuffle the code a bit -- that would be
appreciated.


On a broader view, I would suggest that you stop thinking of your driver
as special. Clearly, it is dear to you, as are everyone's drivers to
them, but in the overall ecosystem it should fit in with a minimum of
fuzz, and not require special tools or special programming. The custom
wireless events, for example, are entirely useless to existing
applications. Similarly, NETLINK_MARVELL (not to mention the abuse of
the netlink system a driver presents that unilaterally declares that a
given netlink ID is reserved for it without making that known to the
kernel at large).


All this said, though, don't think I'm entirely negative. I'm happy
there's a driver, and that you're starting to engage with the community
(although I don't quite understand why your response was private). And
the driver code is at least clean -- I may not agree with how it works,
but at least I don't have to run it through Lindent to protect myself
from eye cancer :)

Mind you, I haven't done a cfg80211 API review at all. I'll do that when
the code flow is easier to follow and not hidden in multiple abstraction
layers and "ioctls".

johannes

