Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab2AFJr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 04:47:56 -0500
Subject: Re: [PATCH RFC] iwlwifi: add basic runtime PM support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4F065F59.2070107@intel.com>
References: <4F065F59.2070107@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 10:47:49 +0100
Message-ID: <1325843269.3330.4.camel@jlt3.sipsolutions.net> (sfid-20120106_104801_719201_848C37F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[add linux-wireless]

On Fri, 2012-01-06 at 10:41 +0800, Yan, Zheng wrote:
> This simple patch adds open/close based runtime PM support to the iwlwifi driver.
> Namely, make the driver suspend the device after shutting down the interface and
> resume the device when activating the interface. In my test, suspending the device
> can save about 0.4 watt power. The shortcoming is that the device no longer generate
> rfkill changes interrupt.

NACK due to that last sentence. There's no way we can live with that in
the general case -- and your patch isn't even configurable afaict. And
I'm sure polling the rfkill flag would use just as much energy.

There might be some value in this in a system that doesn't have a hard
rfkill line, but that means this needs to be configurable since the
device can't know whether there's a button or not [1].

johannes

[1] actually in theory it might be possible to determine whether or not
the pin is floating or not? I doubt even that is possible with the HW we
have though

