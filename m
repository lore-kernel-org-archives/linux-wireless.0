Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37350 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZDGS05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 14:26:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211: changing number of queues in ops->start
Date: Tue, 7 Apr 2009 20:24:41 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Message-Id: <200904072024.41910.mb@bu3sch.de> (sfid-20090407_202701_017456_D3091E0E)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm wondering how to implement QoS capability runtime detection
in a mac80211 driver.

In b43 we don't know at ieee80211_register time whether the firmware does
support QoS or not, because it's not loaded yet. (Reasons for not loading
it that early are issues with builtin-b43, etc...).
So we don't know whether we are going to load opensource fw (no QoS) or
proprietary fw (QoS capable).
But it seems that mac80211 requires to set hw->queues before ieee80211_register.

So what I'd need is a way to change the number of possible queues from within
the ops->start handler.

Any ideas?

-- 
Greetings, Michael.
