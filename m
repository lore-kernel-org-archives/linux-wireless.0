Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0064.outbound.protection.outlook.com ([104.47.37.64]:29472
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753196AbdIRMaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 08:30:03 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH v2 0/2] qtnfmac: misc fixes intended for 4.14
Date: Mon, 18 Sep 2017 15:29:48 +0300
Message-Id: <20170918122950.32612-1-sergey.matyukevich.os@quantenna.com> (sfid-20170918_143008_755529_214B9015)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle, Igor, and all

Here is the second version of the two patches intended for 4.14.
The first patch fixes tx path regression. Lock should be held when queuing
packets to h/w fifos in order to properly handle configurations with two
enabled interfaces or multiple enabled mbss. The second patch fixes scan
issues related to pending scans upon device configuration changes.

Changes v1 -> v2
Introduce changes for scan patch accroding to review comments:
 - remove unneeded change of netdev_carrier_off
 - update commit message: clarify change of firmware scan timeout watchdog

Sergey Matyukevich (2):
  qtnfmac: lock access to h/w in tx path
  qtnfmac: cancel scans on wireless interface changes

 cfg80211.c            |    9 ++++++---
 cfg80211.h            |    3 +++
 event.c               |    2 --
 pearl/pcie.c          |    9 ++++++++-
 pearl/pcie_bus_priv.h |    2 ++
 5 files changed, 19 insertions(+), 6 deletions(-)
