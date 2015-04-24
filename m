Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39773 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbbDXK2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:28:10 -0400
Message-ID: <1429871283.1852.28.camel@sipsolutions.net> (sfid-20150424_122813_562093_D9D5DFD4)
Subject: Re: [PATCH] mac80211: While associated, force off channel
 transmission for action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>
Date: Fri, 24 Apr 2015 12:28:03 +0200
In-Reply-To: <1429559654-23126-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1429559654-23126-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-20 at 22:54 +0300, Emmanuel Grumbach wrote:
> From: Matti Gottlieb <matti.gottlieb@intel.com>
> 
> Currently while associated to an AP and sending an action frame to a
> different AP on the same channel, the action frame will be sent
> like a regular tx frame without going off channel.
> 
> When power save is enabled this can cause problems, since the device can
> go into power save and miss the response to the action frame that is sent
> by the other AP.
> 
> By forcing the frame to be transmitted off channel we avoid this issue.
> 
> Force the transmitting of the action frame to use off channel in
> case of association
> - If HW off channel is enabled
> - The user did not forbid transmitting frames off channel
> - The frame is not designated to the AP that we are associated with

Makes sense, but I reworded the commit message a bit.

If this problem crops up on non-hw-offchannel devices we should prevent
powersave there for the transition period.

johannes

