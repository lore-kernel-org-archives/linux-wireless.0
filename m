Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0074.outbound.protection.outlook.com ([104.47.38.74]:27801
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750970AbeAVMq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:46:57 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH 0/11] qtnfmac fixes and cleanups
Date: Mon, 22 Jan 2018 15:46:23 +0300
Message-Id: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134702_354943_DD3AC4D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle and all,

Here is the patch series containing mostly fixes and cleanups.
The major fixes include:
- switch to 64-bit packet stats counters to handle counter overflows
- two lock issues: mutexes in timer and deadlock
- modify interface combinations handling

Besides, two patches enable more information about firmware/hardware:
- add firmware/hardware version information to driver boot log
- report firmware version via ethtool

Regards,
Sergey

Vasily Ulyanov (5):
  qtnfmac: remove struct qlink_cmd_set_mac_acl
  qtnfmac: fix warnings when mBSS setup is stopped
  qtnfmac: support 64-bit network interface stats
  qtnfmac: get more hardware info from card
  qtnfmac: report hardware/firmware information via ethtool

Igor Mitsyanko (2):
  qtnfmac: do not use mutexes in timer context
  qtnfmac: do not use bus mutex for events processing

Sergey Matyukevich (4):
  qtnfmac: modify supported interface combinations
  qtnfmac: validate interface combinations on changes
  qtnfmac: fix STA disconnect procedure
  qtnfmac: remove redundant 'unlikely' checks


 cfg80211.c   |  131 +++++++++++++++++++++-------------
 cfg80211.h   |   19 -----
 commands.c   |  222 ++++++++++++++++++++++++++++++++++++++++-------------------
 core.c       |  139 +++++++++++++++++++++++++++++++++++-
 core.h       |   15 +++
 event.c      |    4 -
 pearl/pcie.c |    7 -
 qlink.h      |   33 +++++---
 8 files changed, 403 insertions(+), 167 deletions(-)
