Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53749 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1WXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 17:23:15 -0500
Received: by vbbfc26 with SMTP id fc26so4223399vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 14:23:14 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC v2 0/2] cfg80211: Enhancements for country IE / disconnect
Date: Mon, 28 Nov 2011 17:23:09 -0500
Message-Id: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_232318_935539_3B3D040C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a v2 for some enhancements for country IE processing and disconnect events.
Thanks to Rajkumar for spotting this issue and working on some further enhancements.
This series adds a new patch which restores the custom regulatory settings upon
disconnect. As for the optimizations for applying these changes in hardware
immediately for now my recommendation is to do it in the reg_notifier() for
each driver because as can be seen the alternative that I supplied was a bit
nasty.

Luis R. Rodriguez (1):
  cfg80211: allow following country IE power for custom regdom cards

Rajkumar Manoharan (1):
  cfg80211: Restore orig channel values upon disconnect

 include/net/cfg80211.h |    4 +++-
 net/wireless/reg.c     |   40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 39 insertions(+), 5 deletions(-)

-- 
1.7.4.15.g7811d

