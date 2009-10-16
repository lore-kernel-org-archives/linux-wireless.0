Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:26869 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZJPM25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:28:57 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n9GCRR5D015384
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 07:27:30 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [RFC 0/3] mac80211 operating bssid concept implementation
Date: Fri, 16 Oct 2009 15:27:19 +0300
Message-Id: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

With some drivers (at least wl1271 and wl1251), we need to know the BSSID that we are interested in when changing the channel.  They don't have the concept of listening to a channel without listening to a specific BSSID.  This is needed for BT-coext, some power saving mechanisms and filtering.

To support these chips correctly, I've introduced the concept of operating BSSID.  We can set this bssid before we are associated with it.  It's almost like the operating channel.  The hardware needs to know which bssid we are interested in, in the same way as it needs to know which channel we are listening to.

I've spent some time analysing different options and other potential solutions to this problem but this this solution is the least intrusive that I could come up with.  Any other ideas on how to implement this are very welcome.

Please take a look at my proposal and tell me what you think.  If everyone is satisfied, I'll send them for inclusion.

In the same patchset, there is an example implementation in the driver side.  It shows how this feature is used and why it is needed.

Cheers,
Luca.

Luciano Coelho (3):
  mac80211: WIP - add operating BSSID to device configuration struct
  wl1271: WIP - use operating BSSID for joining and disconnecting
  wl1271: WIP - remove workaround for disconnection

 drivers/net/wireless/wl12xx/wl1271.h      |    3 --
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   15 -----------
 drivers/net/wireless/wl12xx/wl1271_main.c |   40 ++++++++++++++++++++++++++---
 include/net/mac80211.h                    |    8 ++++++
 net/mac80211/mlme.c                       |   27 ++++++++++++++++++-
 5 files changed, 69 insertions(+), 24 deletions(-)

