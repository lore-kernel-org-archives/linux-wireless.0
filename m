Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31618 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0DPJUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 05:20:38 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3G9KGsa031118
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 04:20:37 -0500
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3G9I0IG010544
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 12:18:00 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv3 0/2] mac80211: cfg80211: dynamic ps timeout based on pm-qos
Date: Fri, 16 Apr 2010 12:14:32 +0300
Message-Id: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches propose a way to adjust the dynamic ps timeout in the mac80211
based on the pm-qos network latency value. This allows user space to influence
the level of power saving performed by the mac80211.

These patches will the current 100ms timeout for the default network
latency value (2000s), so that for non-adjusted pm-qos the functionality will
remain as it is currently. Dynamic ps is disabled for any larger latency
values, and a timeout of 300s is used for latency values smaller than 50ms.

v3 of these patches ad a 50s dynamic ps configuration.

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
 net/mac80211/mlme.c    |   14 ++++++++++++++
 net/wireless/core.c    |    3 ++-
 5 files changed, 24 insertions(+), 4 deletions(-)

