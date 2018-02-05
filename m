Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:37842
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752937AbeBEPFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 10:05:32 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 0/6] qtnfmac: qsr10g pcie backend updates
Date: Mon,  5 Feb 2018 18:05:10 +0300
Message-Id: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com> (sfid-20180205_160629_556864_1DDA2524)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle and all,

Here is a patch set with various fixes and enhacements for qsr10g
PCIe backend driver. The major changes include the following two
items:
- make rmmod/insmod work properly for qtnfmac_pcie driver
- provide configuration knobs to control NSM (networked standby mode)

NSM (networked standby mode) is not related to WiFi standard. This is
a term that has been introduced by European Commission in regulation
No. 1275/2008. Simplifying things a bit, that regulation specifies
ecodesing requirements for various operating modes. In that document
‘networked standby’ is defined as a condition in which the equipment
is able to resume a function by way of a remotely initiated trigger
from a network connection.

Regards,
Sergey

Sergei Maksimenko (3)
  qtnfmac: implement asynchronous firmware loading
  qtnfmac: enable reloading of qtnfmac kernel modules
  qtnfmac: enable networked standby mode on device

Sergey Matyukevich (3)
  qtnfmac: fix releasing Tx/Rx data buffers
  qtnfmac: fix rmmod for firmware version mismatch
  qtnfmac: fix rmmod for missing firmware


 bus.h                   |    4 
 commands.c              |   33 +++
 commands.h              |    1 
 core.c                  |   77 +++++++++
 core.h                  |    2 
 pearl/pcie.c            |  407 +++++++++++++++++++++++++-----------------------
 pearl/pcie_ipc.h        |    1 
 pearl/pcie_regs_pearl.h |    1 
 qlink.h                 |   30 +++
 9 files changed, 363 insertions(+), 193 deletions(-)
