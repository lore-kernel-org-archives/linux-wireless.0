Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0052.outbound.protection.outlook.com ([104.47.42.52]:40224
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936739AbdLSL3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:29:18 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 0/10] qtnfmac: regular portion of fixes and features
Date: Tue, 19 Dec 2017 14:28:46 +0300
Message-Id: <20171219112856.22463-1-sergey.matyukevich.os@quantenna.com> (sfid-20171219_122923_311327_B22785F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle and all,

Here is the next set of patches for qtnfmac driver. This set
enables the following features:
- radar detection and CAC support
- MAC-based ACL support
- make GET_STA_STATS format more flexible and future-proof
- inform wireless core about supported extended capabilities

Besides, several issues has been fixed. The most notable
among them are:
- fix RSSI data passed from qtnfmac to wireless core
- pass complete channel information between firmware and driver,
  including both primary channel and center frequency

The last fix enables proper operation channel report by iw tool
and fixes ACS mode in hostapd.

Changes v1 -> v2
- remove conditional enablement of WIPHY_FLAG_HAVE_AP_SME when
  non-zero max_acl_mac_addrs is reported by firmware
- rebase on top of the latest wireless-drivers-next/master

Regards,
Sergey

Igor Mitsyanko (6):
  qtnfmac: check that MAC exists in regulatory notifier
  qtnfmac: add support for radar detection and CAC
  qtnfmac: change default interface mode from AP to STA
  qtnfmac: check for passed channel being NULL in MGMT_TX
  qtnfmac: modify GET_STA_STATS cmd format for
  qtnfmac: keeping track of "generation" for STA info

Sergey Matyukevich (2):
  qtnfmac: pass complete channel data between driver and
  qtnfmac: fix rssi data passed to wireless core

Vasily Ulyanov (2):
  qtnfmac: fill wiphy's extended capabilities
  qtnfmac: support MAC address based access control


 cfg80211.c   |   60 ++++++++-
 commands.c   |  375 ++++++++++++++++++++++++++++++++++++++++++-----------------
 commands.h   |    5 
 core.c       |   13 --
 core.h       |    8 -
 event.c      |   76 ++++++++++-
 qlink.h      |  340 ++++++++++++++++++++++++++++++++++++++++-------------
 qlink_util.c |   78 +++++++-----
 qlink_util.h |    4 
 util.c       |    8 -
 util.h       |    4 
 11 files changed, 725 insertions(+), 246 deletions(-)
