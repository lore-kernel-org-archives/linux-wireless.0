Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:59533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751391AbdKMK23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:28:29 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 0/10] qtnfmac: regular portion of features and fixes
Date: Mon, 13 Nov 2017 13:28:05 +0300
Message-Id: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com> (sfid-20171113_112926_588492_01C05119)
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

 cfg80211.c   |   63 ++++++++-
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
 11 files changed, 728 insertions(+), 246 deletions(-)
