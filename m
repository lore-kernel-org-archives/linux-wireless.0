Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab2KHXMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 18:12:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: maheshp@posedge.com
Subject: [RFC 0/2] VHT channel configuration support
Date: Fri,  9 Nov 2012 00:12:35 +0100
Message-Id: <1352416357-17892-1-git-send-email-johannes@sipsolutions.net> (sfid-20121109_001217_299695_0570E81C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've been hacking a bit on VHT channel specification. Here's
what I came up with.

The first patch changes cfg80211 to pass a channel definition
struct everywhere instead of channel/channel_type. This of
course requires the remain-on-channel patch I posted before.

The second patch then changes that struct to support VHT
configuration, and removes the channel_type field. It has
a few helpers to get a channel type (unless VHT is used)
and to create a chan_def from a channel/channel_type.

This is definitely missing the regulatory enforcement and
probably some helper functions to get the control channel
offset from a chan_def struct etc., but it's a start.

Also, obviously mac80211 needs to be converted to this new
API throughout, and possibly mac80211-based drivers (though
I could see keeping the API for backward compatibility)

Let me know what you think!

If you want to actually run the code, I suggest you check
out the "wip" branch of my mac80211-next tree (available
on git.kernel.org), as I haven't sent all the patches to
the list yet that this depends on, mostly because they're
boring :)

johannes

