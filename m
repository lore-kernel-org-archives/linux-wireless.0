Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:55552
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750832AbeBJOEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 09:04:34 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH v2 0/4] qtnfmac: qsr10g pcie backend updates
Date: Sat, 10 Feb 2018 17:04:16 +0300
Message-Id: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com> (sfid-20180210_150439_911309_6BA75660)
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


Changes v1 -> v2
- do not perform fw check using request_firmware (Arend)
- meld rmmod/insmod fixes into async fw async load patch
  -- those fixes are reworked by that patch anyway


Sergei Maksimenko (3)
  qtnfmac: implement asynchronous firmware loading
  qtnfmac: enable reloading of qtnfmac kernel modules
  qtnfmac: enable networked standby mode on device

Sergey Matyukevich (1)
  qtnfmac: fix releasing Tx/Rx data buffers


 bus.h                   |    4 
 commands.c              |   33 +++
 commands.h              |    1 
 core.c                  |   77 ++++++++
 core.h                  |    2 
 pearl/pcie.c            |  418 ++++++++++++++++++++++++------------------------
 pearl/pcie_ipc.h        |    1 
 pearl/pcie_regs_pearl.h |    1 
 qlink.h                 |   30 +++
 9 files changed, 357 insertions(+), 210 deletions(-)
