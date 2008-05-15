Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbYEOLE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 07:04:56 -0400
Message-Id: <20080515105524.359863000@sipsolutions.net> (sfid-20080515_130459_097546_ADBB0D6A)
Date: Thu, 15 May 2008 12:55:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] mac80211 fixes & improvements
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains a fix (first patch) for some of my previous
mac80211 work and these changes:

 * make drivers use wake_queue exclusively and mac80211 start queues
   when the master device is started
 * use rate index in ieee80211_tx_control (preparation for skb->cb)
 * reorder some tx handlers (preparation for skb->cb)
 * move TX info/status into skb->cb

This patch series is based on the recent 26-patch Intel update and
will not apply before that. It applies whether or not the patches
that akpm sent are applied or not.

Since this touches a lot of drivers, I would appreciate any testing
of these patches, but if they go in and break drivers I'll just have
to fix it up later...

I'll rework fragmentation and MQ on top of this later.

johannes

