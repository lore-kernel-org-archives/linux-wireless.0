Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:35580 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab1GML5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 07:57:37 -0400
Received: by mail-bw0-f48.google.com with SMTP id 5so3713003bwb.7
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 04:57:36 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH 0/2] nl80211/cfg80211: add some sched scan hw attributes
Date: Wed, 13 Jul 2011 14:57:27 +0300
Message-Id: <1310558249-15944-1-git-send-email-coelho@ti.com> (sfid-20110713_135741_125545_D531B393)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

These patches add two new attributes that are specific to scheduled scans.

The wl12xx chips can use more SSIDs in scheduled scan commands than in normal
scan commands.  So I added a max_sched_scan_ssids element to differentiate it
from what is supported in normal scans (which is represented by the existing
max_scan_ssids element).

For consistency, and in case some other hardware needs to differentiate the
maximum size of user-specified IE data during scheduled scans (wl12xx chips
don't), I also added a max_sched_scan_ie_len attribute.

Cheers,
Luca.

Luciano Coelho (2):
  nl80211/cfg80211: add max_sched_scan_ssids in the hw description
  nl80211/cfg80211: add max_sched_scan_ie_len in the hw description

 include/linux/nl80211.h |    7 +++++++
 include/net/cfg80211.h  |    6 ++++++
 net/wireless/nl80211.c  |    8 ++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

