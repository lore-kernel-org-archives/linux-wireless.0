Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:35831 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756310Ab2FGUjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:39:44 -0400
Received: by lahd3 with SMTP id d3so747999lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 13:39:41 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 0/9] wl18xx: debugfs additions and a new conf file
Date: Thu,  7 Jun 2012 23:39:19 +0300
Message-Id: <1339101568-25346-1-git-send-email-coelho@ti.com> (sfid-20120607_223947_774614_E67F5DBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A few more patches for wl18xx (or directly related to it).

Eyal added a new control file in debugfs that we use during the R&D
phase, for debugging and fine-tuning.

I added another file in debugfs that allows us to reset the firmware
statistics data, so we can clear it and start counting from a
a certain point in time.

I also added a new conf binary file, which contains driver and
firmware configuration values that are currently hardcoded in the
driver.  With this file we will have much more flexibility and, with
the help of a new userspace tool I implemented, we will be able to
change any of these settings much more easily.  This file will
eventually replace all the hardcoded values and the NVS binary file
that we currently use.

Cheers,
Luca.

Eyal Shapira (2):
  wlcore: add support macros to easily add conf debugfs entries
  wlcore: add debugfs control over rx interrupt pacing

Luciano Coelho (7):
  wl18xx: add support to clear FW statistics
  wlcore: export raw binary with the FW statistics in debugfs
  wlcore/wl18xx/wl12xx: use u8 instead of bool for
    host_fast_wakeup_support
  wlcore: use u8 instead of enum for bcn_filt_mode
  wlcore/wl18xx: the conf structs must be packed so they can be
    exported
  wlcore/wl18xx: export conf struct in a debugfs file
  wl18xx: read configuration structure from a binary file

 drivers/net/wireless/ti/wl12xx/main.c    |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.c     |   24 +++++++
 drivers/net/wireless/ti/wl18xx/acx.h     |    9 +++
 drivers/net/wireless/ti/wl18xx/conf.h    |   10 ++-
 drivers/net/wireless/ti/wl18xx/debugfs.c |   74 +++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c    |   70 ++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/conf.h    |   75 ++++++++++++++-------
 drivers/net/wireless/ti/wlcore/debugfs.c |  106 ++++++++++++++++++++++++++++++
 8 files changed, 337 insertions(+), 33 deletions(-)

-- 
1.7.10

