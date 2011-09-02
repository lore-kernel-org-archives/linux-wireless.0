Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:49067 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab1IBL2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 07:28:41 -0400
Received: by bkar4 with SMTP id r4so3832176bka.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2011 04:28:38 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] wl12xx: add support for SSID matching in sched_scan
Date: Fri,  2 Sep 2011 14:28:20 +0300
Message-Id: <1314962903-29574-1-git-send-email-coelho@ti.com> (sfid-20110902_132844_250500_AEE276C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset adds support for SSID matching (ie. filtering) on
scheduled scans.  I have also increased the number of supported SSIDs,
because recent versions of the firmware support 16 SSIDs at once.

Due to the increased number of SSIDs supported, I also had to increase
the dwell times for the scheduled scan.  I used large arbitrary values
that work fine for now, but they should probably be fine-tuned later.

This patchset depends on "nl80211/cfg80211: add match filtering for
sched_scan".

Please review.

Cheers,
Luca.


Luciano Coelho (3):
  wl12xx: add support for sched_scan filters
  wl12xx: increase number of allowed SSIDs in sched_scan
  wl12xx: ignore sched scan match sets without SSID

 drivers/net/wireless/wl12xx/main.c |    7 +-
 drivers/net/wireless/wl12xx/scan.c |  116 +++++++++++++++++++++++++-----------
 2 files changed, 85 insertions(+), 38 deletions(-)

