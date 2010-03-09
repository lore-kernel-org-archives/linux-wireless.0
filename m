Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27720 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0CILzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 06:55:40 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o29Btb35029790
	for <linux-wireless@vger.kernel.org>; Tue, 9 Mar 2010 13:55:37 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o29BtL6d020412
	for <linux-wireless@vger.kernel.org>; Tue, 9 Mar 2010 13:55:21 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/1] mac80211: Support for HW connection recovery
Date: Tue,  9 Mar 2010 13:52:51 +0200
Message-Id: <1268135572-30722-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When PSM is enabled, the wl1271 performs connection recovery independently by
sending probe-requests to the associated-to AP if it detects beacon loss.

The wl1271 only indicates connection problem after the probe-requests have
failed. At this stage, it's useless for the mac80211 to send further
probe requests in attempt to recover the connection.

Add a new function to allow the HW to indicate this situation.

Juuso Oikarinen (1):
  mac80211: Add ieee80211_probereq_failed function

 include/net/mac80211.h |   12 ++++++++++++
 net/mac80211/mlme.c    |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

