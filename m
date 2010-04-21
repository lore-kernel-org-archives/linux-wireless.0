Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44930 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0DULuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 07:50:03 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3LBn7MQ006241
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 06:50:02 -0500
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3LBnavn016358
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 14:49:37 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv4 0/2] mac80211: cfg80211: dynamic ps timeout based on pm-qos
Date: Wed, 21 Apr 2010 14:47:36 +0300
Message-Id: <1271850458-32437-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches propose a way to adjust the dynamic ps timeout in the mac80211
based on the pm-qos network latency value. This allows user space to influence
the level of power saving performed by the mac80211.

v4 of these patches change the way pm qos network latency ranges converted to 
dynamic ps timeout values a little bit saner. Unlike the previous set of
patches, now the latancy values make sense in a wider scope than this 
ps timeout thing only. I hope this makes them somewhat more future-proof.

As wext still has an interface to adjust the dynamic ps timeout from userspace,
the wext configuration will override the above, to remain backwards
compatible.

Comments are appreciated.

Juuso Oikarinen (2):
  mac80211: Determine dynamic PS timeout based on ps-qos network
    latency
  cfg80211: Remove default dynamic PS timeout value

 include/net/cfg80211.h |    2 ++
 include/net/mac80211.h |    5 ++++-
 net/mac80211/cfg.c     |    4 ++--
 net/mac80211/main.c    |    2 ++
 net/mac80211/mlme.c    |   21 +++++++++++++++++++++
 net/wireless/core.c    |    3 ++-
 6 files changed, 33 insertions(+), 4 deletions(-)

