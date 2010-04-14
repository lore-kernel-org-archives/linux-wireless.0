Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:49540 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab0DNGpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 02:45:44 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi
Subject: [RFC PATCH 0/2] mac80211: cfg80211: dynamic ps timeout based on pm-qos
Date: Wed, 14 Apr 2010 09:41:02 +0300
Message-Id: <1271227264-26868-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches propose a way to adjust the dynamic ps timeout in the mac80211
based on the pm-qos network latency value. This allows user space to influence
the level of power saving performed by the mac80211.

These patches will the current 100ms timeout for the default network
latency value (2000s), so that for non-adjusted pm-qos the functionality will
remain as it is currently. Dynamic ps is disabled for any larger latency
values, and a timeout of 300s is used for latency values smaller than 50ms.

As wext still has an interface to adjust the dynamic ps timeout from userspace,
the wext configuration will override the above, to remain backwards
compatible.

Comments are appreciated.


Juuso Oikarinen (2):
  mac80211: Determine dynamic PS timeout based on ps-qos network
    latency
  cfg80211: Remove default dynamic PS timeout value

 include/net/mac80211.h |    5 ++++-
 net/mac80211/cfg.c     |    4 ++--
 net/mac80211/main.c    |    2 ++
 net/mac80211/mlme.c    |   12 ++++++++++++
 net/wireless/core.c    |    3 ++-
 5 files changed, 22 insertions(+), 4 deletions(-)

