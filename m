Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:47920 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab2FTGOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:14:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFCv2] respect channels in iface combinations
Date: Wed, 20 Jun 2012 08:14:06 +0200
Message-ID: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com> (sfid-20120620_081432_065624_67F018DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here goes an updated patchset with multi-channel work on
cfg80211. Thanks go to Johannes and Eliad for review and
pointing out my mistakes.

I've addressed the issue with non-fixed channel IBSS.
Channels are now cosidered either shared or exclusive. An
exclusive channel always takes a channel resource (when
accouting interface combinations and
num_different_channels). Exclusive channel could also be
called hopping but I thought the first one fits better as it
explicitly states code logic decisions.

I've also refactored and fixed interface combination
checking. There are now functions like
cfg80211_can_use_chan, cfg80211_can_use_iftype_chan.

Monitor channel is now always defined. When there are
only monitors running we set a channel (first we can find in
supported bands structures). This way the corner case
(of a monitor not having a channel and .get_channel
returning NULL) mentioned by Johannes is fixed.

This is based on wireless-next tree.


-- Pozdrawiam / Best regards, Michal Kazior.


