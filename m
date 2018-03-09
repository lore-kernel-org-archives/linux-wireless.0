Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56856 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751249AbeCISUZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 13:20:25 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 0/3] Fix issues with connect and get_channel implementation
Date: Fri, 9 Mar 2018 23:45:23 +0530
Message-ID: <1520619326-14888-1-git-send-email-gbhat@marvell.com> (sfid-20180309_192029_185559_106523F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First change reverts one of our earlier patch, which did change
the hardware info stored in driver. Second patch improves the
first(reverted) patch. Third change adds a new command, which
fixes an issue with get_channel implementation. Three patches
needed to make sure the driver association are working as
expected.

Ganapathi Bhat (3):
  Revert "mwifiex: fix incorrect ht capability problem"
  mwifiex: fix incorrect ht capability problem
  mwifiex: get_channel from firmware

 drivers/net/wireless/marvell/mwifiex/11n.c         | 30 ++++++++++++
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 40 ++++++++++------
 drivers/net/wireless/marvell/mwifiex/decl.h        | 17 +++++++
 drivers/net/wireless/marvell/mwifiex/fw.h          |  7 +++
 drivers/net/wireless/marvell/mwifiex/main.h        | 16 ++++++-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 22 +++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 19 ++++++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 56 +++++-----------------
 8 files changed, 148 insertions(+), 59 deletions(-)

-- 
1.9.1
